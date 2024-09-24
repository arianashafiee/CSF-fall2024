#include <assert.h>
#include <stdlib.h>
#include <stdbool.h>
#include "tctest.h"
#include "imgproc.h"

// An expected color identified by a (non-zero) character code.
// Used in the "Picture" data type.
typedef struct {
  char c;
  uint32_t color;
} ExpectedColor;

// Type representing a "picture" of an expected image.
// Useful for creating a very simple Image to be accessed
// by test functions.
typedef struct {
  ExpectedColor colors[20];
  int width, height;
  const char *data;
} Picture;


// Some "basic" colors to use in test Pictures
#define TEST_COLORS \
    { \
      { ' ', 0x000000FF }, \
      { 'r', 0xFF0000FF }, \
      { 'g', 0x00FF00FF }, \
      { 'b', 0x0000FFFF }, \
      { 'c', 0x00FFFFFF }, \
      { 'm', 0xFF00FFFF }, \
    }

// Expected "basic" colors after grayscale transformation
#define TEST_COLORS_GRAYSCALE \
    { \
      { ' ', 0x000000FF }, \
      { 'r', 0x4E4E4EFF }, \
      { 'g', 0x7F7F7FFF }, \
      { 'b', 0x303030FF }, \
      { 'c', 0xB0B0B0FF }, \
      { 'm', 0x7F7F7FFF }, \
    }

// Colors for test overlay image (for testing the composite
// transformation). Has some fully-opaque colors,
// some partially-transparent colors, and a complete
// transparent color.
#define OVERLAY_COLORS \
  { \
    { 'r', 0xFF0000FF }, \
    { 'R', 0xFF000080 }, \
    { 'g', 0x00FF00FF }, \
    { 'G', 0x00FF0080 }, \
    { 'b', 0x0000FFFF }, \
    { 'B', 0x0000FF80 }, \
    { ' ', 0x00000000 }, \
  }

// Data type for the test fixture object.
// This contains data (including Image objects) that
// can be accessed by test functions. This is useful
// because multiple test functions can access the same
// data (so you don't need to create/initialize that
// data multiple times in different test functions.)
typedef struct {
  // smiley-face picture
  Picture smiley_pic;

  // original smiley-face Image object
  struct Image *smiley;

  // empty Image object to use for output of
  // transformation on smiley-face image
  struct Image *smiley_out;

  // Picture for overlay image (for basic imgproc_composite test)
  Picture overlay_pic;

  // overlay image object
  struct Image *overlay;


} TestObjs;

// Functions to create and clean up a test fixture object
TestObjs *setup( void );
void cleanup( TestObjs *objs );

// Helper functions used by the test code
struct Image *picture_to_img( const Picture *pic );
uint32_t lookup_color(char c, const ExpectedColor *colors);
bool images_equal( struct Image *a, struct Image *b );
void destroy_img( struct Image *img );

// Test functions
void test_mirror_h_basic( TestObjs *objs );
void test_mirror_v_basic( TestObjs *objs );
void test_tile_basic( TestObjs *objs );
void test_grayscale_basic( TestObjs *objs );
void test_composite_basic( TestObjs *objs );
// TODO: add prototypes for additional test functions

void test_all_tiles_nonempty(TestObjs *objs);
void test_determine_tile_w(TestObjs *objs);
void test_determine_tile_x_offset(TestObjs *objs);
void test_determine_tile_h(TestObjs *objs);
void test_determine_tile_y_offset(TestObjs *objs);
void test_copy_tile(TestObjs *objs);
void test_get_r(TestObjs *objs);
void test_get_g(TestObjs *objs);
void test_get_b(TestObjs *objs);
void test_get_a(TestObjs *objs);
void test_make_pixel(TestObjs *objs);
void test_to_grayscale(TestObjs *objs);
void test_blend_components(TestObjs *objs);

int main( int argc, char **argv ) {
  // allow the specific test to execute to be specified as the
  // first command line argument
  if ( argc > 1 )
    tctest_testname_to_execute = argv[1];

  TEST_INIT();

  // Run tests.
  // Make sure you add additional TEST() macro invocations
  // for any additional test functions you add.
  TEST( test_mirror_h_basic );
  TEST( test_mirror_v_basic );
  TEST( test_tile_basic );
  TEST( test_grayscale_basic );
  TEST( test_composite_basic );

  TEST(test_all_tiles_nonempty);
  TEST(test_determine_tile_w);
  TEST(test_determine_tile_x_offset);
  TEST(test_determine_tile_h);
  TEST(test_determine_tile_y_offset);
  TEST(test_copy_tile);
  TEST(test_get_r);
  TEST(test_get_g);
  TEST(test_get_b);
  TEST(test_get_a);
  TEST(test_make_pixel);
  TEST(test_to_grayscale);
  TEST(test_blend_components);

  TEST_FINI();
}

////////////////////////////////////////////////////////////////////////
// Test fixture setup/cleanup functions
////////////////////////////////////////////////////////////////////////

