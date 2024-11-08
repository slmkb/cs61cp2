.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi t0, x0, 1
    bge a1, t0, loop_setup
    addi a0, x0, 0x24
    j exit
loop_setup:
    lw t0, 0(a0)                #t0 = max so far
    add t1, x0, x0              #t1 = index of max so far
    addi t2, x0, 1              #t2 = counter
loop_start:
    beq a1, t2, loop_end        
    addi a0, a0, 4              #next element in array             
    lw t3, 0(a0)                #t3 = current number
    bge t0, t3, loop_continue
    add t0, x0, t3
    add t1, x0, t2
loop_continue:
    addi t2, t2, 1
    j loop_start
loop_end:
    # Epilogue
    add a0, x0, t1
    jr ra
