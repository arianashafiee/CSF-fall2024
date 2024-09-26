	.file	"c_imgproc_fns.c"
	.text
	.globl	all_tiles_nonempty
	.type	all_tiles_nonempty, @function
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
.LFE6:
	.size	all_tiles_nonempty, .-all_tiles_nonempty
	.globl	determine_tile_w
	.type	determine_tile_w, @function
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
.LFE8:
	.size	determine_tile_x_offset, .-determine_tile_x_offset
	.globl	determine_tile_h
	.type	determine_tile_h, @function
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
.LFE9:
	.size	determine_tile_h, .-determine_tile_h
	.globl	determine_tile_y_offset
	.type	determine_tile_y_offset, @function
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
.LFE10:
	.size	determine_tile_y_offset, .-determine_tile_y_offset
	.globl	copy_tile
	.type	copy_tile, @function
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
.LFE11:
	.size	copy_tile, .-copy_tile
	.globl	get_r
	.type	get_r, @function
get_r:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$24, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	get_r, .-get_r
	.globl	get_g
	.type	get_g, @function
get_g:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$16, %eax
	movzbl	%al, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	get_g, .-get_g
	.globl	get_b
	.type	get_b, @function
get_b:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	shrl	$8, %eax
	movzbl	%al, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	get_b, .-get_b
	.globl	get_a
	.type	get_a, @function
get_a:
.LFB15:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	-4(%rbp), %eax
	movzbl	%al, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	get_a, .-get_a
	.globl	make_pixel
	.type	make_pixel, @function
make_pixel:
.LFB16:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	%edx, -12(%rbp)
	movl	%ecx, -16(%rbp)
	movl	-4(%rbp), %eax
	sall	$24, %eax
	movl	%eax, %edx
	movl	-8(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movl	-12(%rbp), %eax
	sall	$8, %eax
	orl	%edx, %eax
	orl	-16(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	make_pixel, .-make_pixel
	.globl	to_grayscale
	.type	to_grayscale, @function
to_grayscale:
.LFB17:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$40, %rsp
	movl	%edi, -36(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	get_r
	movl	%eax, -4(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	get_g
	movl	%eax, -8(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	get_b
	movl	%eax, -12(%rbp)
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	get_a
	movl	%eax, -16(%rbp)
	movl	-4(%rbp), %eax
	imull	$79, %eax, %eax
	movl	-8(%rbp), %edx
	sall	$7, %edx
	addl	%eax, %edx
	movl	-12(%rbp), %eax
	imull	$49, %eax, %eax
	addl	%edx, %eax
	shrl	$8, %eax
	movl	%eax, -20(%rbp)
	movl	-16(%rbp), %ecx
	movl	-20(%rbp), %edx
	movl	-20(%rbp), %esi
	movl	-20(%rbp), %eax
	movl	%eax, %edi
	call	make_pixel
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	to_grayscale, .-to_grayscale
	.globl	blend_components
	.type	blend_components, @function
blend_components:
.LFB18:
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
	jne	.L49
	movl	-8(%rbp), %eax
	jmp	.L50
.L49:
	cmpl	$255, -12(%rbp)
	jne	.L51
	movl	-4(%rbp), %eax
	jmp	.L50
.L51:
	movl	-12(%rbp), %eax
	imull	-4(%rbp), %eax
	movl	%eax, %edx
	movl	$255, %eax
	subl	-12(%rbp), %eax
	imull	-8(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, %edx
	movl	$2155905153, %eax
	imulq	%rdx, %rax
	shrq	$32, %rax
	shrl	$7, %eax
.L50:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	blend_components, .-blend_components
	.globl	blend_colors
	.type	blend_colors, @function
blend_colors:
.LFB19:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$56, %rsp
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movl	-52(%rbp), %eax
	shrl	$24, %eax
	movl	%eax, -4(%rbp)
	movl	-52(%rbp), %eax
	shrl	$16, %eax
	andl	$255, %eax
	movl	%eax, -8(%rbp)
	movl	-52(%rbp), %eax
	shrl	$8, %eax
	andl	$255, %eax
	movl	%eax, -12(%rbp)
	movl	-52(%rbp), %eax
	movzbl	%al, %eax
	movl	%eax, -16(%rbp)
	movl	-56(%rbp), %eax
	shrl	$24, %eax
	movl	%eax, -20(%rbp)
	movl	-56(%rbp), %eax
	shrl	$16, %eax
	andl	$255, %eax
	movl	%eax, -24(%rbp)
	movl	-56(%rbp), %eax
	shrl	$8, %eax
	andl	$255, %eax
	movl	%eax, -28(%rbp)
	cmpl	$0, -16(%rbp)
	jne	.L53
	movl	-56(%rbp), %eax
	jmp	.L54
.L53:
	cmpl	$255, -16(%rbp)
	jne	.L55
	movl	-52(%rbp), %eax
	jmp	.L54
.L55:
	movl	-16(%rbp), %edx
	movl	-20(%rbp), %ecx
	movl	-4(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	blend_components
	movl	%eax, -32(%rbp)
	movl	-16(%rbp), %edx
	movl	-24(%rbp), %ecx
	movl	-8(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	blend_components
	movl	%eax, -36(%rbp)
	movl	-16(%rbp), %edx
	movl	-28(%rbp), %ecx
	movl	-12(%rbp), %eax
	movl	%ecx, %esi
	movl	%eax, %edi
	call	blend_components
	movl	%eax, -40(%rbp)
	movl	-32(%rbp), %eax
	sall	$24, %eax
	movl	%eax, %edx
	movl	-36(%rbp), %eax
	sall	$16, %eax
	orl	%eax, %edx
	movl	-40(%rbp), %eax
	sall	$8, %eax
	orl	%edx, %eax
	orb	$-1, %al
.L54:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	blend_colors, .-blend_colors
	.globl	imgproc_mirror_h
	.type	imgproc_mirror_h, @function
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
.LFE20:
	.size	imgproc_mirror_h, .-imgproc_mirror_h
	.globl	imgproc_mirror_v
	.type	imgproc_mirror_v, @function
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
.LFE21:
	.size	imgproc_mirror_v, .-imgproc_mirror_v
	.globl	imgproc_tile
	.type	imgproc_tile, @function
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
.LFE22:
	.size	imgproc_tile, .-imgproc_tile
	.globl	imgproc_grayscale
	.type	imgproc_grayscale, @function
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
.LFE23:
	.size	imgproc_grayscale, .-imgproc_grayscale
	.globl	imgproc_composite
	.type	imgproc_composite, @function
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
.LFE24:
	.size	imgproc_composite, .-imgproc_composite
	.ident	"GCC: (GNU) 14.2.1 20240801 (Red Hat 14.2.1-1)"
	.section	.note.GNU-stack,"",@progbits
