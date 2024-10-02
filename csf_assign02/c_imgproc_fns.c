// C implementations of image processing functions

#include <stdlib.h>
#include <assert.h>
#include "imgproc.h"

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
int all_tiles_nonempty(int width, int height, int n) {
    if (n <= 0 || width <= 0 || height <= 0) {
        return 0;  // Handle invalid input such as zero or negative dimensions.
    }
    return (width / n > 0) && (height / n > 0);
}

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
int determine_tile_w(int width, int n, int tile_col) {
    if (n <= 0 || width <= 0 || tile_col < 0 || tile_col >= n) {
        return 0;  // Invalid cases
    }
    int base_tile_w = width / n;
    int remainder = width % n;
    return base_tile_w + (tile_col < remainder ? 1 : 0);
}

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
int determine_tile_x_offset(int width, int n, int tile_col) {
    if (n <= 0 || width <= 0 || tile_col < 0 || tile_col >= n) {
        return 0;  // Invalid cases
    }
    int base_tile_w = width / n;
    int remainder = width % n;
    return tile_col * base_tile_w + (tile_col < remainder ? tile_col : remainder);
}

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
int determine_tile_h(int height, int n, int tile_row) {
    if (n <= 0 || height <= 0 || tile_row < 0 || tile_row >= n) {
        return 0;  // Invalid cases
    }
    int base_tile_h = height / n;
    int remainder = height % n;
    return base_tile_h + (tile_row < remainder ? 1 : 0);
}

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
int determine_tile_y_offset(int height, int n, int tile_row) {
    if (n <= 0 || height <= 0 || tile_row < 0 || tile_row >= n) {
        return 0;  // Invalid cases
    }
    int base_tile_h = height / n;
    int remainder = height % n;
    return tile_row * base_tile_h + (tile_row < remainder ? tile_row : remainder);
}

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
void copy_tile(struct Image *out_img, struct Image *img, int tile_row, int tile_col, int n) {
    if (n <= 0 || img->width <= 0 || img->height <= 0) {
        return;  // Invalid case, no operation
    }

    int tile_w = determine_tile_w(img->width, n, tile_col);
    int tile_h = determine_tile_h(img->height, n, tile_row);
    int tile_x_offset = determine_tile_x_offset(img->width, n, tile_col);
    int tile_y_offset = determine_tile_y_offset(img->height, n, tile_row);

    for (int y = 0; y < tile_h; y++) {
        for (int x = 0; x < tile_w; x++) {
            // Handle edge case: Ensure coordinates don't exceed image boundaries.
            if (tile_y_offset + y >= img->height || tile_x_offset + x >= img->width) {
                continue;
            }
            int sample_x = x * n;
            int sample_y = y * n;
            uint32_t pixel = img->data[sample_y * img->width + sample_x];
            out_img->data[(tile_y_offset + y) * out_img->width + (tile_x_offset + x)] = pixel;
        }
    }
}


// Extract the red component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The red component (0-255) of the pixel.
uint32_t get_r(uint32_t pixel) {
    return (pixel >> 24) & 0xFF;
}

// Extract the green component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The green component (0-255) of the pixel.
uint32_t get_g(uint32_t pixel) {
    return (pixel >> 16) & 0xFF;
}

// Extract the blue component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The blue component (0-255) of the pixel.
uint32_t get_b(uint32_t pixel) {
    return (pixel >> 8) & 0xFF;
}

// Extract the alpha component from a pixel.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   The alpha component (0-255) of the pixel.
uint32_t get_a(uint32_t pixel) {
    return pixel & 0xFF;
}

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
uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a) {
    return (r << 24) | (g << 16) | (b << 8) | a;
}

// Convert a pixel to grayscale by computing the weighted average
// of the red, green, and blue components.
//
// Parameters:
//   pixel - 32-bit pixel in RGBA format
//
// Returns:
//   A grayscale 32-bit pixel with the same alpha value as the input pixel.
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
uint32_t blend_components(uint32_t fg, uint32_t bg, uint32_t alpha) {
    return (alpha * fg + (255 - alpha) * bg) / 255;
}

// Blend two pixels (foreground and background) using the alpha value
// of the foreground pixel.
//
// Parameters:
//   fg - 32-bit foreground pixel in RGBA format
//   bg - 32-bit background pixel in RGBA format
//
// Returns:
//   The blended 32-bit pixel in RGBA format, with alpha set to 255 (fully opaque).
uint32_t blend_colors(uint32_t fg, uint32_t bg) {
    // Extract the red, green, blue, and alpha components from both pixels
    uint32_t fg_r = (fg >> 24); // & 0xFF;
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
void imgproc_mirror_h(struct Image *input_img, struct Image *output_img) {
    // Ensure the output image has the same dimensions as the input image
    int32_t width = input_img->width;
    int32_t height = input_img->height;

    // Edge case: Empty image or single-column image
    if (width <= 1 || height <= 0) return;

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

    // Edge case: Empty image or single-row image
    if (width <= 0 || height <= 1) return;

    // Iterate over each row (only up to middle of image)
    for (int32_t y = 0; y < height / 2; y++) {
        // Calculate the position of the mirrored pixel
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
    if (n < 1 || input_img->width <= 0 || input_img->height <= 0) return 0;

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

    // Edge case: Empty image
    if (width <= 0 || height <= 0) return;

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

    if (base_img->width <= 0 || base_img->height <= 0) return 1;  // No operation

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