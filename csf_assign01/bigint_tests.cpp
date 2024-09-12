#include <stdexcept>
#include <sstream>
#include <iostream>
#include "bigint.h"
#include "tctest.h"

struct TestObjs {
  BigInt zero;
  BigInt one;
  BigInt two;
  BigInt u64_max;
  BigInt two_pow_64;
  BigInt negative_two_pow_64;
  BigInt three;
  BigInt negative_nine;
  BigInt negative_three;
  BigInt negative_two;
  BigInt nine;
  
  BigInt negative_one;
    BigInt large_positive;
    BigInt large_negative;

  TestObjs();
};

// prototypes for setup and cleanup functions
TestObjs *setup();
void cleanup(TestObjs *objs);

// Verify that a BigInt contains appropriate data by checking the
// contents of its internal vector of uint64_t values.
// This allows us to validate the contents of a BigInt object
// without needing to rely on member functions other than get_bit_vector().
// Throws std::runtime_error if the actual values don't exactly match
// the expected values.
void check_contents(const BigInt &bigint, std::initializer_list<uint64_t> expected_vals);

// prototypes of test functions
void test_default_ctor(TestObjs *objs);
void test_u64_ctor(TestObjs *objs);
void test_initlist_ctor(TestObjs *objs);
void test_copy_ctor(TestObjs *objs);
void test_get_bits(TestObjs *objs);

void test_add_1(TestObjs *objs);
void test_add_2(TestObjs *objs);
void test_add_3(TestObjs *objs);
void test_add_4(TestObjs *objs);

void test_sub_1(TestObjs *objs);
void test_sub_2(TestObjs *objs);
void test_sub_3(TestObjs *objs);
void test_sub_4(TestObjs *objs);

void test_is_bit_set_1(TestObjs *objs);
void test_is_bit_set_2(TestObjs *objs);

void test_lshift_1(TestObjs *objs);
void test_lshift_2(TestObjs *objs);

void test_mul_1(TestObjs *objs);
void test_mul_2(TestObjs *objs);

void test_compare_1(TestObjs *objs);
void test_compare_2(TestObjs *objs);

void test_div_1(TestObjs *objs);
void test_div_2(TestObjs *objs);
void test_div_3(TestObjs *objs);
void test_div_5(TestObjs *objs);
void test_div_6(TestObjs *objs);
void test_div_7(TestObjs *objs);




void test_to_hex_1(TestObjs *objs);
void test_to_hex_2(TestObjs *objs);

void test_to_dec_1(TestObjs *objs);
void test_to_dec_2(TestObjs *objs);

// New test prototypes
void test_compare_3(TestObjs *objs);
void test_compare_4(TestObjs *objs);
void test_compare_5(TestObjs *objs);
void test_compare_6(TestObjs *objs);
void test_compare_7(TestObjs *objs);
void test_is_bit_set_3(TestObjs *objs);
void test_is_bit_set_4(TestObjs *objs);
void test_is_bit_set_5(TestObjs *objs);
void test_is_bit_set_6(TestObjs *objs);
void test_is_bit_set_7(TestObjs *objs);
void test_is_bit_set_8(TestObjs *objs);
void test_is_bit_set_9(TestObjs *objs);
void test_lshift_3(TestObjs *objs);
void test_lshift_4(TestObjs *objs);
void test_left_shift_5(TestObjs *objs);
void test_left_shift_6(TestObjs *objs);
void test_left_shift_7(TestObjs *objs);
void test_to_hex_3(TestObjs *objs);
void test_to_hex_4(TestObjs *objs);
void test_to_hex_5(TestObjs *objs);
void test_to_hex_6(TestObjs *objs);
void test_to_dec_3(TestObjs *objs);
void test_to_dec_4(TestObjs *objs);
void test_to_dec_5(TestObjs *objs);
void test_to_dec_6(TestObjs *objs);
void test_to_dec_7(TestObjs *objs);
void test_to_dec_8(TestObjs *objs);
void test_to_dec_9(TestObjs *objs);
void test_add_5(TestObjs *objs);
void test_add_6(TestObjs *objs);
void test_add_7(TestObjs *objs);
void test_add_8(TestObjs *objs);
void test_add_9(TestObjs *objs);
void test_sub_5(TestObjs *objs);
void test_sub_6(TestObjs *objs);
void test_sub_7(TestObjs *objs);
void test_sub_8(TestObjs *objs);
void test_mul_3(TestObjs *objs);
void test_mul_4(TestObjs *objs);
void test_mul_5(TestObjs *objs);
void test_mul_6(TestObjs *objs);
void test_mul_7(TestObjs *objs);
void test_div_3(TestObjs *objs);
void test_div_5(TestObjs *objs);
void test_div_6(TestObjs *objs);
void test_div_7(TestObjs *objs);
void test_is_negative(TestObjs *objs);
void test_get_bits_within_bounds(TestObjs *objs);
void test_get_bits_out_of_bounds(TestObjs *objs);
void test_assignment_operator(TestObjs *objs);
void test_unary_negation_operator(TestObjs *objs);
void test_get_bit_vector(TestObjs *objs);
void test_copy_constructor(TestObjs *objs);
void test_single_uint64_constructor(TestObjs *objs);
void test_initializer_list_constructor(TestObjs *objs);
void test_default_constructor(TestObjs *objs);




int main(int argc, char **argv) {
  if (argc > 1) {
    tctest_testname_to_execute = argv[1];
  }

  TEST_INIT();

  TEST(test_default_ctor);
  TEST(test_u64_ctor);
  TEST(test_initlist_ctor);
  TEST(test_copy_ctor);
  TEST(test_get_bits);

  TEST(test_add_1);
  TEST(test_add_2);
  TEST(test_add_3);
  TEST(test_add_4);
  TEST(test_add_5);
  TEST(test_add_6);
  TEST(test_add_7);
  TEST(test_add_8);
  TEST(test_add_9);

  TEST(test_sub_1);
  TEST(test_sub_2);
  TEST(test_sub_3);
  TEST(test_sub_4);
  TEST(test_sub_5);
  TEST(test_sub_6);
  TEST(test_sub_7);
  TEST(test_sub_8);

  TEST(test_is_bit_set_1);
  TEST(test_is_bit_set_2);
  TEST(test_is_bit_set_3);
  TEST(test_is_bit_set_4);
  TEST(test_is_bit_set_5);
  TEST(test_is_bit_set_6);
  TEST(test_is_bit_set_7);
  TEST(test_is_bit_set_8);
  TEST(test_is_bit_set_9);

  TEST(test_lshift_1);
  TEST(test_lshift_2);
  TEST(test_lshift_3);
  TEST(test_lshift_4);
  TEST(test_left_shift_5);
  TEST(test_left_shift_6);
  TEST(test_left_shift_7);

  TEST(test_mul_1);
  TEST(test_mul_2);
  TEST(test_mul_3);
  TEST(test_mul_4);
  TEST(test_mul_5);
  TEST(test_mul_6);
  TEST(test_mul_7);

  TEST(test_compare_1);
  TEST(test_compare_2);
  TEST(test_compare_3);
  TEST(test_compare_4);
  TEST(test_compare_5);
  TEST(test_compare_6);
  TEST(test_compare_7);

  TEST(test_div_1);
  TEST(test_div_2);
  TEST(test_div_3);

  TEST(test_to_hex_1);
  TEST(test_to_hex_2);
  TEST(test_to_hex_3);
  TEST(test_to_hex_4);
  TEST(test_to_hex_5);
  TEST(test_to_hex_6);

  TEST(test_to_dec_1);
  TEST(test_to_dec_2);
  TEST(test_to_dec_3);
  TEST(test_to_dec_4);
  TEST(test_to_dec_5);
  TEST(test_to_dec_6);
  TEST(test_to_dec_7);
  TEST(test_to_dec_8);
  TEST(test_to_dec_9);
  TEST(test_is_negative);
  TEST(test_get_bits_within_bounds);
  TEST(test_get_bits_out_of_bounds);
  TEST(test_assignment_operator);
  TEST(test_unary_negation_operator);
  TEST(test_get_bit_vector);
  TEST(test_default_constructor);
  TEST(test_initializer_list_constructor);
  TEST(test_single_uint64_constructor);
  TEST(test_copy_constructor);




  TEST_FINI();
}


// All initialization of test fixture objects should be done
// in the TestObjs constructor.
TestObjs::TestObjs()
  : zero()
  , one(1UL)
  , two(2UL)
  , u64_max(0xFFFFFFFFFFFFFFFFUL)
  , two_pow_64({ 0UL, 1UL })
  , negative_two_pow_64({ 0UL, 1UL }, true)
  , three(3UL)
  , negative_nine(9UL, true)
  , negative_three(3UL, true)
  , negative_two(2UL, true)
  , nine(9UL)

  , negative_one(1UL, true)
  , large_positive({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL})
  , large_negative({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL}, true)
{
}

TestObjs *setup() {
  return new TestObjs;
}

void cleanup(TestObjs *objs) {
  delete objs;
}

void check_contents(const BigInt &bigint, std::initializer_list<uint64_t> expected_vals) {
  const std::vector<uint64_t> &actual_vals = bigint.get_bit_vector();

  auto i = actual_vals.begin();
  auto j = expected_vals.begin();

  unsigned count = 0;

  while (i != actual_vals.end() && j != expected_vals.end()) {
    if (*i != *j) {
      std::stringstream msg;
      msg << "in word " << count
          << " actual value " << std::hex << *i
          << " does not match expected value " << std::hex << *j;
      throw std::runtime_error(msg.str());
    }
    ++i;
    ++j;
    ++count;
  }

  // at this point, if either the expected values or actual values
  // have additional data, all of the additional values need to be 0

  while (i != actual_vals.end()) {
    if (*i != 0UL) {
      std::stringstream msg;
      msg << "in word " << count
          << " actual value " << std::hex << *i
          << " does not match expected value 0";
      throw std::runtime_error(msg.str());
    }
    ++i;
    ++count;
  }

  while (j != expected_vals.end()) {
    if (*j != 0UL) {
      std::stringstream msg;
      msg << "in word " << count
          << " actual value 0 "
          << " does not match expected value " << std::hex << *j;
      throw std::runtime_error(msg.str());
    }
    ++j;
    ++count;
  }
}

