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
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	cmpl	$0, -12(%rbp)
	jle	.L2
	cmpl	$0, -4(%rbp)
	jle	.L2
	cmpl	$0, -8(%rbp)
	jg	.L3
.L2:
	movl	$0, %eax
	jmp	.L4
.L3:
	movl	-4(%rbp), %eax
	cltd
	idivl	-12(%rbp)
	testl	%eax, %eax
	jle	.L5
	movl	-8(%rbp), %eax
	cltd
	idivl	-12(%rbp)
	testl	%eax, %eax
	jle	.L5
	movl	$1, %eax
	jmp	.L4
.L5:
	movl	$0, %eax
.L4:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

	.globl	determine_tile_w
determine_tile_w:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	cmpl	$0, -24(%rbp)
	jle	.L8
	cmpl	$0, -20(%rbp)
	jle	.L8
	cmpl	$0, -28(%rbp)
	js	.L8
	movl	-28(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L9
.L8:
	movl	$0, %eax
	jmp	.L10
.L9:
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%eax, -4(%rbp)
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%edx, -8(%rbp)
	movl	-28(%rbp), %eax
	cmpl	-8(%rbp), %eax
	setl	%al
	movzbl	%al, %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
.L10:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:

	.globl	determine_tile_x_offset
determine_tile_x_offset:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	cmpl	$0, -24(%rbp)
	jle	.L12
	cmpl	$0, -20(%rbp)
	jle	.L12
	cmpl	$0, -28(%rbp)
	js	.L12
	movl	-28(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L13
.L12:
	movl	$0, %eax
	jmp	.L14
.L13:
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%eax, -4(%rbp)
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%edx, -8(%rbp)
	movl	-28(%rbp), %eax
	imull	-4(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %edx
	movl	-28(%rbp), %eax
	cmpl	%eax, %edx
	cmovle	%edx, %eax
	addl	%ecx, %eax
.L14:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

	.globl	determine_tile_h
determine_tile_h:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	cmpl	$0, -24(%rbp)
	jle	.L16
	cmpl	$0, -20(%rbp)
	jle	.L16
	cmpl	$0, -28(%rbp)
	js	.L16
	movl	-28(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L17
.L16:
	movl	$0, %eax
	jmp	.L18
.L17:
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%eax, -4(%rbp)
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%edx, -8(%rbp)
	movl	-28(%rbp), %eax
	cmpl	-8(%rbp), %eax
	setl	%al
	movzbl	%al, %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
.L18:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

	.globl	determine_tile_y_offset
determine_tile_y_offset:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -20(%rbp)
	movl	%esi, -24(%rbp)
	movl	%edx, -28(%rbp)
	cmpl	$0, -24(%rbp)
	jle	.L20
	cmpl	$0, -20(%rbp)
	jle	.L20
	cmpl	$0, -28(%rbp)
	js	.L20
	movl	-28(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jl	.L21
.L20:
	movl	$0, %eax
	jmp	.L22
.L21:
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%eax, -4(%rbp)
	movl	-20(%rbp), %eax
	cltd
	idivl	-24(%rbp)
	movl	%edx, -8(%rbp)
	movl	-28(%rbp), %eax
	imull	-4(%rbp), %eax
	movl	%eax, %ecx
	movl	-8(%rbp), %edx
	movl	-28(%rbp), %eax
	cmpl	%eax, %edx
	cmovle	%edx, %eax
	addl	%ecx, %eax
.L22:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
    
    .global copy_tile
copy_tile:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movl	%ecx, -72(%rbp)
	movl	%r8d, -76(%rbp)
	cmpl	$0, -76(%rbp)
	jle	.L34
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L34
	movq	-64(%rbp), %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jle	.L34
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	movl	-72(%rbp), %edx
	movl	-76(%rbp), %ecx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	determine_tile_w
	movl	%eax, -12(%rbp)
	movq	-64(%rbp), %rax
	movl	4(%rax), %eax
	movl	-68(%rbp), %edx
	movl	-76(%rbp), %ecx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	determine_tile_h
	movl	%eax, -16(%rbp)
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	movl	-72(%rbp), %edx
	movl	-76(%rbp), %ecx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	determine_tile_x_offset
	movl	%eax, -20(%rbp)
	movq	-64(%rbp), %rax
	movl	4(%rax), %eax
	movl	-68(%rbp), %edx
	movl	-76(%rbp), %ecx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	determine_tile_y_offset
	movl	%eax, -24(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L27
.L33:
	movl	$0, -8(%rbp)
	jmp	.L28
.L32:
	movl	-24(%rbp), %edx
	movl	-4(%rbp), %eax
	addl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %edx
	jge	.L35
	movl	-20(%rbp), %edx
	movl	-8(%rbp), %eax
	addl	%eax, %edx
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jge	.L35
	movl	-8(%rbp), %eax
	imull	-76(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-4(%rbp), %eax
	imull	-76(%rbp), %eax
	movl	%eax, -32(%rbp)
	movq	-64(%rbp), %rax
	movq	8(%rax), %rdx
	movq	-64(%rbp), %rax
	movl	(%rax), %eax
	imull	-32(%rbp), %eax
	movl	%eax, %ecx
	movl	-28(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -36(%rbp)
	movq	-56(%rbp), %rax
	movq	8(%rax), %rdx
	movl	-24(%rbp), %ecx
	movl	-4(%rbp), %eax
	addl	%eax, %ecx
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	imull	%ecx, %eax
	movl	-20(%rbp), %esi
	movl	-8(%rbp), %ecx
	addl	%esi, %ecx
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rdx
	movl	-36(%rbp), %eax
	movl	%eax, (%rdx)
	jmp	.L31
.L35:
	nop
.L31:
	addl	$1, -8(%rbp)
.L28:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L32
	addl	$1, -4(%rbp)
.L27:
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	.L33
	jmp	.L23
.L34:
	nop
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

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
 *   %r12d - holds the original pixel value (callee-saved)
 *   %r13d - holds the red component and later the grayscale value
 *   %r14d - holds the green component
 *   %r15d - holds the blue component
 *   %ebx  - holds the alpha component
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

    .globl to_grayscale
to_grayscale:
    # Prologue: Set up the stack frame
    pushq   %rbp
    movq    %rsp, %rbp

    // # Save pixel in callee-saved register (store %edi in %r12 for later)
    // movl    %edi, %r12d

    // # Extract the red component
    // movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    // shrl    $24, %eax           # Shift right 24 bits to get red component
    // movl    %eax, %r13d         # Save red component in %r13d for later

    // # Extract the green component
    // movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    // shrl    $16, %eax           # Shift right 16 bits to get green component
    // andl    $0xFF, %eax         # Mask to get the green component (8 bits)
    // movl    %eax, %r14d         # Save green component in %r14d for later

    // # Extract the blue component
    // movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    // shrl    $8, %eax            # Shift right 8 bits to get blue component
    // andl    $0xFF, %eax         # Mask to get the blue component (8 bits)
    // movl    %eax, %r15d         # Save blue component in %r15d for later

    // # Preserve the alpha component
    // movl    %edi, %eax          # Move the pixel (in %edi) to %eax
    // andl    $0xFF, %eax         # Mask to get the alpha component (8 bits)
    // movl    %eax, %ebx          # Save alpha component in %ebx for later

    // # Compute the grayscale value using weighted average (79 * r + 128 * g + 49 * b) / 256
    // movl    %r13d, %eax         # Move red component to %eax
    // imull   $79, %eax           # Multiply by 79 (r * 79)

    // movl    %r14d, %ecx         # Move green component to %ecx
    // imull   $128, %ecx          # Multiply by 128 (g * 128)
    // addl    %ecx, %eax          # Add green contribution to %eax

    // movl    %r15d, %ecx         # Move blue component to %ecx
    // imull   $49, %ecx           # Multiply by 49 (b * 49)
    // addl    %ecx, %eax          # Add blue contribution to %eax

    // shrl    $8, %eax            # Divide the total by 256 (shift right by 8 bits)

    // # Now %eax contains the grayscale value (y)
    // movl    %eax, %r13d         # Save grayscale value in %r13d

    // # Create the grayscale pixel with the same alpha value
    // movl    %r13d, %eax         # Move grayscale value to %eax
    // shll    $24, %eax           # Shift grayscale value to the red component

    // movl    %r13d, %ecx         # Move grayscale value to %ecx
    // shll    $16, %ecx           # Shift grayscale value to the green component
    // orl     %ecx, %eax          # OR it with %eax

    // movl    %r13d, %ecx         # Move grayscale value to %ecx
    // shll    $8, %ecx            # Shift grayscale value to the blue component
    // orl     %ecx, %eax          # OR it with %eax

    // movl    %ebx, %ecx          # Move alpha component to %ecx
    // orl     %ecx, %eax          # OR it with %eax (combine grayscale with alpha)

    movl    %edi, %ebx

    movl    %ebx, %edi
    call    get_r
    movl    %eax, %r12d

    movl    %ebx, %edi
    call    get_g
    movl    %eax, %r13d

    movl    %ebx, %edi
    call    get_b
    movl    %eax, %r14d

    movl    %ebx, %edi
    call    get_a
    movl    %eax, %r15d

    movl    %r12d, %eax         # Move red component to %eax
    imull   $79, %eax           # Multiply by 79 (r * 79)

    movl    %r13d, %ecx         # Move green component to %ecx
    imull   $128, %ecx          # Multiply by 128 (g * 128)
    addl    %ecx, %eax          # Add green contribution to %eax

    movl    %r14d, %ecx         # Move blue component to %ecx
    imull   $49, %ecx           # Multiply by 49 (b * 49)
    addl    %ecx, %eax          # Add blue contribution to %eax

    shrl    $8, %eax            # Divide the total by 256 (shift right by 8 bits)

    movl    %eax, %ebx          # Save grayscale value in %r13d

    movl    %ebx, %edi
    movl    %ebx, %esi
    movl    %ebx, %edx
    movl    %r15d, %ecx

    call make_pixel

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

    // movq    %rdi, %r12          # Move fg to %r12
    // movq    %rsi, %r13          # Move bg to %r13
    // movq    %rdx, %r14          # Move alpha to %r14
    // movq    $255, %r15          # Store 255 constant to %r15

    // imulq   %r14, %r12          # Multiply alpha by fg
    // subq    %r14, %r15          # Subtract alpha from 255
    // imulq   %r14, %r13          # Multiply prev. result by bg
    // addq    %r12, %r13          # Add 1st product w/ 2nd product
    // movq    %r13, %rax          # Move sum to %rax
    // cqto                        # Convert quad in %rax to octo in %rdx:%rax
    // divq    %r15                # Divide sum in %rdx:%rax by 255

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
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$40, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	%rdx, -40(%rbp)
	cmpl	$0, -28(%rbp)
	jle	.L71
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L71
	movq	-24(%rbp), %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jg	.L72
.L71:
	movl	$0, %eax
	jmp	.L73
.L72:
	movq	-24(%rbp), %rax
	movl	4(%rax), %ecx
	movq	-24(%rbp), %rax
	movl	(%rax), %eax
	movl	-28(%rbp), %edx
	movl	%ecx, %esi
	movl	%eax, %edi
	call	all_tiles_nonempty
	testl	%eax, %eax
	jne	.L74
	movl	$0, %eax
	jmp	.L73
.L74:
	movl	$0, -4(%rbp)
	jmp	.L75
.L78:
	movl	$0, -8(%rbp)
	jmp	.L76
.L77:
	movl	-28(%rbp), %edi
	movl	-8(%rbp), %ecx
	movl	-4(%rbp), %edx
	movq	-24(%rbp), %rsi
	movq	-40(%rbp), %rax
	movl	%edi, %r8d
	movq	%rax, %rdi
	call	copy_tile
	addl	$1, -8(%rbp)
.L76:
	movl	-8(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L77
	addl	$1, -4(%rbp)
.L75:
	movl	-4(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jl	.L78
	movl	$1, %eax
.L73:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

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
imgproc_composite:
.LFB24:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$56, %rsp
	.cfi_offset 3, -24
	movq	%rdi, -48(%rbp)
	movq	%rsi, -56(%rbp)
	movq	%rdx, -64(%rbp)
	movq	-48(%rbp), %rax
	movl	(%rax), %edx
	movq	-56(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jne	.L89
	movq	-48(%rbp), %rax
	movl	4(%rax), %edx
	movq	-56(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, %edx
	je	.L90
.L89:
	movl	$0, %eax
	jmp	.L91
.L90:
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	testl	%eax, %eax
	jle	.L92
	movq	-48(%rbp), %rax
	movl	4(%rax), %eax
	testl	%eax, %eax
	jg	.L93
.L92:
	movl	$1, %eax
	jmp	.L91
.L93:
	movq	-48(%rbp), %rax
	movl	(%rax), %edx
	movq	-64(%rbp), %rax
	movl	%edx, (%rax)
	movq	-48(%rbp), %rax
	movl	4(%rax), %edx
	movq	-64(%rbp), %rax
	movl	%edx, 4(%rax)
	movl	$0, -12(%rbp)
	jmp	.L94
.L97:
	movl	$0, -16(%rbp)
	jmp	.L95
.L96:
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %edx
	movl	-16(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -20(%rbp)
	movq	-56(%rbp), %rax
	movq	8(%rax), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -24(%rbp)
	movq	-48(%rbp), %rax
	movq	8(%rax), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	addq	%rdx, %rax
	movl	(%rax), %eax
	movl	%eax, -28(%rbp)
	movq	-64(%rbp), %rax
	movq	8(%rax), %rax
	movl	-20(%rbp), %edx
	movslq	%edx, %rdx
	salq	$2, %rdx
	leaq	(%rax,%rdx), %rbx
	movl	-28(%rbp), %edx
	movl	-24(%rbp), %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	blend_colors
	movl	%eax, (%rbx)
	addl	$1, -16(%rbp)
.L95:
	movq	-48(%rbp), %rax
	movl	(%rax), %eax
	cmpl	%eax, -16(%rbp)
	jl	.L96
	addl	$1, -12(%rbp)
.L94:
	movq	-48(%rbp), %rax
	movl	4(%rax), %eax
	cmpl	%eax, -12(%rbp)
	jl	.L97
	movl	$1, %eax
.L91:
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

/*
vim:ft=gas:
*/