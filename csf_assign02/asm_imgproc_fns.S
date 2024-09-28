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


    .globl get_r
get_r:
    # Prologue to set up stack frame
    pushq   %rbp                   # Save the old base pointer
    movq    %rsp, %rbp              # Set the base pointer to the current stack pointer

    # Load the pixel argument from %edi (the first argument)
    movl    %edi, %eax              # Move the 32-bit pixel into %eax

    # Shift right by 24 bits to extract the red component (most significant 8 bits)
    shrl    $24, %eax               # Logical shift right by 24 bits, moving red component to lower 8 bits

    # Mask the result to isolate only the red component (0xFF)
    andl    $0xFF, %eax             # Apply the mask to keep only the least significant 8 bits

    # Epilogue to clean up and return
    movq    %rbp, %rsp              # Restore the old stack pointer
    popq    %rbp                    # Restore the old base pointer
    ret                             # Return to the caller, result in %eax


    .globl get_g
get_g:
    # Prologue to set up stack frame
    pushq   %rbp                  # Save old base pointer
    movq    %rsp, %rbp            # Set base pointer to current stack pointer

    # Move the pixel argument (passed in %edi) into %eax
    movl    %edi, %eax            # Move 32-bit pixel into %eax

    # Shift right by 16 bits to extract the green component (second 8 bits)
    shrl    $16, %eax             # Logical shift right by 16 bits, green component now in lower 8 bits

    # Mask the result to isolate the green component (0xFF)
    andl    $0xFF, %eax           # Apply mask to keep only the least significant 8 bits (green component)

    # Epilogue to restore stack frame and return
    movq    %rbp, %rsp            # Restore the old stack pointer
    popq    %rbp                  # Restore old base pointer
    ret                           # Return to caller, result is in %eax


    .globl get_b
get_b:
    # Prologue: Setup the stack frame
    pushq   %rbp                  # Save base pointer
    movq    %rsp, %rbp            # Set the new base pointer

    # Move the input argument (pixel) from %edi to %eax
    movl    %edi, %eax            # Copy the pixel argument to %eax

    # Shift right by 8 bits to isolate the blue component
    shrl    $8, %eax              # Shift right 8 bits

    # Mask the result to keep only the lower 8 bits
    andl    $0xFF, %eax           # Mask with 0xFF to isolate blue component

    # Epilogue: Clean up and return
    popq    %rbp                  # Restore base pointer
    ret                           # Return, with result in %eax


    .globl get_a
get_a:
    # Prologue: Setup the stack frame
    pushq   %rbp                  # Save base pointer
    movq    %rsp, %rbp            # Set the new base pointer

    # Move the input argument (pixel) from %edi to %eax
    movl    %edi, %eax            # Copy the pixel argument to %eax

    # Mask the result to extract the alpha component (lowest 8 bits)
    andl    $0xFF, %eax           # Mask with 0xFF to extract the alpha component

    # Epilogue: Clean up and return
    popq    %rbp                  # Restore base pointer
    ret                           # Return, with result in %eax

    .globl make_pixel
make_pixel:
    # Input: %rdi (red), %rsi (green), %rdx (blue), %rcx (alpha)
    # Output: %rax (the packed pixel value: 0xRRGGBBAA)

    # Step 1: Pack the red component (shift left by 24 bits to align with most significant byte)
    shl $24, %rdi          # red << 24
    # Step 2: Pack the green component (shift left by 16 bits)
    shl $16, %rsi          # green << 16
    # Step 3: Pack the blue component (shift left by 8 bits)
    shl $8, %rdx           # blue << 8
    # Step 4: Alpha remains as it is (already in the correct position)

    # Step 5: Combine all components using bitwise OR operations
    or %rsi, %rdi          # Combine red and green
    or %rdx, %rdi          # Combine with blue
    or %rcx, %rdi          # Combine with alpha

    # Step 6: Move the packed pixel into %rax for the return value
    mov %rdi, %rax

    # Step 7: Return
    ret

    .globl to_grayscale
