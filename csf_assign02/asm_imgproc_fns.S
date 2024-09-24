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

.globl all_tiles_nonempty
all_tiles_nonempty:
    movl %edi, %eax         # width -> eax
    testl %eax, %eax        # check if width <= 0
    jle .return_zero

    movl %esi, %eax         # height -> eax
    testl %eax, %eax        # check if height <= 0
    jle .return_zero

    movl %edx, %eax         # n -> eax
    testl %eax, %eax        # check if n <= 0
    jle .return_zero

    # width / n
    movl %edi, %eax         # move width to eax
    cltd                    # sign extend to edx:eax for division
    idivl %edx              # eax = width / n
    testl %eax, %eax        # check if result > 0
    jle .return_zero

    # height / n
    movl %esi, %eax         # move height to eax
    cltd                    # sign extend
    idivl %edx              # eax = height / n
    testl %eax, %eax        # check if result > 0
    jle .return_zero

    movl $1, %eax           # return 1 (true)
    ret

.return_zero:
    xorl %eax, %eax         # return 0 (false)
    ret

.globl determine_tile_w
determine_tile_w:
    testl %edi, %edi        # check if width <= 0
    jle .return_zero

    testl %esi, %esi        # check if n <= 0
    jle .return_zero

    testl %edx, %edx        # check if tile_col < 0
    js .return_zero

    cmpl %esi, %edx         # check if tile_col >= n
    jge .return_zero

    movl %edi, %eax         # eax = width
    cltd                    # sign extend for division
    idivl %esi              # eax = width / n
    movl %edx, %ecx         # ecx = remainder

    testl %edx, %edx        # check if tile_col < remainder
    jge .base_tile          # if not, skip addition

    addl $1, %eax           # base_tile_w + 1
.base_tile:
    ret

.return_zero:
    xorl %eax, %eax
    ret

.globl determine_tile_x_offset
determine_tile_x_offset:
    testl %edi, %edi        # check if width <= 0
    jle .return_zero

    testl %esi, %esi        # check if n <= 0
    jle .return_zero

    testl %edx, %edx        # check if tile_col < 0
    js .return_zero

    cmpl %esi, %edx         # check if tile_col >= n
    jge .return_zero

    movl %edi, %eax         # eax = width
    cltd                    # sign extend for division
    idivl %esi              # eax = base_tile_w
    movl %edx, %ecx         # ecx = remainder

    movl %edx, %eax         # eax = tile_col * base_tile_w
    imull %edx, %eax        # multiply
    ret

.return_zero:
    xorl %eax, %eax
    ret

.globl determine_tile_h
determine_tile_h:
    testl %edi, %edi        # check if height <= 0
    jle .return_zero

    testl %esi, %esi        # check if n <= 0
    jle .return_zero

    testl %edx, %edx        # check if tile_row < 0
    js .return_zero

    cmpl %esi, %edx         # check if tile_row >= n
    jge .return_zero

    movl %edi, %eax         # eax = height
    cltd                    # sign extend for division
    idivl %esi              # eax = base_tile_h
    movl %edx, %ecx         # ecx = remainder

    cmpl %edx, %esi         # compare tile_row with remainder
    jge .base_tile          # if not, skip addition

    addl $1, %eax           # base_tile_h + 1
.base_tile:
    ret

.return_zero:
    xorl %eax, %eax
    ret

.globl determine_tile_y_offset
determine_tile_y_offset:
    testl %edi, %edi        # check if height <= 0
    jle .return_zero

    testl %esi, %esi        # check if n <= 0
    jle .return_zero

    testl %edx, %edx        # check if tile_row < 0
    js .return_zero

    cmpl %esi, %edx         # check if tile_row >= n
    jge .return_zero

    movl %edi, %eax         # eax = height
    cltd                    # sign extend for division
    idivl %esi              # eax = base_tile_h
    movl %edx, %ecx         # ecx = remainder

    movl %eax, %ebx         # ebx = tile_row * base_tile_h
    imull %edx, %ebx        # multiply

    cmpl %edx, %esi         # compare tile_row with remainder
    jge .offset_base        # if not, skip

    addl %edx, %ebx         # tile_row < remainder
.offset_base:
    movl %ebx, %eax         # return result in eax
    ret

.return_zero:
    xorl %eax, %eax
    ret

.globl copy_tile
copy_tile:
    # Save registers
    pushq %rbx
    pushq %rcx
    pushq %rdx
    pushq %rsi

    # Load tile dimensions and offsets
    call determine_tile_w        # get tile width (in eax)
    movl %eax, %r8d              # save tile width to r8d

    call determine_tile_h        # get tile height (in eax)
    movl %eax, %r9d              # save tile height to r9d

    call determine_tile_x_offset # get tile x-offset (in eax)
    movl %eax, %r10d             # save x-offset to r10d

    call determine_tile_y_offset # get tile y-offset (in eax)
    movl %eax, %r11d             # save y-offset to r11d

    # Loop through each row
    movl $0, %eax
.row_loop:
    cmpl %r9d, %eax              # compare y with tile height
    jge .done                    # if y >= tile height, done

    # Loop through each column
    movl $0, %ebx
.col_loop:
    cmpl %r8d, %ebx              # compare x with tile width
    jge .next_row                # if x >= tile width, move to next row

    # Calculate input pixel index
    movl %ebx, %ecx
    imull %edi, %ecx             # ecx = sample_x * input_img->width
    addl %r10d, %ecx             # add x-offset

    movl %eax, %edx
    imull %edi, %edx             # edx = sample_y * input_img->width
    addl %r11d, %edx             # add y-offset

    # Copy pixel to output image
    movl (%rsi, %rcx, 4), %ecx   # load pixel
    movl %ecx, (%rdi, %rdx, 4)   # store pixel in output image

    incl %ebx                    # increment column
    jmp .col_loop

.next_row:
    incl %eax                    # increment row
    jmp .row_loop

.done:
    # Restore registers
    popq %rsi
    popq %rdx
    popq %rcx
    popq %rbx
    ret

.globl get_r
get_r:
    movl %edi, %eax         # Load pixel into eax
    shrl $24, %eax          # Shift right by 24 to extract red component
    ret

.globl get_g
get_g:
    movl %edi, %eax         # Load pixel into eax
    shrl $16, %eax          # Shift right by 16 to extract green component
    andl $0xFF, %eax        # Mask the value to get the green component
    ret

.globl get_b
get_b:
    movl %edi, %eax         # Load pixel into eax
    shrl $8, %eax           # Shift right by 8 to extract blue component
    andl $0xFF, %eax        # Mask the value to get the blue component
    ret

.globl get_a
get_a:
    movl %edi, %eax         # Load pixel into eax
    andl $0xFF, %eax        # Mask the value to get the alpha component
    ret

.globl make_pixel
make_pixel:
    shll $24, %edi          # Move red component into the top 8 bits
    shll $16, %esi          # Move green component into the second byte
    shll $8, %edx           # Move blue component into the third byte
    orl %esi, %edi          # Combine red and green components
    orl %edx, %edi          # Combine blue component
    orl %ecx, %edi          # Combine alpha component
    movl %edi, %eax         # Return the pixel
    ret

.globl to_grayscale
to_grayscale:
    call get_r                # Get red component in eax
    movl %eax, %ebx           # Save red component
    movl $79, %edx
    imull %edx, %eax          # Multiply red by 79

    call get_g                # Get green component in eax
    movl $128, %edx
    imull %edx, %eax          # Multiply green by 128
    addl %eax, %ebx           # Add to red contribution

    call get_b                # Get blue component in eax
    movl $49, %edx
    imull %edx, %eax          # Multiply blue by 49
    addl %eax, %ebx           # Add to grayscale total

    shrl $8, %ebx             # Divide by 256
    movl %ebx, %edi           # Grayscale value into edi

    call get_a                # Get alpha value into eax
    movl %eax, %ecx           # Move alpha into ecx
    call make_pixel           # Create pixel
    ret

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
	    .section .text

    .globl imgproc_mirror_h
