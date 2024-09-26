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
    movq %rdx, %rcx               # Save n into %rcx (since idiv overwrites %rdx)
    movq %rdi, %rax               # Move width to %rax (for division)
    xorq %rdx, %rdx               # Clear %rdx for division (cqto equivalent)
    divq %rcx                     # Divide width by n
    cmpq $0, %rax                 # Check if width / n > 0
    jle .Lreturn_zero_all_tiles   # Jump if width / n <= 0

    # Perform height / n
    movq %rsi, %rax               # Move height to %rax (for division)
    xorq %rdx, %rdx               # Clear %rdx for division (cqto equivalent)
    divq %rcx                     # Divide height by n
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
    xorq %rdx, %rdx               # Clear %rdx (to avoid leftovers from previous operations)
    divq %rsi                     # Divide width by n (width / n), quotient in %rax, remainder in %rdx
    movq %rax, %r8                # Store base_tile_w (quotient) in %r8
    movq %rdx, %r9                # Store remainder (width % n) in %r9

    # Compare tile_col with remainder
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

.globl determine_tile_h
determine_tile_h:
    /* Prologue: Save base pointer and set up stack frame */
    pushq %rbp                      # Save base pointer
    movq %rsp, %rbp                 # Set base pointer to current stack pointer

    /* Parameters:
     * %edi - height (passed as first argument)
     * %esi - n (tiling factor, second argument)
     * %edx - tile_row (third argument)
     */

    # Check if n <= 0 (invalid case)
    cmpq $0, %rsi                   # Compare n with 0
    jle .Lreturn_zero               # Jump if n <= 0

    # Check if height <= 0 (invalid case)
    cmpq $0, %rdi                   # Compare height with 0
    jle .Lreturn_zero               # Jump if height <= 0

    # Check if tile_row < 0 (invalid case)
    cmpq $0, %rdx                   # Compare tile_row with 0
    jl .Lreturn_zero                # Jump if tile_row < 0

    # Check if tile_row >= n (invalid case)
    cmpq %rsi, %rdx                 # Compare tile_row with n
    jge .Lreturn_zero               # Jump if tile_row >= n

    # Calculate base_tile_h = height / n
    movq %rdi, %rax                 # Move height into %rax
    cqto                            # Sign extend %rax for division
    idivq %rsi                      # Divide height by n (height / n), quotient in %rax, remainder in %rdx
    movq %rax, %r8                  # Store base_tile_h (quotient) in %r8
    movq %rdx, %r9                  # Store remainder (height % n) in %r9

    # Compare tile_row with remainder
    cmpq %r9, %rdx                  # Compare tile_row with remainder
    jge .Lreturn_base_tile_h         # Jump if tile_row >= remainder (no extra pixel)

    # If tile_row < remainder, add 1 to base_tile_h
    incq %r8                        # Increment base_tile_h by 1

.Lreturn_base_tile_h:
    # Return the final tile height (base_tile_h + 1 if necessary)
    movq %r8, %rax                  # Move result into %rax

    # Epilogue: Clean up stack and return
    popq %rbp
    ret

.Lreturn_zero:
    # Return 0 for invalid cases
    movq $0, %rax                   # Return 0 in %rax
    popq %rbp
    ret

