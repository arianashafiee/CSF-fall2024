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

  // New fields for expected and actual images loaded from PNG files
  struct Image *expected_img;
  struct Image *actual_img;
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
void compare_images_pixel_by_pixel(TestObjs *objs );

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

    // Load the expected image from a PNG file (from a folder)
    const char *expected_img_path = "expected/ingo_tile_3.png";
    objs->expected_img = (struct Image *)malloc(sizeof(struct Image));
    if (img_read(expected_img_path, objs->expected_img) != IMG_SUCCESS) {
        fprintf(stderr, "Error: Couldn't read the expected image from %s\n", expected_img_path);
        free(objs->expected_img);
        free(objs);
        return NULL;
    }

    // Load the actual image from a PNG file (from a folder)
    const char *actual_img_path = "actual/c_ingo_tile_3.png";
    objs->actual_img = (struct Image *)malloc(sizeof(struct Image));
    if (img_read(actual_img_path, objs->actual_img) != IMG_SUCCESS) {
        fprintf(stderr, "Error: Couldn't read the actual image from %s\n", actual_img_path);
        free(objs->actual_img);
        free(objs->expected_img);
        free(objs);
        return NULL;
    }

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

void compare_images_pixel_by_pixel(TestObjs *objs) {
    struct Image *expected_img = objs->expected_img;
    struct Image *actual_img = objs->actual_img;

    // Ensure the images have the same dimensions
    if (expected_img->width != actual_img->width || expected_img->height != actual_img->height) {
        printf("Error: Images have different dimensions\n");
        printf("Expected Image: %dx%d, Actual Image: %dx%d\n",
               expected_img->width, expected_img->height, actual_img->width, actual_img->height);
        return;
    }

    int width = expected_img->width;
    int height = expected_img->height;

    // Iterate through each pixel and compare
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            uint32_t expected_pixel = expected_img->data[y * width + x];
            uint32_t actual_pixel = actual_img->data[y * width + x];

            if (expected_pixel != actual_pixel) {
                printf("Mismatch at pixel (%d, %d):\n", x, y);
                printf("Expected color: %08X\n", expected_pixel);
                printf("Actual color:   %08X\n", actual_pixel);
                return; // Exit after first mismatch
            }
        }
    }

    // If no mismatches found
    printf("Images are identical!\n");
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



