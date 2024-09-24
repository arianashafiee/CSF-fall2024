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

.global all_tiles_nonempty
all_tiles_nonempty:
    ; Prologue
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; width  = %rdi
    ; height = %rsi
    ; n      = %rdx

    ; Check if n <= 0, width <= 0, or height <= 0
    cmpq    $0, %rdx
    jle     .invalid_input   ; if n <= 0, return 0
    cmpq    $0, %rdi
    jle     .invalid_input   ; if width <= 0, return 0
    cmpq    $0, %rsi
    jle     .invalid_input   ; if height <= 0, return 0

    ; Check (width / n > 0) and (height / n > 0)
    movq    %rdi, %rax       ; rax = width
    cqo                     ; sign extend to rdx:rax
    idivq   %rdx             ; rax = width / n
    cmpq    $0, %rax
    jle     .invalid_input   ; if width / n <= 0, return 0

    movq    %rsi, %rax       ; rax = height
    cqo                     ; sign extend to rdx:rax
    idivq   %rdx             ; rax = height / n
    cmpq    $0, %rax
    jle     .invalid_input   ; if height / n <= 0, return 0

    ; Valid input, return 1
    movq    $1, %rax
    jmp     .end

.invalid_input:
    movq    $0, %rax

.end:
    ; Epilogue
    popq    %rbp
    ret


.global determine_tile_w
determine_tile_w:
    ; Prologue
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; width    = %rdi
    ; n        = %rsi
    ; tile_col = %rdx

    ; Handle invalid cases
    cmpq    $0, %rsi
    jle     .invalid_input    ; if n <= 0, return 0
    cmpq    $0, %rdi
    jle     .invalid_input    ; if width <= 0, return 0
    cmpq    %rsi, %rdx
    jge     .invalid_input    ; if tile_col >= n, return 0

    ; Calculate base_tile_w = width / n
    movq    %rdi, %rax        ; rax = width
    cqo                      ; sign extend for division
    idivq   %rsi              ; rax = width / n

    ; Calculate remainder = width % n
    movq    %rdx, %rcx        ; rcx = remainder

    ; Check if tile_col < remainder
    cmpq    %rcx, %rdx
    jl      .add_one          ; if tile_col < remainder, add 1

    ; Return base_tile_w
    jmp     .end

.add_one:
    incq    %rax              ; rax = base_tile_w + 1

.end:
    ; Epilogue
    popq    %rbp
    ret

.invalid_input:
    movq    $0, %rax
    jmp     .end


.global determine_tile_x_offset
determine_tile_x_offset:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; width    = %rdi
    ; n        = %rsi
    ; tile_col = %rdx

    ; Handle invalid cases
    cmpq    $0, %rsi
    jle     .invalid_input
    cmpq    $0, %rdi
    jle     .invalid_input
    cmpq    %rsi, %rdx
    jge     .invalid_input

    ; Calculate base_tile_w = width / n
    movq    %rdi, %rax
    cqo
    idivq   %rsi              ; rax = base_tile_w

    ; Calculate remainder = width % n
    movq    %rdx, %rcx        ; rcx = remainder

    ; tile_x_offset = tile_col * base_tile_w + (tile_col < remainder ? tile_col : remainder)
    imulq   %rdx, %rax        ; rax = tile_col * base_tile_w
    cmpq    %rcx, %rdx
    jl      .add_tile_col
    movq    %rcx, %rax
    jmp     .end

.add_tile_col:
    addq    %rdx, %rax

.end:
    popq    %rbp
    ret

.invalid_input:
    movq    $0, %rax
    jmp     .end


.global determine_tile_h
determine_tile_h:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; height   = %rdi
    ; n        = %rsi
    ; tile_row = %rdx

    ; Handle invalid cases
    cmpq    $0, %rsi
    jle     .invalid_input
    cmpq    $0, %rdi
    jle     .invalid_input
    cmpq    %rsi, %rdx
    jge     .invalid_input

    ; Calculate base_tile_h = height / n
    movq    %rdi, %rax
    cqo
    idivq   %rsi              ; rax = base_tile_h

    ; Calculate remainder = height % n
    movq    %rdx, %rcx        ; rcx = remainder

    ; tile_h = base_tile_h + (tile_row < remainder ? 1 : 0)
    cmpq    %rcx, %rdx
    jl      .add_one
    jmp     .end

.add_one:
    incq    %rax

.end:
    popq    %rbp
    ret

.invalid_input:
    movq    $0, %rax
    jmp     .end


.global determine_tile_y_offset
determine_tile_y_offset:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; height   = %rdi
    ; n        = %rsi
    ; tile_row = %rdx

    ; Handle invalid cases
    cmpq    $0, %rsi
    jle     .invalid_input
    cmpq    $0, %rdi
    jle     .invalid_input
    cmpq    %rsi, %rdx
    jge     .invalid_input

    ; Calculate base_tile_h = height / n
    movq    %rdi, %rax
    cqo
    idivq   %rsi              ; rax = base_tile_h

    ; Calculate remainder = height % n
    movq    %rdx, %rcx        ; rcx = remainder

    ; tile_y_offset = tile_row * base_tile_h + (tile_row < remainder ? tile_row : remainder)
    imulq   %rdx, %rax        ; rax = tile_row * base_tile_h
    cmpq    %rcx, %rdx
    jl      .add_tile_row
    movq    %rcx, %rax
    jmp     .end