.globl determine_tile_x_offset
determine_tile_x_offset:
    # Input: 
    #   width in %rdi (image width)
    #   n in %rsi (tiling factor, number of tiles)
    #   tile_col in %rdx (column index of tile)
    #
    # Output: 
    #   %rax - the x-offset for the tile
    
    # Check if n == 0, return 0 if true (to handle division by zero)
    test %rsi, %rsi       # Test if n is zero
    jz return_zero        # Jump to return_zero if n == 0

    # Check if tile_col is out of bounds (tile_col < 0 or tile_col >= n)
    cmp $0, %rdx          # Compare tile_col with 0
    jl return_zero        # Jump to return_zero if tile_col < 0
    cmp %rsi, %rdx        # Compare tile_col with n
    jge return_zero       # Jump to return_zero if tile_col >= n

    # Check if width == 0, return 0 if true
    test %rdi, %rdi       # Test if width is zero
    jz return_zero        # Jump to return_zero if width == 0

    # Calculate base width for each tile: width / n
    mov %rdi, %rax        # Move width to rax
    cqo                   # Sign extend rax into rdx:rax (prepare for division)
    idiv %rsi             # Divide width by n, quotient in rax, remainder in rdx

    # rax now holds base width (width / n)
    # rdx holds the remainder (width % n)

    # Multiply tile_col by base width to get initial offset
    mov %rdx, %r8         # Save the remainder (rdx) to r8
    mov %rax, %r9         # Save the base width to r9
    imul %rdx, %rdx       # tile_col * base_width, result in rdx (offset)

    # Check if tile_col is less than the remainder. If so, add 1 to the offset
    cmp %r8, %rdx         # Compare tile_col with remainder
    jl add_one            # If tile_col < remainder, jump to add_one

return_offset:
    # Return the calculated offset in %rax
    ret

return_zero:
    xor %rax, %rax        # Return 0
    ret

add_one:
    add $1, %rdx          # Add 1 to the offset
    jmp return_offset      # Jump to return offset

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
    xorq %rdx, %rdx               # Clear %rdx before division
    divq %rsi                     # Divide height by n, quotient in %rax (base_tile_h), remainder in %rdx
    movq %rax, %r8                # Store base_tile_h in %r8
    movq %rdx, %r9                # Store remainder in %r9

    # Multiply tile_row by base_tile_h
    movq %r8, %rax                # Move base_tile_h to %rax
    imulq %rdx, %rax, %rdx        # Multiply tile_row by base_tile_h, result in %rdx

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

        .globl imgproc_mirror_h
imgproc_mirror_h:
    # Prologue: Save base pointer and establish stack frame
    pushq %rbp
    movq %rsp, %rbp
    subq $16, %rsp                # Reserve 16 bytes for local variables

    # Save callee-saved registers
    pushq %r12                    # Save r12 (input image pointer)
    pushq %r13                    # Save r13 (output image pointer)
    pushq %r14                    # Save r14 (width / 2)
    pushq %r15                    # Save r15 (temporary for loop counters)

    # Load input image's width and height from the struct Image
    movl (%rdi), %r8d             # Load width from input_img->width (32-bit) -> offset 0
    movl 4(%rdi), %r9d            # Load height from input_img->height (32-bit) -> offset 4

    # Check for edge case: width <= 1 or height <= 0
    cmpl $1, %r8d                 # Compare width with 1
    jle return                    # If width <= 1, return
    testl %r9d, %r9d              # Check if height is 0 or negative
    jle return                    # If height <= 0, return

    # Load input and output image data pointers into r12 and r13 (callee-saved)
    movq 8(%rdi), %r12            # Load input_img->data (pointer to pixel array) -> offset 8
    movq 8(%rsi), %r13            # Load output_img->data (pointer to pixel array) -> offset 8

    # Calculate half width (width / 2) for swapping pixels
    movl %r8d, %r14d              # Move width to r14d
    shrl $1, %r14d                # Divide width by 2 (shift right by 1)

    # Initialize y loop counter (row iteration)
    xorl %r10d, %r10d             # y = 0 (initialize row index)

y_loop:
    cmpl %r10d, %r9d              # Compare y with height
    jge end_y_loop                # If y >= height, end loop

    # Initialize x loop counter (column iteration)
    xorl %r11d, %r11d             # x = 0 (initialize column index)