TestObjs *setup(void) {
    TestObjs *objs = (TestObjs *)malloc(sizeof(TestObjs));

    // Set up smiley image from picture data (as already implemented)
    Picture smiley_pic = {
        TEST_COLORS,
        16, // width
        10, // height
        "    mrrrggbc    "
        "   c        b   "
        "  r   r  b   c  "
        " b            b "
        " b            r "
        " g   b    c   r "
        "  c   ggrb   b  "
        "   m        c   "
        "    gggrrbmc    "
        "                "
    };
    objs->smiley_pic = smiley_pic;
    objs->smiley = picture_to_img(&smiley_pic);

    // Allocate memory for the output smiley image
    objs->smiley_out = (struct Image *)malloc(sizeof(struct Image));
    img_init(objs->smiley_out, objs->smiley->width, objs->smiley->height);

    // Set up overlay image from picture data (as already implemented)
    Picture overlay_pic = {
        OVERLAY_COLORS,
        16, 10,
        "                "
        "                "
        "                "
        "                "
        "                "
        "  rRgGbB        "
        "                "
        "                "
        "                "
        "                "
    };
    objs->overlay_pic = overlay_pic;
    objs->overlay = picture_to_img(&overlay_pic);

    return objs;
}



void cleanup( TestObjs *objs ) {
  destroy_img( objs->smiley );
  destroy_img( objs->smiley_out );
  destroy_img( objs->overlay );

  free( objs );
}

////////////////////////////////////////////////////////////////////////
// Test code helper functions
////////////////////////////////////////////////////////////////////////

struct Image *picture_to_img( const Picture *pic ) {
  struct Image *img;

  img = (struct Image *) malloc( sizeof(struct Image) );
  img_init( img, pic->width, pic->height );

  for ( int i = 0; i < pic->height; ++i ) {
    for ( int j = 0; j < pic->width; ++j ) {
      int index = i * img->width + j;
      uint32_t color = lookup_color( pic->data[index], pic->colors );
      img->data[index] = color;
    }
  }

  return img;
}

uint32_t lookup_color(char c, const ExpectedColor *colors) {
  for (int i = 0; ; i++) {
    assert(colors[i].c != 0);
    if (colors[i].c == c) {
      return colors[i].color;
    }
  }
}

// Returns true IFF both Image objects are identical
bool images_equal( struct Image *a, struct Image *b ) {
  if ( a->width != b->width || a->height != b->height )
    return false;

  int num_pixels = a->width * a->height;
  for ( int i = 0; i < num_pixels; ++i ) {
    if ( a->data[i] != b->data[i] )
      return false;
  }

  return true;
}

void destroy_img( struct Image *img ) {
  if ( img != NULL )
    img_cleanup( img );
  free( img );
}

////////////////////////////////////////////////////////////////////////
// Test functions
////////////////////////////////////////////////////////////////////////

void test_mirror_h_basic( TestObjs *objs ) {
  Picture smiley_mirror_h_pic = {
    TEST_COLORS,
    16, 10,
    "    cbggrrrm    "
    "   b        c   "
    "  c   b  r   r  "
    " b            b "
    " r            b "
    " r   c    b   g "
    "  b   brgg   c  "
    "   c        m   "
    "    cmbrrggg    "
    "                "
  };
  struct Image *smiley_mirror_h_expected = picture_to_img( &smiley_mirror_h_pic );

  imgproc_mirror_h( objs->smiley, objs->smiley_out );

  ASSERT( images_equal( smiley_mirror_h_expected, objs->smiley_out ) );

  destroy_img( smiley_mirror_h_expected );
}

void test_mirror_v_basic( TestObjs *objs ) {
  Picture smiley_mirror_v_pic = {
    TEST_COLORS,
    16, 10,
    "                "
    "    gggrrbmc    "
    "   m        c   "
    "  c   ggrb   b  "
    " g   b    c   r "
    " b            r "
    " b            b "
    "  r   r  b   c  "
    "   c        b   "
    "    mrrrggbc    "
  };
  struct Image *smiley_mirror_v_expected = picture_to_img( &smiley_mirror_v_pic );

  imgproc_mirror_v( objs->smiley, objs->smiley_out );

  ASSERT( images_equal( smiley_mirror_v_expected, objs->smiley_out ) );

  destroy_img( smiley_mirror_v_expected );
}
void print_image(struct Image *img) {
    for (int y = 0; y < img->height; y++) {
        for (int x = 0; x < img->width; x++) {
            uint32_t pixel = img->data[y * img->width + x];
            printf("%08X ", pixel);  // Print each pixel as a hexadecimal value
        }
        printf("\n");
    }
}
void test_tile_basic(TestObjs *objs) {
    Picture smiley_tile_3_pic = {
        TEST_COLORS,
        16, 10,
        "  rg    rg   rg "
        "                "
        "  gb    gb   gb "
        "                "
        "  rg    rg   rg "
        "                "
        "  gb    gb   gb "
        "  rg    rg   rg "
        "                "
        "  gb    gb   gb "
    };

    struct Image *smiley_tile_3_expected = picture_to_img(&smiley_tile_3_pic);

    int success = imgproc_tile(objs->smiley, 3, objs->smiley_out);
    ASSERT(success);

    if (!images_equal(smiley_tile_3_expected, objs->smiley_out)) {
        printf("Expected image:\n");
        print_image(smiley_tile_3_expected);

        printf("\nActual image:\n");
        print_image(objs->smiley_out);

        // Fail the test with a message
        ASSERT(false && "Images are not equal");
    }

    destroy_img(smiley_tile_3_expected);
}

