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

    .globl all_tiles_nonempty
all_tiles_nonempty:
    /* Prologue to set up the stack frame */
    pushq %rbp                    # Save base pointer
    movq %rsp, %rbp               # Set base pointer to current stack pointer

    /* Parameters: 
     * %edi = width
     * %esi = height
     * %edx = n
     */

    # Check if n <= 0
    cmpq $0, %rdx                 # Compare n with 0
    jle .Lreturn_zero_all_tiles   # Jump if n <= 0

    # Check if width <= 0
    cmpq $0, %rdi                 # Compare width with 0
    jle .Lreturn_zero_all_tiles   # Jump if width <= 0

    # Check if height <= 0
    cmpq $0, %rsi                 # Compare height with 0
    jle .Lreturn_zero_all_tiles   # Jump if height <= 0

    # Perform width / n
    movq %rdi, %rax               # Move width to %rax (for division)
    cqto                          # Sign-extend %rax into %rdx (division setup)
    idivq %rdx                    # Divide width by n
    cmpq $0, %rax                 # Check if width / n > 0
    jle .Lreturn_zero_all_tiles   # Jump if width / n <= 0

    # Perform height / n
    movq %rsi, %rax               # Move height to %rax (for division)
    cqto                          # Sign-extend %rax into %rdx (division setup)
    idivq %rdx                    # Divide height by n
    cmpq $0, %rax                 # Check if height / n > 0
    jle .Lreturn_zero_all_tiles   # Jump if height / n <= 0

    # If both conditions are met, return 1
    movq $1, %rax                 # Return 1 (true)
    jmp .Ldone_all_tiles          # Jump to the function epilogue

.Lreturn_zero_all_tiles:
    # Return 0 if any condition fails
    movq $0, %rax                 # Return 0 (false)

.Ldone_all_tiles:
    # Epilogue to restore stack and return
    popq %rbp                     # Restore base pointer
    ret                           # Return from the function

    .globl determine_tile_w
determine_tile_w:
    /* Prologue: Save base pointer and set up stack frame */
    pushq %rbp
    movq %rsp, %rbp

    /* Parameters:
     * %edi - width (passed as first argument)
     * %esi - n (tiling factor, second argument)
     * %edx - tile_col (third argument)
     */

    # Check if n <= 0
    cmpq $0, %rsi                 # Compare n with 0
    jle .Lreturn_zero_tile_w      # Jump if n <= 0

    # Check if width <= 0
    cmpq $0, %rdi                 # Compare width with 0
    jle .Lreturn_zero_tile_w      # Jump if width <= 0

    # Check if tile_col < 0
    cmpq $0, %rdx                 # Compare tile_col with 0
    jl .Lreturn_zero_tile_w       # Jump if tile_col < 0

    # Check if tile_col >= n
    cmpq %rsi, %rdx               # Compare tile_col with n
    jge .Lreturn_zero_tile_w      # Jump if tile_col >= n

    # Calculate base_tile_w = width / n
    movq %rdi, %rax               # Move width into %rax
    cqto                          # Sign extend %rax to prepare for division
    idivq %rsi                    # Divide width by n (width / n)
    movq %rax, %r8                # Store base_tile_w in %r8

    # Calculate remainder = width % n
    movq %rdx, %r9                # Store remainder (width % n) in %r9

    # Check if tile_col < remainder
    cmpq %r9, %rdx                # Compare tile_col with remainder
    jge .Lno_remainder_add_tile_w # Jump if tile_col >= remainder

    # If tile_col < remainder, add 1 to base_tile_w
    incq %r8                      # base_tile_w++

.Lno_remainder_add_tile_w:
    # Return base_tile_w
    movq %r8, %rax                # Move result into %rax for return

    # Epilogue: Restore stack and return
    popq %rbp
    ret

.Lreturn_zero_tile_w:
    # Return 0 for invalid cases
    movq $0, %rax                 # Return 0 in %rax
    popq %rbp
    ret


    .globl determine_tile_x_offset
