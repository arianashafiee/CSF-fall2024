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

/*
 * all_tiles_nonempty
 *
 * Determines whether all tiles in the grid are non-empty (i.e., none have 0 width or height).
 *
 * Parameters:
 *   %edi - width of the image
 *   %esi - height of the image
 *   %edx - tiling factor (n)
 *
 * Register usage:
 *   %edi - image width
 *   %esi - image height
 *   %edx - tiling factor
 *   %eax - used for storing the result of tile size calculations
 *   %rbp - base pointer for the stack frame
 *
 * Memory use:
 *   -4(%rbp)  - image width
 *   -8(%rbp)  - image height
 *   -12(%rbp) - tiling factor
 */

.global all_tiles_nonempty
all_tiles_nonempty:
.Ltop_tiles_nonempty:
	pushq	%rbp                  # Save base pointer
	movq	%rsp, %rbp            # Set up stack frame
	movl	%edi, -4(%rbp)        # Store image width
	movl	%esi, -8(%rbp)        # Store image height
	movl	%edx, -12(%rbp)       # Store tiling factor
	cmpl	$0, -12(%rbp)         # Check if tiling factor <= 0
	jle	.Ltile_empty_exit      # Jump to failure if invalid
	cmpl	$0, -4(%rbp)          # Check if width <= 0
	jle	.Ltile_empty_exit      # Jump to failure if invalid
	cmpl	$0, -8(%rbp)          # Check if height > 0
	jg	.Ltiles_are_valid          # Continue if valid

.Ltile_empty_exit:
	movl	$0, %eax              # Set return value to 0 (failure)
	jmp	.Ltile_exit

.Ltiles_are_valid:
	movl	-4(%rbp), %eax        # Load image width
	cltd                        # Sign extend for division
	idivl	-12(%rbp)             # Divide width by tiling factor
	testl	%eax, %eax            # Test if result is 0 (empty tile)
	jle	.Ltile_failure         # If result <= 0, failure

	movl	-8(%rbp), %eax        # Load image height
	cltd                        # Sign extend for division
	idivl	-12(%rbp)             # Divide height by tiling factor
	testl	%eax, %eax            # Test if result is 0 (empty tile)
	jle	.Ltile_failure         # If result <= 0, failure

	movl	$1, %eax              # Set return value to 1 (success)
	jmp	.Ltile_exit

.Ltile_failure:
	movl	$0, %eax              # Set return value to 0 (failure)

.Ltile_exit:
	popq	%rbp                  # Restore base pointer
	ret                         # Return

/*
 * determine_tile_w
 *
 * Calculates the width of each tile when tiling the image.
 *
 * Parameters:
 *   %edi - width of the image
 *   %esi - tiling factor
 *   %edx - width of the current tile
 *
 * Register usage:
 *   %edi - image width
 *   %esi - tiling factor
 *   %edx - tile width
 *   %eax - used for storing the calculated tile width
 *   %rbp - base pointer for the stack frame
 *
 * Memory use:
 *   -20(%rbp) - image width
 *   -24(%rbp) - tiling factor
 *   -28(%rbp) - tile width
 */

.globl determine_tile_w
determine_tile_w:
.Ltop_tile_w:
	pushq	%rbp                  # Save base pointer
	movq	%rsp, %rbp            # Set up stack frame
	movl	%edi, -20(%rbp)       # Store image width
	movl	%esi, -24(%rbp)       # Store tiling factor
	movl	%edx, -28(%rbp)       # Store tile width
	cmpl	$0, -24(%rbp)         # Check if tiling factor <= 0
	jle	.Ltile_w_invalid       # Jump to failure if invalid
	cmpl	$0, -20(%rbp)         # Check if width <= 0
	jle	.Ltile_w_invalid       # Jump to failure if invalid
	cmpl	$0, -28(%rbp)         # Check if tile width < 0
	js	.Ltile_w_invalid       # Jump to failure if invalid
	movl	-28(%rbp), %eax       # Load tile width
	cmpl	-24(%rbp), %eax       # Compare tile width with tiling factor
	jl	.Ltile_w_valid         # If valid, proceed

.Ltile_w_invalid:
	movl	$0, %eax              # Set return value to 0 (failure)
	jmp	.Ltile_w_exit

.Ltile_w_valid:
	movl	-20(%rbp), %eax       # Load image width
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide width by tiling factor
	movl	%eax, -4(%rbp)        # Store result (tile width)
	movl	-20(%rbp), %eax       # Load image width again
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide width again
	movl	%edx, -8(%rbp)        # Store remainder
	movl	-28(%rbp), %eax       # Load tile width
	cmpl	-8(%rbp), %eax        # Compare remainder with tile width
	setl	%al                   # Set result based on comparison
	movzbl	%al, %edx             # Zero-extend the result
	movl	-4(%rbp), %eax        # Load tile width
	addl	%edx, %eax            # Add to result

.Ltile_w_exit:
	popq	%rbp                  # Restore base pointer
	ret                         # Return

/*
 * determine_tile_x_offset
 *
 * Calculates the x-offset for a given tile in the grid.
 *
 * Parameters:
 *   %edi - width of the image
 *   %esi - tiling factor
 *   %edx - x-offset of the current tile
 *
 * Register usage:
 *   %edi - image width
 *   %esi - tiling factor
 *   %edx - x-offset of the current tile
 *   %eax - used for storing the calculated x-offset
 *   %rbp - base pointer for the stack frame
 *
 * Memory use:
 *   -20(%rbp) - image width
 *   -24(%rbp) - tiling factor
 *   -28(%rbp) - tile x-offset
 */

.globl determine_tile_x_offset
determine_tile_x_offset:
.Ltop_x_offset:
	pushq	%rbp                  # Save base pointer
	movq	%rsp, %rbp            # Set up stack frame
	movl	%edi, -20(%rbp)       # Store image width
	movl	%esi, -24(%rbp)       # Store tiling factor
	movl	%edx, -28(%rbp)       # Store x-offset
	cmpl	$0, -24(%rbp)         # Check if tiling factor <= 0
	jle	.Ltile_x_offset_invalid # Jump to failure if invalid
	cmpl	$0, -20(%rbp)         # Check if width <= 0
	jle	.Ltile_x_offset_invalid # Jump to failure if invalid
	cmpl	$0, -28(%rbp)         # Check if x-offset < 0
	js	.Ltile_x_offset_invalid # Jump to failure if invalid
	movl	-28(%rbp), %eax       # Load x-offset
	cmpl	-24(%rbp), %eax       # Compare x-offset with tiling factor
	jl	.Ltile_x_offset_valid   # If valid, proceed

.Ltile_x_offset_invalid:
	movl	$0, %eax              # Set return value to 0 (failure)
	jmp	.Ltile_x_offset_exit

.Ltile_x_offset_valid:
	movl	-20(%rbp), %eax       # Load image width
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide width by tiling factor
	movl	%eax, -4(%rbp)        # Store result (x-offset)
	movl	-20(%rbp), %eax       # Load image width again
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide width again
	movl	%edx, -8(%rbp)        # Store remainder
	movl	-28(%rbp), %eax       # Load x-offset
	imull	-4(%rbp), %eax        # Multiply result with x-offset
	movl	%eax, %ecx            # Store result in %ecx
	movl	-8(%rbp), %edx        # Load remainder
	movl	-28(%rbp), %eax       # Load x-offset
	cmpl	%eax, %edx            # Compare with remainder
	cmovle	%edx, %eax            # Move remainder to %eax if less than or equal
	addl	%ecx, %eax            # Add to result

.Ltile_x_offset_exit:
	popq	%rbp                  # Restore base pointer
	ret                         # Return

/*
 * determine_tile_h
 *
 * Calculates the height of each tile when tiling the image.
 *
 * Parameters:
 *   %edi - height of the image
 *   %esi - tiling factor
 *   %edx - height of the current tile
 *
 * Register usage:
 *   %edi - image height
 *   %esi - tiling factor
 *   %edx - tile height
 *   %eax - used for storing the calculated tile height
 *   %rbp - base pointer for the stack frame
 *
 * Memory use:
 *   -20(%rbp) - image height
 *   -24(%rbp) - tiling factor
 *   -28(%rbp) - tile height
 */

.globl determine_tile_h
determine_tile_h:
.Ltop_tile_h:
	pushq	%rbp                  # Save base pointer
	movq	%rsp, %rbp            # Set up stack frame
	movl	%edi, -20(%rbp)       # Store image height
	movl	%esi, -24(%rbp)       # Store tiling factor
	movl	%edx, -28(%rbp)       # Store tile height
	cmpl	$0, -24(%rbp)         # Check if tiling factor <= 0
	jle	.Ltile_h_invalid       # Jump to failure if invalid
	cmpl	$0, -20(%rbp)         # Check if height <= 0
	jle	.Ltile_h_invalid       # Jump to failure if invalid
	cmpl	$0, -28(%rbp)         # Check if tile height < 0
	js	.Ltile_h_invalid       # Jump to failure if invalid
	movl	-28(%rbp), %eax       # Load tile height
	cmpl	-24(%rbp), %eax       # Compare tile height with tiling factor
	jl	.Ltile_h_valid         # If valid, proceed

.Ltile_h_invalid:
	movl	$0, %eax              # Set return value to 0 (failure)
	jmp	.Ltile_h_exit

.Ltile_h_valid:
	movl	-20(%rbp), %eax       # Load image height
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide height by tiling factor
	movl	%eax, -4(%rbp)        # Store result (tile height)
	movl	-20(%rbp), %eax       # Load image height again
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide height again
	movl	%edx, -8(%rbp)        # Store remainder
	movl	-28(%rbp), %eax       # Load tile height
	cmpl	-8(%rbp), %eax        # Compare remainder with tile height
	setl	%al                   # Set result based on comparison
	movzbl	%al, %edx             # Zero-extend the result
	movl	-4(%rbp), %eax        # Load tile height
	addl	%edx, %eax            # Add to result

.Ltile_h_exit:
	popq	%rbp                  # Restore base pointer
	ret                         # Return

/*
 * determine_tile_y_offset
 *
 * Calculates the y-offset for a given tile in the grid.
 *
 * Parameters:
 *   %edi - height of the image
 *   %esi - tiling factor
 *   %edx - y-offset of the current tile
 *
 * Register usage:
 *   %edi - image height
 *   %esi - tiling factor
 *   %edx - y-offset of the current tile
 *   %eax - used for storing the calculated y-offset
 *   %rbp - base pointer for the stack frame
 *
 * Memory use:
 *   -20(%rbp) - image height
 *   -24(%rbp) - tiling factor
 *   -28(%rbp) - tile y-offset
 */

.globl determine_tile_y_offset
determine_tile_y_offset:
.Ltop_y_offset:
	pushq	%rbp                  # Save base pointer
	movq	%rsp, %rbp            # Set up stack frame
	movl	%edi, -20(%rbp)       # Store image height
	movl	%esi, -24(%rbp)       # Store tiling factor
	movl	%edx, -28(%rbp)       # Store y-offset
	cmpl	$0, -24(%rbp)         # Check if tiling factor <= 0
	jle	.Ltile_y_offset_invalid # Jump to failure if invalid
	cmpl	$0, -20(%rbp)         # Check if height <= 0
	jle	.Ltile_y_offset_invalid # Jump to failure if invalid
	cmpl	$0, -28(%rbp)         # Check if y-offset < 0
	js	.Ltile_y_offset_invalid # Jump to failure if invalid
	movl	-28(%rbp), %eax       # Load y-offset
	cmpl	-24(%rbp), %eax       # Compare y-offset with tiling factor
	jl	.Ltile_y_offset_valid   # If valid, proceed