void test_grayscale_basic( TestObjs *objs ) {
  Picture smiley_grayscale_pic = {
    TEST_COLORS_GRAYSCALE,
    16, // width
    10, // height
    "    mrrrggbc    "
    "   c        b   "
    "  r   r  b   c  "
    " b            b "
    " b            r "
    " g   b    c   r "
    "  c   ggrb   b  "
    "   m        c   "
    "    gggrrbmc    "
    "                "
  };

  struct Image *smiley_grayscale_expected = picture_to_img( &smiley_grayscale_pic );

  imgproc_grayscale( objs->smiley, objs->smiley_out );

  ASSERT( images_equal( smiley_grayscale_expected, objs->smiley_out ) );

  destroy_img( smiley_grayscale_expected );
}

void test_composite_basic( TestObjs *objs ) {
  imgproc_composite( objs->smiley, objs->overlay, objs->smiley_out );

  // for all of the fully-transparent pixels in the overlay image,
  // the result image should have a pixel identical to the corresponding
  // pixel in the base image
  for ( int i = 0; i < 160; ++i ) {
    if ( objs->overlay->data[i] == 0x00000000 )
      ASSERT( objs->smiley->data[i] == objs->smiley_out->data[i] );
  }

  // check the computed colors for the partially transparent or
  // fully opaque colors in the overlay image
  ASSERT( 0xFF0000FF == objs->smiley_out->data[82] );
  ASSERT( 0x800000FF == objs->smiley_out->data[83] );
  ASSERT( 0x00FF00FF == objs->smiley_out->data[84] );
  ASSERT( 0x00807FFF == objs->smiley_out->data[85] );
  ASSERT( 0x0000FFFF == objs->smiley_out->data[86] );
  ASSERT( 0x000080FF == objs->smiley_out->data[87] );
}

void test_all_tiles_nonempty(TestObjs *objs) {
  // Test 1: Basic case - perfectly divisible dimensions
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, 2) == 1); // Should return true (1)

  // Test 2: Non-divisible width, divisible height
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, 5) == 1); // Should return true (1)

  // Test 3: Divisible width, non-divisible height
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, 4) == 1); // Should return true (1)

  // Test 4: Both width and height non-divisible by n
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, 3) == 1); // Should return true (1)

  // Test 5: Width is zero
  ASSERT(all_tiles_nonempty(0, objs->smiley->height, 3) == 0); // Should return false (0)

  // Test 6: Height is zero
  ASSERT(all_tiles_nonempty(objs->smiley->width, 0, 3) == 0); // Should return false (0)

  // Test 7: Tiling factor n is zero
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, 0) == 0); // Should return false (0)

  // Test 8: Tiling factor n is negative
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, -1) == 0); // Should return false (0)

  // Test 9: Tiling factor larger than width and height
  ASSERT(all_tiles_nonempty(objs->smiley->width, objs->smiley->height, 20) == 1); // Should return true (1)
}

void test_determine_tile_w(TestObjs *objs) {
  // Test 1: Basic case - width divisible by n
  ASSERT(determine_tile_w(objs->smiley->width, 2, 0) == 8); // First tile
  ASSERT(determine_tile_w(objs->smiley->width, 2, 1) == 8); // Second tile

  // Test 2: Non-divisible width, distribute excess to leftmost tiles
  ASSERT(determine_tile_w(objs->smiley->width, 3, 0) == 6); // First tile gets the excess
  ASSERT(determine_tile_w(objs->smiley->width, 3, 1) == 5); // Second tile gets the remainder

  // Test 3: n = 1, only one tile should span the entire width
  ASSERT(determine_tile_w(objs->smiley->width, 1, 0) == objs->smiley->width); // One large tile

  // Test 4: Edge case, width is zero
  ASSERT(determine_tile_w(0, 3, 0) == 0); // Should return 0 for any tile

  // Test 5: Edge case, n is zero (invalid n)
  ASSERT(determine_tile_w(objs->smiley->width, 0, 0) == 0);

  // Test 6: Edge case, tile_col out of bounds
  ASSERT(determine_tile_w(objs->smiley->width, 3, -1) == 0); // Negative tile_col
  ASSERT(determine_tile_w(objs->smiley->width, 3, 3) == 0);  // tile_col beyond the range

  // Test 7: Small width, large n (some tiles may end up being 0)
  ASSERT(determine_tile_w(objs->smiley->width, 20, 0) == 1); // First tile gets the excess
  ASSERT(determine_tile_w(objs->smiley->width, 20, 1) == 1); // Second tile gets the excess
  ASSERT(determine_tile_w(objs->smiley->width, 20, 2) == 1); // Third tile
  ASSERT(determine_tile_w(objs->smiley->width, 20, 19) == 0); // Last tile gets nothing

  // Test 8: Case with a very large width image
  int large_width = 1000;
  ASSERT(determine_tile_w(large_width, 4, 0) == 250);  // Each tile is 250 pixels wide
  ASSERT(determine_tile_w(large_width, 4, 3) == 250);  // Last tile is also 250 pixels wide

}

