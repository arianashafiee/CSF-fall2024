Ariana Shafiee and Eric Guan
Interesting Implementation details:

The copy_tile function carefully selects pixels from the input image and places them into the output image based on calculated tile offsets and dimensions. It skips copying if a pixel lies outside image boundaries, preventing out-of-bounds errors.
This function enables efficient downsampling of pixels for tiled images, ensuring that the output grid is uniformly sampled from the original image.

Functions like all_tiles_nonempty, determine_tile_w, and determine_tile_h carefully ensure that tiles in the output image are not empty by calculating tile sizes and offsets. They handle edge cases where tile dimensions are invalid or zero, ensuring robust tiling.

Ariana Shafiee:
void imgproc_mirror_h(struct Image *input_img, struct Image *output_img);
void imgproc_mirror_v(struct Image *input_img, struct Image *output_img);
int imgproc_tile(struct Image *input_img, int n, struct Image *output_img);
void imgproc_grayscale(struct Image *input_img, struct Image *output_img);
int imgproc_composite(struct Image *base_img, struct Image *overlay_img, struct Image *output_img);
int all_tiles_nonempty(int width, int height, int n);
int determine_tile_w(int width, int n, int tile_col);
int determine_tile_x_offset(int width, int n, int tile_col);
int determine_tile_h(int height, int n, int tile_row);
int determine_tile_y_offset(int height, int n, int tile_row);
void copy_tile(struct Image *out_img, struct Image *img, int tile_row, int tile_col, int n);
uint32_t get_r(uint32_t pixel);
uint32_t get_g(uint32_t pixel);
uint32_t get_b(uint32_t pixel);
uint32_t get_a(uint32_t pixel);
uint32_t make_pixel(uint32_t r, uint32_t g, uint32_t b, uint32_t a);
uint32_t to_grayscale(uint32_t pixel);
uint32_t blend_components(uint32_t fg, uint32_t bg, uint32_t alpha);
uint32_t blend_colors(uint32_t fg, uint32_t bg);
test_tile_basic(TestObjs *objs)
test_grayscale_basic(TestObjs *objs)
test_composite_basic(TestObjs *objs)
test_all_tiles_nonempty(TestObjs *objs)
test_determine_tile_w(TestObjs *objs)
test_determine_tile_x_offset(TestObjs *objs)
test_determine_tile_h(TestObjs *objs)
test_determine_tile_y_offset(TestObjs *objs)
test_copy_tile(TestObjs *objs)
test_get_r(TestObjs *objs)
test_get_g(TestObjs *objs)
test_get_b(TestObjs *objs)
test_get_a(TestObjs *objs)
test_make_pixel(TestObjs *objs)
test_to_grayscale(TestObjs *objs)
test_blend_components(TestObjs *objs)
test_blend_colors(TestObjs *objs)

Eric Guan: 
test_tile_basic(TestObjs *objs)
test_grayscale_basic(TestObjs *objs)
test_composite_basic(TestObjs *objs)
test_all_tiles_nonempty(TestObjs *objs)
test_determine_tile_w(TestObjs *objs)
test_determine_tile_x_offset(TestObjs *objs)
test_determine_tile_h(TestObjs *objs)
test_determine_tile_y_offset(TestObjs *objs)
test_copy_tile(TestObjs *objs)
test_get_r(TestObjs *objs)
test_get_g(TestObjs *objs)
test_get_b(TestObjs *objs)
test_get_a(TestObjs *objs)
test_make_pixel(TestObjs *objs)
test_to_grayscale(TestObjs *objs)
test_blend_components(TestObjs *objs)
test_blend_colors(TestObjs *objs)


