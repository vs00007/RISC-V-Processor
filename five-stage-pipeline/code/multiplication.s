
#lui x29, 0x10000 # x29 has the base address

#ld x7, 0(x29) # x7 = *(x29)
#ld x8, 8(x29) # x8 = *(x29 + 8)
addi x31, x0, 1
jal x1, random
addi x7, x0, -12
addi x8, x0, 8
add x10, x0, x0 #flag

add x5, x7, x0
add x6, x8, x0
add x11, x0, x6
add x12, x0, x5
add x13, x0, x0

blt x7, x0, negative_x7
blt x8, x0, negative_x8
beq x0, x0, prod_before

random:
    addi x31, x31, -2
    srli x31, x31, 32
    jalr x0, x1, 0

negative_x7: # will branch to this if x7 is negative
    sub x5, x0, x7
    add x12, x5, x0
    blt x8, x0, negative_both
    addi x10, x0, 1 # set x10
    beq x0, x0, prod_before

negative_x8: # will branch to this if x8 is negative
    sub x6, x0, x8
    addi x10, x0, 1 # set x10
    add x11, x0, x6
    beq x0, x0, prod_before
        
negative_both: # will branch to this from negative_x7 only if both x7 and x8 are negative
    sub x6, x0, x8
    add x11, x0, x6
    beq x0, x0, prod_before

prod_before:
    blt x11, x12, prod
    xor x11, x11, x12
    xor x12, x11, x12
    xor x11, x11, x12
    beq x0, x0, prod
    
prod:
    beq x11, x0, sign_check
    add x13, x13, x12
    addi x11, x11, -1
    beq x0, x0, prod
    
sign_check:
    add x9, x0, x13
    beq x10, x0, exit
    xori x9, x9, -1
    addi x9, x9, 1
exit:
    sd x9, 80(x29)  