void test_determine_tile_x_offset(TestObjs *objs) {
  // Test 1: Basic case - width divisible by n
  ASSERT(determine_tile_x_offset(objs->smiley->width, 2, 0) == 0); // First tile (offset 0)
  ASSERT(determine_tile_x_offset(objs->smiley->width, 2, 2) == 8); // Second tile (offset 8)

  // Test 2: Non-divisible width, distribute excess to leftmost tiles
  ASSERT(determine_tile_x_offset(objs->smiley->width, 3, 0) == 0); // First tile (offset 0)
  ASSERT(determine_tile_x_offset(objs->smiley->width, 3, 1) == 6); // Second tile (offset 6)
  ASSERT(determine_tile_x_offset(objs->smiley->width, 3, 2) == 11); // Third tile (offset 11)

  // Test 3: n = 1, only one tile should cover the entire width, offset should always be 0
  ASSERT(determine_tile_x_offset(objs->smiley->width, 1, 0) == 0); // Only one tile, offset 0

  // Test 4: Edge case, width is zero
  ASSERT(determine_tile_x_offset(0, 3, 0) == 0); // Width 0, offset should be 0 for any tile

  // Test 5: Edge case, n is zero (invalid n)
  ASSERT(determine_tile_x_offset(objs->smiley->width, 0, 0) == 0); // n is zero, should return 0

  // Test 6: Edge case, tile_col out of bounds
  ASSERT(determine_tile_x_offset(objs->smiley->width, 3, -1) == 0); // Negative tile_col
  ASSERT(determine_tile_x_offset(objs->smiley->width, 3, 3) == 0);  // tile_col beyond the range

  // Test 7: Small width, large n (some tiles may have minimal width, but offset should be correct)
  ASSERT(determine_tile_x_offset(objs->smiley->width, 20, 0) == 0); // First tile, offset 0
  ASSERT(determine_tile_x_offset(objs->smiley->width, 20, 1) == 1); // Second tile, offset 1
  ASSERT(determine_tile_x_offset(objs->smiley->width, 20, 2) == 2); // Third tile, offset 2
  ASSERT(determine_tile_x_offset(objs->smiley->width, 20, 19) == 10); // Last tile, offset 10

  // Test 8: Case with a large image width (1000 pixels) and n=4 for tiling
  int large_width = 1000;
  ASSERT(determine_tile_x_offset(large_width, 4, 0) == 0);    // First tile starts at 0
  ASSERT(determine_tile_x_offset(large_width, 4, 1) == 250);  // Second tile starts at 250
  ASSERT(determine_tile_x_offset(large_width, 4, 2) == 500);  // Third tile starts at 500
  ASSERT(determine_tile_x_offset(large_width, 4, 3) == 750);  // Fourth tile starts at 750
}

void test_determine_tile_h(TestObjs *objs) {
  // Test 1: Basic case - height divisible by n
  ASSERT(determine_tile_w(objs->smiley->height, 2, 0) == 5); // First tile
  ASSERT(determine_tile_w(objs->smiley->height, 2, 1) == 5); // Second tile

  // Test 2: Non-divisible height, distribute excess to topmost tiles
  ASSERT(determine_tile_w(objs->smiley->height, 3, 0) == 4); // First tile gets the excess
  ASSERT(determine_tile_w(objs->smiley->height, 3, 1) == 3); // Second tile gets the remainder

  // Test 3: n = 1, only one tile should span the entire height
  ASSERT(determine_tile_w(objs->smiley->height, 1, 0) == objs->smiley->height); // One large tile

  // Test 4: Edge case, height is zero
  ASSERT(determine_tile_w(0, 3, 0) == 0); // Should return 0 for any tile

  // Test 5: Edge case, n is zero (invalid n)
  ASSERT(determine_tile_w(objs->smiley->height, 0, 0) == 0);

  // Test 6: Edge case, tile_col out of bounds
  ASSERT(determine_tile_w(objs->smiley->height, 3, -1) == 0); // Negative tile_col
  ASSERT(determine_tile_w(objs->smiley->height, 3, 3) == 0);  // tile_col beyond the range

  // Test 7: Small height, large n (some tiles may end up being 0)
  ASSERT(determine_tile_w(objs->smiley->height, 20, 0) == 1); // First tile gets the excess
  ASSERT(determine_tile_w(objs->smiley->height, 20, 1) == 1); // Second tile gets the excess
  ASSERT(determine_tile_w(objs->smiley->height, 20, 2) == 1); // Third tile
  ASSERT(determine_tile_w(objs->smiley->height, 20, 19) == 0); // Last tile gets nothing
  int large_height = 1000;
  ASSERT(determine_tile_h(large_height, 4, 0) == 250);  // First tile
  ASSERT(determine_tile_h(large_height, 4, 3) == 250);  // Last tile
}