determine_tile_x_offset:
    /* Prologue: Save base pointer and set up stack frame */
    pushq %rbp
    movq %rsp, %rbp

    /* Parameters:
     * %edi - width (passed as first argument)
     * %esi - n (tiling factor, second argument)
     * %edx - tile_col (third argument)
     */

    # Check if n <= 0
    cmpq $0, %rsi                 # Compare n with 0
    jle .Lreturn_zero_x_offset    # Jump if n <= 0

    # Check if width <= 0
    cmpq $0, %rdi                 # Compare width with 0
    jle .Lreturn_zero_x_offset    # Jump if width <= 0

    # Check if tile_col < 0
    cmpq $0, %rdx                 # Compare tile_col with 0
    jl .Lreturn_zero_x_offset     # Jump if tile_col < 0

    # Check if tile_col >= n
    cmpq %rsi, %rdx               # Compare tile_col with n
    jge .Lreturn_zero_x_offset    # Jump if tile_col >= n

    # Calculate base_tile_w = width / n
    movq %rdi, %rax               # Move width into %rax
    cqto                          # Sign extend %rax for division
    idivq %rsi                    # Divide width by n, quotient in %rax, remainder in %rdx
    movq %rax, %r8                # Store base_tile_w in %r8
    movq %rdx, %r9                # Store remainder in %r9

    # Calculate tile_col * base_tile_w
    movq %rdx, %rax               # Move tile_col into %rax
    imulq %r8, %rax               # Multiply tile_col by base_tile_w (tile_col * base_tile_w)

    # Compare tile_col with remainder
    cmpq %r9, %rdx                # Compare tile_col with remainder
    jge .Luse_remainder_offset    # Jump if tile_col >= remainder

    # Add tile_col to the offset if tile_col < remainder
    addq %rdx, %rax               # Add tile_col to the offset

.Luse_remainder_offset:
    # Return the calculated offset
    movq %rax, %rax               # Move the result back for return

    # Epilogue: Restore stack and return
    popq %rbp
    ret

.Lreturn_zero_x_offset:
    movq $0, %rax                 # Return 0 for invalid cases
    popq %rbp
    ret

.globl determine_tile_y_offset
determine_tile_y_offset:
    /* Prologue: Save base pointer and set up stack frame */
    pushq %rbp
    movq %rsp, %rbp

    /* Parameters:
     * %edi - height (passed as first argument)
     * %esi - n (tiling factor, second argument)
     * %edx - tile_row (third argument)
     */

    # Check if n <= 0
    cmpq $0, %rsi                 # Compare n with 0
    jle .Lreturn_zero_tile_y_offset # Jump if n <= 0

    # Check if height <= 0
    cmpq $0, %rdi                 # Compare height with 0
    jle .Lreturn_zero_tile_y_offset # Jump if height <= 0

    # Check if tile_row < 0
    cmpq $0, %rdx                 # Compare tile_row with 0
    jl .Lreturn_zero_tile_y_offset # Jump if tile_row < 0

    # Check if tile_row >= n
    cmpq %rsi, %rdx               # Compare tile_row with n
    jge .Lreturn_zero_tile_y_offset # Jump if tile_row >= n

    # Calculate base_tile_h = height / n
    movq %rdi, %rax               # Move height into %rax
    cqto                          # Sign extend %rax for division
    idivq %rsi                    # Divide height by n, quotient in %rax (base_tile_h), remainder in %rdx
    movq %rax, %r8                # Store base_tile_h in %r8
    movq %rdx, %r9                # Store remainder in %r9

    # Multiply tile_row by base_tile_h
    imulq %r8, %rdx, %rax         # Multiply tile_row by base_tile_h, result in %rax

    # Compare tile_row with remainder
    cmpq %r9, %rdx                # Compare tile_row with remainder
    jge .Ladd_remainder_tile_y_offset # Jump if tile_row >= remainder

    # If tile_row < remainder, add tile_row to base_tile_h * tile_row
    addq %rdx, %rax               # Add tile_row to the result
    jmp .Lreturn_result_tile_y_offset # Jump to return the result