x_loop:
    cmpl %r11d, %r14d             # Compare x with width / 2
    jge end_x_loop                # If x >= width / 2, end x loop

    # Calculate mirrored_x = width - 1 - x
    movl %r8d, %r15d              # mirrored_x = width
    decl %r15d                    # mirrored_x = width - 1
    subl %r11d, %r15d             # mirrored_x -= x

    # Calculate left pixel position: y * width + x
    movl %r10d, %eax              # eax = y (row index)
    imull %r8d, %eax              # eax *= width (row * width)
    addl %r11d, %eax              # eax += x (left pixel offset)

    # Load left pixel: left_pixel = input_img->data[y * width + x]
    movl (%r12,%rax,4), %r14d     # left_pixel = input_img->data[y * width + x]

    # Calculate right pixel position: y * width + mirrored_x
    movl %r10d, %edx              # edx = y (row index)
    imull %r8d, %edx              # edx *= width (row * width)
    addl %r15d, %edx              # edx += mirrored_x (right pixel offset)

    # Load right pixel: right_pixel = input_img->data[y * width + mirrored_x]
    movl (%r12,%rdx,4), %r15d     # right_pixel = input_img->data[y * width + mirrored_x]

    # Swap the pixels in the output image
    # Store right_pixel in output_img->data[y * width + x]
    movl %r15d, (%r13,%rax,4)     # output_img->data[y * width + x] = right_pixel

    # Store left_pixel in output_img->data[y * width + mirrored_x]
    movl %r14d, (%r13,%rdx,4)     # output_img->data[y * width + mirrored_x] = left_pixel

    # Increment x and continue the loop
    incl %r11d                    # x++
    jmp x_loop

end_x_loop:
    # Increment y and continue the loop
    incl %r10d                    # y++
    jmp y_loop

end_y_loop:
    # Epilogue: Restore callee-saved registers
    popq %r15
    popq %r14
    popq %r13
    popq %r12

    # Restore the stack frame
    addq $16, %rsp                # Clean up local variable space
    movq %rbp, %rsp               # Restore the stack pointer
    popq %rbp                     # Restore base pointer
    ret                           # Return from the function

return:
    # Early return if width <= 1 or height <= 0
    addq $16, %rsp                # Clean up local variable space
    popq %rbp                     # Restore base pointer
    ret                           # Return from the function


.global imgproc_mirror_v
imgproc_mirror_v:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $32, %rsp

    movq    16(%rdi), %rax
    movl    (%rax), %eax
    movl    %eax, -4(%rbp)
    movq    20(%rdi), %rax
    movl    (%rax), %eax
    movl    %eax, -8(%rbp)

    cmpl    $1, -8(%rbp)
    jle     end_function

    xorl    %ecx, %ecx
outer_loop:
    movl    -8(%rbp), %eax
    shrl    $1, %eax
    cmpl    %eax, %ecx
    jge     end_function

    movl    -8(%rbp), %eax
    decl    %eax
    subl    %ecx, %eax
    movl    %eax, -12(%rbp)

    xorl    %edx, %edx
inner_loop:
    movl    -4(%rbp), %eax
    cmpl    %eax, %edx
    jge     next_row

    movl    %ecx, %eax
    imull   -4(%rbp), %eax
    addl    %edx, %eax
    movq    24(%rdi), %rsi
    movl    (%rsi,%rax,4), %eax
    movl    %eax, -16(%rbp)

    movl    -12(%rbp), %eax
    imull   -4(%rbp), %eax
    addl    %edx, %eax
    movl    (%rsi,%rax,4), %eax
    movl    %eax, -20(%rbp)

    movl    %ecx, %eax
    imull   -4(%rbp), %eax
    addl    %edx, %eax
    movq    24(%rsi), %rdi
    movl    -20(%rbp), %ebx
    movl    %ebx, (%rdi,%rax,4)

    movl    -12(%rbp), %eax
    imull   -4(%rbp), %eax
    addl    %edx, %eax
    movl    -16(%rbp), %ebx
    movl    %ebx, (%rdi,%rax,4)

    incl    %edx
    jmp     inner_loop

next_row:
    incl    %ecx
    jmp     outer_loop

end_function:
    addq    $32, %rsp
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
    movq    %rax, (%r10, %r8, 4) # Store the grayscale pixel

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