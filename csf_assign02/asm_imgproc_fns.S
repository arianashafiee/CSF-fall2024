/*
 * x86-64 assembly language implementations of functions
 */

    .section .text

/* Offsets of struct Image fields */
#define IMAGE_WIDTH_OFFSET   0
#define IMAGE_HEIGHT_OFFSET  4
#define IMAGE_DATA_OFFSET    8

/*
 * Helper functions for image processing
 */

.global all_tiles_nonempty
all_tiles_nonempty:
    pushq   %rbp
    movq    %rsp, %rbp

    cmpq    $0, %rdx
    jle     .invalid_input_1       # if n <= 0, return 0
    cmpq    $0, %rdi
    jle     .invalid_input_1       # if width <= 0, return 0
    cmpq    $0, %rsi
    jle     .invalid_input_1       # if height <= 0, return 0

    movq    %rdi, %rax             # rax = width
    cqo                             
    idivq   %rdx                   # rax = width / n
    cmpq    $0, %rax
    jle     .invalid_input_1       # if width / n <= 0, return 0

    movq    %rsi, %rax             # rax = height
    cqo                             
    idivq   %rdx                   # rax = height / n
    cmpq    $0, %rax
    jle     .invalid_input_1       # if height / n <= 0, return 0

    movq    $1, %rax
    jmp     .end_1

.invalid_input_1:
    movq    $0, %rax

.end_1:
    popq    %rbp
    ret


.global determine_tile_w
determine_tile_w:
    pushq   %rbp
    movq    %rsp, %rbp

    cmpq    $0, %rsi
    jle     .invalid_input_2
    cmpq    $0, %rdi
    jle     .invalid_input_2
    cmpq    %rsi, %rdx
    jge     .invalid_input_2

    movq    %rdi, %rax
    cqo
    idivq   %rsi

    movq    %rdx, %rcx
    cmpq    %rcx, %rdx
    jl      .add_one_2

    jmp     .end_2

.add_one_2:
    incq    %rax

.end_2:
    popq    %rbp
    ret

.invalid_input_2:
    movq    $0, %rax
    jmp     .end_2


.global determine_tile_x_offset
determine_tile_x_offset:
    pushq   %rbp
    movq    %rsp, %rbp

    cmpq    $0, %rsi
    jle     .invalid_input_3
    cmpq    $0, %rdi
    jle     .invalid_input_3
    cmpq    %rsi, %rdx
    jge     .invalid_input_3

    movq    %rdi, %rax
    cqo
    idivq   %rsi

    movq    %rdx, %rcx

    imulq   %rdx, %rax
    cmpq    %rcx, %rdx
    jl      .add_tile_col_3
    movq    %rcx, %rax
    jmp     .end_3

.add_tile_col_3:
    addq    %rdx, %rax

.end_3:
    popq    %rbp
    ret

.invalid_input_3:
    movq    $0, %rax
    jmp     .end_3


.global get_r
get_r:
    pushq   %rbp
    movq    %rsp, %rbp

    movl    %edi, %eax
    shrl    $24, %eax
    ret

.global get_g
get_g:
    pushq   %rbp
    movq    %rsp, %rbp

    movl    %edi, %eax
    shrl    $16, %eax
    andl    $0xFF, %eax
    ret

.global get_b
get_b:
    pushq   %rbp
    movq    %rsp, %rbp

    movl    %edi, %eax
    shrl    $8, %eax
    andl    $0xFF, %eax
    ret

.global get_a
get_a:
    pushq   %rbp
    movq    %rsp, %rbp

    movl    %edi, %eax
    andl    $0xFF, %eax
    ret


.global make_pixel
make_pixel:
    pushq   %rbp
    movq    %rsp, %rbp

    shlq    $24, %rdi
    shlq    $16, %rsi
    shlq    $8, %rdx

    orq     %rsi, %rdi
    orq     %rdx, %rdi
    orq     %rcx, %rdi

    movq    %rdi, %rax
    popq    %rbp
    ret


.global to_grayscale
to_grayscale:
    pushq   %rbp
    movq    %rsp, %rbp

    call    get_r
    movq    %rax, %rsi        
    call    get_g
    movq    %rax, %rdx         
    call    get_b
    movq    %rax, %rcx         

    movq    $77, %rax          
    imulq   %rsi, %rax         
    movq    $150, %rsi         
    imulq   %rdx, %rsi         
    addq    %rsi, %rax         
    movq    $29, %rsi          
    imulq   %rcx, %rsi         
    addq    %rsi, %rax         

    shrq    $8, %rax           
    popq    %rbp
    ret



/*
 * Mirror horizontally
 */

.globl imgproc_mirror_h
imgproc_mirror_h:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx

    movl    (%rdi), %edx
    movl    4(%rdi), %ecx

    cmpq    $1, %rdx
    jle     .done_mirror_h
    cmpq    $0, %rcx
    jle     .done_mirror_h

    xorq    %rbx, %rbx

.loop_rows_h:
    cmpq    %rbx, %rcx
    jge     .done_mirror_h

    movl    %edx, %r8d
    shrq    $1, %r8d
    xorq    %rax, %rax

.loop_columns_h:
    cmpq    %rax, %r8
    jge     .next_row_h

    movl    %edx, %r9d
    decq    %r9d
    subq    %rax, %r9d

    movl    %edx, %r10d
    imulq   %rbx, %r10d
    addq    %rax, %r10d
    movq    8(%rdi), %r11
    movl    (%r11,%r10,4), %r12d

    movl    %edx, %r13d
    imulq   %rbx, %r13d
    addq    %r9, %r13d
    movl    (%r11,%r13,4), %r14d

    movq    8(%rsi), %r15
    movl    %r14d, (%r15,%r10,4)
    movl    %r12d, (%r15,%r13,4)

    incq    %rax
    jmp     .loop_columns_h