.Ltile_y_offset_invalid:
	movl	$0, %eax              # Set return value to 0 (failure)
	jmp	.Ltile_y_offset_exit

.Ltile_y_offset_valid:
	movl	-20(%rbp), %eax       # Load image height
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide height by tiling factor
	movl	%eax, -4(%rbp)        # Store result (y-offset)
	movl	-20(%rbp), %eax       # Load image height again
	cltd                        # Sign extend for division
	idivl	-24(%rbp)             # Divide height again
	movl	%edx, -8(%rbp)        # Store remainder
	movl	-28(%rbp), %eax       # Load y-offset
	imull	-4(%rbp), %eax        # Multiply result with y-offset
	movl	%eax, %ecx            # Store result in %ecx
	movl	-8(%rbp), %edx        # Load remainder
	movl	-28(%rbp), %eax       # Load y-offset
	cmpl	%eax, %edx            # Compare with remainder
	cmovle	%edx, %eax            # Move remainder to %eax if less than or equal
	addl	%ecx, %eax            # Add to result

.Ltile_y_offset_exit:
	popq	%rbp                  # Restore base pointer
	ret                         # Return

/*
 * copy_tile
 *
 * Copies a tile from the input image to the output image.
 *
 * Parameters:
 *   %rdi - pointer to the output image
 *   %rsi - pointer to the input image
 *   %edx - y-offset of the tile
 *   %ecx - x-offset of the tile
 *   %r8d - tiling factor
 *
 * Register usage:
 *   %rdi - output image pointer
 *   %rsi - input image pointer
 *   %edx - y-offset of the tile
 *   %ecx - x-offset of the tile
 *   %r8d - tiling factor
 *   %rbp - base pointer for the stack frame
 *   %rax, %rdx, %eax - temporary registers for pixel manipulation
 *
 * Memory use:
 *   -56(%rbp) - output image pointer
 *   -64(%rbp) - input image pointer
 *   -68(%rbp) - y-offset
 *   -72(%rbp) - x-offset
 *   -76(%rbp) - tiling factor
 *   -12(%rbp) - tile width
 *   -16(%rbp) - tile height
 *   -20(%rbp) - tile x-offset
 *   -24(%rbp) - tile y-offset
 */

   .globl copy_tile
copy_tile:
.L_copy_start:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)       # Store output image pointer
	movq	%rsi, -64(%rbp)       # Store input image pointer
	movl	%edx, -68(%rbp)       # Store y-offset
	movl	%ecx, -72(%rbp)       # Store x-offset
	movl	%r8d, -76(%rbp)       # Store tiling factor
	cmpl	$0, -76(%rbp)         # Check if tiling factor is <= 0
	jle	.Linvalid_tile         # Jump to failure if tiling factor is invalid
	movq	-64(%rbp), %rax       # Load input image pointer
	movl	(%rax), %eax          # Load image width
	testl	%eax, %eax            # Check if width > 0
	jle	.Linvalid_tile         # Jump to failure if width is invalid
	movq	-64(%rbp), %rax       # Load input image pointer
	movl	4(%rax), %eax         # Load image height
	testl	%eax, %eax            # Check if height > 0
	jle	.Linvalid_tile         # Jump to failure if height is invalid

	# Calculate tile width, height, x-offset, and y-offset
	movq	-64(%rbp), %rax       # Load input image pointer
	movl	(%rax), %eax          # Load image width
	movl	-72(%rbp), %edx       # Load x-offset
	movl	-76(%rbp), %ecx       # Load tiling factor
	movl	%ecx, %esi            # Move tiling factor to %esi
	movl	%eax, %edi            # Move image width to %edi
	call	determine_tile_w       # Calculate tile width
	movl	%eax, -12(%rbp)       # Store tile width

	movq	-64(%rbp), %rax       # Load input image pointer
	movl	4(%rax), %eax         # Load image height
	movl	-68(%rbp), %edx       # Load y-offset
	movl	-76(%rbp), %ecx       # Load tiling factor
	movl	%ecx, %esi            # Move tiling factor to %esi
	movl	%eax, %edi            # Move image height to %edi
	call	determine_tile_h       # Calculate tile height
	movl	%eax, -16(%rbp)       # Store tile height

	movq	-64(%rbp), %rax       # Load input image pointer
	movl	(%rax), %eax          # Load image width
	movl	-72(%rbp), %edx       # Load x-offset
	movl	-76(%rbp), %ecx       # Load tiling factor
	movl	%ecx, %esi            # Move tiling factor to %esi
	movl	%eax, %edi            # Move image width to %edi
	call	determine_tile_x_offset # Calculate x-offset
	movl	%eax, -20(%rbp)       # Store tile x-offset

	movq	-64(%rbp), %rax       # Load input image pointer
	movl	4(%rax), %eax         # Load image height
	movl	-68(%rbp), %edx       # Load y-offset
	movl	-76(%rbp), %ecx       # Load tiling factor
	movl	%ecx, %esi            # Move tiling factor to %esi
	movl	%eax, %edi            # Move image height to %edi
	call	determine_tile_y_offset # Calculate y-offset
	movl	%eax, -24(%rbp)       # Store tile y-offset

	# Start copying tiles
	movl	$0, -4(%rbp)          # Initialize row index to 0
	jmp	.Lrow_loop_start

.Lcol_loop_start:
	movl	$0, -8(%rbp)          # Initialize column index to 0
	jmp	.Lcol_loop