void test_determine_tile_y_offset(TestObjs *objs) {
  // Test 1: Basic case - height divisible by n
  ASSERT(determine_tile_x_offset(objs->smiley->height, 2, 0) == 0); // First tile (offset 0)
  ASSERT(determine_tile_x_offset(objs->smiley->height, 2, 2) == 5); // Second tile (offset 8)

  // Test 2: Non-divisible height, distribute excess to topmost tiles
  ASSERT(determine_tile_x_offset(objs->smiley->height, 3, 0) == 0); // First tile (offset 0)
  ASSERT(determine_tile_x_offset(objs->smiley->height, 3, 1) == 4); // Second tile (offset 6)
  ASSERT(determine_tile_x_offset(objs->smiley->height, 3, 2) == 3); // Third tile (offset 11)

  // Test 3: n = 1, only one tile should cover the entire height, offset should always be 0
  ASSERT(determine_tile_x_offset(objs->smiley->height, 1, 0) == 0); // Only one tile, offset 0

  // Test 4: Edge case, height is zero
  ASSERT(determine_tile_x_offset(0, 3, 0) == 0); // Height 0, offset should be 0 for any tile

  // Test 5: Edge case, n is zero (invalid n)
  ASSERT(determine_tile_x_offset(objs->smiley->height, 0, 0) == 0); // n is zero, should return 0

  // Test 6: Edge case, tile_col out of bounds
  ASSERT(determine_tile_x_offset(objs->smiley->height, 3, -1) == 0); // Negative tile_col
  ASSERT(determine_tile_x_offset(objs->smiley->height, 3, 3) == 0);  // tile_col beyond the range

  // Test 7: Small height, large n (some tiles may have minimal height, but offset should be correct)
  ASSERT(determine_tile_x_offset(objs->smiley->height, 20, 0) == 0);  // First tile, offset 0
  ASSERT(determine_tile_x_offset(objs->smiley->height, 20, 1) == 1);  // Second tile, offset 1
  ASSERT(determine_tile_x_offset(objs->smiley->height, 20, 2) == 2);  // Third tile, offset 2
  ASSERT(determine_tile_x_offset(objs->smiley->height, 20, 19) == 10); // Last tile, offset 10

  // Test 8: Case with a large image height (1000 pixels) and n=4 for tiling
  int large_height = 1000;
  ASSERT(determine_tile_y_offset(large_height, 4, 0) == 0);    // First tile starts at 0
  ASSERT(determine_tile_y_offset(large_height, 4, 1) == 250);  // Second tile starts at 250
  ASSERT(determine_tile_y_offset(large_height, 4, 2) == 500);  // Third tile starts at 500
  ASSERT(determine_tile_y_offset(large_height, 4, 3) == 750);  // Fourth tile starts at 750
}

void test_copy_tile(TestObjs *objs) {
    // Test 1: Standard case with n=2
    // We expect the tiles to be copied correctly with 2x2 tiling
    struct Image *expected_output = (struct Image *)malloc(sizeof(struct Image));
    img_init(expected_output, objs->smiley->width, objs->smiley->height);

    // Copy the tile at row 0, column 0 into the expected output image
    copy_tile(expected_output, objs->smiley, 0, 0, 2);
    
    // Now we manually create an expected result for this tile
    Picture expected_tile_0_0 = {
        TEST_COLORS,
        8, 5,  // Tile dimensions
        "    mrrr"
        "   c    "
        "  r   r "
        " b      "
        " b      "
    };
    struct Image *expected_tile_image = picture_to_img(&expected_tile_0_0);

    // Compare the expected output and the tile copied from the original image
    ASSERT(images_equal(expected_output, expected_tile_image));

    // Clean up memory
    destroy_img(expected_output);
    destroy_img(expected_tile_image);

    // Test 2: Case where n=3 (3x3 tiling)
    // We expect the tiles to be copied correctly into a 3x3 grid
    img_init(expected_output, objs->smiley->width, objs->smiley->height);

    // Copy the tile at row 1, column 1 (second tile down and right) into the expected output
    copy_tile(expected_output, objs->smiley, 1, 1, 3);

    // Now we manually create an expected result for this tile
    Picture expected_tile_1_1 = {
        TEST_COLORS,
        5, 3,  // Tile dimensions
        "  c  "
        " b   "
        " r   "
    };
    expected_tile_image = picture_to_img(&expected_tile_1_1);

    // Compare the expected output and the tile copied from the original image
    ASSERT(images_equal(expected_output, expected_tile_image));

    // Clean up memory
    destroy_img(expected_output);
    destroy_img(expected_tile_image);

    // Test 3: Case where n is larger than the image dimensions
    // n=10 for a 16x10 image means one large tile covering the entire image
    img_init(expected_output, objs->smiley->width, objs->smiley->height);
    
    copy_tile(expected_output, objs->smiley, 0, 0, 10);

    // Expected output should match the entire smiley image
    ASSERT(images_equal(expected_output, objs->smiley));

    // Clean up memory
    destroy_img(expected_output);

    // Test 4: Case with smaller image (5x5) and n=2
    // Create a smaller image and tile from it
    Picture small_picture = {
        TEST_COLORS,
        5, 5,  // Small image
        "r    "
        " g g "
        "  b  "
        " g g "
        "    r"
    };
    struct Image *small_img = picture_to_img(&small_picture);
    struct Image *small_out = (struct Image *)malloc(sizeof(struct Image));
    img_init(small_out, small_img->width, small_img->height);

    // Copy the first tile from this smaller image
    copy_tile(small_out, small_img, 0, 0, 2);

    // Manually construct the expected tile
    Picture expected_small_tile = {
        TEST_COLORS,
        3, 3,  // Tile size with remainder
        "r  "
        " g "
        "  b"
    };
    expected_tile_image = picture_to_img(&expected_small_tile);

    // Compare the expected tile with the result of the tile copy
    ASSERT(images_equal(small_out, expected_tile_image));

    // Clean up memory
    destroy_img(small_img);
    destroy_img(small_out);
    destroy_img(expected_tile_image);

    // Test 5: Edge case with invalid parameters (n=0)
    // We expect no tiles to be copied in this invalid scenario
    img_init(expected_output, objs->smiley->width, objs->smiley->height);

    copy_tile(expected_output, objs->smiley, 0, 0, 0);  // Invalid n, expect no change
    ASSERT(images_equal(expected_output, objs->smiley_out));  // Expecting the output to remain empty

    // Clean up memory
    destroy_img(expected_output);
}


