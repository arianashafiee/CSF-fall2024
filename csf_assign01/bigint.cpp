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
        if (compare_magnitudes(*this, rhs) >= 0) {
            result.bits = subtract_magnitudes(*this, rhs);
            result.negative = this->is_negative();
        } else {
            result.bits = subtract_magnitudes(rhs, *this);
            result.negative = rhs.is_negative();
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
    BigInt result;
    bool result_negative = (this->is_negative() != rhs.is_negative());

    if (this->is_zero() || rhs.is_zero()) {
        return BigInt(); // Return zero BigInt
    }

    // Result starts at 0
    result = BigInt(0, false);

    // Iterate through each bit of the first operand
    for (size_t i = 0; i < bits.size() * 64; ++i) {
        if (this->is_bit_set(i)) {
            // Shift the second operand by i and add to the result
            BigInt shifted_rhs = rhs << i;
            result = result + shifted_rhs;
        }
    }

    // Set the correct sign
    result.negative = result_negative;
    
    // Remove leading zeros from the result
    while (result.bits.size() > 1 && result.bits.back() == 0) {
        result.bits.pop_back();
    }

    return result;
}



BigInt BigInt::operator/(const BigInt &rhs) const {
    // Implement division
    return BigInt(); // Placeholder return
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
    // Implement division by 2
    return BigInt(); // Placeholder return
}

std::string BigInt::to_dec() const {
    // TODO: implement
    return ""; // Placeholder return
}
