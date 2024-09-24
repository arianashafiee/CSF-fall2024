/*
 * x86-64 assembly language implementations of functions
 */

	.section .text

/* Offsets of struct Image fields */
#define IMAGE_WIDTH_OFFSET   0
#define IMAGE_HEIGHT_OFFSET  4
#define IMAGE_DATA_OFFSET    8

/*
 * TODO: define your helper functions here.
 * Don't forget to use the .globl directive to make
 * them visible to the test code.
 */

/*
 * Implementations of API functions
 */

/*
 * void imgproc_mirror_h( struct Image *input_img, struct Image *output_img );
 *
 * Transform image by mirroring its pixels horizontally.
 * This transformation always succeeds.
 *
 * Parameters:
 *   %rdi - pointer to original struct Image
 *   %rsi - pointer to output struct Image
 */
	.globl imgproc_mirror_h
imgproc_mirror_h:
    pushq %rbp
    movq %rsp, %rbp

    movq 8(%rdi), %r8  # input_img->data
    movq 8(%rsi), %r9  # output_img->data
    movl (%rdi), %r10d # input_img->width
    movl 4(%rdi), %r11d # input_img->height

    xorq %r12, %r12    # r12 = y (row index)

mirror_h_outer_loop:
    cmpq %r12, %r11    # if y >= height, exit
    jge mirror_h_done

    xorq %r13, %r13    # r13 = x (column index)

mirror_h_inner_loop:
    cmpq %r13, %r10    # if x >= width / 2, next row
    jge mirror_h_next_row

    # Calculate indices for the swap
    movq %r13, %rax    # rax = x
    movq %r10, %rbx    # rbx = width - 1 - x
    subq %r13, %rbx

    # Swap pixels
    movl (%r8, %rax, 4), %eax
    movl (%r8, %rbx, 4), %edx
    movl %edx, (%r9, %rax, 4)
    movl %eax, (%r9, %rbx, 4)

    incq %r13          # x++
    jmp mirror_h_inner_loop

mirror_h_next_row:
    incq %r12          # y++
    jmp mirror_h_outer_loop

mirror_h_done:
    popq %rbp
    ret


/*
 * void imgproc_mirror_v( struct Image *input_img, struct Image *output_img );
 *
 * Transform image by mirroring its pixels vertically.
 * This transformation always succeeds.
 *
 * Parameters:
 *   %rdi - pointer to original struct Image
 *   %rsi - pointer to output struct Image
 */
	.globl imgproc_mirror_v
imgproc_mirror_v:
    pushq %rbp
    movq %rsp, %rbp

    movq 8(%rdi), %r8  # input_img->data
    movq 8(%rsi), %r9  # output_img->data
    movl (%rdi), %r10d # input_img->width
    movl 4(%rdi), %r11d # input_img->height

    xorq %r12, %r12    # r12 = y (row index)

mirror_v_outer_loop:
    cmpq %r12, %r11    # if y >= height / 2, exit
    jge mirror_v_done

    movq %r11, %rax    # rax = height - 1 - y
    subq %r12, %rax

mirror_v_inner_loop:
    xorq %r13, %r13    # r13 = x (column index)
    cmpq %r13, %r10    # if x >= width, next row
    jge mirror_v_next_row

    # Swap pixels
    movl (%r8, %r12, 4), %eax
    movl (%r8, %rax, 4), %edx
    movl %edx, (%r9, %r12, 4)
    movl %eax, (%r9, %rax, 4)

mirror_v_next_row:
    incq %r12          # y++
    jmp mirror_v_inner_loop

mirror_v_done:
    popq %rbp
    ret


/*
 * int imgproc_tile( struct Image *input_img, int n, struct Image *output_img );
 *
 * Transform image by generating a grid of n x n smaller tiles created by
 * sampling every n'th pixel from the original image.
 *
 * Parameters:
 *   %rdi - pointer to original struct Image
 *   %esi - tiling factor (how many rows and columns of tiles to generate)
 *   %rdx - pointer to the output Image (in which the transformed
 *          pixels should be stored)
 *
 * Returns (in %eax):
 *   1 if successful, or 0 if either
 *     - n is less than 1, or
 *     - the output can't be generated because at least one tile would
 *       be empty (i.e., have 0 width or height)
 */
	.globl imgproc_tile
imgproc_tile:
	/* TODO: implement (this stub implementation just returns 0) */
	xorl %eax, %eax
	ret

/*
 * void imgproc_grayscale( struct Image *input_img, struct Image *output_img );
 *
 * Transform image by converting each pixel to grayscale.
 * This transformation always succeeds.
 *
 * Parameters:
 *   %rdi - pointer to original struct Image
 *   %rsi - pointer to output struct Image
 */
	.globl imgproc_grayscale
imgproc_grayscale:
    pushq %rbp
    movq %rsp, %rbp

    movq 8(%rdi), %r8  # input_img->data
    movq 8(%rsi), %r9  # output_img->data
    movl (%rdi), %r10d # input_img->width
    movl 4(%rdi), %r11d # input_img->height

    xorq %r12, %r12    # r12 = y (row index)

grayscale_outer_loop:
    cmpq %r12, %r11    # if y >= height, exit
    jge grayscale_done

    xorq %r13, %r13    # r13 = x (column index)

grayscale_inner_loop:
    cmpq %r13, %r10    # if x >= width, next row
    jge grayscale_next_row

    # Get pixel at current index
    movl (%r8, %r13, 4), %eax

    # Extract components (r = %al, g = %ah, b = byte in %rax[16:24])
    shrq $24, %eax     # Get red
    andl $0xFF, %eax   # Red
    addl %eax

grayscale_done:
    popq %rbp
    ret

/*
 * int imgproc_composite( struct Image *base_img, struct Image *overlay_img );
 *
 * Overlay a foreground image on a background image, using each foreground
 * pixel's alpha value to determine its degree of opacity in order to blend
 * it with the corresponding background pixel.
 *
 * Parameters:
 *   %rdi - pointer to base (background) image
 *   %rsi - pointer to overlaid (foreground) image
 *   %rdx - pointer to output Image
 *
 * Returns:
 *   1 if successful, or 0 if the transformation fails because the base
 *   and overlay image do not have the same dimensions
 */
	.globl imgproc_composite
imgproc_composite:
	/* TODO: implement (this stub implementation just returns 0) */
	xorl %eax, %eax
	ret

/*
vim:ft=gas:
*/