void test_get_r(TestObjs *objs) {
  // Test 1: Basic case, arbitrary red value
  uint32_t pixel = 0x7F000000; // Red component = 127 (0x7F), other components = 0
  ASSERT(get_r(pixel) == 127);

  // Test 2: Edge case, red component = 0
  pixel = 0x00000000; // Red component = 0, other components = 0
  ASSERT(get_r(pixel) == 0);

  // Test 3: Edge case, red component = 255 (max value)
  pixel = 0xFFFFFFFF; // Red component = 255 (0xFF), other components = 255
  ASSERT(get_r(pixel) == 255);

  // Test 4: Red component with other color values set
  pixel = 0x7F123456; // Red component = 127, green = 18, blue = 52, alpha = 86
  ASSERT(get_r(pixel) == 127);

  // Test 5: Fully transparent pixel (alpha = 0), red component = 128
  pixel = 0x80000000; // Red component = 128, fully transparent (alpha = 0)
  ASSERT(get_r(pixel) == 128);

  // Test 6: Fully opaque pixel (alpha = 255), red component = 64
  pixel = 0x400000FF; // Red component = 64, fully opaque (alpha = 255)
  ASSERT(get_r(pixel) == 64);

  // Test 7: Extract red component from a pixel in the smiley image
  uint32_t smiley_red_pixel = objs->smiley->data[objs->smiley_pic.data[4] == 'r' ? 4 : 0];  // First red pixel
  ASSERT(get_r(smiley_red_pixel) == 0xFF);  // Expected red component is 255 (0xFF)

  // Test 8: Extract red component from a pixel in a smaller custom image
  Picture custom_picture = {
    TEST_COLORS,
    3, 3,
    "r  "
    " g "
    "  b"
  };
  struct Image *custom_img = picture_to_img(&custom_picture);
  uint32_t custom_red_pixel = custom_img->data[0];  // This should be the red pixel
  ASSERT(get_r(custom_red_pixel) == 0xFF);  // The red component should be 0xFF
  // Clean up memory
  destroy_img(custom_img);
}

void test_get_g(TestObjs *objs) {
  // Test 1: Basic case, arbitrary green value
  uint32_t pixel = 0x007F0000; // Green component = 127 (0x7F), other components = 0
  ASSERT(get_r(pixel) == 127);

  // Test 2: Edge case, green component = 0
  pixel = 0x00000000; // Green component = 0, other components = 0
  ASSERT(get_r(pixel) == 0);

  // Test 3: Edge case, green component = 255 (max value)
  pixel = 0xFFFFFFFF; // Green component = 255 (0xFF), other components = 255
  ASSERT(get_r(pixel) == 255);

  // Test 4: Green component with other color values set
  pixel = 0x127F3456; // Green component = 127, red = 18, blue = 52, alpha = 86
  ASSERT(get_r(pixel) == 127);

  // Test 5: Fully transparent pixel (alpha = 0), green component = 128
  pixel = 0x00800000; // Green component = 128, fully transparent (alpha = 0)
  ASSERT(get_r(pixel) == 128);

  // Test 6: Fully opaque pixel (alpha = 255), green component = 64
  pixel = 0x004000FF; // Green component = 64, fully opaque (alpha = 255)
  ASSERT(get_r(pixel) == 64);
}