.Ladd_remainder_tile_y_offset:
    # If tile_row >= remainder, add remainder to base_tile_h * tile_row
    addq %r9, %rax                # Add remainder to the result

.Lreturn_result_tile_y_offset:
    # Return the result
    movq %rax, %rax               # Move the final result into %rax (return value)

    # Epilogue: Restore stack and return
    popq %rbp                     # Restore the base pointer
    ret                           # Return

.Lreturn_zero_tile_y_offset:
    # Return 0 for invalid cases
    movq $0, %rax                 # Set return value to 0
    popq %rbp                     # Restore the base pointer
    ret                           # Return


.globl copy_tile
copy_tile:
    # Prologue
    pushq %rbp                      # Save base pointer
    movq %rsp, %rbp                 # Set stack pointer
    subq $32, %rsp                  # Reserve 32 bytes for local variables

    # Save callee-saved registers
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    # Arguments:
    # %rdi - out_img (pointer to output Image)
    # %rsi - img (pointer to input Image)
    # %edx - tile_row (index of tile row)
    # %ecx - tile_col (index of tile column)
    # %r8d - n (tiling factor)

    # Check for invalid input (n <= 0 || img->width <= 0 || img->height <= 0)
    testl %r8d, %r8d                # Check if n <= 0
    jle .Lreturn_copy_tile

    movl 8(%rsi), %eax              # Load img->width
    testl %eax, %eax                # Check if img->width <= 0
    jle .Lreturn_copy_tile

    movl 12(%rsi), %eax             # Load img->height
    testl %eax, %eax                # Check if img->height <= 0
    jle .Lreturn_copy_tile

    # Calculate tile_w: determine_tile_w(img->width, n, tile_col)
    movl 8(%rsi), %edi              # Load img->width into %edi (first argument for determine_tile_w)
    movl %r8d, %esi                 # Move n into %esi (second argument)
    movl %ecx, %edx                 # Move tile_col into %edx (third argument)
    call determine_tile_w           # Call determine_tile_w
    movl %eax, -4(%rbp)             # Store tile_w in local variable (-4(%rbp))

    # Calculate tile_h: determine_tile_h(img->height, n, tile_row)
    movl 12(%rsi), %edi             # Load img->height into %edi
    movl %r8d, %esi                 # Move n into %esi
    movl %edx, %edx                 # Move tile_row into %edx
    call determine_tile_h           # Call determine_tile_h
    movl %eax, -8(%rbp)             # Store tile_h in local variable (-8(%rbp))
    
    # Calculate tile_x_offset: determine_tile_x_offset(img->width, n, tile_col)
    movl 8(%rsi), %edi              # Load img->width into %edi
    movl %r8d, %esi                 # Move n into %esi
    movl %ecx, %edx                 # Move tile_col into %edx
    call determine_tile_x_offset    # Call determine_tile_x_offset
    movl %eax, -12(%rbp)            # Store tile_x_offset in local variable (-12(%rbp))

    # Calculate tile_y_offset: determine_tile_y_offset(img->height, n, tile_row)
    movl 12(%rsi), %edi             # Load img->height into %edi
    movl %r8d, %esi                 # Move n into %esi
    movl %edx, %edx                 # Move tile_row into %edx
    call determine_tile_y_offset    # Call determine_tile_y_offset
    movl %eax, -16(%rbp)            # Store tile_y_offset in local variable (-16(%rbp))

    # Start copying tile pixels
    xorl %r9d, %r9d                 # Initialize y = 0

.Ly_loop_copy_tile:
    cmpl -8(%rbp), %r9d             # Compare y with tile_h
    jge .Ldone_copy_tile            # If y >= tile_h, exit loop

    xorl %r10d, %r10d               # Initialize x = 0