.Lprocess_pixel:
	# Process a single pixel in the tile
	movl	-24(%rbp), %edx       # Load y-offset
	movl	-4(%rbp), %eax        # Load row index
	addl	%eax, %edx            # Calculate y position
	movq	-64(%rbp), %rax       # Load input image pointer
	movl	4(%rax), %eax         # Load image height
	cmpl	%eax, %edx            # Check if y position is valid
	jge	.Lend_tile_copy        # Jump to done if invalid

	movl	-20(%rbp), %edx       # Load x-offset
	movl	-8(%rbp), %eax        # Load column index
	addl	%eax, %edx            # Calculate x position
	movq	-64(%rbp), %rax       # Load input image pointer
	movl	(%rax), %eax          # Load image width
	cmpl	%eax, %edx            # Check if x position is valid
	jge	.Lend_tile_copy        # Jump to done if invalid

	movl	-8(%rbp), %eax        # Load column index
	imull	-76(%rbp), %eax       # Multiply by tiling factor
	movl	%eax, -28(%rbp)       # Store result (column offset)

	movl	-4(%rbp), %eax        # Load row index
	imull	-76(%rbp), %eax       # Multiply by tiling factor
	movl	%eax, -32(%rbp)       # Store result (row offset)

	# Copy pixel from input image to output image
	movq	-64(%rbp), %rax       # Load input image pointer
	movq	8(%rax), %rdx         # Load pixel data pointer
	movq	-64(%rbp), %rax       # Load input image pointer
	movl	(%rax), %eax          # Load image width
	imull	-32(%rbp), %eax       # Multiply width by row offset
	movl	%eax, %ecx            # Store result
	movl	-28(%rbp), %eax       # Load column offset
	addl	%ecx, %eax            # Add row and column offsets
	cltq                        # Sign-extend to 64 bits
	salq	$2, %rax              # Multiply by 4 (pixel size)
	addq	%rdx, %rax            # Add to pixel data pointer
	movl	(%rax), %eax          # Load pixel value
	movl	%eax, -36(%rbp)       # Store pixel value

	movq	-56(%rbp), %rax       # Load output image pointer
	movq	8(%rax), %rdx         # Load pixel data pointer
	movl	-24(%rbp), %ecx       # Load y-offset
	movl	-4(%rbp), %eax        # Load row index
	addl	%eax, %ecx            # Add row index to y-offset
	movq	-56(%rbp), %rax       # Load output image pointer
	movl	(%rax), %eax          # Load image width
	imull	%ecx, %eax            # Multiply width by y-offset
	movl	-20(%rbp), %esi       # Load x-offset
	movl	-8(%rbp), %ecx        # Load column index
	addl	%esi, %ecx            # Add column index to x-offset
	addl	%ecx, %eax            # Add x-offset to total
	cltq                        # Sign-extend to 64 bits
	salq	$2, %rax              # Multiply by 4 (pixel size)
	addq	%rax, %rdx            # Add to pixel data pointer
	movl	-36(%rbp), %eax       # Load pixel value
	movl	%eax, (%rdx)          # Store pixel value in output image

	jmp	.Lpixel_done

.Lend_tile_copy:
	nop

.Lpixel_done:
	addl	$1, -8(%rbp)          # Increment column index

.Lcol_loop:
	movl	-8(%rbp), %eax        # Load column index
	cmpl	-12(%rbp), %eax       # Compare with tile width
	jl	.Lprocess_pixel        # If column index < tile width, continue

	addl	$1, -4(%rbp)          # Increment row index

.Lrow_loop_start:
	movl	-4(%rbp), %eax        # Load row index
	cmpl	-16(%rbp), %eax       # Compare with tile height
	jl	.Lcol_loop_start       # If row index < tile height, continue

.Ltile_exit_func:
	leave                        # Restore base pointer and stack
	ret                          # Return

.Linvalid_tile:
	movl	$0, %eax              # Return 0 for invalid conditions
	jmp	.Ltile_exit_func            # Jump to return

/*
 * Register use:
 *   %rbp - base pointer for the stack frame
 *   %rsp - stack pointer, used for adjusting the stack
 *   %edi - holds the input pixel argument (32-bit value)
 *   %eax - used for storing the pixel value and result (red component)
 *
 * Memory:
 *   No explicit use of stack memory beyond the base pointer and stack pointer for setting up and tearing down the stack frame.
 *
 *   The function extracts the red color component from a 32-bit pixel value.
 *   It shifts the input value right by 24 bits to move the red component to the lowest 8 bits.
 *   It then applies a mask to isolate the red component and returns it.
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

/*
 * Register use:
 *   %rbp - base pointer for the stack frame
 *   %rsp - stack pointer, used for adjusting the stack
 *   %edi - holds the input pixel argument (32-bit value)
 *   %eax - used for storing the pixel value and result (green component)
 *
 * Memory:
 *   No explicit use of stack memory beyond the base pointer and stack pointer for setting up and tearing down the stack frame.
 *
 *   This function extracts the green color component from a 32-bit pixel value.
 *   It shifts the input value right by 16 bits to move the green component to the lowest 8 bits.
 *   Then, it applies a mask to isolate the green component and returns it.
 */

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

/*
 *
 * Register use:
 *   %rbp - base pointer for the stack frame
 *   %rsp - stack pointer, used for adjusting the stack
 *   %edi - holds the input pixel argument (32-bit value)
 *   %eax - used for storing the pixel value and result (blue component)
 *
 * Memory:
 *   No explicit use of stack memory beyond the base pointer and stack pointer for setting up and tearing down the stack frame.
 *
 *   This function extracts the blue color component from a 32-bit pixel value.
 *   It shifts the input value right by 8 bits to move the blue component to the lowest 8 bits.
 *   Then, it applies a mask to isolate the blue component and returns it.
 */
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

