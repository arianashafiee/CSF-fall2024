#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "imgproc.h"

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
            int sample_x = (x * n + tile_x_offset) % img->width;
            int sample_y = (y * n + tile_y_offset) % img->height;

            // Get the pixel from the input image
            uint32_t pixel = img->data[sample_y * img->width + sample_x];

            // Place the sampled pixel in the corresponding location in the output image
            out_img->data[(tile_y_offset + y) * out_img->width + (tile_x_offset + x)] = pixel;
        }
    }
}

// Convert input pixels to grayscale
void imgproc_grayscale(struct Image *input_img, struct Image *output_img) {
    int32_t width = input_img->width;
    int32_t height = input_img->height;

    // Iterate over each pixel in the image
    for (int32_t y = 0; y < height; y++) {
        for (int32_t x = 0; x < width; x++) {
            // Get the current pixel from the input image
            uint32_t pixel = input_img->data[y * width + x];

            // Convert the pixel to grayscale
            uint32_t gray_pixel = to_grayscale(pixel);

            // Store the grayscale pixel in the output image
            output_img->data[y * width + x] = gray_pixel;
        }
    }
}

// Composite function for blending images
int imgproc_composite(struct Image *base_img, struct Image *overlay_img, struct Image *output_img) {
    // Check if the base and overlay images have the same dimensions
    if (base_img->width != overlay_img->width || base_img->height != overlay_img->height) {
        return 0; // Failure: Dimensions don't match
    }

    // Set the output image dimensions
    output_img->width = base_img->width;
    output_img->height = base_img->height;

    // Iterate over each pixel
    for (int y = 0; y < base_img->height; y++) {
        for (int x = 0; x < base_img->width; x++) {
            // Get the index of the current pixel
            int idx = y * base_img->width + x;

            // Get the foreground (overlay) and background (base) pixels
            uint32_t fg_pixel = overlay_img->data[idx];
            uint32_t bg_pixel = base_img->data[idx];

            // Blend the pixels and store the result in the output image
            output_img->data[idx] = blend_colors(fg_pixel, bg_pixel);
        }
    }

    return 1; // Success
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
void imgproc_grayscale(struct Image *input_img, struct Image *output_img) {
    // Ensure the output image has the same dimensions as the input image
    int32_t width = input_img->width;
    int32_t height = input_img->height;
    
    // Iterate over each pixel in the image
    for (int32_t y = 0; y < height; y++) {
        for (int32_t x = 0; x < width; x++) {
            // Get the current pixel from the input image
            uint32_t pixel = input_img->data[y * width + x];
            
            // Convert the pixel to grayscale
            uint32_t gray_pixel = to_grayscale(pixel);
            
            // Store the grayscale pixel in the output image
            output_img->data[y * width + x] = gray_pixel;
        }
    }
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
int imgproc_composite(struct Image *base_img, struct Image *overlay_img, struct Image *output_img) {
    // Check if the base and overlay images have the same dimensions
    if (base_img->width != overlay_img->width || base_img->height != overlay_img->height) {
        return 0; // Failure: Dimensions don't match
    }

    // Set the output image dimensions
    output_img->width = base_img->width;
    output_img->height = base_img->height;

    // Iterate over each pixel
    for (int y = 0; y < base_img->height; y++) {
        for (int x = 0; x < base_img->width; x++) {
            // Get the index of the current pixel
            int idx = y * base_img->width + x;

            // Get the foreground (overlay) and background (base) pixels
            uint32_t fg_pixel = overlay_img->data[idx];
            uint32_t bg_pixel = base_img->data[idx];

            // Blend the pixels and store the result in the output image
            output_img->data[idx] = blend_colors(fg_pixel, bg_pixel);
        }
    }

    return 1; // Success
}