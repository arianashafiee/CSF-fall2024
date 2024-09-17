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