/*
 *
 * Register use:
 *   %rbp - base pointer for the stack frame
 *   %rsp - stack pointer, used for adjusting the stack
 *   %edi - holds the input pixel argument (32-bit value)
 *   %eax - used for storing the pixel value and result (alpha component)
 *
 * Memory:
 *   No explicit use of stack memory beyond the base pointer and stack pointer for setting up and tearing down the stack frame.
 *
 *   This function extracts the alpha component from a 32-bit pixel value.
 *   It directly applies a mask to the least significant 8 bits to isolate the alpha component and returns it.
 */

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

/*
 * Register use:
 *   %rdi - red component (input)
 *   %rsi - green component (input)
 *   %rdx - blue component (input)
 *   %rcx - alpha component (input)
 *   %rax - final packed pixel (output)
 *
 * Memory:
 *   No explicit use of stack memory beyond the base pointer and stack pointer for setting up and tearing down the stack frame.
 *
 *   This function packs the red, green, blue, and alpha components into a 32-bit pixel value.
 *   It shifts each component to its correct position in the 32-bit pixel and combines them using bitwise OR.
 *   The final packed pixel is returned in %rax.
 */
    .globl make_pixel
make_pixel:

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

/*
 * Register use:
 *   %rbp - base pointer for the stack frame
 *   %rsp - stack pointer, used for adjusting the stack
 *   %edi - holds the input pixel argument (32-bit value)
 *   %ebx - holds the original pixel value (callee-saved)
 *   %r12d - holds the red component and later the grayscale value
 *   %r13d - holds the green component
 *   %r14d - holds the blue component
 *   %r15d  - holds the alpha component
 *   %eax  - used for temporary calculations (grayscale)
 *   %ecx  - used for combining color components into the final pixel
 *
 * Memory:
 *   No explicit use of stack memory beyond the base pointer and stack pointer for setting up and tearing down the stack frame.
 *
 *   This function converts a 32-bit pixel (ARGB format) to grayscale using a weighted average formula:
 *   grayscale = (79 * red + 128 * green + 49 * blue) / 256.
 *   It then combines the grayscale value with the original alpha component to produce a 32-bit grayscale pixel.
 */
    .global to_grayscale
to_grayscale:
    # Prologue: Set up the stack frame
    pushq   %rbp
    movq    %rsp, %rbp

	# Save pixel in callee-saved register (store %edi in %ebx for later)
	movl    %edi, %ebx

	# Extract red component
    movl    %ebx, %edi			# Move pixel (in %edi) to %edi as func. param.
    call    get_r				# Call get_r to get red component
    movl    %eax, %r12d         # Save red component in %r12d for later

	# Extract green component
    movl    %ebx, %edi			# Move pixel (in %edi) to %edi as func. param.
    call    get_g				# Call get_g to get green component
    movl    %eax, %r13d         # Save green component in %r13d for later

	# Extract blue component
    movl    %ebx, %edi			# Move pixel (in %edi) to %edi as func. param.
    call    get_b				# Call get_b to get blue component
    movl    %eax, %r14d         # Save blue component in %r14d for later

	# Preserve alpha component
    movl    %ebx, %edi			# Move pixel (in %edi) to %edi as func. param.
    call    get_a				# Call get_a to get alpha component
    movl    %eax, %r15d         # Save alpha component in %r15d for later

	# Compute grayscale value using weighted average (79 * r + 128 * g + 49 * b) / 256
    movl    %r12d, %eax         # Move red component to %eax
    imull   $79, %eax           # Multiply by 79 (r * 79)

    movl    %r13d, %ecx         # Move green component to %ecx
    imull   $128, %ecx          # Multiply by 128 (g * 128)
    addl    %ecx, %eax          # Add green contribution to %eax

    movl    %r14d, %ecx         # Move blue component to %ecx
    imull   $49, %ecx           # Multiply by 49 (b * 49)
    addl    %ecx, %eax          # Add blue contribution to %eax

    shrl    $8, %eax            # Divide the total by 256 (shift right by 8 bits)

	# Now %eax contains grayscale value (y)
    movl    %eax, %ebx          # Save grayscale value in %ebx

	# Use grayscale value as parameters when calling make_pixel
    movl    %ebx, %edi			# Pass grayscale value as red component param. in make_pixel
    movl    %ebx, %esi			# Pass grayscale value as green component param. in make_pixel
    movl    %ebx, %edx			# Pass grayscale value as blue component param. in make_pixel
    movl    %r15d, %ecx			# Pass extracted alpha as alpha component param. in make_pixel

	# Create grayscale pixel with same alpha value by calling make_pixel
    call 	make_pixel

    # Epilogue: Restore stack and return
    popq    %rbp                # Restore base pointer
    ret                         # Return with the grayscale pixel

    .globl blend_components
blend_components:
    # Arguments:
    # fg in %edi
    # bg in %esi
    # alpha in %edx

    pushq   %rbp
    movq    %rsp, %rbp

    movl    %edi, %eax
    imull   %edx, %eax

    movl    $255, %ecx
    subl    %edx, %ecx

    imull   %esi, %ecx
    addl    %ecx, %eax

    movl    $255, %ecx
    cltq
    cqto
    idivl   %ecx

    popq    %rbp
    ret

    .globl blend_colors
