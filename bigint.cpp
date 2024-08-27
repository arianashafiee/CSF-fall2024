#include <cassert>
#include "bigint.h"

int a;
int b;

BigInt::BigInt()
  // TODO: initialize member variables MS1
{
  num = '0';
}

BigInt::BigInt(std::initializer_list<uint64_t> vals, bool negative)
  // TODO: initialize member variables MS1
{
}

BigInt::BigInt(uint64_t val, bool negative)
  // TODO: initialize member variables MS1
{
}

BigInt::BigInt(const BigInt &other)
  // TODO: initialize member variables MS1
{
}

BigInt::~BigInt()
{
}

BigInt &BigInt::operator=(const BigInt &rhs)
{
  // TODO: implement MS1
}

bool BigInt::is_negative() const
{
  // TODO: implement MS1
}

uint64_t BigInt::get_bits(unsigned index) const
{
  // TODO: implement MS1
}

const std::vector<uint64_t> &BigInt::get_bit_vector() const
{
  // TODO: implement MS1
}

BigInt BigInt::operator+(const BigInt &rhs) const
{
  sum = a + b
  if (sum < a ){

  }
}

BigInt BigInt::operator-(const BigInt &rhs) const
{
  // TODO: implement
  // Hint: a - b could be computed as a + -b
}

BigInt BigInt::operator-() const
{
  // TODO: implement MS1
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

std::string BigInt::to_hex() const
{
  // TODO: implement MS1
}

std::string BigInt::to_dec() const
{
  // TODO: implement
}