to_grayscale:
    # Prologue: Set up the stack frame
    pushq   %rbp
    movq    %rsp, %rbp

    # Save pixel in callee-saved register (store %edi in %r12 for later)
    movl    %edi, %r12d

    # Extract the red component
    movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    shrl    $24, %eax           # Shift right 24 bits to get red component
    movl    %eax, %r13d         # Save red component in %r13d for later

    # Extract the green component
    movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    shrl    $16, %eax           # Shift right 16 bits to get green component
    andl    $0xFF, %eax         # Mask to get the green component (8 bits)
    movl    %eax, %r14d         # Save green component in %r14d for later

    # Extract the blue component
    movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    shrl    $8, %eax            # Shift right 8 bits to get blue component
    andl    $0xFF, %eax         # Mask to get the blue component (8 bits)
    movl    %eax, %r15d         # Save blue component in %r15d for later

    # Preserve the alpha component
    movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    andl    $0xFF, %eax         # Mask to get the alpha component (8 bits)
    movl    %eax, %ebx          # Save alpha component in %ebx for later

    # Compute the grayscale value using weighted average (79 * r + 128 * g + 49 * b) / 256
    movl    %r13d, %eax         # Move red component to %eax
    imull   $79, %eax           # Multiply by 79 (r * 79)

    movl    %r14d, %ecx         # Move green component to %ecx
    imull   $128, %ecx          # Multiply by 128 (g * 128)
    addl    %ecx, %eax          # Add green contribution to %eax

    movl    %r15d, %ecx         # Move blue component to %ecx
    imull   $49, %ecx           # Multiply by 49 (b * 49)
    addl    %ecx, %eax          # Add blue contribution to %eax

    shrl    $8, %eax            # Divide the total by 256 (shift right by 8 bits)

    # Now %eax contains the grayscale value (y)
    movl    %eax, %r13d         # Save grayscale value in %r13d

    # Create the grayscale pixel with the same alpha value
    movl    %r13d, %eax         # Move grayscale value to %eax
    shll    $24, %eax           # Shift grayscale value to the red component

    movl    %r13d, %ecx         # Move grayscale value to %ecx
    shll    $16, %ecx           # Shift grayscale value to the green component
    orl     %ecx, %eax          # OR it with %eax

    movl    %r13d, %ecx         # Move grayscale value to %ecx
    shll    $8, %ecx            # Shift grayscale value to the blue component
    orl     %ecx, %eax          # OR it with %eax

    movl    %ebx, %ecx          # Move alpha component to %ecx
    orl     %ecx, %eax          # OR it with %eax (combine grayscale with alpha)

    # Epilogue: Restore stack and return
    popq    %rbp                # Restore base pointer
    ret                         # Return with the grayscale pixel in

/*
 * void imgproc_mirror_h( struct Image *input_img, struct Image *output_img );
 *
 * Transform image by mirroring its pixels horizontally.
 * This transformation always succeeds.
 *
 * Parameters:
 *   %rdi - pointer to original struct Image (input image)
 *   %rsi - pointer to output struct Image (output image)
 *
 * Register usage:
 *   %rdi - input image pointer
 *   %rsi - output image pointer
 *   %rax - temporary register for pixel manipulation
 *   %rbp - base pointer for the stack frame
 *
 * Memory use:
 *   -40(%rbp) - input image pointer
 *   -48(%rbp) - output image pointer
 *   -12(%rbp) - image width
 *   -16(%rbp) - image height
 *   -4(%rbp)  - current row index (y)
 *   -8(%rbp)  - current left column index (x)
 *   -20(%rbp) - current mirrored right column index
 *   -24(%rbp) - pixel value from left column
 *   -28(%rbp) - pixel value from right column
 */

    .global imgproc_mirror_h
imgproc_mirror_h:
    pushq   %rbp                   # Save base pointer
    movq    %rsp, %rbp              # Set up stack frame
    movq    %rdi, -40(%rbp)         # Store input image pointer
    movq    %rsi, -48(%rbp)         # Store output image pointer

    # Load image width and height
    movq    -40(%rbp), %rax         # Load input image pointer
    movl    (%rax), %eax            # Load width from input image
    movl    %eax, -12(%rbp)         # Store width in local variable
    movq    -40(%rbp), %rax         # Load input image pointer again
    movl    4(%rax), %eax           # Load height from input image
    movl    %eax, -16(%rbp)         # Store height in local variable

    # Check if width <= 1 or height <= 0 (no need to mirror)
    cmpl    $1, -12(%rbp)           # Compare width with 1
    jle     .Lmirror_h_exit            # Exit if width <= 1
    cmpl    $0, -16(%rbp)           # Compare height with 0
    jle     .Lmirror_h_exit            # Exit if height <= 0

    # Initialize row index (y) to 0
    movl    $0, -4(%rbp)            # Set row index y to 0

    # Begin row loop