void test_default_ctor(TestObjs *objs) {
  check_contents(objs->zero, { 0UL });
  ASSERT(!objs->zero.is_negative());
}

void test_u64_ctor(TestObjs *objs) {
  check_contents(objs->one, { 1UL });
  ASSERT(!objs->one.is_negative());

  check_contents(objs->two, { 2UL });
  ASSERT(!objs->two.is_negative());

  check_contents(objs->u64_max, { 0xFFFFFFFFFFFFFFFFUL });
  ASSERT(!objs->u64_max.is_negative());

  check_contents(objs->three, { 3UL });
  ASSERT(!objs->three.is_negative());

  check_contents(objs->negative_nine, { 9UL });
  ASSERT(objs->negative_nine.is_negative());

  check_contents(objs->negative_three, { 3UL });
  ASSERT(objs->negative_three.is_negative());

  check_contents(objs->nine, { 9UL });
  ASSERT(!objs->nine.is_negative());
}

void test_initlist_ctor(TestObjs *objs) {
  check_contents(objs->two_pow_64, { 0UL, 1UL });
  ASSERT(!objs->two_pow_64.is_negative());

  check_contents(objs->negative_two_pow_64, { 0UL, 1UL });
  ASSERT(objs->negative_two_pow_64.is_negative());
}

void test_copy_ctor(TestObjs *objs) {
  BigInt copy(objs->two_pow_64);

  check_contents(copy, { 0UL, 1UL });
  ASSERT(!copy.is_negative());
}

void test_get_bits(TestObjs *objs) {
  ASSERT(0UL == objs->zero.get_bits(0));
  ASSERT(0UL == objs->zero.get_bits(1));

  ASSERT(1UL == objs->one.get_bits(0));
  ASSERT(0UL == objs->one.get_bits(1));

  ASSERT(0xFFFFFFFFFFFFFFFFUL == objs->u64_max.get_bits(0));
  ASSERT(0UL == objs->u64_max.get_bits(1));

  ASSERT(0UL == objs->two_pow_64.get_bits(0));
  ASSERT(1UL == objs->two_pow_64.get_bits(1));
}

void test_add_1(TestObjs *objs) {
  // very basic tests for addition

  BigInt result1 = objs->zero + objs->zero;
  check_contents(result1, { 0UL });
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->zero + objs->one;
  check_contents(result2, { 1UL });
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->one + objs->zero;
  check_contents(result3, { 1UL });
  ASSERT(!result3.is_negative());

  BigInt result4 = objs->u64_max + objs->one;
  check_contents(result4, { 0UL, 1UL });
  ASSERT(!result4.is_negative());
}

void test_add_2(TestObjs *) {
  // Harder addition test(s)
  {
    BigInt left({0xc26e6d5f53ab28a0UL, 0xfb12a615f71867UL, 0x1f12c444bbc13UL});
    BigInt right({0x68adaac8bc0c460aUL, 0x2b287106b393UL});
    BigInt result = left + right;
    check_contents(result, {0x2b1c18280fb76eaaUL, 0xfb3dce86fdcbfbUL, 0x1f12c444bbc13UL});
    ASSERT(!result.is_negative());
  }
}

void test_add_3(TestObjs *objs) {
  // Test additions with mixed signs

  BigInt result1 = objs->three + objs->negative_nine;
  check_contents(result1, { 6UL });
  ASSERT(result1.is_negative());

  BigInt result2 = objs->negative_nine + objs->three;
  check_contents(result2, { 6UL });
  ASSERT(result2.is_negative());
}

