
#include "bigint.h"
#include <cassert>
#include <sstream>
#include <iomanip>
#include <ios>

// Default constructor for BigInt, initializes to 0 
BigInt::BigInt() : bits(1, 0), negative(false) {}

// Constructor from initializer list, initializes BigInt with specified bits and sign
BigInt::BigInt(const std::initializer_list<uint64_t> vals, bool negative)
    : bits(vals), negative(negative) {

    while (bits.size() > 1 && bits.back() == 0) {
        bits.pop_back();  // Remove the most significant zeroes
    }
}

// Constructor from a single 64-bit unsigned integer, initializes BigInt with the given value and sign
BigInt::BigInt(uint64_t val, bool negative)
    : bits(1, val), negative(negative) {}

// Deep copy of bits and sign
BigInt::BigInt(const BigInt &other)
    : bits(other.bits), negative(other.negative) {}

// Destructor
BigInt::~BigInt() {}

// Assignment operator, assigns the values of another BigInt to this BigInt
BigInt &BigInt::operator=(const BigInt &rhs) {
    if (this != &rhs) {
        bits = rhs.bits;       // Copy the bit vector
        negative = rhs.negative; // Copy the sign
    }
    return *this;
}

// Returns true if the BigInt is negative and false otherwise
bool BigInt::is_negative() const {
    return negative;
}

// Returns the 64-bit chunk at the specified index in the bit vector.
// If the index is out of bounds, it returns 0 
uint64_t BigInt::get_bits(unsigned index) const {
    if (index < bits.size()) {
        return bits[index];  // Return the bits at the specified index
    }
    return 0;  // Return 0 if index is out of bounds
}

// Returns a const reference to the bit vector, which stores the magnitude of the BigInt
const std::vector<uint64_t> &BigInt::get_bit_vector() const {
    return bits;  // Return a reference to the internal bit vector
}

// Addition operator for BigInt, handles both positive and negative numbers
BigInt BigInt::operator+(const BigInt &rhs) const {
    BigInt result;  // Initialize the result BigInt

    // Both BigInts have the same sign
    if (this->is_negative() == rhs.is_negative()) {
        // Add the magnitudes and set the result's sign to match the operands' sign
        result.bits = add_magnitudes(*this, rhs);
        result.negative = this->is_negative();
    } 
    // BigInts have different signs (subtraction of magnitudes)
    else {
        // Compare magnitudes and subtract the smaller magnitude from the larger one
        if (compare_magnitudes(*this, rhs) > 0) {
            result.bits = subtract_magnitudes(*this, rhs);
            result.negative = this->is_negative();
        } else if (compare_magnitudes(*this, rhs) < 0) {
            result.bits = subtract_magnitudes(rhs, *this);
            result.negative = rhs.is_negative();
        } else {
            // If the magnitudes are equal, the result is zero
            result.bits = subtract_magnitudes(rhs, *this);
            result.negative = false;
        }
    }
    return result;  
}

// Subtraction operator, subtracts the rhs from this BigInt by adding the negation of rhs
BigInt BigInt::operator-(const BigInt &rhs) const {
    BigInt neg_rhs = rhs;  // Make a copy of the right-hand operand
    neg_rhs.negative = !rhs.is_negative();  // Negate the sign of the copy
    return *this + neg_rhs;  // Perform addition with the negated rhs
}

// Unary negation operator, negates the current BigInt 
BigInt BigInt::operator-() const {
    BigInt result = *this;  // Copy current BigInt
    // Flip the sign if the BigInt is not zero
    if (!is_zero()) {
        result.negative = !this->negative;
    }
    return result;  
}

// Checks if the n-th bit is set in the BigInt
bool BigInt::is_bit_set(unsigned n) const {
    // Return false if the bit index is out of bounds (greater than total bit length)
    if (n >= bits.size() * 64) {
        return false;
    }

    // Calculate which word contains the bit and its position within the word
    size_t index = n / 64;  // Index of the 64-bit word
    size_t bit_position = n % 64;  // Bit position within the 64-bit word

    // Check if the bit is set 
    return (bits[index] & (1ULL << bit_position)) != 0;
}