.Lmirror_h_row_loop:
    movl    $0, -8(%rbp)            # Set left column index x to 0

    # Begin column loop (left half of image)
.Lmirror_h_col_loop_check:
    # Calculate mirrored right column index (width - 1 - x)
    movl    -12(%rbp), %eax         # Load image width
    subl    $1, %eax                # width - 1
    subl    -8(%rbp), %eax          # width - 1 - x
    movl    %eax, -20(%rbp)         # Store mirrored column index

    # Load pixel from left column (x, y)
    movq    -40(%rbp), %rax         # Load input image pointer
    movq    8(%rax), %rdx           # Load image data pointer
    movl    -4(%rbp), %eax          # Load row index y
    imull   -12(%rbp), %eax         # y * width
    movl    %eax, %ecx              # Store row offset in ecx
    movl    -8(%rbp), %eax          # Load left column index x
    addl    %ecx, %eax              # Calculate y * width + x
    cltq                            # Convert to 64-bit
    salq    $2, %rax                # Multiply by 4 (each pixel is 4 bytes)
    addq    %rdx, %rax              # Calculate final address of left column pixel
    movl    (%rax), %eax            # Load pixel value
    movl    %eax, -24(%rbp)         # Store pixel value from left column

    # Load pixel from right column (mirrored, y)
    movq    -40(%rbp), %rax         # Load input image pointer again
    movq    8(%rax), %rdx           # Load image data pointer
    movl    -4(%rbp), %eax          # Load row index y
    imull   -12(%rbp), %eax         # y * width
    movl    %eax, %ecx              # Store row offset in ecx
    movl    -20(%rbp), %eax         # Load mirrored column index
    addl    %ecx, %eax              # Calculate y * width + mirrored column index
    cltq                            # Convert to 64-bit
    salq    $2, %rax                # Multiply by 4 (each pixel is 4 bytes)
    addq    %rdx, %rax              # Calculate final address of right column pixel
    movl    (%rax), %eax            # Load pixel value
    movl    %eax, -28(%rbp)         # Store pixel value from right column

    # Write mirrored pixel (from right column) to left column in output image
    movq    -48(%rbp), %rax         # Load output image pointer
    movq    8(%rax), %rdx           # Load output image data pointer
    movl    -4(%rbp), %eax          # Load row index y
    imull   -12(%rbp), %eax         # y * width
    movl    %eax, %ecx              # Store row offset in ecx
    movl    -8(%rbp), %eax          # Load left column index x
    addl    %ecx, %eax              # Calculate y * width + x
    cltq                            # Convert to 64-bit
    salq    $2, %rax                # Multiply by 4
    addq    %rax, %rdx              # Calculate final address in output image
    movl    -28(%rbp), %eax         # Load mirrored pixel value from right column
    movl    %eax, (%rdx)            # Store it in left column of output image

    # Write original left pixel to right column in output image
    movq    -48(%rbp), %rax         # Load output image pointer again
    movq    8(%rax), %rdx           # Load output image data pointer
    movl    -4(%rbp), %eax          # Load row index y
    imull   -12(%rbp), %eax         # y * width
    movl    %eax, %ecx              # Store row offset in ecx
    movl    -20(%rbp), %eax         # Load mirrored column index
    addl    %ecx, %eax              # Calculate y * width + mirrored column index
    cltq                            # Convert to 64-bit
    salq    $2, %rax                # Multiply by 4
    addq    %rax, %rdx              # Calculate final address in output image
    movl    -24(%rbp), %eax         # Load original left pixel value
    movl    %eax, (%rdx)            # Store it in right column of output image

    # Increment left column index x
    addl    $1, -8(%rbp)            # Increment x
    movl    -12(%rbp), %eax         # Load image width
    movl    %eax, %edx              # Copy width to edx
    shrl    $31, %edx               # Handle potential negative widths
    addl    %edx, %eax              # Adjust width
    sarl    %eax                    # Divide width by 2
    cmpl    %eax, -8(%rbp)          # Compare x with width / 2
    jl      .Lmirror_h_col_loop_check  # Repeat column loop if x < width / 2

    # Increment row index y
    addl    $1, -4(%rbp)            # Increment y
    movl    -4(%rbp), %eax          # Check if y < height
    cmpl    -16(%rbp), %eax
    jl      .Lmirror_h_row_loop        # Repeat row loop if y < height

    # Exit routine
