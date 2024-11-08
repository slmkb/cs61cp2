.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:

    # Error checks


    # Prologue
    addi sp, sp, -48
    sw  s0, 0(sp)
    sw  s1, 4(sp)
    sw  s2, 8(sp)
    sw  s3, 12(sp)
    sw  s4, 16(sp)
    sw  s5, 20(sp)
    sw  s6, 24(sp)
    sw  s7, 28(sp)
    sw  s8, 32(sp)
    sw  s9, 36(sp)
    sw  s10, 40(sp)
    sw  s11, 44(sp)
    add s0, x0, a0  #   s0 (int*)  is the pointer to the start of m0
    add s1, x0, a1  #   s1 (int)   is the # of rows (height) of m0
    add s2, x0, a2  #   s2 (int)   is the # of columns (width) of m0
    add s3, x0, a3  #   s3 (int*)  is the pointer to the start of m1
    add s4, x0, a4  #   s4 (int)   is the # of rows (height) of m1
    add s5, x0, a5  #   s5 (int)   is the # of columns (width) of m1
                    #   a6 (int*)  is the pointer to the the start of d
    mul s6, a1, a5  #   s6 (int)   is the # of elements of d
    addi s7, x0, 1  #   s7 (int)   is the counter of the first loop
    addi s8, x0, 4
outer_loop_start:
    beq s7, s6, outer_loop_end
    add s9, x0, s3  #   t3 (int*)  address of first element in column used for multiply
    addi s10, x0, 1  #   t2 (int)   is the counter of the inner loop
    
inner_loop_start:
    beq s10, s2, inner_loop_end
    add a0, x0, s0
    add a1, x0, s3
    add a2, x0, s2
    addi a3, x0, 1
    add a4, x0, s5
    jal ra, dot
    sw a0, 0(a6)
    add a6, a6, s8
    addi s10, s10, 1
    add s9, s9, s8
    j inner_loop_start
inner_loop_end:
    mul s10, s2, s8
    add s0, s0, s10
    addi t1, t1, 1
    j outer_loop_start
outer_loop_end:


    # Epilogue


    jr ra
