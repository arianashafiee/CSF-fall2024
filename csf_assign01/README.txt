Team members: Ariana Shafiee and Eric Guan

Ariana Shafiee:
is_bit_set(unsigned) member function
operator+(const BigInt &) member function 
operator-(const BigInt &) member function 
operator*(const BigInt &) member function
compare(const BigInt &) member function
operator<<(unsigned) member function 
operator/(const BigInt &) member function 
to_dec() member function 
Test Functions

Eric Guan:
is_bit_set(unsigned) member function
operator+(const BigInt &) member function 
operator-(const BigInt &) member function 
operator*(const BigInt &) member function
compare(const BigInt &) member function
operator<<(unsigned) member function 
operator/(const BigInt &) member function 
to_dec() member function 
Test Functions

Interesting things about our implementation:
- During the initialization, we removed unnecessary leading zeros to ensure the internal bit representation is compact, not only optimizing memory usage, but also simplifies operations including comparison and arithmetic.

- The division operation makes use of a binary search approach to compute the quotient, ensuring that division is handled efficiently, even for large numbers, by narrowing down the quotient through comparisons and bit shifts

- The decimal conversion is particularly interesting, as it performs repeated division by 10 and stores the digits in reverse order before constructing the final string.
