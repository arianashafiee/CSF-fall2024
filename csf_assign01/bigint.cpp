#include <cassert>
#include "bigint.h"
#include <sstream>
#include <iomanip>
#include <ios>
#include <list>



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
    if (n == 0 || is_zero()) {
        return *this;
    }

    size_t full_words_shift = n / 64;
    size_t bit_shift = n % 64;
    BigInt result;

    result.bits.resize(bits.size() + full_words_shift + 1, 0);

    for (size_t i = 0; i < bits.size(); ++i) {
        result.bits[i + full_words_shift] |= (bits[i] << bit_shift);
        if (bit_shift && i + full_words_shift + 1 < result.bits.size()) {
            result.bits[i + full_words_shift + 1] |= (bits[i] >> (64 - bit_shift));
        }
    }

    while (result.bits.size() > 1 && result.bits.back() == 0) {
        result.bits.pop_back();
    }

    result.negative = negative;
    return result;
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

int compare_magnitudes(const BigInt &lhs, const BigInt &rhs) {
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

BigInt add_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    const std::vector<uint64_t>& lhs_bits = lhs.get_bit_vector();
    const std::vector<uint64_t>& rhs_bits = rhs.get_bit_vector();

    size_t max_size = std::max(lhs_bits.size(), rhs_bits.size());
    std::vector<uint64_t> result_bits(max_size, 0);

    uint64_t carry = 0;

    for (size_t i = 0; i < max_size; ++i) {
        uint64_t lhs_val = (i < lhs_bits.size()) ? lhs_bits[i] : 0;
        uint64_t rhs_val = (i < rhs_bits.size()) ? rhs_bits[i] : 0;

        uint64_t sum = lhs_val + rhs_val + carry;
        carry = (sum < lhs_val || sum < rhs_val) ? 1 : 0;
        result_bits[i] = sum;
    }

    if (carry > 0) {
        result_bits.push_back(carry);
    }

    // Use auto to convert result_bits to a single uint64_t value
    uint64_t result_val = 0;
    for (auto it = result_bits.rbegin(); it != result_bits.rend(); ++it) {
        result_val = (result_val << 64) | *it;
    }

    BigInt result(result_val, false);  // Using existing constructor
    return result;
}

BigInt subtract_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    const std::vector<uint64_t>& lhs_bits = lhs.get_bit_vector();
    const std::vector<uint64_t>& rhs_bits = rhs.get_bit_vector();

    size_t max_size = std::max(lhs_bits.size(), rhs_bits.size());
    std::vector<uint64_t> result_bits(max_size, 0);

    uint64_t borrow = 0;

    for (size_t i = 0; i < max_size; ++i) {
        uint64_t lhs_val = (i < lhs_bits.size()) ? lhs_bits[i] : 0;
        uint64_t rhs_val = (i < rhs_bits.size()) ? rhs_bits[i] : 0;

        uint64_t diff = lhs_val - rhs_val - borrow;
        borrow = (lhs_val < rhs_val + borrow) ? 1 : 0;
        result_bits[i] = diff;
    }

    // Remove leading zeros
    while (result_bits.size() > 1 && result_bits.back() == 0) {
        result_bits.pop_back();
    }

    // Use auto to convert result_bits to a single uint64_t value
    uint64_t result_val = 0;
    for (auto it = result_bits.rbegin(); it != result_bits.rend(); ++it) {
        result_val = (result_val << 64) | *it;
    }

    BigInt result(result_val, false);  // Using existing constructor
    return result;
}


BigInt BigInt::operator+(const BigInt &rhs) const {
    if (this->is_negative() == rhs.is_negative()) {
        BigInt result = add_magnitudes(*this, rhs);
        result.negative = this->is_negative();
        return result;
    } else {
        if (compare_magnitudes(*this, rhs) >= 0) {
            BigInt result = subtract_magnitudes(*this, rhs);
            result.negative = this->is_negative();
            return result;
        } else {
            BigInt result = subtract_magnitudes(rhs, *this);
            result.negative = rhs.is_negative();
            return result;
        }
    }
}

BigInt BigInt::operator-(const BigInt &rhs) const {
    BigInt neg_rhs = rhs;
    neg_rhs.negative = !neg_rhs.is_negative();
    return *this + neg_rhs;
}


BigInt BigInt::div_by_2() const {
    // Implement division by 2
    return BigInt(); // Placeholder return
}

std::string BigInt::to_dec() const {
    // TODO: implement
    return ""; // Placeholder return
}