imgproc_mirror_h:
    push %rbp                   # Save base pointer
    mov %rsp, %rbp               # Set stack frame

    # Load image width and height
    mov 0(%rdi), %eax            # Load input_img->width into eax
    mov 4(%rdi), %edx            # Load input_img->height into edx

    # Check for zero width or height
    test %eax, %eax
    jle end_mirror_h
    test %edx, %edx
    jle end_mirror_h

    # Iterate over each row (y-axis)
    mov %edx, %ecx               # Save height in ecx for row loop
    mov %eax, %ebx               # Save width in ebx for column loop
    shr $1, %ebx                 # Divide width by 2 for swapping

mirror_h_row_loop:
    dec %ecx                     # Decrement row counter
    jl end_mirror_h              # If no more rows, exit

    mov %ebx, %edi               # Copy column limit (width / 2)

mirror_h_col_loop:
    dec %edi                     # Decrement column counter
    jl next_row_h                # If no more columns, go to next row

    # Calculate pixel positions (left and right side)
    mov %ebx, %esi               # esi = width - column
    sub %edi, %esi               # Index for right side pixel
    mov (%rdi,%edi,4), %r8d      # Load left pixel
    mov (%rdi,%esi,4), %r9d      # Load right pixel

    # Swap pixels
    mov %r9d, (%rsi,%edi,4)      # Store right pixel in left
    mov %r8d, (%rsi,%esi,4)      # Store left pixel in right

    jmp mirror_h_col_loop        # Continue column loop

next_row_h:
    jmp mirror_h_row_loop        # Continue row loop

end_mirror_h:
    leave
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
    push %rbp                   # Save base pointer
    mov %rsp, %rbp               # Set stack frame

    # Load image width and height
    mov 0(%rdi), %eax            # Load input_img->width into eax
    mov 4(%rdi), %edx            # Load input_img->height into edx

    # Check for zero width or height
    test %eax, %eax
    jle end_mirror_v
    test %edx, %edx
    jle end_mirror_v

    # Iterate over each column (x-axis)
    mov %edx, %ecx               # Save height in ecx for row loop
    shr $1, %ecx                 # Divide height by 2

mirror_v_row_loop:
    dec %ecx                     # Decrement row counter
    jl end_mirror_v              # If no more rows, exit

    # Calculate top and bottom row
    mov %edx, %esi               # esi = height - row
    sub %ecx, %esi               # Index for bottom row
    mov (%rdi,%ecx,4), %r8d      # Load top row pixel
    mov (%rdi,%esi,4), %r9d      # Load bottom row pixel

    # Swap rows
    mov %r9d, (%rsi,%ecx,4)      # Store bottom row in top row
    mov %r8d, (%rsi,%esi,4)      # Store top row in bottom row

    jmp mirror_v_row_loop        # Continue row loop

end_mirror_v:
    leave
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
    push %rbp                   # Save base pointer
    mov %rsp, %rbp               # Set stack frame

    # Load image width and height
    mov 0(%rdi), %eax            # Load input_img->width into eax
    mov 4(%rdi), %edx            # Load input_img->height into edx

    # Check for zero width or height
    test %eax, %eax
    jle end_grayscale
    test %edx, %edx
    jle end_grayscale

grayscale_pixel_loop:
    test %eax, %eax              # Test if there are pixels left
    jle end_grayscale            # Exit if no pixels

    mov (%rdi), %r8d             # Load pixel from input image
    call to_grayscale            # Convert to grayscale

    mov %r8d, (%rsi)             # Store the grayscale pixel in output image

    dec %eax                     # Decrement pixel counter
    jmp grayscale_pixel_loop     # Repeat for each pixel

end_grayscale:
    leave
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
