#include <cassert>
#include "bigint.h"
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
    if (this->negative == rhs.negative) {
        // Both numbers have the same sign; add magnitudes
        return add_magnitudes(*this, rhs);
    } else {
        // Different signs; perform subtraction
        if (compare_magnitudes(*this, rhs) >= 0) {
            // `*this` is greater or equal to `rhs`
            return subtract_magnitudes(*this, rhs);
        } else {
            // `rhs` is greater than `*this`
            BigInt result = subtract_magnitudes(rhs, *this);
            result.negative = rhs.negative;
            return result;
        }
    }
}


BigInt BigInt::operator-(const BigInt &rhs) const {
    if (this->negative == rhs.negative) {
        if (compare_magnitudes(*this, rhs) >= 0) {
            // Subtract magnitudes and keep the sign of `*this`
            return subtract_magnitudes(*this, rhs);
        } else {
            // Subtract magnitudes and negate the result
            BigInt result = subtract_magnitudes(rhs, *this);
            result.negative = !this->negative;
            return result;
        }
    } else {
        // If signs are different, add magnitudes
        BigInt rhs_neg = rhs;
        rhs_neg.negative = !rhs_neg.negative;
        return *this + rhs_neg;
    }
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

    for (unsigned i = 0; i < bits.size(); ++i) {
        if (is_bit_set(i)) {
            BigInt term = rhs;
            term = term << i;
            result = add_magnitudes(result, term);
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

static int compare_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    const std::vector<uint64_t>& lhs_bits = lhs.get_bit_vector();
    const std::vector<uint64_t>& rhs_bits = rhs.get_bit_vector();

    if (lhs_bits.size() > rhs_bits.size()) {
        return 1;
    }
    if (lhs_bits.size() < rhs_bits.size()) {
        return -1;
    }

    for (size_t i = lhs_bits.size(); i-- > 0; ) {
        if (lhs_bits[i] > rhs_bits[i]) {
            return 1;
        }
        if (lhs_bits[i] < rhs_bits[i]) {
            return -1;
        }
    }

    return 0;
}
BigInt BigInt::add_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    // Ensure lhs and rhs are of the same size
    std::vector<uint64_t> result_bits;
    size_t max_size = std::max(lhs.bits.size(), rhs.bits.size());
    result_bits.resize(max_size, 0);

    uint64_t carry = 0;
    for (size_t i = 0; i < max_size; ++i) {
        uint64_t lhs_val = (i < lhs.bits.size()) ? lhs.bits[i] : 0;
        uint64_t rhs_val = (i < rhs.bits.size()) ? rhs.bits[i] : 0;

        uint64_t sum = lhs_val + rhs_val + carry;
        result_bits[i] = sum;
        carry = (sum < lhs_val) ? 1 : 0; // Carry is set if sum overflowed
    }

    // Handle final carry
    if (carry > 0) {
        result_bits.push_back(carry);
    }

    // Create and return a new BigInt object
    return BigInt(result_bits, false);
}

BigInt BigInt::subtract_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    std::vector<uint64_t> result_bits;
    size_t max_size = std::max(lhs.bits.size(), rhs.bits.size());
    result_bits.resize(max_size, 0);

    int64_t borrow = 0;
    for (size_t i = 0; i < max_size; ++i) {
        uint64_t lhs_val = (i < lhs.bits.size()) ? lhs.bits[i] : 0;
        uint64_t rhs_val = (i < rhs.bits.size()) ? rhs.bits[i] : 0;

        uint64_t diff = lhs_val - rhs_val - borrow;
        if (lhs_val < rhs_val + borrow) {
            borrow = 1;
            diff += (1ULL << 64); // Add 2^64 to the difference to handle underflow
        } else {
            borrow = 0;
        }

        result_bits[i] = diff;
    }

    // Remove leading zeros
    while (result_bits.size() > 1 && result_bits.back() == 0) {
        result_bits.pop_back();
    }

    // Create and return a new BigInt object
    return BigInt(result_bits, false);
}

BigInt BigInt::div_by_2() const {
    // Implement division by 2
    return BigInt(); // Placeholder return
}

std::string BigInt::to_dec() const {
    // TODO: implement
    return ""; // Placeholder return
}