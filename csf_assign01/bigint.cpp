#include <cassert>
#include "bigint.h"
#include <sstream>   // For std::ostringstream
#include <iomanip>   // For std::setw, std::setfill, std::hex
#include <ios>

BigInt::BigInt() : bits(1, 0), negative(false) {}

BigInt::BigInt(std::initializer_list<uint64_t> vals, bool negative)
    : bits(vals), negative(negative) {
    // Remove leading zeros
    while (bits.size() > 1 && bits.back() == 0) {
        bits.pop_back();
    }
}

BigInt::BigInt(uint64_t val, bool negative)
    : bits(1, val), negative(negative) {}

BigInt::BigInt(const BigInt &other)
    : bits(other.bits), negative(other.negative) {}

BigInt::~BigInt()
{
}

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
    if (this->is_negative() == rhs.is_negative()) {
        // Both numbers have the same sign; add their magnitudes
        BigInt result = add_magnitudes(*this, rhs);
        result.negative = this->is_negative(); // Result has the same sign
        return result;
    } else {
        // Different signs; subtract magnitudes and use the sign of the larger magnitude
        if (compare_magnitudes(*this, rhs) >= 0) {
            // *this is larger or equal in magnitude
            BigInt result = subtract_magnitudes(*this, rhs);
            result.negative = this->is_negative(); // Result has the sign of *this
            return result;
        } else {
            // rhs is larger in magnitude
            BigInt result = subtract_magnitudes(rhs, *this);
            result.negative = rhs.is_negative(); // Result has the sign of rhs
            return result;
        }
    }
}


BigInt BigInt::operator-(const BigInt &rhs) const {
    // Subtract rhs from *this, which is equivalent to adding *this and -rhs
    BigInt neg_rhs = rhs;
    neg_rhs.negative = !neg_rhs.is_negative(); // Negate the sign of rhs
    return *this + neg_rhs;
}


BigInt BigInt::operator-() const {
    // BigInt result;
    // if (result.negative) {
    //     result.negative = false;
    // }
    // else {
    //     result.negative = true;
    // }

    BigInt result;
    result.bits = this->bits; 

    if (this->is_zero()) {
        result.negative = false; 
    } else {
        result.negative = !this->negative;  
    result.bits = this->bits;

    if (this->is_zero())
    {
        result.negative = false;
    }
    else
    {
        result.negative = !this->negative;
    }

    return result;
}


bool BigInt::is_bit_set(unsigned n) const {
    if (n >= bits.size() * 64) {
        return false; // Bit position is out of range
    }

    // Determine which uint64_t element contains the bit
    size_t index = n / 64;
    // Determine which bit within that uint64_t element
    size_t bit_position = n % 64;

    // Check if the bit is set
    return (bits[index] & (1ULL << bit_position)) != 0;
}

BigInt BigInt::operator<<(unsigned n) const {
    // TODO: implement
    return BigInt(); // Placeholder return
}

BigInt BigInt::operator*(const BigInt &rhs) const {
    if (this->is_zero() || rhs.is_zero()) {
        return BigInt(); // Product of any number with zero is zero
    }

    // Result will have the sign of the result
    bool result_negative = (this->is_negative() != rhs.is_negative());

    // Prepare the result BigInt
    BigInt result;

    // Perform multiplication
    for (unsigned i = 0; i < bits.size(); ++i) {
        if (is_bit_set(i)) {
            // Shift rhs by i bits and add to result
            BigInt term = rhs;
            term = term << i; // Shift left by i bits
            result = add_magnitudes(result, term);
        }
    }

    // Set the sign of the result
    result.negative = result_negative;

    return result;
}


BigInt BigInt::operator/(const BigInt &rhs) const {
    // TODO: implement
    return BigInt(); // Placeholder return
}

int BigInt::compare(const BigInt &rhs) const {
    // First, compare the magnitudes
    int magnitude_comparison = compare_magnitudes(*this, rhs);

    if (is_negative() && !rhs.is_negative()) {
        // If *this is negative and rhs is positive, *this is less than rhs
        return -1;
    }
    if (!is_negative() && rhs.is_negative()) {
        // If *this is positive and rhs is negative, *this is greater than rhs
        return 1;
    }
    if (is_negative() && rhs.is_negative()) {
        // Both are negative, reverse the magnitude comparison
        return -magnitude_comparison;
    }

    // Both are non-negative, return magnitude comparison result
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
    bool leading = true; // skip leading zeros

    for (std::vector<uint64_t>::const_reverse_iterator it = bit_vector.rbegin(); it != bit_vector.rend(); ++it) {
        if (leading) {
            if (*it == 0) {
                continue; // skip leading zero groups
            } else {
                oss << std::hex << std::hex << *it;
                leading = false; // stop skipping after first non-zero group
            }
        } else {
            oss << std::hex << std::setw(16) << std::setfill('0') << *it;
        }
    }

    return oss.str();
}


bool BigInt::is_zero() const {
    return bits.empty() || bits.size() == 1 && bits[0] == 0;
}

static int compare_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    // Get the bit vectors for both BigInt objects
    const std::vector<uint64_t>& lhs_bits = lhs.get_bit_vector();
    const std::vector<uint64_t>& rhs_bits = rhs.get_bit_vector();

    // Compare sizes first
    if (lhs_bits.size() > rhs_bits.size()) {
        return 1;  // lhs has more bits, so it is larger
    }
    if (lhs_bits.size() < rhs_bits.size()) {
        return -1; // rhs has more bits, so it is larger
    }

    // Sizes are equal, compare elements from most significant to least significant
    for (size_t i = lhs_bits.size(); i-- > 0; ) {
        if (lhs_bits[i] > rhs_bits[i]) {
            return 1;  // lhs is larger
        }
        if (lhs_bits[i] < rhs_bits[i]) {
            return -1; // rhs is larger
        }
    }

    // If all elements are equal
    return 0;
}