void test_get_b(TestObjs *objs) {
  // Test 1: Basic case, arbitrary blue value
  uint32_t pixel = 0x00007F00; // Blue component = 127 (0x7F), other components = 0
  ASSERT(get_r(pixel) == 127);

  // Test 2: Edge case, blue component = 0
  pixel = 0x00000000; // Blue component = 0, other components = 0
  ASSERT(get_r(pixel) == 0);

  // Test 3: Edge case, blue component = 255 (max value)
  pixel = 0xFFFFFFFF; // Blue component = 255 (0xFF), other components = 255
  ASSERT(get_r(pixel) == 255);

  // Test 4: Blue component with other color values set
  pixel = 0x12347F56; // Blue component = 127, red = 18, green = 52, alpha = 86
  ASSERT(get_r(pixel) == 127);

  // Test 5: Fully transparent pixel (alpha = 0), blue component = 128
  pixel = 0x00008000; // Blue component = 128, fully transparent (alpha = 0)
  ASSERT(get_r(pixel) == 128);

  // Test 6: Fully opaque pixel (alpha = 255), blue component = 64
  pixel = 0x000040FF; // Blue component = 64, fully opaque (alpha = 255)
  ASSERT(get_r(pixel) == 64);
}

void test_get_a(TestObjs *objs) {
  // Test 1: Basic case, arbitrary alpha value
  uint32_t pixel = 0x0000007F; // Alpha component = 127 (0x7F), other components = 0
  ASSERT(get_r(pixel) == 127);

  // Test 2: Edge case, alpha component = 0
  pixel = 0x00000000; // Alpha component = 0, other components = 0
  ASSERT(get_r(pixel) == 0);

  // Test 3: Edge case, alpha component = 255 (max value)
  pixel = 0xFFFFFFFF; // Alpha component = 255 (0xFF), other components = 255
  ASSERT(get_r(pixel) == 255);

  // Test 4: Alpha component with other color values set
  pixel = 0x1234567F; // Alpha component = 127, red = 18, green = 52, blue = 86
  ASSERT(get_r(pixel) == 127);
}

void test_make_pixel(TestObjs *objs) {
  // Test 1: Basic case, arbitrary values for red, green, blue, and alpha
  uint32_t pixel = make_pixel(127, 63, 255, 128); // r = 127, g = 63, b = 255, a = 128
  ASSERT(pixel == 0x7F3FFF80);                    // Expected pixel value: 0x7F3FFF80

  // Test 2: Edge case, all components at minimum value (0)
  pixel = make_pixel(0, 0, 0, 0); // r = 0, g = 0, b = 0, a = 0
  ASSERT(pixel == 0x00000000);    // Expected pixel value: 0x00000000

  // Test 3: Edge case, all components at maximum value (255)
  pixel = make_pixel(255, 255, 255, 255); // r = 255, g = 255, b = 255, a = 255
  ASSERT(pixel == 0xFFFFFFFF);            // Expected pixel value: 0xFFFFFFFF

  // Test 4: Verify red component is placed correctly
  pixel = make_pixel(255, 0, 0, 0); // r = 255, g = 0, b = 0, a = 0
  ASSERT(pixel == 0xFF000000);      // Expected pixel value: 0xFF000000

  // Test 5: Verify green component is placed correctly
  pixel = make_pixel(0, 255, 0, 0); // r = 0, g = 255, b = 0, a = 0
  ASSERT(pixel == 0x00FF0000);      // Expected pixel value: 0x00FF0000

  // Test 6: Verify blue component is placed correctly
  pixel = make_pixel(0, 0, 255, 0); // r = 0, g = 0, b = 255, a = 0
  ASSERT(pixel == 0x0000FF00);      // Expected pixel value: 0x0000FF00

  // Test 7: Verify alpha component is placed correctly
  pixel = make_pixel(0, 0, 0, 255); // r = 0, g = 0, b = 0, a = 255
  ASSERT(pixel == 0x000000FF);      // Expected pixel value: 0x000000FF
}

void test_to_grayscale(TestObjs *objs) {
  // Test 1: Basic case, arbitrary color pixel
  uint32_t pixel = make_pixel(100, 150, 200, 128); // r = 100, g = 150, b = 200, a = 128
  uint32_t gray_pixel = to_grayscale(pixel);
  uint32_t expected_y = (79 * 100 + 128 * 150 + 49 * 200) / 256; // Grayscale formula
  ASSERT(get_r(gray_pixel) == expected_y);
  ASSERT(get_g(gray_pixel) == expected_y);
  ASSERT(get_b(gray_pixel) == expected_y);
  ASSERT(get_a(gray_pixel) == 128); // Alpha should remain unchanged

  // Test 2: Edge case, all components at 0
  pixel = make_pixel(0, 0, 0, 255); // r = 0, g = 0, b = 0, a = 0
  gray_pixel = to_grayscale(pixel);
  expected_y = (79 * 0 + 128 * 0 + 49 * 0) / 256;
  ASSERT(get_r(gray_pixel) == expected_y);
  ASSERT(get_g(gray_pixel) == expected_y);
  ASSERT(get_b(gray_pixel) == expected_y);
  ASSERT(get_a(gray_pixel) == 0);

  // Test 3: Edge case - all components at 255
  pixel = make_pixel(255, 255, 255, 255); // r = 255, g = 255, b = 255, a = 255
  gray_pixel = to_grayscale(pixel);
  expected_y = (79 * 255 + 128 * 255 + 49 * 255) / 256;
  ASSERT(get_r(gray_pixel) == expected_y);
  ASSERT(get_g(gray_pixel) == expected_y);
  ASSERT(get_b(gray_pixel) == expected_y);
  ASSERT(get_a(gray_pixel) == 255);

  // Test 4: Red component only
  pixel = make_pixel(255, 0, 0, 128); // r = 255, g = 0, b = 0, a = 128
  expected_y = (79 * 255 + 128 * 0 + 49 * 0) / 256;
  gray_pixel = to_grayscale(pixel);
  ASSERT(get_r(gray_pixel) == expected_y);
  ASSERT(get_g(gray_pixel) == expected_y);
  ASSERT(get_b(gray_pixel) == expected_y);
  ASSERT(get_a(gray_pixel) == 128);

  // Test 5: Green component only
  pixel = make_pixel(0, 255, 0, 128); // r = 0, g = 255, b = 0, a = 128
  expected_y = (79 * 0 + 128 * 255 + 49 * 0) / 256;
  gray_pixel = to_grayscale(pixel);
  ASSERT(get_r(gray_pixel) == expected_y);
  ASSERT(get_g(gray_pixel) == expected_y);
  ASSERT(get_b(gray_pixel) == expected_y);
  ASSERT(get_a(gray_pixel) == 128);

  // Test 6: Blue component only
  pixel = make_pixel(0, 0, 255, 128); // r = 0, g = 0, b = 255, a = 128
  expected_y = (79 * 0 + 128 * 0 + 49 * 255) / 256;
  gray_pixel = to_grayscale(pixel);
  ASSERT(get_r(gray_pixel) == expected_y);
  ASSERT(get_g(gray_pixel) == expected_y);
  ASSERT(get_b(gray_pixel) == expected_y);
  ASSERT(get_a(gray_pixel) == 128);
}