blend_colors:
    # Arguments:
    # fg: %edi
    # bg: #esi

    # Prologue
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $24, %rsp

    # Store argument values in stack
    movl    %edi, -4(%rbp)
    movl    %esi, -8(%rbp)

    # Get component values from fg
    movl    -4(%rbp), %edi
    call    get_r
    movl    %eax, %r12d

    movl    -4(%rbp), %edi
    call    get_g
    movl    %eax, %r13d

    movl    -4(%rbp), %edi
    call    get_b
    movl    %eax, %r14d

    movl    -4(%rbp), %edi
    call    get_a
    movl    %eax, %r15d

    # Get component values from bg
    movl    -8(%rbp), %edi
    call    get_r
    movl    %eax, -12(%rbp)

    movl    -8(%rbp), %edi
    call    get_g
    movl    %eax, -16(%rbp)

    movl    -8(%rbp), %edi
    call    get_b
    movl    %eax, -20(%rbp)

    # Blend red component
    movl    %r12d, %edi
    movl    -12(%rbp), %esi
    movl    %r15d, %edx
    call    blend_components
    movl    %eax, %r12d

    # Blend green component
    movl    %r13d, %edi
    movl    -16(%rbp), %esi
    movl    %r15d, %edx
    call    blend_components
    movl    %eax, %r13d

    # Blend blue component
    movl    %r14d, %edi
    movl    -20(%rbp), %esi
    movl    %r15d, %edx
    call    blend_components
    movl    %eax, %r14d

    # Make pixel from blended components
    movl    %r12d, %edi
    movl    %r13d, %esi
    movl    %r14d, %edx
    movl    $255, %ecx
    call    make_pixel

    # Exit
    addq    $24, %rsp
    popq    %rbp
    ret

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
 *   %rdi - pointer to original struct Image (input image)
 *   %esi - tiling factor (n), how many rows and columns of tiles to generate
 *   %rdx - pointer to output struct Image (resulting tiled image)
 *
 * Returns (in %eax):
 *   1 if successful, or 0 if the transformation fails because n is less than 1,
 *   or because the resulting tiles would have 0 width or height.
 *
 * Memory use:
 *   -24(%rbp) - input image pointer
 *   -28(%rbp) - tiling factor (n)
 *   -40(%rbp) - output image pointer
 *   -4(%rbp)  - current row index (y)
 *   -8(%rbp)  - current column index (x)
 */

    .globl imgproc_tile
imgproc_tile:
	pushq	%rbp                    # Save base pointer
	movq	%rsp, %rbp              # Set up stack frame
	subq	$40, %rsp               # Allocate space on the stack
	movq	%rdi, -24(%rbp)         # Store input image pointer
	movl	%esi, -28(%rbp)         # Store tiling factor (n)
	movq	%rdx, -40(%rbp)         # Store output image pointer

	# Check if tiling factor n is valid
	cmpl	$0, -28(%rbp)           # Compare tiling factor (n) with 0
	jle	.Linvalid_tile_dimensions           # Jump to failure if n <= 0

	# Check if input image has valid dimensions (width > 0, height > 0)
	movq	-24(%rbp), %rax         # Load input image pointer
	movl	(%rax), %eax            # Load width of input image
	testl	%eax, %eax              # Check if width > 0
	jle	.Linvalid_tile_dimensions           # Jump to failure if width <= 0

	movq	-24(%rbp), %rax         # Load input image pointer
	movl	4(%rax), %eax           # Load height of input image
	testl	%eax, %eax              # Check if height > 0
	jg	.Lvalid_tile_dimensions  # Jump if height > 0

.Linvalid_tile_dimensions:
	movl	$0, %eax                # Set return value to 0 (failure)
	jmp	.Lreturn                 # Jump to return

.Lvalid_tile_dimensions:
	# Check if all tiles are non-empty
	movq	-24(%rbp), %rax         # Load input image pointer
	movl	4(%rax), %ecx           # Load height of input image
	movq	-24(%rbp), %rax         # Load input image pointer again
	movl	(%rax), %eax            # Load width of input image
	movl	-28(%rbp), %edx         # Load tiling factor (n)
	movl	%ecx, %esi              # Move height to %esi
	movl	%eax, %edi              # Move width to %edi
	call	all_tiles_nonempty       # Check if all tiles are non-empty
	testl	%eax, %eax              # Test if result is true
	jne	.Lprocess_tiles          # Jump to process tiles if true

	movl	$0, %eax                # Set return value to 0 (failure)
	jmp	.Lreturn                 # Jump to return

.Lprocess_tiles:
	movl	$0, -4(%rbp)            # Initialize row index (y) to 0
	jmp	.Lrow_loop_starting         # Jump to row loop

.Lcolumn_loop_start:
	movl	$0, -8(%rbp)            # Initialize column index (x) to 0
	jmp	.Lcolumn_loop            # Jump to column loop

.Lprocess_tile:
	# Process a single tile
	movl	-28(%rbp), %edi         # Load tiling factor (n)
	movl	-8(%rbp), %ecx          # Load column index (x)
	movl	-4(%rbp), %edx          # Load row index (y)
	movq	-24(%rbp), %rsi         # Load input image pointer
	movq	-40(%rbp), %rax         # Load output image pointer
	movl	%edi, %r8d              # Move tiling factor to %r8d
	movq	%rax, %rdi              # Move output image pointer to %rdi
	call	copy_tile               # Call copy_tile to process the current tile
	addl	$1, -8(%rbp)            # Increment column index (x)

.Lcolumn_loop:
	# Column loop: iterate over columns in the current row
	movl	-8(%rbp), %eax          # Load column index (x)
	cmpl	-28(%rbp), %eax         # Compare column index with tiling factor (n)
	jl	.Lprocess_tile           # If x < n, process the next tile

	addl	$1, -4(%rbp)            # Increment row index (y)

.Lrow_loop_starting:
	# Row loop: iterate over rows
	movl	-4(%rbp), %eax          # Load row index (y)
	cmpl	-28(%rbp), %eax         # Compare row index with tiling factor (n)
	jl	.Lcolumn_loop      # If y < n, process the next row

	movl	$1, %eax                # Set return value to 1 (success)

