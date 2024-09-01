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
    // TODO: implement
    return BigInt(); // Placeholder return
}

BigInt BigInt::operator-(const BigInt &rhs) const {
    // TODO: implement
    return BigInt(); // Placeholder return
}

BigInt BigInt::operator-() const {
    BigInt result;
    if (is_zero) {
        result.negative = false;
    }
    else if (result.negative) {
        result.negative = false;
    }
    else {
        result.negative = true;
    }

    return result;
}

bool BigInt::is_bit_set(unsigned n) const {
    // TODO: implement
    return false; // Placeholder return
}

BigInt BigInt::operator<<(unsigned n) const {
    // TODO: implement
    return BigInt(); // Placeholder return
}

BigInt BigInt::operator*(const BigInt &rhs) const {
    // TODO: implement
    return BigInt(); // Placeholder return
}

BigInt BigInt::operator/(const BigInt &rhs) const {
    // TODO: implement
    return BigInt(); // Placeholder return
}

int BigInt::compare(const BigInt &rhs) const {
    // TODO: implement
    return 0; // Placeholder return
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
    return bits.size() == 1 && bits[0] == 0;
}

std::string BigInt::to_dec() const {
    // TODO: implement
    return ""; // Placeholder return
}