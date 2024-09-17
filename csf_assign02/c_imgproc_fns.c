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

// Helper function to extract the red component from a pixel
uint32_t get_r(uint32_t pixel) {
    return (pixel >> 24) & 0xFF;
}

// Helper function to extract the green component from a pixel
uint32_t get_g(uint32_t pixel) {
    return (pixel >> 16) & 0xFF;
}

// Helper function to extract the blue component from a pixel
uint32_t get_b(uint32_t pixel) {
    return (pixel >> 8) & 0xFF;
}

// Helper function to extract the alpha component from a pixel
uint32_t get_a(uint32_t pixel) {
    return pixel & 0xFF;
}

// Helper function to make a pixel from RGBA values
uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a) {
    return (r << 24) | (g << 16) | (b << 8) | a;
}

// Helper function to convert a pixel to grayscale
uint32_t to_grayscale(uint32_t pixel) {
    uint32_t r = get_r(pixel);
    uint32_t g = get_g(pixel);
    uint32_t b = get_b(pixel);
    uint32_t a = get_a(pixel);

    // Calculate the gray value using the given formula
    uint32_t gray = (79 * r + 128 * g + 49 * b) / 256;

    // Return the grayscale pixel (same value for R, G, and B; original alpha)
    return make_pixel(gray, gray, gray, a);
}

// Helper function to blend a single color component (r, g, or b)
uint32_t blend_component(uint32_t fg, uint32_t bg, uint32_t alpha) {
    return (alpha * fg + (255 - alpha) * bg) / 255;
}

// Helper function to blend two colors (RGBA format)
uint32_t blend_colors(uint32_t fg_pixel, uint32_t bg_pixel) {
    uint32_t fg_r = get_r(fg_pixel);
    uint32_t fg_g = get_g(fg_pixel);
    uint32_t fg_b = get_b(fg_pixel);
    uint32_t fg_a = get_a(fg_pixel);

    uint32_t bg_r = get_r(bg_pixel);
    uint32_t bg_g = get_g(bg_pixel);
    uint32_t bg_b = get_b(bg_pixel);

    // Blend each color component (R, G, B)
    uint32_t blended_r = blend_component(fg_r, bg_r, fg_a);
    uint32_t blended_g = blend_component(fg_g, bg_g, fg_a);
    uint32_t blended_b = blend_component(fg_b, bg_b, fg_a);

    // The resulting alpha is always 255 (fully opaque)
    return make_pixel(blended_r, blended_g, blended_b, 255);
}


// Mirror input image horizontally.
// This transformation always succeeds.
//
// Parameters:
//   input_img  - pointer to the input Image
//   output_img - pointer to the output Image (in which the transformed
//                pixels should be stored)
// Function to mirror the image horizontally
// Function to mirror the image horizontally
void imgproc_mirror_h(struct Image *input_img, struct Image *output_img) {
    int width = input_img->width;
    int height = input_img->height;

    // Loop through each row
    for (int y = 0; y < height; y++) {
        // Loop through each column
        for (int x = 0; x < width; x++) {
            // Find the pixel on the opposite side horizontally
            int mirrored_x = width - x - 1;
            // Copy pixel from input image to the mirrored position in the output image
            output_img->data[y * width + mirrored_x] = input_img->data[y * width + x];
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
// Function to mirror the image vertically
void imgproc_mirror_v(struct Image *input_img, struct Image *output_img) {
    int width = input_img->width;
    int height = input_img->height;

    // Loop through each row
    for (int y = 0; y < height; y++) {
        // Calculate the mirrored row
        int mirrored_y = height - y - 1;

        // Copy the entire row to the mirrored position in the output image
        for (int x = 0; x < width; x++) {
            output_img->data[mirrored_y * width + x] = input_img->data[y * width + x];
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
// Transform image by generating a grid of n x n smaller tiles created by
// sampling every n'th pixel from the original image.
int imgproc_tile(struct Image *input_img, int n, struct Image *output_img) {
    // Check if n is valid
    if (n < 1) {
        return 0; // Invalid tiling factor
    }

    int width = input_img->width;
    int height = input_img->height;

    // Check if the output would contain empty tiles
    if (width / n == 0 || height / n == 0) {
        return 0; // Output can't be generated because tiles would be empty
    }

    // Calculate the size of the tiles
    int tile_width = width / n;
    int tile_height = height / n;

    // Loop through each tile (row-major order)
    for (int tile_row = 0; tile_row < n; tile_row++) {
        for (int tile_col = 0; tile_col < n; tile_col++) {
            // Calculate where the top-left corner of this tile comes from in the original image
            int src_x = tile_col * tile_width;
            int src_y = tile_row * tile_height;

            // Loop over the pixels in this tile and copy them to the corresponding place in the output image
            for (int y = 0; y < tile_height; y++) {
                for (int x = 0; x < tile_width; x++) {
                    // Calculate the source pixel index in the input image
                    int src_idx = (src_y + y) * width + (src_x + x);

                    // Calculate the destination pixel index in the output image
                    int dest_x = tile_col * tile_width + x;
                    int dest_y = tile_row * tile_height + y;
                    int dest_idx = dest_y * width + dest_x;

                    // Copy the pixel from input to output
                    output_img->data[dest_idx] = input_img->data[src_idx];
                }
            }
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
    int width = input_img->width;
    int height = input_img->height;

    // Loop through each pixel in the input image
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int idx = y * width + x;

            // Convert the pixel to grayscale
            output_img->data[idx] = to_grayscale(input_img->data[idx]);
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
// Overlay a foreground image on a background image using alpha blending
int imgproc_composite(struct Image *base_img, struct Image *overlay_img, struct Image *output_img) {
    // Check if the dimensions of both images match
    if (base_img->width != overlay_img->width || base_img->height != overlay_img->height) {
        return 0; // Fail if dimensions don't match
    }

    int width = base_img->width;
    int height = base_img->height;

    // Loop through each pixel
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int idx = y * width + x;

            // Blend the foreground and background pixels
            output_img->data[idx] = blend_colors(overlay_img->data[idx], base_img->data[idx]);
        }
    }

    return 1; // Success
}