.Lmirror_h_exit:
    popq    %rbp                    # Restore base pointer
    ret                             # Return


/*
 * void imgproc_mirror_v( struct Image *input_img, struct Image *output_img );
 *
 * Transform image by mirroring its pixels vertically.
 * This transformation always succeeds.
 *
 * Parameters:
 *   %rdi - pointer to original struct Image (input image)
 *   %rsi - pointer to output struct Image (output image)
 *
 * Register use:
 *   %rdi - input image (pointer)
 *   %rsi - output image (pointer)
 *   %rax - temporary storage for pixel operations
 *   %rbp - base pointer (stack frame)
 *
 * Memory use:
 *   -40(%rbp) - input image pointer
 *   -48(%rbp) - output image pointer
 *   -12(%rbp) - image width
 *   -16(%rbp) - image height
 *   -4(%rbp)  - current row index (y)
 *   -8(%rbp)  - current column index (x)
 *   -20(%rbp) - mirrored row index (mirrored_y)
 */
    .global imgproc_mirror_v
imgproc_mirror_v:
	pushq	%rbp                # Save base pointer
	movq	%rsp, %rbp          # Set up stack frame
	movq	%rdi, -40(%rbp)     # Store input image pointer
	movq	%rsi, -48(%rbp)     # Store output image pointer

    # Load image width and height
	movq	-40(%rbp), %rax     # Load input image pointer
	movl	(%rax), %eax        # Load width from input image
	movl	%eax, -12(%rbp)     # Store height in local varaible
	movq	-40(%rbp), %rax     # Load input image pointer again
	movl	4(%rax), %eax       # Load height from input image
	movl	%eax, -16(%rbp)     # Store height in local variable

    # Check if width <= 0 or height <= 1 (no need to mirror)
    cmpl    $0, -12(%rbp)       # Compare width with 0
    jle     .Lmirror_v_exit       # Exit if width <= 0
    cmpl    $1, -16(%rbp)       # Compare height with 1
    jle     .Lmirror_v_exit       # Exit if height <= 1

    # Initialize row index (y) to 0
	movl	$0, -4(%rbp)        # Set row index y to 0
	jmp	    .Lmirror_v_row_loop
.Lmirror_v_col_loop_start:
	movl	-16(%rbp), %eax
	subl	$1, %eax
	subl	-4(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	$0, -8(%rbp)
	jmp	    .Lmirror_v_process_pixels
.Lmirror_v_pixel_processing:
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -24(%rbp)


	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-20(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -28(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rdx
	movl	-28(%rbp), %eax
	movl	%eax, (%rdx)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-20(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -8(%rbp)
.Lmirror_v_process_pixels:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	    .Lmirror_v_pixel_processing
	addl	$1, -4(%rbp)
.Lmirror_v_row_loop:
	movl	-16(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	%eax, -4(%rbp)
	jl	    .Lmirror_v_col_loop_start

    # Exit routine
.Lmirror_v_exit:
	popq	%rbp                # Restore base pointer
	ret                         # Return


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
 *   %rdi - pointer to original struct Image (input image)
 *   %rsi - pointer to output struct Image (output image)
 *
 * Register use:
 *   %rdi - input image pointer
 *   %rsi - output image pointer
 *   %rax - temporary storage for pixel operations
 *   %rbp - base pointer (stack frame)
 *
 * Memory use:
 *   -40(%rbp) - input image pointer
 *   -48(%rbp) - output image pointer
 *   -12(%rbp) - image width
 *   -16(%rbp) - image height
 *   -4(%rbp)  - current row index (y)
 *   -8(%rbp)  - current column index (x)
 *   -20(%rbp) - current pixel value
 *   -24(%rbp) - grayscale pixel value
 */

    .globl imgproc_grayscale
imgproc_grayscale:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-40(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -16(%rbp)
	cmpl	$0, -12(%rbp)
	jle	    .L_exit
	cmpl	$0, -16(%rbp)
	jle	    .L_exit
	movl	$0, -4(%rbp)
	jmp	    .L_outer_loop
.L_inner_loop:
	movl	$0, -8(%rbp)
	jmp	    .L_process_pixel
.L_pixel_processing:
	movq	-40(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	to_grayscale
	movl	%eax, -24(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -8(%rbp)
.L_process_pixel:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	    .L_pixel_processing
	addl	$1, -4(%rbp)
.L_outer_loop:
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	    .L_inner_loop
	jmp	    .L_return
.L_exit:
	nop
.L_return:
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