.Lx_loop_copy_tile:
    cmpl -4(%rbp), %r10d            # Compare x with tile_w
    jge .Lnext_row_copy_tile        # If x >= tile_w, go to next row

    # Calculate sample_y = y * n
    imull %r8d, %r9d, %eax          # sample_y = y * n

    # Calculate sample_x = x * n
    imull %r8d, %r10d, %edx         # sample_x = x * n

    # Ensure sample coordinates are within image bounds
    addl %eax, -16(%rbp)            # Add tile_y_offset to sample_y
    addl %edx, -12(%rbp)            # Add tile_x_offset to sample_x

    cmpl 12(%rsi), %eax             # Compare sample_y with img->height
    jge .Lskip_pixel_copy_tile      # If sample_y >= img->height, skip pixel

    cmpl 8(%rsi), %edx              # Compare sample_x with img->width
    jge .Lskip_pixel_copy_tile      # If sample_x >= img->width, skip pixel

    # Load pixel from img->data[sample_y * img->width + sample_x]
    movl 8(%rsi), %r11d             # img->width
    imull %eax, %r11d, %eax         # sample_y * img->width
    addl %edx, %eax                 # sample_y * img->width + sample_x
    movl (%rsi,%rax,4), %r12d       # Load pixel from img->data

    # Store pixel in out_img->data
    movl 8(%rdi), %r11d             # out_img->width
    imull %r9d, %r11d, %r9d         # tile_y_offset + y
    addl %r10d, %r9d                # tile_x_offset + x
    movl %r12d, (%rdi,%r9,4)        # Store pixel to out_img->data

.Lskip_pixel_copy_tile:
    incl %r10d                      # Increment x
    jmp .Lx_loop_copy_tile          # Continue x loop

.Lnext_row_copy_tile:
    incl %r9d                       # Increment y
    jmp .Ly_loop_copy_tile          # Continue y loop

.Ldone_copy_tile:
    # Epilogue
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    addq $32, %rsp                  # Restore stack space
    popq %rbp                       # Restore base pointer
    ret                             # Return

.Lreturn_copy_tile:
    # Handle invalid case (return without doing anything)
    popq %r15
    popq %r14
    popq %r13
    popq %r12
    addq $32, %rsp
    popq %rbp
    ret




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
    # Prologue: Setup the stack frame
    pushq   %rbp                   # Save base pointer
    movq    %rsp, %rbp             # Set the new base pointer

    # Move the arguments into appropriate registers
    movl    %edi, %eax             # Move the red component (r) into %eax
    shll    $24, %eax              # Shift left red component by 24 bits (r << 24)

    movl    %esi, %ecx             # Move the green component (g) into %ecx
    shll    $16, %ecx              # Shift left green component by 16 bits (g << 16)
    orl     %ecx, %eax             # OR it with %eax (combine with red component)

    movl    %edx, %ecx             # Move the blue component (b) into %ecx
    shll    $8, %ecx               # Shift left blue component by 8 bits (b << 8)
    orl     %ecx, %eax             # OR it with %eax (combine with red and green)

    movl    %r8d, %ecx             # Move the alpha component (a) into %ecx
    orl     %ecx, %eax             # OR it with %eax (combine with red, green, and blue)

    # %eax now holds the complete pixel
    # Epilogue: Clean up and return
    popq    %rbp                   # Restore base pointer
    ret                            # Return, with the pixel in %eax



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
    ret                         # Return with the grayscale pixel in %eax

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
    # Prologue: Set up stack frame
    pushq   %rbp
    movq    %rsp, %rbp

    # Register use:
    # %rdi - pointer to original struct Image (input_img)
    # %rsi - pointer to output struct Image (output_img)
    # %rax - width of the image (input_img->width)
    # %rcx - height of the image (input_img->height)
    # %r10 - x coordinate (used to iterate over width)
    # %r11 - y coordinate (used to iterate over height)
    # %r12 - pixel in input_img
    # %r13 - pixel in output_img
    # %r14 - mirrored pixel column (width - x - 1)

    # Load the width and height of the input image into registers
    movq    8(%rdi), %rax       # Load width (input_img->width)
    movq    16(%rdi), %rcx      # Load height (input_img->height)

    # Loop through each row (y coordinate)