.Lreturn:
	leave                          # Restore base pointer and stack
	ret                            # Return from function


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
	pushq	%rbp                # Save the base pointer
	movq	%rsp, %rbp          # Set up the new stack frame
	subq	$48, %rsp           # Allocate 48 bytes of stack space
	movq	%rdi, -40(%rbp)     # Store input image pointer in stack
	movq	%rsi, -48(%rbp)     # Store output image pointer in stack
	movq	-40(%rbp), %rax     # Load input image pointer into %rax
	movl	(%rax), %eax        # Load image width from input image structure
	movl	%eax, -12(%rbp)     # Store image width in stack variable
	movq	-40(%rbp), %rax     # Load input image pointer again into %rax
	movl	4(%rax), %eax       # Load image height from input image structure
	movl	%eax, -16(%rbp)     # Store image height in stack variable
	cmpl	$0, -12(%rbp)       # Compare image width with 0
	jle	    .Lgrayscale_exit    # Exit if width <= 0
	cmpl	$0, -16(%rbp)       # Compare image height with 0
	jle	    .Lgrayscale_exit    # Exit if height <= 0
	movl	$0, -4(%rbp)        # Initialize row index (y) to 0
	jmp	    .Lgrayscale_y_loop  # Jump to the start of the row loop

.Lgrayscale_x_loop:               # Start of the column loop
	movl	$0, -8(%rbp)        # Initialize column index (x) to 0
	jmp	    .Lgrayscale_process_pixel # Jump to pixel processing

.Lgrayscale_pixel_processing:     # Begin pixel processing
	movq	-40(%rbp), %rax     # Load input image pointer into %rax
	movq	8(%rax), %rdx       # Load pixel array pointer from input image
	movl	-4(%rbp), %eax      # Load current row index (y)
	imull	-12(%rbp), %eax     # Multiply by image width to get row offset
	movl	%eax, %ecx          # Store row offset in %ecx
	movl	-8(%rbp), %eax      # Load current column index (x)
	addl	%ecx, %eax          # Add column index to row offset
	cltq                     # Convert to 64-bit value
	salq	$2, %rax            # Multiply by 4 (pixel size)
	addq	%rdx, %rax          # Add to pixel array base address
	movl	(%rax), %eax        # Load pixel value from input image
	movl	%eax, -20(%rbp)     # Store current pixel value in stack

	movl	-20(%rbp), %eax     # Load current pixel value
	movl	%eax, %edi          # Move pixel value to %edi for the to_grayscale call
	call	to_grayscale        # Call to_grayscale function
	movl	%eax, -24(%rbp)     # Store grayscale value in stack

	movq	-48(%rbp), %rax     # Load output image pointer into %rax
	movq	8(%rax), %rdx       # Load pixel array pointer from output image
	movl	-4(%rbp), %eax      # Load current row index (y)
	imull	-12(%rbp), %eax     # Multiply by image width to get row offset
	movl	%eax, %ecx          # Store row offset in %ecx
	movl	-8(%rbp), %eax      # Load current column index (x)
	addl	%ecx, %eax          # Add column index to row offset
	cltq                     # Convert to 64-bit value
	salq	$2, %rax            # Multiply by 4 (pixel size)
	addq	%rax, %rdx          # Add to pixel array base address
	movl	-24(%rbp), %eax     # Load grayscale pixel value
	movl	%eax, (%rdx)        # Store grayscale pixel in output image

	addl	$1, -8(%rbp)        # Increment column index (x)
.Lgrayscale_process_pixel:        # Continue processing pixels in the row
	movl	-8(%rbp), %eax      # Load current column index (x)
	cmpl	-12(%rbp), %eax     # Compare x with image width
	jl	    .Lgrayscale_pixel_processing # Jump to pixel processing if x < width

	addl	$1, -4(%rbp)        # Increment row index (y)
.Lgrayscale_y_loop:               # Continue processing rows
	movl	-4(%rbp), %eax      # Load current row index (y)
	cmpl	-16(%rbp), %eax     # Compare y with image height
	jl	    .Lgrayscale_x_loop  # Jump to column loop if y < height

	jmp	    .Lgrayscale_return  # Jump to return section

.Lgrayscale_exit:                 # Exit if invalid image dimensions
	nop                          # No operation

.Lgrayscale_return:               # Return from the function
	leave                        # Restore stack and base pointer
	ret                          # Return to caller


/*
 * int imgproc_composite( struct Image *base_img, struct Image *overlay_img, struct Image *output_img );
 *
 * Overlay a foreground image on a background image, using each foreground
 * pixel's alpha value to determine its degree of opacity in order to blend
 * it with the corresponding background pixel.
 *
 * Parameters:
 *   %rdi - pointer to base (background) image
 *   %rsi - pointer to overlay (foreground) image
 *   %rdx - pointer to output image (result of blending)
 *
 * Returns:
 *   1 if successful, or 0 if the transformation fails because the base
 *   and overlay images do not have the same dimensions.
 *
 * Memory use:
 *   -48(%rbp) - base image pointer
 *   -56(%rbp) - overlay image pointer
 *   -64(%rbp) - output image pointer
 *   -12(%rbp) - row index (y)
 *   -16(%rbp) - column index (x)
 *   -20(%rbp) - pixel index (1D)
 *   -24(%rbp) - foreground (overlay) pixel
 *   -28(%rbp) - background (base) pixel
 */
    .globl imgproc_composite
