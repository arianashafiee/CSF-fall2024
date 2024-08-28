#include <cassert>
#include "bigint.h"

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

BigInt BigInt::operator+(const BigInt &rhs) const
{
}

BigInt BigInt::operator-(const BigInt &rhs) const {
  // TODO: implement

}

BigInt BigInt::operator-() const {
  return BigInt(bits, !negative);
}

bool BigInt::is_bit_set(unsigned n) const
{
  // TODO: implement
}

BigInt BigInt::operator<<(unsigned n) const
{
  // TODO: implement
}

BigInt BigInt::operator*(const BigInt &rhs) const
{
  // TODO: implement
}

BigInt BigInt::operator/(const BigInt &rhs) const
{
  // TODO: implement
}

int BigInt::compare(const BigInt &rhs) const
{
  // TODO: implement
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

    for (std::vector<uint64_t>::const_reverse_iterator it = bit_vector.rbegin(); it != bit_vector.rend(); ++it) {
        oss << std::hex << std::setw(16) << std::setfill('0') << *it;
    }

    return oss.str();
}

bool BigInt::is_zero() const {
    return bits.size() == 1 && bits[0] == 0;
}

std::string BigInt::to_dec() const
{
  // TODO: implement
}