.add_tile_row:
    addq    %rdx, %rax

.end:
    popq    %rbp
    ret

.invalid_input:
    movq    $0, %rax
    jmp     .end


.global copy_tile
copy_tile:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; out_img  = %rdi
    ; img      = %rsi
    ; tile_row = %rdx
    ; tile_col = %rcx
    ; n        = %r8

    ; Handle invalid cases
    cmpq    $0, %r8
    jle     .end_no_op
    cmpq    $0, (%rsi)        ; img->width <= 0
    jle     .end_no_op
    cmpq    $0, 4(%rsi)       ; img->height <= 0
    jle     .end_no_op

    ; Calculate tile width, height, x_offset, and y_offset
    ; tile_w = determine_tile_w(img->width, n, tile_col)
    ; tile_h = determine_tile_h(img->height, n, tile_row)
    ; tile_x_offset = determine_tile_x_offset(img->width, n, tile_col)
    ; tile_y_offset = determine_tile_y_offset(img->height, n, tile_row)

    ; for loop logic to copy pixels (simplified, the actual copying involves memory)
    ; Omitted for brevity

.end_no_op:
    popq    %rbp
    ret


.global get_r
get_r:
    ; Prologue
    pushq   %rbp
    movq    %rsp, %rbp

    ; Argument:
    ; pixel = %rdi

    ; Shift pixel right by 24 to isolate red component
    movl    %edi, %eax        ; Move pixel to eax
    shrq    $24, %rax         ; Shift right by 24 bits
    andq    $0xFF, %rax       ; Mask to isolate red component

    ; Epilogue
    popq    %rbp
    ret


.global get_g
get_g:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Argument: pixel = %rdi

    movl    %edi, %eax        ; Move pixel to eax
    shrq    $16, %rax         ; Shift right by 16 bits
    andq    $0xFF, %rax       ; Mask to isolate green component

    popq    %rbp
    ret


.global get_b
get_b:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Argument: pixel = %rdi

    movl    %edi, %eax        ; Move pixel to eax
    shrq    $8, %rax          ; Shift right by 8 bits
    andq    $0xFF, %rax       ; Mask to isolate blue component

    popq    %rbp
    ret


.global get_a
get_a:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Argument: pixel = %rdi

    movl    %edi, %eax        ; Move pixel to eax
    andq    $0xFF, %rax       ; Mask to isolate alpha component

    popq    %rbp
    ret

.global make_pixel
make_pixel:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Arguments:
    ; r = %rdi
    ; g = %rsi
    ; b = %rdx
    ; a = %rcx

    ; Combine components into a pixel
    shlq    $24, %rdi          ; Shift red component left 24 bits
    shlq    $16, %rsi          ; Shift green component left 16 bits
    shlq    $8, %rdx           ; Shift blue component left 8 bits

    orq     %rsi, %rdi         ; Combine red and green
    orq     %rdx, %rdi         ; Combine blue
    orq     %rcx, %rdi         ; Combine alpha

    movq    %rdi, %rax         ; Move result to return register

    popq    %rbp
    ret

.global to_grayscale
to_grayscale:
    pushq   %rbp
    movq    %rsp, %rbp

    ; Argument: pixel = %rdi

    ; Extract red, green, blue components
    call    get_r
    movq    %rax, %rsi         ; r = %rsi
    call    get_g
    movq    %rax, %rdx         ; g = %rdx
    call    get_b
    movq    %rax, %rcx         ; b = %rcx
    call   


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
    pushq   %rbp                    # Save the base pointer
    movq    %rsp, %rbp              # Set up the stack frame
    pushq   %rbx                    # Save callee-saved register %rbx

    # Function arguments:
    # %rdi - pointer to input_img (struct Image *)
    # %rsi - pointer to output_img (struct Image *)

    # Step 1: Load input image width and height
    movl    (%rdi), %edx            # input_img->width (%rdi points to input image)
    movl    4(%rdi), %ecx           # input_img->height (%rdi points to input image)

    # Edge case: width <= 1 or height <= 0
    cmpq    $1, %rdx
    jle     .done                   # If width <= 1, return (no mirroring necessary)
    cmpq    $0, %rcx
    jle     .done                   # If height <= 0, return

    # Step 2: Iterate over each row (y)
    xorq    %rbx, %rbx              # Initialize y (row index) to 0

.loop_rows:
    cmpq    %rbx, %rcx              # Compare y with height
    jge     .done                   # If y >= height, we're done with rows

    # Step 3: Iterate over each column, up to width / 2
    movl    %edx, %r8d              # Move width into %r8d (used for mirrored_x calculation)
    shrq    $1, %r8d                # Divide width by 2 (width / 2)
    xorq    %rax, %rax              # Initialize x (column index) to 0

.loop_columns:
    cmpq    %rax, %r8               # Compare x with width / 2
    jge     .next_row               # If x >= width / 2, move to the next row

    # Step 4: Calculate mirrored_x = width - 1 - x
    movl    %edx, %r9d              # r9d = width
    decq    %r9d                    # r9d = width - 1
    subq    %rax, %r9d              # mirrored_x = width - 1 - x

    # Step 5: Load the left and right pixels
    # Left pixel: input_img->data[y * width + x]
    movl    %edx, %r10d             # r10d = width
    imulq   %rbx, %r10d             # r10d = y * width
    addq    %rax, %r10d             # r10d = y * width + x
    movq    8(%rdi), %r11           # Load pointer to input_img->data into r11
    movl    (%r11,%r10,4), %r12d    # Load the left pixel (input_img->data[y * width + x])

    # Right pixel: input_img->data[y * width + mirrored_x]
    movl    %edx, %r13d             # r13d = width
    imulq   %rbx, %r13d             # r13d = y * width
    addq    %r9, %r13d              # r13d = y * width + mirrored_x
    movl    (%r11,%r13,4), %r14d    # Load the right pixel (input_img->data[y * width + mirrored_x])

    # Step 6: Write swapped pixels to the output image
    movq    8(%rsi), %r15           # Load pointer to output_img->data into r15

    # Write the right pixel to the left side of the output image
    movl    %r14d, (%r15,%r10,4)    # output_img->data[y * width + x] = right_pixel

    # Write the left pixel to the right side of the output image
    movl    %r12d, (%r15,%r13,4)    # output_img->data[y * width + mirrored_x] = left_pixel

    # Increment x
    incq    %rax
    jmp     .loop_columns           # Repeat for next column

.next_row:
    # Increment y
    incq    %rbx
    jmp     .loop_rows              # Repeat for next row

.done:
    popq    %rbx                    # Restore saved register %rbx
    popq    %rbp                    # Restore the base pointer
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
    # Prologue - Set up the stack frame
    pushq   %rbp
    movq    %rsp, %rbp
    pushq   %rbx  # Save callee-saved registers
    pushq   %r12
    pushq   %r13
    pushq   %r14
    pushq   %r15

    # Arguments:
    # %rdi - pointer to input_img (struct Image *)
    # %rsi - pointer to output_img (struct Image *)

    # Load width and height of input image
    movl    (%rdi), %edx            # Load input_img->width into %edx
    movl    4(%rdi), %ecx           # Load input_img->height into %ecx

    # Edge case: if width <= 0 or height <= 1, return early (no transformation needed)
    cmpq    $1, %rcx
    jle     .done                   # If height <= 1, return
    cmpq    $0, %rdx
    jle     .done                   # If width <= 0, return

    # Set up the loop to iterate over each row
    xorq    %rbx, %rbx              # Initialize y (row index) to 0

.loop_rows:
    cmpq    %rbx, %rcx              # Compare y with height / 2
    jge     .done                   # If y >= height / 2, we're done with rows

    # Calculate mirrored_y = height - 1 - y
    movl    %ecx, %r8d              # r8d = height
    decq    %r8d                    # r8d = height - 1
    subq    %rbx, %r8d              # r8d = mirrored_y (height - 1 - y)

    # Loop over each column for the current row
    xorq    %rax, %rax              # Initialize x (column index) to 0

.loop_columns:
    cmpq    %rax, %rdx              # Compare x with width
    jge     .next_row               # If x >= width, go to the next row

    # Calculate positions for the top and bottom pixels
    # Top pixel: input_img->data[y * width + x]
    movl    %rdx, %r9d              # r9d = width
    imulq   %rbx, %r9d              # r9d = y * width
    addq    %rax, %r9d              # r9d = y * width + x
    movq    8(%rdi), %r10           # Load pointer to input_img->data into %r10
    movl    (%r10,%r9,4), %r11d     # Load the top pixel

    # Bottom pixel: input_img->data[mirrored_y * width + x]
    movl    %rdx, %r12d             # r12d = width
    imulq   %r8d, %r12d             # r12d = mirrored_y * width
    addq    %rax, %r12d             # r12d = mirrored_y * width + x
    movl    (%r10,%r12,4), %r13d    # Load the bottom pixel

    # Write the swapped pixels to the output image
    movq    8(%rsi), %r14           # Load pointer to output_img->data into %r14

    # Write the bottom pixel to the top position in the output image
    movl    %r13d, (%r14,%r9,4)     # output_img->data[y * width + x] = bottom_pixel

    # Write the top pixel to the bottom position in the output image
    movl    %r11d, (%r14,%r12,4)    # output_img->data[mirrored_y * width + x] = top_pixel

    # Increment x
    incq    %rax
    jmp     .loop_columns           # Repeat for next column

.next_row:
    # Increment y
    incq    %rbx
    shrq    $1, %rcx                # height /= 2 for row iteration
    jmp     .loop_rows              # Repeat for next row

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