imgproc_composite:
    # Prologue: set up stack frame
    pushq   %rbp                 # Save base pointer
    movq    %rsp, %rbp           # Set up new base pointer
    pushq   %rbx                 # Save %rbx for later use
    subq    $56, %rsp            # Allocate space on the stack

    # Store parameters (input images and output image) in local variables
    movq    %rdi, -48(%rbp)      # Store base image pointer in local variable
    movq    %rsi, -56(%rbp)      # Store overlay image pointer in local variable
    movq    %rdx, -64(%rbp)      # Store output image pointer in local variable

    # Check if the base and overlay images have the same width
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    (%rax), %edx         # Load width of base image
    movq    -56(%rbp), %rax      # Load overlay image pointer
    movl    (%rax), %eax         # Load width of overlay image
    cmpl    %eax, %edx           # Compare base and overlay widths
    jne     .Lsize_mismatch      # Jump to failure if widths do not match

    # Check if the base and overlay images have the same height
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    4(%rax), %edx        # Load height of base image
    movq    -56(%rbp), %rax      # Load overlay image pointer
    movl    4(%rax), %eax        # Load height of overlay image
    cmpl    %eax, %edx           # Compare base and overlay heights
    je      .Lsize_match         # If height matches, continue processing

.Lsize_mismatch:
    movl    $0, %eax             # Set return value to 0 (failure)
    jmp     .Lret             # Jump to return

.Lsize_match:
    # Ensure valid dimensions (both width and height > 0)
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    (%rax), %eax         # Load width of base image
    testl   %eax, %eax           # Check if width > 0
    jle     .Linvalid_dimensions # Jump to failure if width <= 0

    movq    -48(%rbp), %rax      # Load base image pointer
    movl    4(%rax), %eax        # Load height of base image
    testl   %eax, %eax           # Check if height > 0
    jg      .Lprocess_images     # If height > 0, continue processing

.Linvalid_dimensions:
    movl    $1, %eax             # Set return value to 1 (failure due to invalid dimensions)
    jmp     .Lret             # Jump to return

.Lprocess_images:
    # Copy dimensions to output image (width and height)
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    (%rax), %edx         # Load width of base image
    movq    -64(%rbp), %rax      # Load output image pointer
    movl    %edx, (%rax)         # Copy width to output image

    movq    -48(%rbp), %rax      # Load base image pointer
    movl    4(%rax), %edx        # Load height of base image
    movq    -64(%rbp), %rax      # Load output image pointer
    movl    %edx, 4(%rax)        # Copy height to output image

    movl    $0, -12(%rbp)        # Initialize row index (y) to 0
    jmp     .Lrows_loop           # Jump to row loop

.Lrow_done:
    movl    $0, -16(%rbp)        # Initialize column index (x) to 0
    jmp     .Lcols_loop        # Jump to pixel processing loop

.Lprocessing_pixel:
    # Calculate the 1D index of the current pixel in the image arrays
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    (%rax), %eax         # Load width of base image
    imull   -12(%rbp), %eax      # Multiply width by row index (y)
    movl    %eax, %edx           # Store result (row offset)
    movl    -16(%rbp), %eax      # Load column index (x)
    addl    %edx, %eax           # Add column index to row offset
    movl    %eax, -20(%rbp)      # Store pixel index (1D)

    # Load overlay pixel (foreground)
    movq    -56(%rbp), %rax      # Load overlay image pointer
    movq    8(%rax), %rax        # Load pixel data pointer
    movl    -20(%rbp), %edx      # Load pixel index
    movslq  %edx, %rdx           # Convert pixel index to 64-bit
    salq    $2, %rdx             # Multiply by 4 (pixel size)
    addq    %rdx, %rax           # Add to base address of pixel data
    movl    (%rax), %eax         # Load pixel value (foreground)
    movl    %eax, -24(%rbp)      # Store foreground pixel

    # Load base pixel (background)
    movq    -48(%rbp), %rax      # Load base image pointer
    movq    8(%rax), %rax        # Load pixel data pointer
    movl    -20(%rbp), %edx      # Load pixel index
    movslq  %edx, %rdx           # Convert pixel index to 64-bit
    salq    $2, %rdx             # Multiply by 4 (pixel size)
    addq    %rdx, %rax           # Add to base address of pixel data
    movl    (%rax), %eax         # Load pixel value (background)
    movl    %eax, -28(%rbp)      # Store background pixel

    # Perform pixel blending (using alpha channel)
    movq    -64(%rbp), %rax      # Load output image pointer
    movq    8(%rax), %rax        # Load pixel data pointer
    movl    -20(%rbp), %edx      # Load pixel index
    movslq  %edx, %rdx           # Convert pixel index to 64-bit
    salq    $2, %rdx             # Multiply by 4 (pixel size)
    leaq    (%rax,%rdx), %rbx    # Calculate pixel memory address in output image
    movl    -28(%rbp), %edx      # Load background pixel
    movl    -24(%rbp), %eax      # Load foreground pixel
    movl    %edx, %esi           # Move background pixel to %esi
    movl    %eax, %edi           # Move foreground pixel to %edi
    call    blend_colors         # Call blend_colors function to blend pixels
    movl    %eax, (%rbx)         # Store blended pixel in output image

    addl    $1, -16(%rbp)        # Increment column index (x)
.Lcols_loop:
    # Column loop (iterate over all pixels in the row)
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    (%rax), %eax         # Load width of base image
    cmpl    %eax, -16(%rbp)      # Compare column index (x) with width
    jl      .Lprocessing_pixel      # If x < width, process next pixel

    addl    $1, -12(%rbp)        # Increment row index (y)
.Lrows_loop:
    # Row loop (iterate over all rows)
    movq    -48(%rbp), %rax      # Load base image pointer
    movl    4(%rax), %eax        # Load height of base image
    cmpl    %eax, -12(%rbp)      # Compare row index (y) with height
    jl      .Lrow_done           # If y < height, process next row

    movl    $1, %eax             # Set return value to 1 (success)

.Lret:
    movq    -8(%rbp), %rbx       # Restore %rbx
    leave                        # Restore base pointer and stack
    ret                          # Return to caller

/*
vim:ft=gas:
*/