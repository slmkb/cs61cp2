.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:

    # Prologue
    addi t5, x0, 1
    bge a2, t5, loop_setup
    addi a0, x0, 0x24
    j exit
loop_setup:
    blt a3, t5, stride_error
    blt a4, t5, stride_error
    addi t3, x0, 4
    addi t4, x0, 4
    mul t3, a3, t3              #byte stride 1
    mul t4, a4, t4              #byte stride 2
    add t0, x0, x0              #sum = 0
    add t6, x0, x0
loop_start:
    bge t6, a2, loop_end
    lw t1, 0(a0)
    lw t2, 0(a1)
    mul t1, t1, t2              
    add t0, t0, t1              #sum += mul
    add a0, a0, t3
    add a1, a1, t4
    addi t6, t6, 1
    j loop_start
loop_end:

    add a0, x0, t0
    # Epilogue
    jr ra

stride_error:
    addi a0, x0, 0x25
    j exit
