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

// Helper function to get the red component from a pixel
uint32_t get_r(uint32_t pixel) {
    return (pixel >> 24) & 0xFF;
}

// Helper function to get the green component from a pixel
uint32_t get_g(uint32_t pixel) {
    return (pixel >> 16) & 0xFF;
}

// Helper function to get the blue component from a pixel
uint32_t get_b(uint32_t pixel) {
    return (pixel >> 8) & 0xFF;
}

// Helper function to get the alpha component from a pixel
uint32_t get_a(uint32_t pixel) {
    return pixel & 0xFF;
}

// Helper function to create a pixel from r, g, b, and a components
uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a) {
    return (r << 24) | (g << 16) | (b << 8) | a;
}

// Helper function to convert a pixel to grayscale
uint32_t to_grayscale(uint32_t pixel) {
    uint32_t r = get_r(pixel);
    uint32_t g = get_g(pixel);
    uint32_t b = get_b(pixel);
    uint32_t a = get_a(pixel); // Preserve the alpha value

    // Compute the grayscale value using the formula
    uint32_t y = (79 * r + 128 * g + 49 * b) / 256;

    // Create the grayscale pixel with the same alpha
    return make_pixel(y, y, y, a);
}

// Helper function to blend a single color component (red, green, or blue)
uint32_t blend_components(uint32_t fg, uint32_t bg, uint32_t alpha) {
    return (alpha * fg + (255 - alpha) * bg) / 255;
}

// Helper function to blend two pixels (foreground and background).
uint32_t blend_colors(uint32_t fg, uint32_t bg) {
    // Extract the red, green, blue, and alpha components from both pixels
    uint32_t fg_r = (fg >> 24) & 0xFF;
    uint32_t fg_g = (fg >> 16) & 0xFF;
    uint32_t fg_b = (fg >> 8) & 0xFF;
    uint32_t fg_a = fg & 0xFF;

    uint32_t bg_r = (bg >> 24) & 0xFF;
    uint32_t bg_g = (bg >> 16) & 0xFF;
    uint32_t bg_b = (bg >> 8) & 0xFF;

    // Blend each color component using the foreground alpha value
    uint32_t blended_r = blend_components(fg_r, bg_r, fg_a);
    uint32_t blended_g = blend_components(fg_g, bg_g, fg_a);
    uint32_t blended_b = blend_components(fg_b, bg_b, fg_a);

    // Return the blended pixel with alpha set to 255 (fully opaque)
    return (blended_r << 24) | (blended_g << 16) | (blended_b << 8) | 0xFF;
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