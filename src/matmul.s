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
    addi sp, sp, -52
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
    sw  ra, 48(sp)
    add s0, x0, a0  #   s0 (int*)  is the pointer to the start of m0
    add s1, x0, a1  #   s1 (int)   is the # of rows (height) of m0
    add s2, x0, a2  #   s2 (int)   is the # of columns (width) of m0
    add s3, x0, a3  #   s3 (int*)  is the pointer to the start of m1
    add s4, x0, a4  #   s4 (int)   is the # of rows (height) of m1
    add s5, x0, a5  #   s5 (int)   is the # of columns (width) of m1
                    #   a6 (int*)  is the pointer to the the start of d
    #mul s6, a1, a5  #   s6 (int)   is the # of elements of d
    add s7, x0, x0  #   s7 (int)   is the counter of the first loop
    addi s8, x0, 4  #   s8 (int)   byte offset for int
outer_loop_start:
    beq s7, s1, outer_loop_end
    add s11, s3, x0 #   s11 (int*)  pointer to the first element of m1
    mul a0, s8, s2  #   a0  (int)   width in bytes of m1
    mul s6, a0, s7  #   s6  (int)   width of m1 * row number
    add s10, x0, x0 #   s10 (int)   is the counter of the inner loop
inner_loop_start:
    beq s10, s1, inner_loop_end
    add a0, s6, s0  #   a0 (int*)   is the start of m0 + offest (conter of outer_loop*number of columns of m0)
    add a1, s11, x0 #   a1 (int*)   is the start of m1 + offest (column number of m1)
    add a2, s2, x0  #   a2 (int)    is the number of columns of m1
    addi a3, x0, 1  #   a3 (int)    is the stride of m0 (always 1?)
    add a4, s5, x0  #   a4 (int)    is the stride of m1 (#columns of m1)
    call dot
    sw a0, 0(a6)    
    addi a6, a6, 4 
    addi s11, s11, 4 #  s11(int*)   next column of m1
    addi s10, s10, 1
    j inner_loop_start
inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start
outer_loop_end:
    
    lw  s0, 0(sp)
    lw  s1, 4(sp)
    lw  s2, 8(sp)
    lw  s3, 12(sp)
    lw  s4, 16(sp)
    lw  s5, 20(sp)
    lw  s6, 24(sp)
    lw  s7, 28(sp)
    lw  s8, 32(sp)
    lw  s9, 36(sp)
    lw  s10, 40(sp)
    lw  s11, 44(sp)
    lw  ra, 48(sp)
    addi sp, sp, 52
    # Epilogue


    jr ra