void test_blend_colors(TestObjs *objs) {
  // Test 1: Basic case
  uint32_t fg = make_pixel(100, 150, 200, 128); // r = 100, g = 150, b = 200, a = 128 (semi-transparent)
  uint32_t bg = make_pixel(50, 50, 50, 255); // r = 50, g = 50, b = 50, a = 255 (fully opaque background)
  uint32_t blended_pixel = blend_colors(fg, bg);

  uint32_t expected_r = (128 * 100 + (255 - 128) * 50) / 255; // Expected blended r component
  uint32_t expected_g = (128 * 150 + (255 - 128) * 50) / 255; // Expected blended g component
  uint32_t expected_b = (128 * 200 + (255 - 128) * 50) / 255; // Expected blended b component

  ASSERT(get_r(blended_pixel) == expected_r);
  ASSERT(get_g(blended_pixel) == expected_g);
  ASSERT(get_b(blended_pixel) == expected_b);
  ASSERT(get_a(blended_pixel) == 255); // Alpha should always be 255

  // Test 2: Edge case, fully transparent foreground (a = 0)
  fg = make_pixel(255, 255, 255, 0); // r = 255, g = 255, b = 255, a = 0 (fully transparent)
  bg = make_pixel(50, 50, 50, 255); // r = 50, g = 50, b = 50, a = 255
  blended_pixel = blend_colors(fg, bg);

  ASSERT(get_r(blended_pixel) == 50); // Should return the background color
  ASSERT(get_g(blended_pixel) == 50);
  ASSERT(get_b(blended_pixel) == 50);
  ASSERT(get_a(blended_pixel) == 255); // Alpha should always be 255

  // Test 3: Edge case, fully opaque foreground (alpha = 255)
  fg = make_pixel(255, 255, 255, 255); // r = 255, g = 0, b = 0, a = 255 (fully opaque)
  bg = make_pixel(50, 50, 50, 255); // r = 50, g = 50, b = 50, a = 255
  blended_pixel = blend_colors(fg, bg);

  ASSERT(get_r(blended_pixel) == 255); // Should return the foreground color
  ASSERT(get_g(blended_pixel) == 255);
  ASSERT(get_b(blended_pixel) == 255);
  ASSERT(get_a(blended_pixel) == 255); // Alpha should always be 255

  // Test 4: Extreme case, foreground and background both black
  fg = make_pixel(0, 0, 0, 128); // r = 0, g = 0, b = 0, a = 128 (black foreground)
  bg = make_pixel(0, 0, 0, 255); // r = 0, g = 0, b = 0, a = 255 (black background)
  blended_pixel = blend_colors(fg, bg);

  ASSERT(get_r(blended_pixel) == 0); // Black blended with black should yield black
  ASSERT(get_g(blended_pixel) == 0);
  ASSERT(get_b(blended_pixel) == 0);
  ASSERT(get_a(blended_pixel) == 255); // Alpha should always be 255

  // Test 5: Extreme case, foreground and background both white
  fg = make_pixel(255, 255, 255, 128); // r = 255, g = 255, b = 255, a = 128 (white foreground)
  bg = make_pixel(255, 255, 255, 255); // r = 255, g = 255, b = 255, a = 255 (white background)
  blended_pixel = blend_colors(fg, bg);

  ASSERT(get_r(blended_pixel) == 255); // White blended with white should yield white
  ASSERT(get_g(blended_pixel) == 255);
  ASSERT(get_b(blended_pixel) == 255);
  ASSERT(get_a(blended_pixel) == 255); // Alpha should always be 255
}