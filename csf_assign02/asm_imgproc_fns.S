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
	.size	determine_tile_w, .-determine_tile_w
	.globl	determine_tile_x_offset
	.type	determine_tile_x_offset, @function
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
 *   %rdi - pointer to original struct Image
 *   %rsi - pointer to output struct Image
 */
    .global imgproc_mirror_h
imgproc_mirror_h:
.LFB20:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-40(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -16(%rbp)
	cmpl	$1, -12(%rbp)
	jle	.L64
	cmpl	$0, -16(%rbp)
	jle	.L64
	movl	$0, -4(%rbp)
	jmp	.L60
.L63:
	movl	$0, -8(%rbp)
	jmp	.L61
.L62:
	movl	-12(%rbp), %eax
	subl	$1, %eax
	subl	-8(%rbp), %eax
	movl	%eax, -20(%rbp)
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
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
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
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, %ecx
	movl	-20(%rbp), %eax
	addl	%ecx, %eax
	cltq
	salq	$2, %rax
	addq	%rax, %rdx
	movl	-24(%rbp), %eax
	movl	%eax, (%rdx)
	addl	$1, -8(%rbp)
.L61:
	movl	-12(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	%eax, -8(%rbp)
	jl	.L62
	addl	$1, -4(%rbp)
.L60:
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	.L63
	jmp	.L56
.L64:
	nop
.L56:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

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
    .global imgproc_mirror_v
imgproc_mirror_v:
.LFB21:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	-40(%rbp), %rax
	movl	(%rax), %eax
	movl	%eax, -12(%rbp)
	movq	-40(%rbp), %rax
	movl	4(%rax), %eax
	movl	%eax, -16(%rbp)
	movl	$0, -4(%rbp)
	jmp	.L66
.L69:
	movl	-16(%rbp), %eax
	subl	$1, %eax
	subl	-4(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L67
.L68:
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
.L67:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L68
	addl	$1, -4(%rbp)
.L66:
	movl	-16(%rbp), %eax
	movl	%eax, %edx
	shrl	$31, %edx
	addl	%edx, %eax
	sarl	%eax
	cmpl	%eax, -4(%rbp)
	jl	.L69
	nop
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

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
.LFB23:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
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
	jle	.L87
	cmpl	$0, -16(%rbp)
	jle	.L87
	movl	$0, -4(%rbp)
	jmp	.L83
.L86:
	movl	$0, -8(%rbp)
	jmp	.L84
.L85:
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
.L84:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jl	.L85
	addl	$1, -4(%rbp)
.L83:
	movl	-4(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jl	.L86
	jmp	.L79
.L87:
	nop
.L79:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc

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