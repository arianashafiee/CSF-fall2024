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

// Check if all tiles are non-empty based on the dimensions of the image
// and the tiling factor.
//
// Parameters:
//   width  - width of the input image
//   height - height of the input image
//   n      - tiling factor (number of rows and columns of tiles)
//
// Returns:
//   1 if all tiles are non-empty (have positive width and height), 0 otherwise.
int all_tiles_nonempty(int width, int height, int n);

// Determine the width of a tile in the output image based on the image width,
// tiling factor, and column index.
//
// Parameters:
//   width     - width of the input image
//   n         - tiling factor (number of columns of tiles)
//   tile_col  - index of the tile column being processed
//
// Returns:
//   The width of the tile, accounting for any remainder when dividing the
//   image width by the tiling factor.
int determine_tile_w(int width, int n, int tile_col);

// Determine the x-offset of a tile in the output image based on the image width,
// tiling factor, and column index.
//
// Parameters:
//   width     - width of the input image
//   n         - tiling factor (number of columns of tiles)
//   tile_col  - index of the tile column being processed
//
// Returns:
//   The x-offset for the tile in the output image, accounting for any
//   remainder when dividing the image width by the tiling factor.
int determine_tile_x_offset(int width, int n, int tile_col);

// Determine the height of a tile in the output image based on the image height,
// tiling factor, and row index.
//
// Parameters:
//   height    - height of the input image
//   n         - tiling factor (number of rows of tiles)
//   tile_row  - index of the tile row being processed
//
// Returns:
//   The height of the tile, accounting for any remainder when dividing the
//   image height by the tiling factor.
int determine_tile_h(int height, int n, int tile_row);

// Determine the y-offset of a tile in the output image based on the image height,
// tiling factor, and row index.
//
// Parameters:
//   height    - height of the input image
//   n         - tiling factor (number of rows of tiles)
//   tile_row  - index of the tile row being processed
//
// Returns:
//   The y-offset for the tile in the output image, accounting for any
//   remainder when dividing the image height by the tiling factor.
int determine_tile_y_offset(int height, int n, int tile_row);

// Copy a tile from the input image to the output image, downsampling pixels
// based on the tiling factor.
//
// Parameters:
//   out_img   - pointer to the output Image (in which the tile should be copied)
//   img       - pointer to the input Image (from which the tile should be copied)
//   tile_row  - index of the tile row being processed
//   tile_col  - index of the tile column being processed
//   n         - tiling factor (how many rows and columns of tiles to generate)
//
// This function copies a tile from the input image, sampling every n'th pixel.
void copy_tile(struct Image *out_img, struct Image *img, int tile_row, int tile_col, int n);

// Extract the red component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The red component (0-255) of the pixel.
uint32_t get_r(uint32_t pixel);

// Extract the green component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The green component (0-255) of the pixel.
uint32_t get_g(uint32_t pixel);

// Extract the blue component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The blue component (0-255) of the pixel.
uint32_t get_b(uint32_t pixel);

// Extract the alpha component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The alpha component (0-255) of the pixel.
uint32_t get_a(uint32_t pixel);

// Create a pixel from the red, green, blue, and alpha components.
//
// Parameters:
//   r - red component (0-255)
//   g - green component (0-255)
//   b - blue component (0-255)
//   a - alpha component (0-255)
//
// Returns:
//   A 32-bit pixel in RGBA format.
uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a);

// Convert a pixel to grayscale by computing the weighted average
// of the red, green, and blue components.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   A grayscale 32-bit pixel with the same alpha value as the input pixel.
uint32_t to_grayscale(uint32_t pixel);

// Blend two color components (red, green, or blue) based on the alpha value
// of the foreground pixel.
//
// Parameters:
//   fg    - foreground color component (0-255)
//   bg    - background color component (0-255)
//   alpha - alpha value (0-255) of the foreground pixel
//
// Returns:
//   The blended color component value.
uint32_t blend_components(uint32_t fg, uint32_t bg, uint32_t alpha);

// Blend two pixels (foreground and background) using the alpha value
// of the foreground pixel.
//
// Parameters:
//   fg - 32-bit foreground pixel in RGBA format
//   bg - 32-bit background pixel in RGBA format
//
// Returns:
//   The blended 32-bit pixel in RGBA format, with alpha set to 255 (fully opaque).
uint32_t blend_colors(uint32_t fg, uint32_t bg);

extern int all_tiles_nonempty(int width, int height, int n);
extern int determine_tile_w(int width, int n, int tile_col);
extern int determine_tile_x_offset(int width, int n, int tile_col);
extern int determine_tile_h(int height, int n, int tile_row);
extern int determine_tile_y_offset(int height, int n, int tile_row);
extern void copy_tile(struct Image *out_img, struct Image *img, int tile_row, int tile_col, int n);

extern uint32_t get_r(uint32_t pixel);
extern uint32_t get_g(uint32_t pixel);
extern uint32_t get_b(uint32_t pixel);
extern uint32_t get_a(uint32_t pixel);
extern uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a);
extern uint32_t to_grayscale(uint32_t pixel);

/* API functions implemented in assembly */
extern void imgproc_mirror_h(struct Image *input_img, struct Image *output_img);
extern void imgproc_mirror_v(struct Image *input_img, struct Image *output_img);
extern int imgproc_tile(struct Image *input_img, int n, struct Image *output_img);
extern void imgproc_grayscale(struct Image *input_img, struct Image *output_img);
extern int imgproc_composite(struct Image *base_img, struct Image *overlay_img, struct Image *output_img);

#endif // IMGPROC_H 