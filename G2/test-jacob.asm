#############################################################
# These tests are slightly modified from Christian's tests.
# Correct the errors starting from the first test, 
# as they can affect each other.
#############################################################

#---------------------------------------------------
# Test simple operations. No hazards.
# addiu, addu, slt, slti, subu, and, andi,
# or, ori, lw, sw, beq, jal, jr
#---------------------------------------------------

# Test 1: addiu
# Expected result: $1 = 55
addiu $1, $zero, 55

# Test 2: addu
# Expected result: $2 = 75
addiu $2, $zero, 20
addu $zero, $zero, $zero # nop
addu $zero, $zero, $zero # nop
addu $2, $1, $2
addu $zero, $zero, $zero # nop
addu $zero, $zero, $zero # nop
addu $2, $2, $zero

# Test 3: slt
# Expected results: $3 = 1 and $4 = 0
addu $zero, $zero, $zero # nop
addu $zero, $zero, $zero # nop
slt $3, $1, $2
slt $4, $2, $1

# Test 4: slti
# Expected results: $5 = 0 and $6 = 1
slti $5, $1, 50
slti $6, $2, 80

# Test 5: subu
# Expected result: $7 = -20
subu $7, $2, $1

# Test 6: and
# Expected result: $8 = 0x00000003
and $8, $2, $1

# Test 7: andi
# Expected result: $9 = 0x00000048
andi $9, $2, 1000

# Test 8: or
# Expected result: $10 = 0x0000007f
or $10, $2, $1

# Test 9: ori
# Expected result: $11 = 0x000003eb
ori $11, $2, 1000

# Test 10: sw and lw
# Expected result: $12 = 75
sw $2 , 0($gp)
lw $12, 0($gp)

# Test 11: beq
# Expected result: $13 = $14 = 75
addu $13, $zero, $2
beq $zero, $zero, TAKEN
addu $zero, $zero, $zero # nop (for your delay slot)
addu $13, $13, $13
TAKEN:
beq $zero, $2, NOTTAKEN
addu $zero, $zero, $zero # nop (for your delay slot)
addu $14, $zero, $13
NOTTAKEN:

# Test 12: jal & jr
# Expected result: $15 = $16 = 150
jal JALTEST
addu $zero, $zero, $zero # nop (for your delay slot)
addu $15, $zero, $16
beq $zero, $zero, END
addu $zero, $zero, $zero # nop (for your delay slot)
JALTEST:
addu $16, $2, $2
jr $31
addu $zero, $zero, $zero # nop (for your delay slot)
END:


#---------------------------------------------------
# Test forwarding and hazards (depending on
# your implementation).
#---------------------------------------------------

# Test 13: Forwarding & hazards (Can be forwarded)
# Expected result: $17 = 150
addu $17, $zero, $2
addu $17, $17, $17

# Test 14: Forwarding & hazards (Must be stalled)
# Expected result: $18 = $19 = 8
addiu $18, $gp, 8 
sw $18, 4($18)
lw $18, 4($18)
sw $18, 4($18)
lw $19, 4($18)


#---------------------------------------------------
# Test the delay slot
# NOTE: Your register 20 will not correspond with
# mars.
#---------------------------------------------------

# Test 15: Delay slot
# Expected result: $20 = 16
beq $zero, $zero, DONE
addu $20, $18, $19
DONE:




