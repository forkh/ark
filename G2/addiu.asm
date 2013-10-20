addiu $s0, $zero, 5
addiu $s1, $zero, 4
addu $s2, $s0, $s1


#addiu $s0, $zero, 42
#ori   $s1, $s0, 35
#nop


#addiu $s0, $zero, 42  # $s0 = 42 = 101010_2
#addiu $s1, $zero, 35  # $s1 = 35 = 100011_2
#nop
#nop
#nop
#nop
#nop
#or    $s2, $s0, $s1   # $s2 = $s0 AND $s1 = 101011_2 = 43


#addiu $s0, $zero, 42
#nop
#nop
#nop
#nop
#nop
#andi  $s1, $s0, 35

#addiu $s0, $zero, 42
#addiu $s1, $zero, 35
#nop
#nop
#nop
#nop
#nop
#and $s2, $s0, $s1



#addiu $s0, $zero, 5   # $s0 = 5
#addiu $s1, $zero, 2   # $s1 = 2
#nop
#nop
#nop
#nop
#nop
#subu  $s2, $s0, $s1   # $s2 = $s0 - $s1 = 3


#addiu $s0, $zero, 5
#nop
#nop
#nop
#nop
#nop
#slti  $s1, $s0, 10

#addiu $s0, $zero, 5
#addiu $s1, $zero, 4
#nop
#nop
#nop
#nop
#addu  $s2, $s0, $s1
#nop
#nop
#nop
#nop
#nop
#slt   $s3, $s1, $s2   # $s1 < $s2 = 4 < 9 = true  => $s3 = 1
#slt   $s3, $s2, $s1   # $s2 < $s1 = 9 < 4 = false => $s3 = 0
