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
    // Implement left shift
    return BigInt(); // Placeholder return
}

BigInt BigInt::operator*(const BigInt &rhs) const {
    if (this->is_zero() || rhs.is_zero()) {
        return BigInt();
    }

    bool result_negative = (this->is_negative() != rhs.is_negative());
    BigInt result;

    // Initialize result.bits with a vector of zeroes
    result.bits = std::vector<uint64_t>(bits.size() + rhs.bits.size(), 0);

    for (unsigned i = 0; i < bits.size(); ++i) {
        if (is_bit_set(i)) {
            BigInt term = rhs;
            term = term << i;
            // Use add_magnitudes to accumulate the result
            result.bits = add_magnitudes(result.bits, term.get_bit_vector());
        }
    }

    result.negative = result_negative;
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