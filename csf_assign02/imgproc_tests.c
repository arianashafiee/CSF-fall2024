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

void test_all_tiles_nonempty(TestObjs *objs)
{
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

void test_determine_tile_w(TestObjs *objs)
{
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
}

void test_determine_tile_x_offset(TestObjs *objs)
{
  ASSERT(determine_tile_x_offset(objs->smiley->width, 4, 0) == 0);
  ASSERT(determine_tile_x_offset(objs->smiley->width, 3, 2) == 11);
  // ASSERT(determine_tile_x_offset(objs->smiley->width, 20, 0) == );
  // ASSERT(determine_tile_x_offset(objs->smiley->width, 0, 20) == );
}

void test_determine_tile_h(TestObjs *objs)
{
  ASSERT(determine_tile_h(objs->smiley->height, 4, 0) == 2);
  ASSERT(determine_tile_h(objs->smiley->height, 3, 1) == 4);
  // ASSERT(determine_tile_h(objs->smiley->height, 5, 0) ==  );
  // ASSERT(determine_tile_h(objs->smiley->height, 5, 4) ==  );
}

void test_determine_tile_y_offset(TestObjs *objs)
{
  // ASSERT(determine_tile_y_offset(objs->smiley->height, , ) == );
  // ASSERT(determine_tile_y_offset(objs->smiley->height, , ) == );
  // ASSERT(determine_tile_y_offset(objs->smiley->height, , ) == );
  // ASSERT(determine_tile_y_offset(objs->smiley->height, , ) == );
}

void test_copy_tile(TestObjs *objs)
{
  copy_tile(objs->smiley_out, objs->smiley, 0, 0, 2);
  ASSERT(objs->smiley_out->data[0] == objs->smiley->data[0]);
  ASSERT(objs->smiley_out->data[1] == objs->smiley->data[2 * 2]);

  cleanup(objs);
}

void test_get_r(TestObjs *objs)
{
  ASSERT(get_r(0x11223344) == 0x11);
  ASSERT(get_r(0x00000000) == 0);
}

void test_get_g(TestObjs *objs)
{
  ASSERT(get_g(0x11223344) == 0x22);
  ASSERT(get_g(0x00000000) == 0);
}

void test_get_b(TestObjs *objs)
{
  ASSERT(get_b(0x11223344) == 0x33);
  ASSERT(get_b(0x00000000) == 0);
}

void test_get_a(TestObjs *objs)
{
  ASSERT(get_a(0x11223344) == 0x44);
  ASSERT(get_a(0x00000000) == 0);
}

void test_make_pixel(TestObjs *objs)
{
  uint32_t pixel = make_pixel(0x11, 0x22, 0x33, 0x44);
  ASSERT(pixel == 0x11223344);
}

void test_to_grayscale(TestObjs *objs)
{
  uint32_t test_colors[] = {0x000000FF, 0xFF0000FF, 0x00FF00FF, 0x0000FFFF, 0x00FFFFFF, 0xFF00FFFF};
  uint32_t expected_grayscale[] = {0x000000FF, 0x4E4E4EFF, 0x7F7F7FFF, 0x303030FF, 0xB0B0B0FF, 0x7F7F7FFF};

  for (int i = 0; i < sizeof(test_colors) / sizeof(test_colors[0]); i++)
  {
    uint32_t gray_pixel = to_grayscale(test_colors[i]);
    ASSERT(gray_pixel == expected_grayscale[i]);
  }
}

void test_blend_components(TestObjs *objs)
{
  uint32_t overlay_color = objs->overlay->data[0];
  uint32_t smiley_color = objs->smiley->data[0];

  uint32_t blended = blend_colors(overlay_color, smiley_color);
  ASSERT(blended == smiley_color);

  overlay_color = objs->overlay->data[5];
  smiley_color = objs->smiley->data[5];

  blended = blend_colors(overlay_color, smiley_color);
  ASSERT(blended == blend_components(overlay_color, smiley_color, 0));

  cleanup(objs);
}