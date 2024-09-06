#include "bigint.h"
#include <cassert>
#include <sstream>
#include <iomanip>
#include <ios>

BigInt::BigInt() : bits(1, 0), negative(false) {}

BigInt::BigInt(const std::initializer_list<uint64_t> vals, bool negative)
    : bits(vals), negative(negative) {
    while (bits.size() > 1 && bits.back() == 0) {
        bits.pop_back();
    }
}

BigInt::BigInt(uint64_t val, bool negative)
    : bits(1, val), negative(negative) {}

BigInt::BigInt(const BigInt &other)
    : bits(other.bits), negative(other.negative) {}

BigInt::~BigInt() {}

BigInt &BigInt::operator=(const BigInt &rhs) {
    if (this != &rhs) {
        bits = rhs.bits;
        negative = rhs.negative;
    }
    return *this;
}

bool BigInt::is_negative() const {
    return negative;
}

uint64_t BigInt::get_bits(unsigned index) const {
    if (index < bits.size()) {
        return bits[index];
    }
    return 0;
}

const std::vector<uint64_t> &BigInt::get_bit_vector() const {
    return bits;
}


BigInt BigInt::operator+(const BigInt &rhs) const {
    BigInt result;
    if (this->is_negative() == rhs.is_negative()) {
        result.bits = add_magnitudes(*this, rhs);
        result.negative = this->is_negative();
    } else {
        if (compare_magnitudes(*this, rhs) > 0) {
            result.bits = subtract_magnitudes(*this, rhs);
            result.negative = this->is_negative();
        } else if (compare_magnitudes(*this, rhs) < 0) {
            result.bits = subtract_magnitudes(rhs, *this);
            result.negative = rhs.is_negative();
        } else {
            result.bits = subtract_magnitudes(rhs, *this);
            result.negative = false;
        }
    }
    return result;
}

BigInt BigInt::operator-(const BigInt &rhs) const {
    BigInt neg_rhs = rhs;
    neg_rhs.negative = !rhs.is_negative();
    return *this + neg_rhs;
}

BigInt BigInt::operator-() const {
    BigInt result = *this;
    if (!is_zero()) {
        result.negative = !this->negative;
    }
    return result;
}

bool BigInt::is_bit_set(unsigned n) const {
    if (n >= bits.size() * 64) {
        return false;
    }
    size_t index = n / 64;
    size_t bit_position = n % 64;
    return (bits[index] & (1ULL << bit_position)) != 0;
}

BigInt BigInt::operator<<(unsigned n) const {
    if (n == 0 || is_zero()) {
        return *this; // No shift needed for zero or n = 0
    }

    if (is_negative()) {
        throw std::invalid_argument("Cannot shift negative BigInt");
    }

    size_t full_words_shift = n / 64; // Number of 64-bit words to shift
    size_t bit_shift = n % 64; // Bit shift within a 64-bit word

    BigInt result;
    result.bits.resize(bits.size() + full_words_shift + 1, 0);

    for (size_t i = 0; i < bits.size(); ++i) {
        if (bit_shift) {
            result.bits[i + full_words_shift] |= (bits[i] << bit_shift);
            if (i + full_words_shift + 1 < result.bits.size()) {
                result.bits[i + full_words_shift + 1] |= (bits[i] >> (64 - bit_shift));
            }
        } else {
            result.bits[i + full_words_shift] = bits[i];
        }
    }

    // Remove leading zeros
    while (result.bits.size() > 1 && result.bits.back() == 0) {
        result.bits.pop_back();
    }

    result.negative = negative; // Copy the sign
    return result;
}


BigInt BigInt::operator*(const BigInt &rhs) const {
    // Handle trivial cases like multiplying by zero
    if (this->is_zero() || rhs.is_zero()) {
        return BigInt();  // Return zero
    }

    // Determine the sign of the result
    bool result_negative = (this->is_negative() != rhs.is_negative());

    // Initialize the result BigInt to zero
    BigInt result(0, false);

    // Iterate through each bit of the first operand (this BigInt)
    for (size_t i = 0; i < bits.size(); ++i) {
        uint64_t carry = 0;  // Initialize carry for the current "row" of multiplication

        // Multiply each word of this->bits[i] with all words of rhs
        for (size_t j = 0; j < rhs.bits.size() || carry > 0; ++j) {
            // Ensure the result is large enough to hold the result
            if (result.bits.size() <= i + j) {
                result.bits.push_back(0);
            }

            // Calculate the product of bits[i] * rhs.bits[j] + carry + current result value
            __uint128_t product = static_cast<__uint128_t>(bits[i]) *
                                  (j < rhs.bits.size() ? rhs.bits[j] : 0) +
                                  result.bits[i + j] +
                                  carry;

            result.bits[i + j] = static_cast<uint64_t>(product);  // Store the lower 64 bits
            carry = static_cast<uint64_t>(product >> 64);         // Store the carry (upper 64 bits)
        }
    }

    // Remove leading zeros in the result
    while (result.bits.size() > 1 && result.bits.back() == 0) {
        result.bits.pop_back();
    }

    // Set the correct sign
    result.negative = result_negative;

    return result;
}