BigInt BigInt::operator<<(unsigned n) const {
    if (n == 0 || is_zero()) {
        return *this; // No shift needed
    }

    // Throw an exception if trying to left-shift a negative BigInt, as this operation is not supported
    if (is_negative()) {
        throw std::invalid_argument("Cannot shift negative BigInt");
    }

    size_t full_words_shift = n / 64; // Number of full 64-bit words to shift

    size_t bit_shift = n % 64; // Number of bits to shift within the word

    // Create a new BigInt to store the result and resize its bit vector to accommodate the shift
    BigInt result;
    result.bits.resize(bits.size() + full_words_shift + 1, 0);  

    for (size_t i = 0; i < bits.size(); ++i) {
        // If a bit shift is needed, handle both the shift and overflow
        if (bit_shift) {
            // Shift the current word left by bit_shift and store it at the correct position in the result
            result.bits[i + full_words_shift] |= (bits[i] << bit_shift);

            // Handles overflow, as bits that shift out of the left side are carried into the next word
            if (i + full_words_shift + 1 < result.bits.size()) {
                result.bits[i + full_words_shift + 1] |= (bits[i] >> (64 - bit_shift));
            }
        } else {
            // If no bit shift needed, move word to the correct position
            result.bits[i + full_words_shift] = bits[i];
        }
    }

    // Remove leading zeros from the result to ensure it has the correct magnitude representation
    while (result.bits.size() > 1 && result.bits.back() == 0) {
        result.bits.pop_back(); 
    }

    // Copy the sign from the original BigInt to the result
    result.negative = negative;  

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
    // Handle edge cases: Division by zero
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

    // Binary search to find the quotient
    BigInt quotient = binary_search_quotient(dividend, divisor);

    // Set the sign of the result
    quotient.negative = result_negative;

    // Remove leading zeros
    while (quotient.bits.size() > 1 && quotient.bits.back() == 0) {
        quotient.bits.pop_back();
    }

    return quotient;
}

// Helper function for binary search
BigInt BigInt::binary_search_quotient(const BigInt &dividend, const BigInt &divisor) const {
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

    return quotient;
}


int BigInt::compare(const BigInt &rhs) const {
    int magnitude_comparison = compare_magnitudes(*this, rhs);

    if (is_negative() && !rhs.is_negative()) {
        return -1;  // Negative is always smaller than positive
    }

    if (!is_negative() && rhs.is_negative()) {
        return 1;  // Positive is always greater than negative
    }

    // Both are negative, so we reverse the magnitude comparison
    // because a larger magnitude in negative numbers means a smaller value.
    if (is_negative() && rhs.is_negative()) {
        return -magnitude_comparison;  // Reverse the result for negative numbers
    }

    // Both numbers are non-negative, return the normal magnitude comparison
    return magnitude_comparison;
}


std::string BigInt::to_hex() const {
    std::ostringstream oss;  

    // If BigInt is zero, return "0"
    if (is_zero()) {
        return "0";
    }

    // If the BigInt is negative, prepend a negative sign to  output
    if (is_negative()) {
        oss << "-";
    }

    // Get a reference to magnitude representation
    const std::vector<uint64_t>& bit_vector = get_bit_vector();
    bool leading = true;  // handles leading zeros

    // Iterate over the bit vector in reverse order (most significant word first)
    for (auto it = bit_vector.rbegin(); it != bit_vector.rend(); ++it) {
        // Skip leading zeros
        if (leading) {
            if (*it == 0) {
                continue;  // Skip if current word is zero
            } else {
                // Once a non-zero word is found, output without padding
                oss << std::hex << *it;
                leading = false;  // Disable the leading zero flag
            }
        } else {
            // For subsequent words, output as 16-char hexadecimal values
            oss << std::hex << std::setw(16) << std::setfill('0') << *it;
        }
    }

    return oss.str();  // Return hexadecimal string
}


bool BigInt::is_zero() const {
    return bits.empty() || (bits.size() == 1 && bits[0] == 0);
}

BigInt BigInt::div_by_2() const {
    BigInt result(*this);  // Create copy of BigInt to store result
    uint64_t carry = 0;    // holds bits carried over between words

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

    BigInt value = *this;  // Copy of BigInt 
    value.negative = false;  // Work with the abs value

    std::stringstream ss;
    if (is_negative()) {
        ss << "-";
    }

    // Vector to store digits in reverse order
    std::vector<char> digits;

    // BigInt for 10 (divisor)
    BigInt ten(10, false);

    while (!value.is_zero()) {
        // Get the quotient and remainder 
        BigInt quotient = value / ten;
        BigInt remainder = value - (quotient * ten);  // remainder = value % 10
        digits.push_back(static_cast<char>(remainder.get_bits(0) + '0'));  // Store digit as a char
        value = quotient;  // Update value to the quotient for next iteration
    }

    // Reverse collected digits
    for (auto it = digits.rbegin(); it != digits.rend(); ++it) {
        ss << *it;
    }

    return ss.str();
}