.Louter_loop:
    movq    $0, %r10            # Set x = 0 for each new row

.Linner_loop:
    # Calculate the mirrored column (width - x - 1)
    movq    %rax, %r14          # r14 = width
    subq    %r10, %r14          # r14 = width - x
    subq    $1, %r14            # r14 = width - x - 1 (mirror position)

    # Calculate pixel address in input image: input_img->data[y * width + x]
    movq    %r10, %r12          # r12 = x
    imulq   %rax, %r11          # r11 = y * width
    addq    %r12, %r11          # r11 = y * width + x (input pixel offset)
    movq    (%rdi), %r12        # r12 = input_img->data
    addq    %r11, %r12          # r12 = input_img->data[y * width + x]

    # Calculate pixel address in output image: output_img->data[y * width + (width - x - 1)]
    movq    %r14, %r13          # r13 = width - x - 1
    imulq   %rax, %r11          # r11 = y * width (reuse calculation)
    addq    %r13, %r11          # r11 = y * width + (width - x - 1) (output pixel offset)
    movq    (%rsi), %r13        # r13 = output_img->data
    addq    %r11, %r13          # r13 = output_img->data[y * width + (width - x - 1)]

    # Copy pixel from input to output: output_img->data[y * width + (width - x - 1)] = input_img->data[y * width + x]
    movl    (%r12), %r15d       # Load pixel from input image
    movl    %r15d, (%r13)       # Store pixel in output image

    # Increment x and check if done with the row
    incq    %r10
    cmpq    %rax, %r10          # Compare x with width
    jl      .Linner_loop        # If x < width, continue with the row

    # Increment y and check if done with all rows
    incq    %r11                # Increment y
    cmpq    %rcx, %r11          # Compare y with height
    jl      .Louter_loop        # If y < height, continue with the next row

    # Epilogue: Restore stack frame and return
    popq    %rbp
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
    # Prologue: Set up the stack frame
    pushq   %rbp
    movq    %rsp, %rbp

    # Register use:
    # %rdi - input_img pointer
    # %rsi - output_img pointer
    # %rax - width of the image (input_img->width)
    # %rcx - height of the image (input_img->height)
    # %r10 - y (current row index)
    # %r11 - mirrored_y (height - y - 1)
    # %r12 - x (column index)
    # %r13 - top pixel
    # %r14 - bottom pixel

    # Load the width and height of the input image into registers
    movq    8(%rdi), %rax        # Load width (input_img->width)
    movq    16(%rdi), %rcx       # Load height (input_img->height)

    # Edge case: If height <= 1 or width <= 0, return immediately
    cmpq    $1, %rcx
    jle     .Lexit_mirror
    cmpq    $0, %rax
    jle     .Lexit_mirror

    # Outer loop: Iterate over the rows (y)
    movq    $0, %r10             # Set y = 0
.Louter_loop_mirror:
    # Check if y >= height / 2
    movq    %rcx, %r11           # r11 = height
    shrq    $1, %r11             # r11 = height / 2
    cmpq    %r11, %r10           # Compare y with height / 2
    jge     .Lexit_mirror        # If y >= height / 2, exit

    # Calculate mirrored_y = height - 1 - y
    movq    %rcx, %r11           # r11 = height
    subq    %r10, %r11           # r11 = height - y
    subq    $1, %r11             # r11 = height - y - 1 (mirrored_y)

    # Inner loop: Iterate over each column (x)
    movq    $0, %r12             # Set x = 0