static BigInt add_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    const std::vector<uint64_t>& lhs_bits = lhs.get_bit_vector();
    const std::vector<uint64_t>& rhs_bits = rhs.get_bit_vector();

    size_t max_size = std::max(lhs_bits.size(), rhs_bits.size());
    std::vector<uint64_t> result_bits(max_size, 0);

    uint64_t carry = 0;

    for (size_t i = 0; i < max_size; ++i) {
        uint64_t lhs_val = (i < lhs_bits.size()) ? lhs_bits[i] : 0;
        uint64_t rhs_val = (i < rhs_bits.size()) ? rhs_bits[i] : 0;

        uint64_t sum = lhs_val + rhs_val + carry;
        carry = (sum < lhs_val || sum < rhs_val) ? 1 : 0; // Determine carry
        result_bits[i] = sum;
    }

    if (carry > 0) {
        result_bits.push_back(carry); // Add the final carry if needed
    }

    return BigInt(result_bits, false); // The result of addition is non-negative
}

static BigInt subtract_magnitudes(const BigInt &lhs, const BigInt &rhs) {
    const std::vector<uint64_t>& lhs_bits = lhs.get_bit_vector();
    const std::vector<uint64_t>& rhs_bits = rhs.get_bit_vector();

    size_t max_size = lhs_bits.size();
    std::vector<uint64_t> result_bits(max_size, 0);

    uint64_t borrow = 0;

    for (size_t i = 0; i < max_size; ++i) {
        uint64_t lhs_val = lhs_bits[i];
        uint64_t rhs_val = (i < rhs_bits.size()) ? rhs_bits[i] : 0;

        uint64_t diff = lhs_val - rhs_val - borrow;
        borrow = (diff > is) ? 1 : 0; // Determine borrow
        result_bits[i] = diff;
    }

    // Remove trailing zeros from result_bits
    while (result_bits.size() > 1 && result_bits.back() == 0) {
        result_bits.pop_back();
    }

    return BigInt(result_bits, false); // The result of subtraction is non-negative
}

BigInt BigInt::div_by_2() const {
    if (is_zero()) {
        return BigInt(); // Dividing zero by 2 results in zero
    }

    std::vector<uint64_t> result_bits(bits.size(), 0);

    uint64_t carry = 0;

    for (size_t i = bits.size(); i-- > 0; ) {
        uint64_t current = bits[i];
        result_bits[i] = (current >> 1) | carry;
        carry = (current & 1) ? (1ULL << 63) : 0; // Determine if the carry bit is set for the next iteration
    }

    // Remove leading zeros from result_bits
    while (result_bits.size() > 1 && result_bits.back() == 0) {
        result_bits.pop_back();
    }

    // The sign of the result depends on the original sign
    return BigInt(result_bits, is_negative());
}


std::string BigInt::to_dec() const {
    // TODO: implement
    return ""; // Placeholder return
}