BigInt BigInt::operator/(const BigInt &rhs) const {
    // Edge case: Division by zero
    if (rhs.is_zero()) {
        throw std::invalid_argument("Division by zero");
    }

    // Edge case: If the dividend is zero, return 0
    if (this->is_zero()) {
        return BigInt();  // Return 0
    }

    // Edge case: If dividing by 1 or -1, return the dividend or negated dividend
    if (rhs == BigInt(1, false)) {
        return *this;
    }
    if (rhs == BigInt(1, true)) {
        return -*this;
    }

    BigInt dividend = *this;  // Copy of the dividend
    BigInt divisor = rhs;     // Copy of the divisor
    dividend.negative = false;
    divisor.negative = false;

    // Handle case where dividend is smaller than divisor
    if (compare_magnitudes(dividend, divisor) < 0) {
        return BigInt(0, false);  // Quotient is 0
    }

    // Determine the sign of the result
    bool result_negative = (this->is_negative() != rhs.is_negative());

    // Binary search bounds: low = 0, high = dividend
    BigInt low(0, false);
    BigInt high = dividend;

    BigInt quotient(0, false);  // To store the final quotient

    while (low <= high) {
        // Midpoint of the binary search range
        BigInt mid = (low + high).div_by_2();
        BigInt product = mid * divisor;

        // Exact match, stop here
        if (product == dividend) {
            quotient = mid;
            break;
        }
        // If product is less than dividend, move the lower bound up
        else if (product < dividend) {
            quotient = mid;  // Update quotient
            low = mid + BigInt(1, false);  // Narrow the range upwards
        }
        // If product is greater than dividend, move the upper bound down
        else {
            high = mid - BigInt(1, false);  // Narrow the range downwards
        }
    }

    // Set the sign of the result
    quotient.negative = result_negative;

    // Remove leading zeros
    while (quotient.bits.size() > 1 && quotient.bits.back() == 0) {
        quotient.bits.pop_back();
    }

    return quotient;
}



int BigInt::compare(const BigInt &rhs) const {
    int magnitude_comparison = compare_magnitudes(*this, rhs);

    if (is_negative() && !rhs.is_negative()) {
        return -1;
    }
    if (!is_negative() && rhs.is_negative()) {
        return 1;
    }
    if (is_negative() && rhs.is_negative()) {
        return -magnitude_comparison;
    }

    return magnitude_comparison;
}

std::string BigInt::to_hex() const {
    std::ostringstream oss;

    if (is_zero()) {
        return "0";
    }

    if (is_negative()) {
        oss << "-";
    }

    const std::vector<uint64_t>& bit_vector = get_bit_vector();
    bool leading = true;

    for (auto it = bit_vector.rbegin(); it != bit_vector.rend(); ++it) {
        if (leading) {
            if (*it == 0) {
                continue;
            } else {
                oss << std::hex << *it;
                leading = false;
            }
        } else {
            oss << std::hex << std::setw(16) << std::setfill('0') << *it;
        }
    }

    return oss.str();
}

bool BigInt::is_zero() const {
    return bits.empty() || (bits.size() == 1 && bits[0] == 0);
}



BigInt BigInt::div_by_2() const {
    BigInt result(*this);  // Create a copy of the current BigInt to store the result
    uint64_t carry = 0;    // Variable to hold bits carried over between words

    // Iterate from the most significant word to the least significant word
    for (size_t i = result.bits.size(); i-- > 0; ) {
        uint64_t new_carry = result.bits[i] & 1;  // Get the least significant bit of the current word
        result.bits[i] = (result.bits[i] >> 1) | (carry << 63);  // Shift right and add carry from the previous word
        carry = new_carry;  // Carry over the LSB to the next word
    }

    // Remove leading zero words from the result
    while (result.bits.size() > 1 && result.bits.back() == 0) {
        result.bits.pop_back();
    }

    return result;
}


std::string BigInt::to_dec() const {
    if (is_zero()) {
        return "0";
    }

    BigInt value = *this;  // Copy of the BigInt to manipulate
    value.negative = false;  // Work with the absolute value (magnitude)

    std::stringstream ss;
    if (is_negative()) {
        ss << "-";
    }

    // Vector to store digits in reverse order
    std::vector<char> digits;

    // BigInt for 10 (divisor)
    BigInt ten(10, false);

    while (!value.is_zero()) {
        // Get the quotient and remainder (digit)
        BigInt quotient = value / ten;
        BigInt remainder = value - (quotient * ten);  // remainder = value % 10
        digits.push_back(static_cast<char>(remainder.get_bits(0) + '0'));  // Store digit as a char
        value = quotient;  // Update value to the quotient for the next iteration
    }

    // Reverse the collected digits
    for (auto it = digits.rbegin(); it != digits.rend(); ++it) {
        ss << *it;
    }

    return ss.str();
}