.next_row_h:
    incq    %rbx
    jmp     .loop_rows_h

.done_mirror_h:
    popq    %rbx
    popq    %rbp
    ret


/*
 * Mirror vertically
 */

.globl imgproc_mirror_v
imgproc_mirror_v:
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx

    movl    (%rdi), %edx
    movl    4(%rdi), %ecx

    cmpq    $1, %rcx
    jle     .done_mirror_v
    cmpq    $0, %rdx
    jle     .done_mirror_v

    xorq    %rbx, %rbx

.loop_rows_v:
    cmpq    %rbx, %rcx
    jge     .done_mirror_v

    movl    %ecx, %r8d
    decq    %r8d
    subq    %rbx, %r8d

    xorq    %rax, %rax

.loop_columns_v:
    cmpq    %rax, %rdx
    jge     .next_row_v

    movl    %rdx, %r9d
    imulq   %rbx, %r9d
    addq    %rax, %r9d
    movq    8(%rdi), %r10
    movl    (%r10,%r9,4), %r11d

    movl    %rdx, %r12d
    imulq   %r8d, %r12d
    addq    %rax, %r12d
    movl    (%r10,%r12,4), %r13d

    movq    8(%rsi), %r14
    movl    %r13d, (%r14,%r9,4)
    movl    %r11d, (%r14,%r12,4)

    incq    %rax
    jmp     .loop_columns_v

.next_row_v:
    incq    %rbx
    jmp     .loop_rows_v

.done_mirror_v:
    popq    %rbx
    popq    %rbp
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
    # Prologue - Set up stack frame
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx         # Save callee-saved registers
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

    # Arguments:
    # %rdi - input_img (pointer to struct Image)
    # %rsi - output_img (pointer to struct Image)

    # Load width and height of input image
    movl    (%rdi), %edx            # Load input_img->width into %edx
    movl    4(%rdi), %ecx           # Load input_img->height into %ecx

    # Edge case: if width <= 0 or height <= 0, return early
    cmpq    $0, %rdx
    jle     .done
    cmpq    $0, %rcx
    jle     .done

    # Set up outer loop (y loop - iterating over rows)
    xorq    %rbx, %rbx              # Set y = 0

.outer_loop:
    cmpq    %rbx, %rcx              # Check if y < height
    jge     .done                   # If y >= height, we're done

    # Set up inner loop (x loop - iterating over columns)
    xorq    %rax, %rax              # Set x = 0

.inner_loop:
    cmpq    %rax, %rdx              # Check if x < width
    jge     .next_row               # If x >= width, go to the next row

    # Calculate the index for input_img->data[y * width + x]
    movl    %rdx, %r8d              # r8d = width
    imulq   %rbx, %r8d              # r8d = y * width
    addq    %rax, %r8d              # r8d = y * width + x

    # Load the pixel from input_img->data[y * width + x]
    movq    8(%rdi), %r9            # Load pointer to input_img->data into %r9
    movl    (%r9,%r8,4), %r10d      # Load the pixel into %r10d

    # Call to_grayscale - Convert pixel to grayscale
    # Grayscale formula: gray = (79 * r + 128 * g + 49 * b) / 256

    # Extract the red component (get_r)
    movl    %r10d, %r11d            # Copy pixel to r11d
    shrl    $24, %r11d              # Shift right 24 bits to extract red
    movl    $79, %r12d              # Load 79 (grayscale weight for red)
    imull   %r12d, %r11d            # Multiply red component by 79

    # Extract the green component (get_g)
    movl    %r10d, %r13d            # Copy pixel to r13d
    shrl    $16, %r13d              # Shift right 16 bits to extract green
    andl    $0xFF, %r13d            # Mask to get the green value
    movl    $128, %r12d             # Load 128 (grayscale weight for green)
    imull   %r12d, %r13d            # Multiply green component by 128

    # Extract the blue component (get_b)
    movl    %r10d, %r14d            # Copy pixel to r14d
    shrl    $8, %r14d               # Shift right 8 bits to extract blue
    andl    $0xFF, %r14d            # Mask to get the blue value
    movl    $49, %r12d              # Load 49 (grayscale weight for blue)
    imull   %r12d, %r14d            # Multiply blue component by 49

    # Sum r, g, and b values
    addl    %r11d, %r13d            # r13d = (79 * r) + (128 * g)
    addl    %r14d, %r13d            # r13d = (79 * r) + (128 * g) + (49 * b)
    shrl    $8, %r13d               # Divide by 256 to get the final grayscale value

    # Extract the alpha component (get_a)
    andl    $0xFF, %r10d            # Mask to get the alpha value

    # Make the new grayscale pixel (make_pixel)
    movl    %r13d, %r12d            # Copy grayscale value to r12d
    shll    $8, %r12d               # Shift left 8 bits
    orl     %r13d, %r12d            # Combine the grayscale value for the green
    shll    $8, %r12d               # Shift left 8 bits
    orl     %r13d, %r12d            # Combine the grayscale value for the blue
    shll    $8, %r12d               # Shift left 8 bits
    orl     %r10d, %r12d            # Combine the alpha value

    # Store the grayscale pixel in the output image
    movq    8(%rsi), %r15           # Load pointer to output_img->data into %r15
    movl    %r12d, (%r15,%r8,4)     # Store the grayscale pixel

    # Increment x and continue inner loop
    incq    %rax
    jmp     .inner_loop

.next_row:
    # Increment y and continue outer loop
    incq    %rbx
    jmp     .outer_loop

.done:
    # Epilogue - Restore callee-saved registers and return
    popq    %r15
    popq    %r14
    popq    %r13
    popq    %r12
    popq    %rbx
    popq    %rbp
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
