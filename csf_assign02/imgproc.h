// Header for image processing API functions (imgproc_mirror_h, etc.)
// as well as any helper functions they rely on.

#ifndef IMGPROC_H
#define IMGPROC_H

#include "image.h" // for struct Image and related functions

// Mirror input image horizontally.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
void imgproc_mirror_h( struct Image *input_img, struct Image *output_img );

// Mirror input image vertically.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
void imgproc_mirror_v( struct Image *input_img, struct Image *output_img );

// Transform image by generating a grid of n x n smaller tiles created by
// sampling every n'th pixel from the original image.
//
// Parameters:
//   input_img  - pointer to original struct Image
//   n          - tiling factor (how many rows and columns of tiles to generate)
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
// Returns:
//   1 if successful, or 0 if either
//     - n is less than 1, or
//     - the output can't be generated because at least one tile would
//       be empty (i.e., have 0 width or height)
int imgproc_tile( struct Image *input_img, int n, struct Image *output_img );

// Convert input pixels to grayscale.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
void imgproc_grayscale( struct Image *input_img, struct Image *output_img );

// Overlay a foreground image on a background image, using each foreground
// pixel's alpha value to determine its degree of opacity in order to blend
// it with the corresponding background pixel.
//
// Parameters:
//   base_img - pointer to base (background) image
//   overlay_img - pointer to overlaid (foreground) image
//   output_img - pointer to output Image
//
// Returns:
//   1 if successful, or 0 if the transformation fails because the base
//   and overlay image do not have the same dimensions
int imgproc_composite( struct Image *base_img, struct Image *overlay_img, struct Image *output_img );

// TODO: add prototypes for your helper functions
// Check if all tiles are non-empty.
int all_tiles_nonempty(int width, int height, int n);

// Determine the width of a tile in the output image.
int determine_tile_w(int width, int n, int tile_col);

// Determine the x-offset of a tile in the output image.
int determine_tile_x_offset(int width, int n, int tile_col);

// Determine the height of a tile in the output image.
int determine_tile_h(int height, int n, int tile_row);

// Determine the y-offset of a tile in the output image.
int determine_tile_y_offset(int height, int n, int tile_row);

// Copy a tile from input to output image, downsampling pixels.
void copy_tile(struct Image *out_img, struct Image *img, int tile_row, int tile_col, int n);

// Get the red component from a pixel.
uint32_t get_r(uint32_t pixel);

// Get the green component from a pixel.
uint32_t get_g(uint32_t pixel);

// Get the blue component from a pixel.
uint32_t get_b(uint32_t pixel);

// Get the alpha component from a pixel.
uint32_t get_a(uint32_t pixel);

// Create a pixel from r, g, b, and a components.
uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a);

// Convert a pixel to grayscale.
uint32_t to_grayscale(uint32_t pixel);

// Blend a single color component (red, green, or blue).
uint32_t blend_components(uint32_t fg, uint32_t bg, uint32_t alpha);

// Blend two pixels (foreground and background).
uint32_t blend_colors(uint32_t fg, uint32_t bg);
#endif // IMGPROC_H
