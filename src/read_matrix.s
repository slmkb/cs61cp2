.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
    
    # Prologue
    addi sp, sp, -32
    sw  ra, 0(sp)
    sw  s0, 4(sp)
    sw  s1, 8(sp)
    sw  s2, 12(sp)
    sw  s3, 16(sp)
    sw  s4, 20(sp)
    sw  s5, 24(sp)
    sw  s6, 28(sp)
    
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add a1, x0, x0
    call fopen
    add s4, a0, x0
    addi t0, x0, -1
    addi a0, x0, 27
    beq s4, t0, error
    add a0, s4, x0
    add a1, s1, x0
    addi a2, x0, 4
    call fread
    add t0, a0, x0
    addi a0, x0, 29
    addi t1, x0, 4
    bne t0, t1, error
    add a0, s4, x0
    add a1, s2, x0
    addi a2, x0, 4
    call fread
    add t0, a0, x0
    addi a0, x0, 29
    addi t1, x0, 4
    bne t0, t1, error
    lw a1, 0(s1)
    lw a2, 0(s2)
    mul s6, a1, a2
    addi t0, x0, 4
    mul s6, s6, t0
    mul a0, s6, t0
    call malloc
    add s5, a0, x0
    addi a0, x0, 26
    beq s5, x0, error
    add a0, s4, x0
    add a1, s5, x0
    add a2, s6, x0
    call fread
    
    add t0, a0, x0
    bne s6, t0, error
    
    add a0, s4, x0
    call fclose
    add t0, a0, x0
    addi a0, x0, 28
    bne t0, x0, error
    
    add a0, s5, x0
    
    
    lw  ra, 0(sp)
    lw  s0, 4(sp)
    lw  s1, 8(sp)
    lw  s2, 12(sp)
    lw  s3, 16(sp)
    lw  s4, 20(sp)
    lw  s5, 24(sp)
    lw  s6, 28(sp)
    addi sp, sp, 32
    # Epilogue


    jr ra

error:
    j exit