void test_add_4(TestObjs *) {
  // Harder addition test(s) with negative and nonnegative operands
  {
    BigInt left({0x9f33ca9e0290d102UL, 0xd331662e19562498UL, 0x2347e72885d6e83UL, 0x529bac52c46b047UL, 0x69b3f801ea78f778UL, 0xfdba8845fc024708UL, 0x2UL});
    BigInt right({0x3efacbd8f95c7bbUL, 0x974f58eddfc56dfeUL, 0xa844e13b7c33ebedUL, 0xb4dd001fbdf5f260UL, 0x755c8aee33f48fecUL, 0x60UL}, true);
    BigInt result = left + right;
    check_contents(result, {0x9b441de072fb0947UL, 0x3be20d403990b69aUL, 0x59ef9d370c298296UL, 0x504cbaa56e50bde6UL, 0xf4576d13b684678bUL, 0xfdba8845fc0246a7UL, 0x2UL});
    ASSERT(!result.is_negative());
  }

  {
    BigInt left({0xd2ec154f6f077e95UL, 0x1bb578fcbf5bec60UL, 0x36735d365fe0f69eUL, 0xa803e03015c610e8UL, 0xca14aac782de50a2UL, 0x2191456abd619da2UL, 0xd9a345c56ba9a659UL, 0x1de31271dc3UL}, true);
    BigInt right({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL}, true);
    BigInt result = left + right;
    check_contents(result, {0xb59e87ef7168ae78UL, 0xeda1de5b1d8a2999UL, 0x582fd87e1ac8af37UL, 0x5a15629c64224557UL, 0x3ec79d142be30f0UL, 0x33e531c4dbbd2d3dUL, 0x946004cdecfe6d47UL, 0x3e67713d575ed0b1UL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
    ASSERT(result.is_negative());
  }

}

void test_sub_1(TestObjs *objs) {
  // very basic tests for subtraction

  BigInt result1 = objs->zero - objs->zero;
  check_contents(result1, { 0UL });
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->one - objs->zero;
  check_contents(result2, { 1UL });
  ASSERT(!result2.is_negative());

  // 0 - 1 should be -1
  BigInt result3 = objs->zero - objs->one;
  check_contents(result3, { 1UL });
  ASSERT(result3.is_negative());
}

void test_sub_2(TestObjs *) {
  // Harder test(s) for subtraction (with only nonnegative operands)
  {
    BigInt left({0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
    BigInt right({0x555ecb5be6a2352UL, 0x6ac021fcd678e7bdUL, 0xb2c36b0123d8adefUL, 0xda6c10c4b0UL});
    BigInt result = left - right;
    check_contents(result, {0x69846249d6659795UL, 0x11cc21dd8ce35b87UL, 0x6e0a4712b17b6b93UL, 0xbabfeed7ad1b0daeUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
    ASSERT(!result.is_negative());
  }
}

void test_sub_3(TestObjs *objs) {
  // Some mixed-sign subtraction tests

  BigInt result1 = objs->negative_three - objs->one;
  check_contents(result1, { 4UL });
  ASSERT(result1.is_negative());

  BigInt result2 = objs->one - objs->negative_three;
  check_contents(result2, { 4UL });
  ASSERT(!result2.is_negative());
}

void test_sub_4(TestObjs *) {
  // harder subtraction test(s) involving various
  // combinations of non-negative and negative operands

  {
    BigInt left({0xda069f1394210a58UL, 0x17aeeda0ba999cc9UL, 0x76d8613d4dfa6239UL, 0x2c20a77d76bb2b7dUL, 0xa852e8c7965c99cbUL, 0x2da25d942abf02ddUL, 0x8c7166619290106eUL, 0x72115b9db363aa85UL, 0xc3dcfa489c903019UL, 0x7f69b50321b7f3d5UL, 0x72ba467bb329ff89UL, 0x20a41c2UL}, true);
    BigInt right({0x25e9179995f954a7UL, 0x803da91345e6d0f3UL, 0x509d92c5fd3b8895UL, 0x2d61fc2da4c3962dUL, 0x1fe8e2e2223b1717UL, 0xe7e8724f74e51f4aUL, 0xe138b44b919a3926UL, 0xab9971d99b12be24UL, 0x4f39add59d016768UL, 0xe16b13e35c0e108cUL, 0xa6ef8ef9ec844222UL, 0xe78df73060cc35eeUL, 0x14fUL}, true);
    BigInt result = left - right;
    check_contents(result, {0x4be2788601d84a4fUL, 0x688ebb728b4d3429UL, 0xd9c53188af41265cUL, 0x14154b02e086aafUL, 0x7795fa1a8bde7d4cUL, 0xba4614bb4a261c6cUL, 0x54c74de9ff0a28b8UL, 0x3988163be7af139fUL, 0x8b5cb38d0071374fUL, 0x62015ee03a561cb6UL, 0x3435487e395a4299UL, 0xe78df7305ec1f42cUL, 0x14fUL});
    ASSERT(!result.is_negative());
  }

  {
    BigInt left({0x2731e5530045218aUL, 0x1c29aaUL});
    BigInt right({0xc2baed5ea8cf3dd0UL, 0x81fe5f9adde938d6UL, 0x56ec433719861074UL, 0x7f6d01dbc70c1274UL, 0xd02fd7f2403ee362UL, 0x24c5400e94347fb3UL, 0x764521caebba2c9UL, 0x51a61e0aa376ff6dUL, 0x103c5aa88eb6e90UL}, true);
    BigInt result = left - right;
    check_contents(result, {0xe9ecd2b1a9145f5aUL, 0x81fe5f9ade056280UL, 0x56ec433719861074UL, 0x7f6d01dbc70c1274UL, 0xd02fd7f2403ee362UL, 0x24c5400e94347fb3UL, 0x764521caebba2c9UL, 0x51a61e0aa376ff6dUL, 0x103c5aa88eb6e90UL});
    ASSERT(!result.is_negative());
  }
}

void test_is_bit_set_1(TestObjs *objs) {
  // some basic tests for is_bit_set

  ASSERT(!objs->zero.is_bit_set(0));
  ASSERT(!objs->zero.is_bit_set(1));

  // it should be ok to inquire about any bit position, even if it's beyond
  // the extent of the internal bitstring representation
  ASSERT(!objs->zero.is_bit_set(1000000));

  ASSERT(objs->one.is_bit_set(0));
  ASSERT(!objs->one.is_bit_set(1));

  ASSERT(!objs->two_pow_64.is_bit_set(63));
  ASSERT(objs->two_pow_64.is_bit_set(64));
  ASSERT(!objs->two_pow_64.is_bit_set(65));
}

void test_is_bit_set_2(TestObjs *) {
  // test(s) for is_bit_set: these test a random
  // sampling of bits in various large-ish BigInt values

  {
    BigInt val({0xad77cbed0273e33UL, 0xe151b7c18231a194UL, 0x7b2beb2888d66093UL, 0xeab20633a9a9595aUL});
    ASSERT(val.is_bit_set(0));
    ASSERT(val.is_bit_set(4));
    ASSERT(val.is_bit_set(9));
    ASSERT(!val.is_bit_set(15));
    ASSERT(!val.is_bit_set(24));
    ASSERT(val.is_bit_set(30));
    ASSERT(val.is_bit_set(42));
    ASSERT(val.is_bit_set(52));
    ASSERT(!val.is_bit_set(58));
    ASSERT(val.is_bit_set(89));
    ASSERT(val.is_bit_set(109));
    ASSERT(!val.is_bit_set(158));
    ASSERT(val.is_bit_set(177));
    ASSERT(val.is_bit_set(184));
    ASSERT(!val.is_bit_set(202));
    ASSERT(val.is_bit_set(241));
  }
}

void test_lshift_1(TestObjs *objs) {
  // Some very basic left shift tests

  BigInt result1 = objs->one << 1;
  check_contents(result1, { 2UL });
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->one << 63;
  check_contents(result2, { 0x8000000000000000UL });
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->one << 64;
  check_contents(result3, { 0UL, 1UL });
  ASSERT(!result3.is_negative());

  BigInt result4 = objs->three << 63;
  check_contents(result4, { 0x8000000000000000UL, 1UL });
  ASSERT(!result4.is_negative());

  // make sure that a std::invalid_argument exception is
  // thrown if there is an attempt to left shift a
  // negative value
  try {
    objs->negative_nine << 42;
    FAIL("left shifting a negative value should throw an exception");
  } catch (std::invalid_argument &ex) {
    // good
  }
}

void test_lshift_2(TestObjs *) {
  // left shift test(s) on large-ish values

  {
    BigInt val({0xbcc523fa26450fc2UL, 0x5490bb4c35ae6c03UL, 0x310a4f3349801bbeUL});
    BigInt result = val << 390;
    check_contents(result, {0x0UL, 0x0UL, 0x0UL, 0x0UL, 0x0UL, 0x0UL, 0x3148fe899143f080UL, 0x242ed30d6b9b00efUL, 0x4293ccd26006ef95UL, 0xcUL});
    ASSERT(!result.is_negative());
  }

  {
    BigInt val({0x7ca1c82cd5678c64UL, 0x24c995d549d6cbe8UL, 0x55df71ecab97c375UL, 0x9523341dc8fd0196UL, 0xf9c1dd3486f16b31UL, 0x7fe83598f38b19d1UL, 0x3b77ae13ce121dUL});
    BigInt result = val << 444;
    check_contents(result, {0x0UL, 0x0UL, 0x0UL, 0x0UL, 0x0UL, 0x0UL, 0x4000000000000000UL, 0x87ca1c82cd5678c6UL, 0x524c995d549d6cbeUL, 0x655df71ecab97c37UL, 0x19523341dc8fd019UL, 0x1f9c1dd3486f16b3UL, 0xd7fe83598f38b19dUL, 0x3b77ae13ce121UL});
    ASSERT(!result.is_negative());
  }
}

void test_mul_1(TestObjs *objs) {
  // some very basic multiplication tests

  BigInt result1 = objs->three * objs->three;
  check_contents(result1, { 9UL });
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->two_pow_64 * objs->two;
  check_contents(result2, { 0UL, 2UL });
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->u64_max * objs->u64_max;
  check_contents(result3, { 0x0000000000000001UL, 0xFFFFFFFFFFFFFFFEUL });
  ASSERT(!result3.is_negative());
}

void test_mul_2(TestObjs *) {
  // multiplication test(s) with larger values

  {
    BigInt left({0x63a2caa5324b539dUL, 0x176fde8a24cUL});
    BigInt right({0x7fd944a0481a66c6UL});
    BigInt result = left * right;
    check_contents(result, {0x2bf1cf198f85396eUL, 0x92c5b43447ed673fUL, 0xbb463828efUL});
    ASSERT(!result.is_negative());
  }
}

void test_compare_1(TestObjs *objs) {
  // some basic tests for compare
  ASSERT(objs->zero.compare(objs->zero) == 0);
  ASSERT(objs->zero.compare(objs->one) < 0);
  ASSERT(objs->one.compare(objs->zero) > 0);
  ASSERT(objs->negative_nine.compare(objs->three) < 0);
  ASSERT(objs->three.compare(objs->negative_three) > 0);
}

void test_compare_2(TestObjs *) {
  // test(s) for compare with larger values (both negative and
  // non-negative)

  {
    BigInt left({0xcedf54d4ce62e836UL, 0x80bcc908ac2470e5UL, 0x7f5530530656407UL, 0xd708e6b15caaffe6UL, 0xea4413128f8d85dfUL, 0x8761bb0238eef891UL, 0x112046064d41670bUL, 0x52e17af98118272fUL, 0x2bcb5a93df6b9791UL, 0xe4UL}, true);
    BigInt right({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL});
    int result = left.compare(right);
    ASSERT(result < 0);
  }
}

void test_div_1(TestObjs *objs) {
  // Some relatively basic division tests

  BigInt result1 = objs->nine / objs->three;
  check_contents(result1, { 3UL });
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->nine / objs->two;
  check_contents(result2, { 4UL });
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->negative_nine / objs->three;
  check_contents(result3, { 3UL });
  ASSERT(result3.is_negative());

  BigInt result4 = objs->negative_nine / objs->two;
  check_contents(result4, { 4UL });
  ASSERT(result4.is_negative());
}

void test_div_2(TestObjs *) {
  // harder division test(s) with larger values

  {
    BigInt left({0x5a1f7b06e95d205bUL, 0x16bef383084c9bf5UL, 0x6bfd5cb9a0cfa403UL, 0xbb47e519c0ffc392UL, 0xc8c47a8ab9cc20afUL, 0x30302fb07ef81d25UL, 0x8b8bcb6df3f72911UL, 0x3de679169dc89703UL, 0x48f52b428f255e1dUL, 0xd623c2e8a460f5beUL, 0xae2df81a84808054UL, 0xcfb038910d158d63UL, 0xcf97bc9UL});
    BigInt right({0xe1d191b09fd571e7UL, 0xd6e34973337d88fdUL, 0x7235628c33211b03UL, 0xe0bbc74b5d7fe26aUL, 0xf6242ed96eb2c8d9UL, 0x3b0cad8e5dd18f5UL, 0x558c283a839910c0UL, 0xbb4df9de72952652UL, 0xed8b519e3c63ce56UL, 0xe96f9c8454bde1c4UL, 0x76b62db592951f97UL, 0x577341UL});
    BigInt result = left / right;
    check_contents(result, {0xfb3e6b02be39b6ceUL, 0x25UL});
    ASSERT(!result.is_negative());
  }
}

void test_to_hex_1(TestObjs *objs) {
  // some basic tests for to_hex()

  std::string result1 = objs->zero.to_hex();
  ASSERT("0" == result1);

  std::string result2 = objs->negative_nine.to_hex();
  ASSERT("-9" == result2);

  std::string result3 = objs->u64_max.to_hex();
  ASSERT("ffffffffffffffff" == result3);

  std::string result4 = objs->two_pow_64.to_hex();
  ASSERT("10000000000000000" == result4);
}

void test_to_hex_2(TestObjs *) {
  // test(s) for to_hex() on larger values

  {
    BigInt val({0xd8b5422df2c7e5d4UL, 0x2186595636ed41d7UL, 0xcf498dc4c634eb41UL, 0xa6579a3f9d2aab0cUL, 0xb5cbefaf0e63a6e3UL, 0xf419b0aadf4d14f1UL, 0xcec650d523acc64eUL, 0x14318cf757a58UL});
    std::string result = val.to_hex();
    ASSERT("14318cf757a58cec650d523acc64ef419b0aadf4d14f1b5cbefaf0e63a6e3a6579a3f9d2aab0ccf498dc4c634eb412186595636ed41d7d8b5422df2c7e5d4" == result);
  }

  {
    BigInt val({0xd8b5422df2c7e5d4UL, 0x2186595636ed41d7UL, 0xcf498dc4c634eb41UL, 0xa6579a3f9d2aab0cUL, 0xb5cbefaf0e63a6e3UL, 0xf419b0aadf4d14f1UL, 0xcec650d523acc64eUL, 0x14318cf757a58UL}, true);
    std::string result = val.to_hex();
    ASSERT("-14318cf757a58cec650d523acc64ef419b0aadf4d14f1b5cbefaf0e63a6e3a6579a3f9d2aab0ccf498dc4c634eb412186595636ed41d7d8b5422df2c7e5d4" == result);
  }

}

void test_to_dec_1(TestObjs *objs) {
  // some basic tests for to_dec()

  std::string result1 = objs->zero.to_dec();
  ASSERT("0" == result1);

  std::string result2 = objs->negative_nine.to_dec();
  ASSERT("-9" == result2);

  std::string result3 = objs->u64_max.to_dec();
  ASSERT("18446744073709551615" == result3);
}

void test_to_dec_2(TestObjs *) {
  // harder test(s) for to_dec()

  {
    BigInt val({0x361adeb15b6962c7UL, 0x31a5b3c012d2a685UL, 0x7b3b4839UL});
    std::string result = val.to_dec();
    ASSERT("703527900324720116021349050368162523567079645895" == result);
  }
}

// TODO: implement additional test functions
void test_compare_3(TestObjs *objs) {
  // some basic tests for compare

  BigInt big({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL});
  BigInt big_neg({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL}, true);

  ASSERT(objs->nine.compare(objs->nine) == 0);
  ASSERT(objs->negative_nine.compare(objs->negative_nine) == 0);
  ASSERT(big.compare(big) == 0);
  ASSERT(big_neg.compare(big_neg) == 0);
}

void test_compare_4(TestObjs *objs) {
  // some basic tests for compare

  BigInt big({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL});
  BigInt big_neg({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL}, true);

  ASSERT(objs->zero.compare(big) < 0);
  ASSERT(objs->zero.compare(objs->negative_nine) > 0);
  ASSERT(objs->zero.compare(big_neg) > 0);

  ASSERT(big.compare(objs->zero) > 0);
  ASSERT(objs->negative_nine.compare(objs->zero) < 0);
  ASSERT(big_neg.compare(objs->zero) < 0);
}

void test_compare_5(TestObjs *objs) {
  // some basic tests for compare

  BigInt big1({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL});
  BigInt big2({0xcedf54d4ce62e836UL, 0x80bcc908ac2470e5UL, 0x7f5530530656407UL, 0xd708e6b15caaffe6UL, 0xea4413128f8d85dfUL, 0x8761bb0238eef891UL, 0x112046064d41670bUL, 0x52e17af98118272fUL, 0x2bcb5a93df6b9791UL, 0xe4UL});

  ASSERT(objs->three.compare(objs->nine) < 0);
  ASSERT(big1.compare(objs->nine) > 0);
  ASSERT(objs->three.compare(big1) < 0);
  ASSERT(big1.compare(big2) > 0);
}

void test_compare_6(TestObjs *objs) {
  // some basic tests for compare

  BigInt big1_neg({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL}, true);
  BigInt big2_neg({0xcedf54d4ce62e836UL, 0x80bcc908ac2470e5UL, 0x7f5530530656407UL, 0xd708e6b15caaffe6UL, 0xea4413128f8d85dfUL, 0x8761bb0238eef891UL, 0x112046064d41670bUL, 0x52e17af98118272fUL, 0x2bcb5a93df6b9791UL, 0xe4UL}, true);

  ASSERT(objs->negative_nine.compare(objs->negative_three) < 0);
  ASSERT(big1_neg.compare(objs->negative_three) < 0);
  ASSERT(objs->negative_nine.compare(big1_neg) > 0);
  ASSERT(big1_neg.compare(big2_neg) < 0);
}

void test_compare_7(TestObjs *objs) {
  // some basic tests for compare

  BigInt big({0xa4771be9296f10c9UL, 0x99652558ce608a70UL, 0x72a5a8d90da8a461UL, 0xae81eebacbc14061UL, 0xbe8ee1d7d75975c9UL, 0xef670eb972588d3aUL, 0x73c02c5138c02430UL, 0x6ed794ae35fd9f68UL, 0x4dd6b9ebe076ac72UL, 0x42b6daa3d05d11c7UL, 0x2cfe1d5965b49e99UL, 0x927becUL});
  BigInt big_neg({0xcedf54d4ce62e836UL, 0x80bcc908ac2470e5UL, 0x7f5530530656407UL, 0xd708e6b15caaffe6UL, 0xea4413128f8d85dfUL, 0x8761bb0238eef891UL, 0x112046064d41670bUL, 0x52e17af98118272fUL, 0x2bcb5a93df6b9791UL, 0xe4UL}, true);

  ASSERT(big_neg.compare(objs->three) < 0);
  ASSERT(objs->negative_nine.compare(big) < 0);
  ASSERT(big.compare(objs->negative_three) > 0);
  ASSERT(objs->three.compare(big_neg) > 0);
  ASSERT(big.compare(big_neg) > 0);
}

void test_is_bit_set_3(TestObjs *objs) {
  // some basic tests for is_bit_set

  ASSERT(!objs->negative_two_pow_64.is_bit_set(63));
  ASSERT(objs->negative_two_pow_64.is_bit_set(64));
  ASSERT(!objs->negative_two_pow_64.is_bit_set(65));
}

void test_is_bit_set_4(TestObjs *) {
  // test(s) for is_bit_set: these test a random
  // sampling of bits in various large-ish BigInt values

  {
    BigInt val({0xad77cbed0273e33UL, 0xe151b7c18231a194UL, 0x7b2beb2888d66093UL, 0xeab20633a9a9595aUL}, true);
    ASSERT(val.is_bit_set(0));
    ASSERT(val.is_bit_set(4));
    ASSERT(val.is_bit_set(9));
    ASSERT(!val.is_bit_set(15));
    ASSERT(!val.is_bit_set(24));
    ASSERT(val.is_bit_set(30));
    ASSERT(val.is_bit_set(42));
    ASSERT(val.is_bit_set(52));
    ASSERT(!val.is_bit_set(58));
    ASSERT(val.is_bit_set(89));
    ASSERT(val.is_bit_set(109));
    ASSERT(!val.is_bit_set(158));
    ASSERT(val.is_bit_set(177));
    ASSERT(val.is_bit_set(184));
    ASSERT(!val.is_bit_set(202));
    ASSERT(val.is_bit_set(241));
  }
}

void test_is_bit_set_5(TestObjs *objs) {
    // Test case for checking bits in a small positive number
    BigInt small({9UL}); // 9 in binary: 1001

    // Check bit 0 (LSB), should be 1
    ASSERT(small.is_bit_set(0));

    // Check bit 1, should be 0
    ASSERT(!small.is_bit_set(1));

    // Check bit 3, should be 1 (since 9 is 1001 in binary)
    ASSERT(small.is_bit_set(3));

    // Check bit 4 and beyond, should be 0
    ASSERT(!small.is_bit_set(4));
    ASSERT(!small.is_bit_set(10));
}

void test_is_bit_set_6(TestObjs *objs) {
    // Test case for checking bits in a large number
    BigInt large({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL}); // All bits set

    // Check bit 0 (LSB), should be 1
    ASSERT(large.is_bit_set(0));

    // Check bit 63 (last bit of the first uint64_t), should be 1
    ASSERT(large.is_bit_set(63));

    // Check bit 64 (first bit of the second uint64_t), should be 1
    ASSERT(large.is_bit_set(64));

    // Check bit 127 (MSB of the second uint64_t), should be 1
    ASSERT(large.is_bit_set(127));

    // Check out-of-range bit, should return false or handle gracefully
    ASSERT(!large.is_bit_set(128));
}

void test_is_bit_set_7(TestObjs *objs) {
    // Test for negative numbers
    BigInt negative({1UL}, true); // -1 in binary (assuming two's complement)

    // For a negative number (in your implementation, since no two's complement), should test only magnitude
    ASSERT(negative.is_bit_set(0)); // The bit should be set for the magnitude
}

void test_is_bit_set_8(TestObjs *objs) {
    // Test for zero number
    BigInt zero({0UL}); // 0 in binary

    // Check any bit, should all be 0
    ASSERT(!zero.is_bit_set(0));
    ASSERT(!zero.is_bit_set(10));
    ASSERT(!zero.is_bit_set(100));
}

void test_is_bit_set_9(TestObjs *objs) {
    // Test for checking bits far beyond the length of the number
    BigInt small({1UL}); // Binary: 1

    // Check a very large bit index, should return false or handle safely
    ASSERT(!small.is_bit_set(1000)); // Out of range bit index
}


void test_lshift_3(TestObjs *objs) {
  // Some very basic left shift tests

  BigInt result = objs->zero << 656;
  check_contents(result, { 0UL });
  ASSERT(!result.is_negative());
}

void test_lshift_4(TestObjs *) {
  // left shift test(s) on large-ish values
  try {
    BigInt val({0x7ca1c82cd5678c64UL, 0x24c995d549d6cbe8UL, 0x55df71ecab97c375UL, 0x9523341dc8fd0196UL, 0xf9c1dd3486f16b31UL, 0x7fe83598f38b19d1UL, 0x3b77ae13ce121dUL}, true);
    BigInt result = val << 444;
    FAIL("left shifting a negative value should throw an exception");
  } catch (std::invalid_argument &ex) {
    // good
  }
}

void test_left_shift_5(TestObjs *objs) {
  //large value
  BigInt result = objs->one << 65;
  check_contents(result, {0UL, 2UL});
  ASSERT(!result.is_negative());
}

void test_left_shift_6(TestObjs *objs) {
  //negative number
  try {
    BigInt result = objs->negative_nine << 1;
    FAIL("left shift on negative number should throw an exception");
  } catch (std::invalid_argument &ex) {
    // expected exception
  }
}

void test_left_shift_7(TestObjs *objs) {
  // test left shift of 0
  BigInt result = objs->zero << 100;
  check_contents(result, {0UL});
  ASSERT(!result.is_negative());
}

void test_to_hex_3(TestObjs *objs) {
  // Test(s) for large positive numbers

  {
    BigInt val({0x1234567890abcdefUL, 0xfedcba9876543210UL});
    std::string result = val.to_hex();
    ASSERT("fedcba98765432101234567890abcdef" == result);
  }

  {
    BigInt val({0xABCDEFABCDEFABCUL});
    std::string result = val.to_hex();
    ASSERT("abcdefabcdefabc" == result);
  }
}

void test_to_hex_4(TestObjs *objs) {
  // Test(s) for large negative numbers

  {
    BigInt val({0xd8b5422df2c7e5d4UL, 0x2186595636ed41d7UL, 0xcf498dc4c634eb41UL, 0xa6579a3f9d2aab0cUL, 0xb5cbefaf0e63a6e3UL, 0xf419b0aadf4d14f1UL, 0xcec650d523acc64eUL, 0x14318cf757a58UL}, true);
    std::string result = val.to_hex();
    ASSERT("-14318cf757a58cec650d523acc64ef419b0aadf4d14f1b5cbefaf0e63a6e3a6579a3f9d2aab0ccf498dc4c634eb412186595636ed41d7d8b5422df2c7e5d4" == result);
  }

  {
    BigInt val({0x1234567890abcdefUL, 0xfedcba9876543210UL}, true);
    std::string result = val.to_hex();
    ASSERT("-fedcba98765432101234567890abcdef" == result);
  }
}

void test_to_hex_5(TestObjs *objs) {
  // Test maximum possible uint64_t values

  {
    BigInt val({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL});
    std::string result = val.to_hex();
    ASSERT("ffffffffffffffffffffffffffffffffffffffffffffffff" == result);
  }

  {
    BigInt val({0xFFFFFFFFFFFFFFFFUL});
    std::string result = val.to_hex();
    ASSERT("ffffffffffffffff" == result);
  }
}

void test_to_hex_6(TestObjs *objs) {
  // Test with leading zeros in the hexadecimal representation

  {
    BigInt val({0x000000000000000FUL, 0x0000000000000000UL, 0x00000000000000A1UL});
    std::string result = val.to_hex();
    ASSERT("a10000000000000000000000000000000f" == result); // Leading zeros should be trimmed except for significant digits
  }

  {
    BigInt val({0x000000000000001FUL, 0x0000000000000000UL});
    std::string result = val.to_hex();
    ASSERT("1f" == result); // Ensure leading zeros are properly handled
  }
}


void test_to_dec_3(TestObjs *) {
  // harder test(s) for to_dec()

  {
    BigInt val({0x361adeb15b6962c7UL, 0x31a5b3c012d2a685UL, 0x7b3b4839UL}, true);
    std::string result = val.to_dec();
    ASSERT("-703527900324720116021349050368162523567079645895" == result);
  }

  {
    BigInt val({0xd8b5422df2c7e5d4UL, 0x2186595636ed41d7UL, 0xcf498dc4c634eb41UL, 0xa6579a3f9d2aab0cUL, 0xb5cbefaf0e63a6e3UL, 0xf419b0aadf4d14f1UL, 0xcec650d523acc64eUL, 0x14318cf757a58UL});
    std::string result = val.to_dec();
    ASSERT("258208595916058390782425184669257502292625418517096463620488359566874081089736110475715564700157964468805342289834870437863743611557735447439784535508" == result);
  }

  {
    BigInt val({0xd8b5422df2c7e5d4UL, 0x2186595636ed41d7UL, 0xcf498dc4c634eb41UL, 0xa6579a3f9d2aab0cUL, 0xb5cbefaf0e63a6e3UL, 0xf419b0aadf4d14f1UL, 0xcec650d523acc64eUL, 0x14318cf757a58UL}, true);
    std::string result = val.to_dec();
    ASSERT("-258208595916058390782425184669257502292625418517096463620488359566874081089736110475715564700157964468805342289834870437863743611557735447439784535508" == result);
  }
}

void test_to_dec_4(TestObjs *objs) {
  // Test number objects
  {
    std::string result = objs->two.to_dec();
    ASSERT("2" == result);
  }

  // Test basic negative integer
  {
    std::string result = objs->negative_nine.to_dec();
    ASSERT("-9" == result);
  }

  // Test the largest possible uint64_t value
  {
    std::string result = objs->u64_max.to_dec();
    ASSERT("18446744073709551615" == result);
  }

  // Test a number that's exactly a power of two (2^64)
  {
    std::string result = objs->two_pow_64.to_dec();
    ASSERT("18446744073709551616" == result);
  }
}
void test_to_dec_5(TestObjs *objs) {
  // Test a negative number with a large magnitude
  BigInt large_negative({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL}, true); // A large negative value
  std::string result = large_negative.to_dec();
  ASSERT("-340282366920938463463374607431768211455" == result); // Check for correct conversion of large negative numbers
}

void test_to_dec_6(TestObjs *objs) {
  // Test zero value, should always return "0"
  BigInt zero({0UL}); 
  std::string result = zero.to_dec();
  ASSERT("0" == result);
}

void test_to_dec_7(TestObjs *objs) {
  // Test a very large positive number spread across multiple uint64_t values
  BigInt large({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL}); // 2^128 - 1
  std::string result = large.to_dec();
  ASSERT("340282366920938463463374607431768211455" == result); // Check for correct conversion of large positive numbers
}

void test_to_dec_8(TestObjs *objs) {
  // Test small positive numbers
  BigInt small_pos({123UL}); // Simple small positive number
  std::string result = small_pos.to_dec();
  ASSERT("123" == result);
}

void test_to_dec_9(TestObjs *objs) {
  // Test a very large value that might cause overflow if not handled correctly
  BigInt very_large({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL}); 
  std::string result = very_large.to_dec();
  ASSERT("6277101735386680763835789423207666416102355444464034512895" == result); // Verify for very large numbers
}

void test_add_5(TestObjs *objs) {
  // very basic tests for addition

  BigInt big({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  BigInt big_neg({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL}, true);

  BigInt result1 = objs->zero + big;
  check_contents(result1, {0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->zero + objs->negative_nine;
  check_contents(result2, {9UL});
  ASSERT(result2.is_negative());

  BigInt result3 = objs->zero + big_neg;
  check_contents(result3, {0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result3.is_negative());

  BigInt result4 = big + objs->zero;
  check_contents(result4, {0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result4.is_negative());

  BigInt result5 = objs->negative_three + objs->zero;
  check_contents(result5, {3UL});
  ASSERT(result5.is_negative());

  BigInt result6 = big_neg + objs->zero;
  check_contents(result6, {0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result6.is_negative());
}

void test_add_6(TestObjs *objs) {
  // very basic tests for addition

  BigInt big({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});

  BigInt result1 = objs->two + objs->three;
  check_contents(result1, {5UL});
  ASSERT(!result1.is_negative());

  BigInt result2 = big + objs->three;
  check_contents(result2, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->two + big;
  check_contents(result3, {0xe2b272a002612fe5UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result3.is_negative());
}

void test_add_7(TestObjs *objs) {
  // very basic tests for addition

  BigInt big_neg({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL}, true);

  BigInt result1 = objs->negative_nine + objs->negative_three;
  check_contents(result1, {12UL});
  ASSERT(result1.is_negative());

  BigInt result2 = big_neg + objs->negative_three;
  check_contents(result2, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result2.is_negative());

  BigInt result3 = objs->negative_three + big_neg;
  check_contents(result3, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result3.is_negative());
}

void test_add_8(TestObjs *objs) {
  // very basic tests for addition

  BigInt big1({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  BigInt big1_neg({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL}, true);
  BigInt big2({0xd2ec154f6f077e95UL, 0x1bb578fcbf5bec60UL, 0x36735d365fe0f69eUL, 0xa803e03015c610e8UL, 0xca14aac782de50a2UL, 0x2191456abd619da2UL, 0xd9a345c56ba9a659UL, 0x1de31271dc3UL});

  BigInt result1 = big1_neg + objs->two;
  check_contents(result1, {0xe2b272a002612fe1UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result1.is_negative());

  BigInt result2 = objs->negative_three + big1;
  check_contents(result2, {0xe2b272a002612fe0UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result2.is_negative());

  BigInt result3 = big1_neg + big2;
  check_contents(result3, {0xfc65d509359b14eUL, 0xb636ec619ed250d8UL, 0xeb491e115b06c1fbUL, 0xa0da23c38962386UL, 0x6fc324423d018fabUL, 0xf0c2a6ef60f9f1f7UL, 0xe119794315ab2094UL, 0x3e676d80f5109529UL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result3.is_negative());

  BigInt result4 = big1 + objs->negative_three;
  check_contents(result4, {0xe2b272a002612fe0UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result4.is_negative());

  BigInt result5 = objs->two + big1_neg;
  check_contents(result5, {0xe2b272a002612fe1UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result5.is_negative());
}

void test_add_9(TestObjs *objs) {
  // test add overflow
  BigInt large({0xFFFFFFFFFFFFFFFFUL, 0xFFFFFFFFFFFFFFFFUL});
  BigInt result = large + objs->one;
  check_contents(result, {0UL, 0UL, 1UL});
  ASSERT(!result.is_negative());
}

void test_sub_5(TestObjs *objs) {
  // very basic tests for subtraction

  BigInt big({0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
  BigInt big_neg({0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL}, true);

  BigInt result1 = objs->zero - big;
  check_contents(result1, {0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
  ASSERT(result1.is_negative());

  BigInt result2 = objs->zero - objs->negative_nine;
  check_contents(result2, {9UL});
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->zero - big_neg;
  check_contents(result3, {0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
  ASSERT(!result3.is_negative());

  BigInt result4 = big - objs->zero;
  check_contents(result4, {0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
  ASSERT(!result4.is_negative());

  BigInt result5 = objs->negative_nine - objs->zero;
  check_contents(result5, {9UL});
  ASSERT(result5.is_negative());

  BigInt result6 = big_neg - objs->zero;
  check_contents(result6, {0x6eda4eff94cfbae7UL, 0x7c8c43da635c4344UL, 0x20cdb213d5541982UL, 0xbabfefb2192bd25fUL, 0x101fc2c8776f1e13UL, 0x91ecffb0a16ed1dfUL, 0x6f8e57b78c2b4126UL, 0x129a78f1cd7e3ce3UL, 0x64cb2c9c277276bUL, 0xd3e06abb451c73b8UL, 0xe9cc5fd7751987e1UL, 0x1a2d858e65ab0f23UL, 0x5cdd7cbf9bbb3853UL, 0xaac5e94bUL});
  ASSERT(result6.is_negative());
}

void test_sub_6(TestObjs *objs) {
  // subtraction

  BigInt big({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});

  BigInt result1 = objs->three - objs->nine;
  check_contents(result1, {6UL});
  ASSERT(result1.is_negative());

  BigInt result2 = objs->nine - objs->three;
  check_contents(result2, {6UL});
  ASSERT(!result2.is_negative());

  BigInt result3 = big - objs->three;
  check_contents(result3, {0xe2b272a002612fe0UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result3.is_negative());

  BigInt result4 = objs->two - big;
  check_contents(result4, {0xe2b272a002612fe1UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result4.is_negative());

  BigInt result5 = objs->two - objs->two;
  check_contents(result5, {0UL});
  ASSERT(!result5.is_negative());

  BigInt result6 = big - big;
  check_contents(result6, {0UL});
  ASSERT(!result6.is_negative());
}

void test_sub_7(TestObjs *objs) {
  // subtraction

  BigInt big({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  BigInt big_neg({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL}, true);

  BigInt result1 = objs->negative_three - objs->negative_nine;
  check_contents(result1, {6UL});
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->negative_nine - objs->negative_three;
  check_contents(result2, {6UL});
  ASSERT(result2.is_negative());

  BigInt result3 = big_neg - objs->negative_two;
  check_contents(result3, {0xe2b272a002612fe1UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result3.is_negative());

  BigInt result4 = objs->three - big_neg;
  check_contents(result4, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result4.is_negative());
}

void test_sub_8(TestObjs *objs) {
  // subtraction

  BigInt big1({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  BigInt big2({0xd2ec154f6f077e95UL, 0x1bb578fcbf5bec60UL, 0x36735d365fe0f69eUL, 0xa803e03015c610e8UL, 0xca14aac782de50a2UL, 0x2191456abd619da2UL, 0xd9a345c56ba9a659UL, 0x1de31271dc3UL});
  BigInt big1_neg({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL}, true);

  BigInt result1 = big1_neg - objs->three;
  check_contents(result1, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result1.is_negative());

  BigInt result2 = objs->negative_three - big1;
  check_contents(result2, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result2.is_negative());

  BigInt result3 = big1_neg - big2;
  check_contents(result3, {0xb59e87ef7168ae78UL, 0xeda1de5b1d8a2999UL, 0x582fd87e1ac8af37UL, 0x5a15629c64224557UL, 0x3ec79d142be30f0UL, 0x33e531c4dbbd2d3dUL, 0x946004cdecfe6d47UL, 0x3e67713d575ed0b1UL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(result3.is_negative());

  BigInt result4 = big1 - objs->negative_three;
  check_contents(result4, {0xe2b272a002612fe6UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result4.is_negative());

  BigInt result5 = objs->two - big1_neg;
  check_contents(result5, {0xe2b272a002612fe5UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL, 0xb211826c4e5c346fUL, 0x39d7cf09bfdfe04dUL, 0x1253ec5a1e5b8f9aUL, 0xbabcbf088154c6eeUL, 0x3e676f5f2637b2edUL, 0xcc7edfb347fcd8b4UL, 0x5978260d5ecf00a7UL, 0xe242586be49c40c1UL, 0xf734798ec1dd4ddaUL, 0x76394dUL});
  ASSERT(!result5.is_negative());
}

void test_mul_3(TestObjs *objs) {
  // multiplication by zero

  BigInt big({0x63a2caa5324b539dUL, 0x176fde8a24cUL});
  BigInt big_neg({0x63a2caa5324b539dUL, 0x176fde8a24cUL}, true);

  BigInt result1 = objs->zero * objs->zero;
  check_contents(result1, {0UL});
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->zero * objs->two;
  check_contents(result2, {0UL});
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->zero * big;
  check_contents(result3, {0UL});
  ASSERT(!result3.is_negative());

  BigInt result4 = objs->zero * objs->negative_nine;
  check_contents(result4, {0UL});
  ASSERT(!result4.is_negative());

  BigInt result5 = objs->zero * big_neg;
  check_contents(result5, {0UL});
  ASSERT(!result5.is_negative());

  BigInt result6 = objs->two * objs->zero;
  check_contents(result6, {0UL});
  ASSERT(!result6.is_negative());

  BigInt result7 = big * objs->zero;
  check_contents(result7, {0UL});
  ASSERT(!result7.is_negative());

  BigInt result8 = objs->negative_nine * objs->zero;
  check_contents(result8, {0UL});
  ASSERT(!result8.is_negative());

  BigInt result9 = big_neg * objs->zero;
  check_contents(result9, {0UL});
  ASSERT(!result9.is_negative());
}

void test_mul_4(TestObjs *objs) {
  // multiplication with positive signs

  BigInt big({0x63a2caa5324b539dUL, 0x176fde8a24cUL});

  BigInt result1 = big * objs->two;
  check_contents(result1, {0xc745954a6496a73aUL, 0x2edfbd14498UL});
  ASSERT(!result1.is_negative());

  BigInt result2 = objs->three * big;
  check_contents(result2, {0x2ae85fef96e1fad7UL, 0x464f9b9e6e5UL});
  ASSERT(!result2.is_negative());
}

void test_mul_5(TestObjs *objs) {
  // multiplication with negative signs

  BigInt big1_neg({0x63a2caa5324b539dUL, 0x176fde8a24cUL}, true);
  BigInt big2_neg({0x7fd944a0481a66c6UL}, true);

  BigInt result1 = objs->negative_three * objs->negative_two;
  check_contents(result1, {6UL});
  ASSERT(!result1.is_negative());

  BigInt result2 = big1_neg * objs->negative_two;
  check_contents(result2, {0xc745954a6496a73aUL, 0x2edfbd14498UL});
  ASSERT(!result2.is_negative());

  BigInt result3 = objs->negative_three * big1_neg;
  check_contents(result3, {0x2ae85fef96e1fad7UL, 0x464f9b9e6e5UL});
  ASSERT(!result3.is_negative());

  BigInt result4 = big1_neg * big2_neg;
  check_contents(result4, {0x2bf1cf198f85396eUL, 0x92c5b43447ed673fUL, 0xbb463828efUL});
  ASSERT(!result4.is_negative());
}

void test_mul_6(TestObjs *objs) {
  // multiplication with mixed signs

  BigInt big1({0x63a2caa5324b539dUL, 0x176fde8a24cUL});
  BigInt big1_neg({0x63a2caa5324b539dUL, 0x176fde8a24cUL}, true);
  BigInt big2({0x7fd944a0481a66c6UL});
  BigInt big2_neg({0x7fd944a0481a66c6UL}, true);

  BigInt result1 = objs->negative_three * objs->two;
  check_contents(result1, {6UL});
  ASSERT(result1.is_negative());

  BigInt result2 = big1_neg * objs->two;
  check_contents(result2, {0xc745954a6496a73aUL, 0x2edfbd14498UL});
  ASSERT(result2.is_negative());

  BigInt result3 = objs->negative_three * big1;
  check_contents(result3, {0x2ae85fef96e1fad7UL, 0x464f9b9e6e5UL});
  ASSERT(result3.is_negative());

  BigInt result4 = big1_neg * big2;
  check_contents(result4, {0x2bf1cf198f85396eUL, 0x92c5b43447ed673fUL, 0xbb463828efUL});
  ASSERT(result4.is_negative());

  BigInt result5 = objs->three * objs->negative_two;
  check_contents(result5, {6UL});
  ASSERT(result5.is_negative());

  BigInt result6 = big1 * objs->negative_two;
  check_contents(result6, {0xc745954a6496a73aUL, 0x2edfbd14498UL});
  ASSERT(result6.is_negative());

  BigInt result7 = objs->three * big1_neg;
  check_contents(result7, {0x2ae85fef96e1fad7UL, 0x464f9b9e6e5UL});
  ASSERT(result7.is_negative());

  BigInt result8 = big1 * big2_neg;
  check_contents(result8, {0x2bf1cf198f85396eUL, 0x92c5b43447ed673fUL, 0xbb463828efUL});
  ASSERT(result8.is_negative());
}

void test_mul_7(TestObjs *objs) {
  // Test multiplication with negative signs for larger values using provided BigInt objects

  // Multiply two negative values
  BigInt result1 = objs->negative_two * objs->negative_three;
  check_contents(result1, {6UL});
  ASSERT(!result1.is_negative()); // The result should be positive (neg * neg = pos)

  BigInt result2 = objs->negative_nine * objs->negative_two_pow_64;
  check_contents(result2, {0UL, 9UL});
  ASSERT(!result2.is_negative()); // The result should be positive (neg * neg = pos)

  // Multiply a positive and a negative value
  BigInt result3 = objs->two * objs->negative_nine;
  check_contents(result3, {18UL});
  ASSERT(result3.is_negative()); // The result should be negative (pos * neg = neg)

  BigInt result4 = objs->three * objs->negative_two_pow_64;
  check_contents(result4, {0UL, 3UL});
  ASSERT(result4.is_negative()); // The result should be negative (pos * neg = neg)

  BigInt result5 = objs->u64_max * objs->negative_three;
  check_contents(result5, {0xFFFFFFFFFFFFFFFDUL, 0x2UL});
  ASSERT(result5.is_negative()); // The result should be negative (pos * neg = neg)
}


void test_div_3(TestObjs *objs) {
  // Test division with negative signs (all values are negative)

  // Divide two negative values
  BigInt result1 = objs->negative_nine / objs->negative_three;
  check_contents(result1, {3UL});
  ASSERT(!result1.is_negative()); // The result should be positive (neg / neg = pos)

  // Divide two smaller negative numbers
  BigInt result3 = objs->negative_nine / objs->negative_nine;
  check_contents(result3, {1UL});
  ASSERT(!result3.is_negative()); // The result should be positive (neg / neg = pos)

  BigInt result4 = objs->negative_two / objs->negative_two;
  check_contents(result4, {1UL});
  ASSERT(!result4.is_negative()); // The result should be positive (neg / neg = pos)
}

void test_div_5(TestObjs *objs) {
  // Division with mixed signs (larger values)

  // Case 1: Large positive divided by large negative
  BigInt big_pos({0xe2b272a002612fe3UL, 0xd1ec655e5e2e3d38UL, 0x21bc7b47bae7b899UL});
  BigInt big_neg({0x63a2caa5324b539dUL, 0x176fde8a24cUL}, true);

  BigInt result1 = big_pos / big_neg;
  check_contents(result1, {0x22UL, 0x3fUL});
  ASSERT(result1.is_negative()); // The result should be negative (pos / neg = neg)

  // Case 2: Large negative divided by large positive
  BigInt result2 = big_neg / big_pos;
  check_contents(result2, {0x0UL});
  ASSERT(!result2.is_negative()); // The result should be zero (neg / larger pos = 0)

  // Case 3: Dividing a negative number by a smaller positive number
  BigInt result3 = objs->negative_two_pow_64 / objs->nine;
  check_contents(result3, {0x1c71c71c71c71c71UL, 0x71c71c71c71c71cUL});
  ASSERT(result3.is_negative()); // The result should be negative (neg / pos = neg)

  // Case 4: Dividing a positive number by a larger negative number
  BigInt result4 = objs->two_pow_64 / big_neg;
  check_contents(result4, {0x1aUL, 0x7UL});
  ASSERT(result4.is_negative()); // The result should be negative (pos / neg = neg)

  // Case 5: Smaller negative number divided by larger positive number
  BigInt result5 = objs->negative_nine / objs->two_pow_64;
  check_contents(result5, {0UL});
  ASSERT(!result5.is_negative()); // The result should be zero (neg / larger pos = 0)
}


void test_div_6(TestObjs *objs) {
  // Division involving zero

  // Case 1: Zero divided by a positive number
  BigInt result1 = objs->zero / objs->nine;
  check_contents(result1, {0UL});
  ASSERT(!result1.is_negative()); // The result should be zero and not negative

  // Case 2: Zero divided by a negative number
  BigInt result2 = objs->zero / objs->negative_nine;
  check_contents(result2, {0UL});
  ASSERT(!result2.is_negative()); // The result should be zero and not negative

  // Case 3: Non-zero positive divided by zero should throw an exception
  try {
    objs->nine / objs->zero;
    FAIL("division by zero should throw an exception");
  } catch (std::invalid_argument &ex) {
    // Expected behavior: division by zero throws an exception
  }

  // Case 4: Non-zero negative divided by zero should throw an exception
  try {
    objs->negative_nine / objs->zero;
    FAIL("division by zero should throw an exception");
  } catch (std::invalid_argument &ex) {
    // Expected behavior: division by zero throws an exception
  }
}


void test_div_7(TestObjs *objs) {  
  // Division involving zero with larger values

  // Case 1: Zero divided by a large positive number
  BigInt large_positive({0x123456789ABCDEF0UL, 0xFEDCBA9876543210UL});
  BigInt result1 = objs->zero / large_positive;
  check_contents(result1, {0UL});
  ASSERT(!result1.is_negative()); // The result should be zero and not negative

  // Case 2: Zero divided by a large negative number
  BigInt large_negative({0x123456789ABCDEF0UL, 0xFEDCBA9876543210UL}, true);
  BigInt result2 = objs->zero / large_negative;
  check_contents(result2, {0UL});
  ASSERT(!result2.is_negative()); // The result should be zero and not negative

  // Case 3: Large positive number divided by zero should throw an exception
  try {
    large_positive / objs->zero;
    FAIL("division by zero should throw an exception");
  } catch (std::invalid_argument &ex) {
    // Expected behavior: division by zero throws an exception
  }

  // Case 4: Large negative number divided by zero should throw an exception
  try {
    large_negative / objs->zero;
    FAIL("division by zero should throw an exception");
  } catch (std::invalid_argument &ex) {
    // Expected behavior: division by zero throws an exception
  }
}

void test_is_negative(TestObjs *objs) {
    // Test cases for non-negative values
    ASSERT(!objs->zero.is_negative());  // 0 is not negative
    ASSERT(!objs->one.is_negative());   // 1 is not negative
    ASSERT(!objs->two.is_negative());   // 2 is not negative
    ASSERT(!objs->nine.is_negative());  // 9 is not negative
    ASSERT(!objs->u64_max.is_negative());  // U64 max is not negative
    ASSERT(!objs->two_pow_64.is_negative());  // 2^64 is not negative
    ASSERT(!objs->large_positive.is_negative());  // Large positive number is not negative

    // Test cases for negative values
    ASSERT(objs->negative_one.is_negative());  // -1 is negative
    ASSERT(objs->negative_nine.is_negative());  // -9 is negative
    ASSERT(objs->negative_three.is_negative());  // -3 is negative
    ASSERT(objs->negative_two.is_negative());  // -2 is negative
    ASSERT(objs->negative_two_pow_64.is_negative());  // -2^64 is negative
    ASSERT(objs->large_negative.is_negative());  // Large negative number is negative
}

void test_get_bits_within_bounds(TestObjs *objs) {
    // Test case 1: Index within bounds for a small number
    ASSERT(objs->zero.get_bits(0) == 0);  // zero has no bits
    ASSERT(objs->one.get_bits(0) == 1);   // one has one bit set at index 0
    ASSERT(objs->two.get_bits(0) == 2);   // two has one bit set at index 0

    // Test case 2: Index within bounds for larger numbers
    ASSERT(objs->two_pow_64.get_bits(0) == 0);  // 2^64 has 0 in the lower 64 bits
    ASSERT(objs->two_pow_64.get_bits(1) == 1);  // 2^64 has 1 in the next 64 bits

    ASSERT(objs->u64_max.get_bits(0) == 0xFFFFFFFFFFFFFFFFUL);  // u64_max has all bits set at index 0
    ASSERT(objs->negative_two_pow_64.get_bits(1) == 1);         // negative_two_pow_64 has 1 at index 1
}

void test_get_bits_out_of_bounds(TestObjs *objs) {
    // Test case 1: Index out of bounds for small numbers
    ASSERT(objs->one.get_bits(1) == 0);  // one has no bit at index 1
    ASSERT(objs->two.get_bits(1) == 0);  // two has no bit at index 1

    // Test case 2: Index out of bounds for larger numbers
    ASSERT(objs->two_pow_64.get_bits(2) == 0);  // two_pow_64 has no bit at index 2
    ASSERT(objs->u64_max.get_bits(1) == 0);     // u64_max has no bit at index 1
}

void test_assignment_operator(TestObjs *objs) {
    // Test case 1: Assigning one positive BigInt to another
    BigInt a = objs->one;  // Assignment from fixture object
    ASSERT(a.to_hex() == "1");  // Check the result

    // Test case 2: Assigning a larger BigInt
    BigInt b = objs->two_pow_64;  // Assignment from another fixture object
    ASSERT(b.to_hex() == "10000000000000000");  // Check the result

    // Test case 3: Self-assignment (should not change the object)
    b = b;  // Self-assignment
    ASSERT(b.to_hex() == "10000000000000000");  // Check the result stays the same

    // Test case 4: Assigning a negative BigInt
    BigInt c = objs->negative_nine;  // Assignment of a negative BigInt
    ASSERT(c.to_hex() == "-9");  // Check that the negative sign is correctly preserved

    // Test case 5: Assigning zero to another BigInt
    BigInt d;
    d = objs->zero;  // Assign zero to another BigInt
    ASSERT(d.to_hex() == "0");  // Ensure the value is zero

    // Test case 6: Assigning a BigInt initialized with multiple 64-bit values
    BigInt e = objs->u64_max;  // Assign a BigInt with multiple 64-bit values
    ASSERT(e.to_hex() == "ffffffffffffffff");  // Check the result

    // Test case 7: Assigning a BigInt to another after modification
    a = objs->negative_two_pow_64;  // Assign a different value
    ASSERT(a.to_hex() == "-10000000000000000");  // Check that the new value is assigned correctly

    // Test case 8: Assigning a smaller value after a larger one
    e = objs->one;  // Assign a smaller value after a larger one
    ASSERT(e.to_hex() == "1");  // Ensure the new value is assigned correctly
}


void test_unary_negation_operator(TestObjs *objs) {
    // Test case 1: Negating a positive BigInt (one)
    BigInt neg_one = -objs->one;
    ASSERT(neg_one.is_negative() == true);  // The result should be negative
    ASSERT(neg_one.to_hex() == "-1");       // Check the result

    // Test case 2: Negating a negative BigInt (negative_nine)
    BigInt pos_nine = -objs->negative_nine;
    ASSERT(pos_nine.is_negative() == false);  // The result should be positive
    ASSERT(pos_nine.to_hex() == "9");         // Check the result

    // Test case 3: Negating zero (should remain zero)
    BigInt neg_zero = -objs->zero;
    ASSERT(neg_zero.is_negative() == false);  // Zero should not be negative
    ASSERT(neg_zero.to_hex() == "0");         // Check the result

    // Test case 4: Negating a large positive number (u64_max)
    BigInt neg_u64_max = -objs->u64_max;
    ASSERT(neg_u64_max.is_negative() == true);  // The result should be negative
    ASSERT(neg_u64_max.to_hex() == "-ffffffffffffffff");  // Check the result

    // Test case 5: Negating a large negative number (negative_two_pow_64)
    BigInt pos_two_pow_64 = -objs->negative_two_pow_64;
    ASSERT(pos_two_pow_64.is_negative() == false);  // The result should be positive
    ASSERT(pos_two_pow_64.to_hex() == "10000000000000000");  // Check the result

    // Test case 6: Negating a number twice (double negation should give the original number)
    BigInt double_neg_one = -neg_one;
    ASSERT(double_neg_one.is_negative() == false);  // The result should be positive
    ASSERT(double_neg_one.to_hex() == "1");         // Double negation should give the original value
}

void test_get_bit_vector(TestObjs *objs) {
    // Test case 1: Check the bit vector for zero
    const std::vector<uint64_t>& zero_bits = objs->zero.get_bit_vector();
    ASSERT(zero_bits.size() == 1);  // The bit vector should contain only one word for zero
    ASSERT(zero_bits[0] == 0);      // The word should be zero

    // Test case 2: Check the bit vector for a small positive number (one)
    const std::vector<uint64_t>& one_bits = objs->one.get_bit_vector();
    ASSERT(one_bits.size() == 1);  // The bit vector should contain only one word
    ASSERT(one_bits[0] == 1);      // The word should be 1

    // Test case 3: Check the bit vector for a larger positive number (two_pow_64)
    const std::vector<uint64_t>& two_pow_64_bits = objs->two_pow_64.get_bit_vector();
    ASSERT(two_pow_64_bits.size() == 2);        // The bit vector should contain two words
    ASSERT(two_pow_64_bits[0] == 0);            // The lower 64 bits should be zero
    ASSERT(two_pow_64_bits[1] == 1);            // The upper 64 bits should be 1

    // Test case 4: Check the bit vector for u64_max
    const std::vector<uint64_t>& u64_max_bits = objs->u64_max.get_bit_vector();
    ASSERT(u64_max_bits.size() == 1);          // The bit vector should contain one word
    ASSERT(u64_max_bits[0] == 0xFFFFFFFFFFFFFFFFUL);  // All bits should be set

    // Test case 5: Check the bit vector for a negative number (negative_nine)
    const std::vector<uint64_t>& negative_nine_bits = objs->negative_nine.get_bit_vector();
    ASSERT(negative_nine_bits.size() == 1);  // The bit vector should contain one word
    ASSERT(negative_nine_bits[0] == 9);      // The magnitude should be 9 (only sign differs)

    // Test case 6: Check the bit vector for a larger negative number (negative_two_pow_64)
    const std::vector<uint64_t>& negative_two_pow_64_bits = objs->negative_two_pow_64.get_bit_vector();
    ASSERT(negative_two_pow_64_bits.size() == 2);  // The bit vector should contain two words
    ASSERT(negative_two_pow_64_bits[0] == 0);      // The lower 64 bits should be zero
    ASSERT(negative_two_pow_64_bits[1] == 1);      // The upper 64 bits should be 1

    // Test case 7: Check if modifying the returned reference modifies the original BigInt (const test)
    // Since the reference is const, this is just a test for consistency and immutability.
    // We will verify that the reference indeed reflects the underlying bits without modification.
    const std::vector<uint64_t>& immutable_bits = objs->one.get_bit_vector();
    ASSERT(immutable_bits[0] == 1);  // Should still be 1 as the reference is const
}

void test_default_constructor(TestObjs *objs) {
    // Test case 1: Check if a BigInt constructed with the default constructor represents zero
    BigInt default_bigint;
    
    // Check that the magnitude (bit vector) contains only one word and that word is 0
    const std::vector<uint64_t>& bits = default_bigint.get_bit_vector();
    ASSERT(bits.size() == 1);  // The bit vector should contain exactly one word
    ASSERT(bits[0] == 0);      // The word should be zero, representing the value 0

    // Check that the BigInt is not marked as negative
    ASSERT(!default_bigint.is_negative());  // The BigInt should not be negative

    // Test case 2: Check that zero from the test objects matches the default constructor behavior
    ASSERT(objs->zero == default_bigint);  // Both should represent the same value (0)

    // Test case 3: Check that converting the default BigInt to hex returns "0"
    ASSERT(default_bigint.to_hex() == "0");  // The hex representation of zero should be "0"

    // Test case 4: Check that converting the default BigInt to decimal returns "0"
    ASSERT(default_bigint.to_dec() == "0");  // The decimal representation of zero should be "0"
}

void test_initializer_list_constructor(TestObjs *objs) {
    // Test case 1: Construct a BigInt with multiple words and positive sign
    BigInt positive_bigint({0x123456789ABCDEF0UL, 0x0F0F0F0F0F0F0F0FUL}, false);
    const std::vector<uint64_t>& bits1 = positive_bigint.get_bit_vector();
    ASSERT(bits1.size() == 2);  // Should have two words
    ASSERT(bits1[0] == 0x123456789ABCDEF0UL);  // Check the lower word
    ASSERT(bits1[1] == 0x0F0F0F0F0F0F0F0FUL);  // Check the higher word
    ASSERT(!positive_bigint.is_negative());  // Should be positive

    // Test case 2: Construct a BigInt with multiple words and negative sign
    BigInt negative_bigint({0xFFFFFFFFFFFFFFFFUL, 0x123456789ABCDEF0UL}, true);
    const std::vector<uint64_t>& bits2 = negative_bigint.get_bit_vector();
    ASSERT(bits2.size() == 2);  // Should have two words
    ASSERT(bits2[0] == 0xFFFFFFFFFFFFFFFFUL);  // Check the lower word
    ASSERT(bits2[1] == 0x123456789ABCDEF0UL);  // Check the higher word
    ASSERT(negative_bigint.is_negative());  // Should be negative

    // Test case 3: Construct a BigInt with leading zeros in the initializer list
    BigInt leading_zeros_bigint({0x123456789ABCDEF0UL, 0x0UL, 0x0UL}, false);
    const std::vector<uint64_t>& bits3 = leading_zeros_bigint.get_bit_vector();
    ASSERT(bits3.size() == 1);  // Leading zeros should be removed, leaving only one word
    ASSERT(bits3[0] == 0x123456789ABCDEF0UL);  // Check the remaining word
    ASSERT(!leading_zeros_bigint.is_negative());  // Should be positive

    // Test case 4: Construct a BigInt with a single word and positive sign
    BigInt single_word_bigint({0x123456789ABCDEF0UL}, false);
    const std::vector<uint64_t>& bits4 = single_word_bigint.get_bit_vector();
    ASSERT(bits4.size() == 1);  // Should have one word
    ASSERT(bits4[0] == 0x123456789ABCDEF0UL);  // Check the word
    ASSERT(!single_word_bigint.is_negative());  // Should be positive

    // Test case 5: Construct a BigInt with a single word and negative sign
    BigInt negative_single_word_bigint({0x123456789ABCDEF0UL}, true);
    const std::vector<uint64_t>& bits5 = negative_single_word_bigint.get_bit_vector();
    ASSERT(bits5.size() == 1);  // Should have one word
    ASSERT(bits5[0] == 0x123456789ABCDEF0UL);  // Check the word
    ASSERT(negative_single_word_bigint.is_negative());  // Should be negative

}

void test_single_uint64_constructor(TestObjs *objs) {
    // Test case 1: Construct a positive BigInt from a 64-bit unsigned integer
    BigInt positive_bigint(0x123456789ABCDEF0UL, false);
    const std::vector<uint64_t>& bits1 = positive_bigint.get_bit_vector();
    ASSERT(bits1.size() == 1);  // Should have one word
    ASSERT(bits1[0] == 0x123456789ABCDEF0UL);  // Check the word value
    ASSERT(!positive_bigint.is_negative());  // Should be positive

    // Test case 2: Construct a negative BigInt from a 64-bit unsigned integer
    BigInt negative_bigint(0x123456789ABCDEF0UL, true);
    const std::vector<uint64_t>& bits2 = negative_bigint.get_bit_vector();
    ASSERT(bits2.size() == 1);  // Should have one word
    ASSERT(bits2[0] == 0x123456789ABCDEF0UL);  // Check the word value
    ASSERT(negative_bigint.is_negative());  // Should be negative

    // Test case 3: Construct a BigInt from zero with positive sign
    BigInt zero_bigint(0x0UL, false);
    const std::vector<uint64_t>& bits3 = zero_bigint.get_bit_vector();
    ASSERT(bits3.size() == 1);  // Should have one word
    ASSERT(bits3[0] == 0x0UL);  // The word should be zero
    ASSERT(!zero_bigint.is_negative());  // Zero should not be negative

    // Test case 4: Construct a BigInt from zero with negative sign
    BigInt negative_zero_bigint(0x0UL, true);
    const std::vector<uint64_t>& bits4 = negative_zero_bigint.get_bit_vector();
    ASSERT(bits4.size() == 1);  // Should have one word
    ASSERT(bits4[0] == 0x0UL);  // The word should be zero
    ASSERT(!negative_zero_bigint.is_negative());  // Zero should not be negative, sign ignored

    // Test case 5: Construct a BigInt from the maximum 64-bit unsigned integer (positive)
    BigInt max_positive_bigint(0xFFFFFFFFFFFFFFFFUL, false);
    const std::vector<uint64_t>& bits5 = max_positive_bigint.get_bit_vector();
    ASSERT(bits5.size() == 1);  // Should have one word
    ASSERT(bits5[0] == 0xFFFFFFFFFFFFFFFFUL);  // Check the word value
    ASSERT(!max_positive_bigint.is_negative());  // Should be positive

}

void test_copy_constructor(TestObjs *objs) {
    // Test case 1: Copy constructor with a positive BigInt
    BigInt original1(0x123456789ABCDEF0UL, false);  // Original positive BigInt
    BigInt copy1(original1);  // Copy using the copy constructor
    const std::vector<uint64_t>& bits1 = copy1.get_bit_vector();
    ASSERT(bits1.size() == 1);  // Should have one word
    ASSERT(bits1[0] == 0x123456789ABCDEF0UL);  // Word should match the original
    ASSERT(!copy1.is_negative());  // Sign should match the original (positive)
    ASSERT(original1.get_bit_vector() == copy1.get_bit_vector());  // Ensure deep copy of bits

    // Test case 2: Copy constructor with a negative BigInt
    BigInt original2(0x123456789ABCDEF0UL, true);  // Original negative BigInt
    BigInt copy2(original2);  // Copy using the copy constructor
    const std::vector<uint64_t>& bits2 = copy2.get_bit_vector();
    ASSERT(bits2.size() == 1);  // Should have one word
    ASSERT(bits2[0] == 0x123456789ABCDEF0UL);  // Word should match the original
    ASSERT(copy2.is_negative());  // Sign should match the original (negative)
    ASSERT(original2.get_bit_vector() == copy2.get_bit_vector());  // Ensure deep copy of bits

    // Test case 3: Copy constructor with zero BigInt (non-negative)
    BigInt original3(0x0UL, false);  // Original zero BigInt
    BigInt copy3(original3);  // Copy using the copy constructor
    const std::vector<uint64_t>& bits3 = copy3.get_bit_vector();
    ASSERT(bits3.size() == 1);  // Should have one word
    ASSERT(bits3[0] == 0x0UL);  // Word should be zero
    ASSERT(!copy3.is_negative());  // Sign should match the original (non-negative)
    ASSERT(original3.get_bit_vector() == copy3.get_bit_vector());  // Ensure deep copy of bits

    // Test case 4: Copy constructor with zero BigInt (negative)
    BigInt original4(0x0UL, true);  // Original zero BigInt with negative flag
    BigInt copy4(original4);  // Copy using the copy constructor
    const std::vector<uint64_t>& bits4 = copy4.get_bit_vector();
    ASSERT(bits4.size() == 1);  // Should have one word
    ASSERT(bits4[0] == 0x0UL);  // Word should be zero
    ASSERT(!copy4.is_negative());  // Zero should always be non-negative regardless of the original flag
    ASSERT(original4.get_bit_vector() == copy4.get_bit_vector());  // Ensure deep copy of bits

    // Test case 5: Copy constructor with multiple 64-bit words
    BigInt original5({0xFFFFFFFFFFFFFFFFUL, 0x123456789ABCDEF0UL}, false);  // Original BigInt with multiple words
    BigInt copy5(original5);  // Copy using the copy constructor
    const std::vector<uint64_t>& bits5 = copy5.get_bit_vector();
    ASSERT(bits5.size() == 2);  // Should have two words
    ASSERT(bits5[0] == 0xFFFFFFFFFFFFFFFFUL);  // Check the lower word
    ASSERT(bits5[1] == 0x123456789ABCDEF0UL);  // Check the higher word
    ASSERT(!copy5.is_negative());  // Sign should match the original (positive)
    ASSERT(original5.get_bit_vector() == copy5.get_bit_vector());  // Ensure deep copy of bits
}
