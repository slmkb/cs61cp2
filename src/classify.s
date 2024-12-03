.globl classify

.data
m0:
    .word 0, 0
m1:
    .word 0, 0
input:
    .word 0, 0

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi sp, sp, -40
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    sw  s2, 12(sp)
    sw  s3, 16(sp)
    sw  s4, 20(sp)
    sw  s5, 24(sp)
    sw  s6, 28(sp)
    sw  s7, 32(sp)
    sw  s8, 36(sp)
    
    add s0, a0, x0
    addi t0, x0, 5
    addi a0, x0, 31
    bne t0, s0, error
    add s1, a1, x0
    add s2, a2, x0
    # Read pretrained m0
    lw   a0, 4(s1)
    la   a1, m0
    addi a2, a1, 4
    call read_matrix
    add s3, a0, x0
    
    # Read pretrained m1
    lw   a0, 8(s1)
    la   a1, m1
    addi a2, a1, 4
    call read_matrix
    add s4, a0, x0

    # Read input matrix
    lw   a0, 12(s1)
    la   a1, input
    addi a2, a1, 4
    call read_matrix
    add s5, a0, x0
    
    la t0, m0
    la t1, input
    lw t0, 0(t0)
    lw t1, 4(t1) 
    mul t0, t1, t0
    addi t1, x0, 4
    mul a0, t1, t0
    call malloc
    add s6, a0, x0
    

    # Compute h = matmul(m0, input)
    la t0, m0
    add a0, s3, x0
    lw a1, 0(t0)
    lw a2, 4(t0)
    add a3, s5, x0
    la t0, input
    lw a4, 0(t0)
    lw a5, 4(t0)
    add a6, s6, x0
    call matmul
    
    # Compute h = relu(h)
    la  t0, m0
    lw  t0, 0(t0)
    la  t1, input
    lw  t1, 4(t1)
    mul a1, t0, t1
    add a0, s6, x0
    call relu
    
    la t0, m1
    la t1, input
    lw t0, 0(t0)
    lw t1, 4(t1)
    mul t0, t1, t0
    addi t1, x0, 4
    mul a0, t1, t0
    call malloc
    add s7, a0, x0
    
    # Compute o = matmul(m1, h)
    add a0, s4, x0
    la t0, m1
    lw a1, 0(t0)
    lw a2, 4(t0)
    add a3, s6, x0
    la t0, m0
    lw a4, 0(t0)
    la t0, input
    lw a5, 4(t0)
    add a6, s7, x0
    call matmul
    
    # Write output matrix o
    lw a0, 16(s1)
    add a1, s7, x0
    la t0, m1
    lw a2, 0(t0)
    la t0, input
    lw a3, 4(t0)
    call write_matrix
    
    # Compute and return argmax(o)   
    add a0, s7, x0
    la t0, m1
    lw t0, 0(t0)
    la t1, input
    lw t1, 4(t1)
    mul a1, t0, t1
    call argmax
    add s8, a0, x0
    
    # If enabled, print argmax(o) and newline
    bne x0, s2, print0
    call print_int
    li a0, '\n'
    call print_char
print0:
    add a0, s8, x0

    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    lw  s3, 16(sp)
    lw  s4, 20(sp)
    lw  s5, 24(sp)
    lw  s6, 28(sp)
    lw  s7, 32(sp)
    lw  s8, 36(sp)
    addi sp, sp, 40
 
    jr ra

error:
    j exit