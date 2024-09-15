// C implementations of image processing functions

#include <stdlib.h>
#include <assert.h>
#include "imgproc.h"

// TODO: define your helper functions here
// Helper function to check if all tiles are non-empty
int all_tiles_nonempty(int width, int height, int n) {
    return (width / n > 0) && (height / n > 0);
}

// Helper function to determine the width of a tile in the output image
int determine_tile_w(int width, int n, int tile_col) {
    int base_tile_w = width / n;
    int remainder = width % n;
    return base_tile_w + (tile_col < remainder ? 1 : 0);
}

// Helper function to determine the x-offset of a tile in the output image
int determine_tile_x_offset(int width, int n, int tile_col) {
    int base_tile_w = width / n;
    int remainder = width % n;
    return tile_col * base_tile_w + (tile_col < remainder ? tile_col : remainder);
}

// Helper function to determine the height of a tile in the output image
int determine_tile_h(int height, int n, int tile_row) {
    int base_tile_h = height / n;
    int remainder = height % n;
    return base_tile_h + (tile_row < remainder ? 1 : 0);
}

// Helper function to determine the y-offset of a tile in the output image
int determine_tile_y_offset(int height, int n, int tile_row) {
    int base_tile_h = height / n;
    int remainder = height % n;
    return tile_row * base_tile_h + (tile_row < remainder ? tile_row : remainder);
}

// Helper function to copy a tile from input to output image, downsampling pixels
void copy_tile(struct Image *out_img, struct Image *img, int tile_row, int tile_col, int n) {
    int tile_w = determine_tile_w(img->width, n, tile_col);
    int tile_h = determine_tile_h(img->height, n, tile_row);
    int tile_x_offset = determine_tile_x_offset(img->width, n, tile_col);
    int tile_y_offset = determine_tile_y_offset(img->height, n, tile_row);

    for (int y = 0; y < tile_h; y++) {
        for (int x = 0; x < tile_w; x++) {
            // Sample pixel from input image by skipping every n-th pixel
            int sample_x = x * n;
            int sample_y = y * n;
            uint32_t pixel = img->data[sample_y * img->width + sample_x];

            // Place the sampled pixel in the corresponding location in the output image
            out_img->data[(tile_y_offset + y) * out_img->width + (tile_x_offset + x)] = pixel;
        }
    }
}

// Mirror input image horizontally.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
// Function to mirror the image horizontally
void imgproc_mirror_h(struct Image *input_img, struct Image *output_img) {
    // Ensure the output image has the same dimensions as the input image
    int32_t width = input_img->width;
    int32_t height = input_img->height;
    
    // Iterate over each row
    for (int32_t y = 0; y < height; y++) {
        // Iterate over each column (only up to the middle of the image)
        for (int32_t x = 0; x < width / 2; x++) {
            // Calculate the position of the mirrored pixel
            int32_t mirrored_x = width - 1 - x;
            
            // Get the pixels from both sides
            uint32_t left_pixel = input_img->data[y * width + x];
            uint32_t right_pixel = input_img->data[y * width + mirrored_x];
            
            // Swap the pixels
            output_img->data[y * width + x] = right_pixel;
            output_img->data[y * width + mirrored_x] = left_pixel;
        }
    }
}

// Mirror input image vertically.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
void imgproc_mirror_v(struct Image *input_img, struct Image *output_img) {
    // Ensure the output image has the same dimensions as the input image
    int32_t width = input_img->width;
    int32_t height = input_img->height;
    
    // Iterate over each column
    for (int32_t y = 0; y < height / 2; y++) {
        // Calculate the position of the mirrored row
        int32_t mirrored_y = height - 1 - y;
        
        // Swap pixels in each column between the current row and the mirrored row
        for (int32_t x = 0; x < width; x++) {
            // Get the pixels from both rows
            uint32_t top_pixel = input_img->data[y * width + x];
            uint32_t bottom_pixel = input_img->data[mirrored_y * width + x];
            
            // Swap the pixels
            output_img->data[y * width + x] = bottom_pixel;
            output_img->data[mirrored_y * width + x] = top_pixel;
        }
    }
}

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
int imgproc_tile(struct Image *input_img, int n, struct Image *output_img) {
    // Validate the tiling factor
    if (n < 1) return 0;

    // Ensure all tiles will be non-empty
    if (!all_tiles_nonempty(input_img->width, input_img->height, n)) return 0;

    // Iterate through each tile (row and column)
    for (int tile_row = 0; tile_row < n; tile_row++) {
        for (int tile_col = 0; tile_col < n; tile_col++) {
            // Copy the corresponding tile from the input image to the output image
            copy_tile(output_img, input_img, tile_row, tile_col, n);
        }
    }

    return 1; // Success
}

// Convert input pixels to grayscale.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
void imgproc_grayscale( struct Image *input_img, struct Image *output_img ) {
  // TODO: implement
}

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
int imgproc_composite( struct Image *base_img, struct Image *overlay_img, struct Image *output_img ) {
  // TODO: implement
  return 0;
}