.Linner_loop_mirror:
    # Check if x >= width
    cmpq    %rax, %r12           # Compare x with width
    jge     .Lnext_row_mirror    # If x >= width, go to the next row

    # Load the top pixel: input_img->data[y * width + x]
    movq    %r12, %r13           # r13 = x
    imulq   %rax, %r10           # r10 = y * width
    addq    %r13, %r10           # r10 = y * width + x (top pixel offset)
    movq    (%rdi), %r13         # r13 = input_img->data
    movl    (%r13, %r10, 4), %r13d # Load top pixel

    # Load the bottom pixel: input_img->data[mirrored_y * width + x]
    movq    %r12, %r14           # r14 = x
    imulq   %rax, %r11           # r11 = mirrored_y * width
    addq    %r14, %r11           # r11 = mirrored_y * width + x (bottom pixel offset)
    movq    (%rdi), %r14         # r14 = input_img->data
    movl    (%r14, %r11, 4), %r14d # Load bottom pixel

    # Swap the top and bottom pixels
    # Store top pixel at output_img->data[mirrored_y * width + x]
    movq    (%rsi), %r15         # r15 = output_img->data
    movl    %r13d, (%r15, %r11, 4) # Store top pixel in mirrored row position

    # Store bottom pixel at output_img->data[y * width + x]
    movq    (%rsi), %r15         # r15 = output_img->data
    movl    %r14d, (%r15, %r10, 4) # Store bottom pixel in original row position

    # Increment x and go to the next column
    incq    %r12
    jmp     .Linner_loop_mirror

.Lnext_row_mirror:
    # Increment y and go to the next row
    incq    %r10
    jmp     .Louter_loop_mirror

.Lexit_mirror:
    # Epilogue: Restore the stack and return
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
    # Prologue: set up the stack frame
    pushq   %rbp
    movq    %rsp, %rbp

    # Register use:
    # %rdi - pointer to input_img
    # %rsi - pointer to output_img
    # %rax - width of the image (input_img->width)
    # %rcx - height of the image (input_img->height)
    # %rdx - x (current column index)
    # %r8  - y (current row index)
    # %r9  - pixel (current pixel)
    # %r10 - grayscale pixel

    # Load the width and height of the input image into registers
    movq    8(%rdi), %rax        # Load width (input_img->width)
    movq    16(%rdi), %rcx       # Load height (input_img->height)

    # Edge case: If width <= 0 or height <= 0, return immediately
    cmpq    $0, %rax
    jle     .Lexit_grayscale
    cmpq    $0, %rcx
    jle     .Lexit_grayscale

    # Outer loop: Iterate over the rows (y)
    movq    $0, %r8              # Set y = 0
.Louter_loop_grayscale:
    cmpq    %rcx, %r8            # Compare y with height
    jge     .Lexit_grayscale     # If y >= height, exit

    # Inner loop: Iterate over the columns (x)
    movq    $0, %rdx             # Set x = 0
.Linner_loop_grayscale:
    cmpq    %rax, %rdx           # Compare x with width
    jge     .Lnext_row_grayscale # If x >= width, go to the next row

    # Load the pixel from input_img->data[y * width + x]
    movq    %rdx, %r9            # r9 = x
    imulq   %rax, %r8            # r8 = y * width
    addq    %r9, %r8             # r8 = y * width + x (pixel offset)
    movq    (%rdi), %r9          # r9 = input_img->data
    movl    (%r9, %r8, 4), %r9d  # Load the pixel (32-bit RGBA)

    # Call the to_grayscale function to convert pixel to grayscale
    # Note: This would be an external function call to to_grayscale.
    call    to_grayscale          # Result goes to %rax (grayscale pixel)

    # Store the grayscale pixel in output_img->data[y * width + x]
    movq    (%rsi), %r10         # r10 = output_img->data
    movl    %rax, (%r10, %r8, 4) # Store the grayscale pixel

    # Increment x and go to the next column
    incq    %rdx
    jmp     .Linner_loop_grayscale

.Lnext_row_grayscale:
    # Increment y and go to the next row
    incq    %r8
    jmp     .Louter_loop_grayscale

.Lexit_grayscale:
    # Epilogue: Restore the stack and return
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