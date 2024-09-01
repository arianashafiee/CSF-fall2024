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
    BigInt result = *this;

    // Invert all bits
    for (std::size_t i = 0; i < result.bit_string.size(); ++i) {
        result.bit_string[i] = ~result.bit_string[i];
    }

    // Add 1 to get the two's complement
    uint64_t carry = 1;
    for (std::size_t i = 0; i < result.bit_string.size(); ++i) {
        uint64_t temp = result.bit_string[i] + carry;
        if (temp < result.bit_string[i]) {  // Check for overflow
            carry = 1;
        } else {
            carry = 0;
        }
        result.bit_string[i] = temp;
        if (carry == 0) {
            break;
        }
    }

    // Toggle the sign
    result.is_negative = !this->is_negative;

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

    // Handle the sign
    if (is_negative) {
        oss << '-';
    }

    // Loop through the vector in reverse to convert each uint64_t to hex
    bool leading_zero = true; // To skip leading zeros
    for (std::vector<uint64_t>::const_reverse_iterator it = bit_string.rbegin(); it != bit_string.rend(); ++it) {
        if (leading_zero) {
            if (*it != 0) {
                leading_zero = false;
                oss << std::hex << *it;
            }
        } else {
            // Set width to 16 to ensure full representation of uint64_t
            oss << std::setfill('0') << std::setw(16) << std::hex << *it;
        }
    }

    // Handle the case where all bits are zero
    if (oss.str().empty() || oss.str() == "-") {
        return "0";
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