# Quicksort implemented in MIPS assembly.
# To be executed in MARS (MIPS Assembler and Runtime Simulator).
# The MIPS jump and branch delay slot is not considered in the following.
.data
banner:  .ascii  "------------------------\n"
         .ascii  "--   MIPS Quicksort   --\n"
         .asciiz "------------------------\n"

comma:   .asciiz ", "
nl:      .asciiz "\n"

#array:   .word   56, 54, 32, 78, 59, 16, 32, 1, 77, -17
#array:   .word   10,9,8,7,6,5,4,3,2,1
array:   .word   1,2,3,4,5,6,7,8,9,10

.text
main:
  # Push the values of $ra, $a0, $a1 and $a2 onto the stack
  addi  $sp, $sp, -16   # adjust stack for 4 items
  sw    $ra, 12($sp)    # push the return address
  sw    $a2,  8($sp)    # push the 3 registers $a0, $a1 and $a2
  sw    $a1,  4($sp)
  sw    $a0,  0($sp)

  # Print MIPS Quicksort banner
  la    $a0, banner     # load the memory address of ascii string banner into reg $a0
  li    $v0, 4          # store syscall service number 4 for print string in reg $v0
  syscall               # issue a print string syscall

  # Place arguments and run quicksort
  la    $a0, array      # load address of array into reg $s0 (1. argumet for qsort)
  addi  $a1, $zero, 0   # store the value 0 in reg $s1 (2. argument for qsort)
  addi  $a2, $zero, 9   # store the value 9 in reg $s2 (3. argument for qsort)
  jal   qsort           # jump to the qsort procedure and save the return address

  jal printarray

  # Restore registers $ra and $a0 - $a2
  lw    $a0,  0($sp)
  lw    $a1,  4($sp)
  lw    $a2,  8($sp)
  lw    $ra, 12($sp)
  addi  $sp, $sp, 16    # adjust stack pointer to pop 4 items

  # Exit syscall
  li    $v0, 10         # exit / stop execution service number
  syscall               # syscall to perform exit


qsort:
  add   $s4, $zero, $a0

  add   $a0, $zero, $a1
  li    $v0, 1
  syscall

  li    $v0, 4
  la    $a0, comma
  syscall

  add   $a0, $zero, $a2
  li    $v0, 1
  syscall

  li    $v0, 4
  la    $a0, nl
  syscall

  add $a0, $zero, $s4


  addi  $sp, $sp, -16   # adjust stack for 4 items
  sw    $ra, 12($sp)    # push the return address
  sw    $a2,  8($sp)    # push the 3 arguments $a0=address, $a1=left, $a2=right
  sw    $a1,  4($sp)
  sw    $a0,  0($sp)

  slt   $t0, $a1, $a2           # compare indices left and right
                                # $t0 = $a1 < $a2, i.e. left < right
  beq   $t0, $zero, restore     # branch to restore if $t0 is 0, i.e. left >= right

  sll   $t0, $a1, 2             # shift two left on left index (multiply by 4)
                                # and save in $t0
  add   $t0, $a0, $t0           # add left*4 index, $t0, to array address, $a0, and
                                # save in $t0
  lw    $t1, ($t0)              # load array[left] into $t1 (= tmp)
  add   $t2, $a1, $a2           # $t2 = $a1 + $a2 <=> $t2 = left + right
  srl   $t2, $t2, 1             # $t2 = $t2 / 2 (shift right by one)

  #li    $v0, 1
  #add   $s0, $zero, $a0
  #add   $a0, $zero, $t2
  #syscall
  #add   $a0, $zero, $s0


  sll   $t2, $t2, 2

  add   $t2, $a0, $t2           # address of array[(left+right)/2] in $t2
  lw    $t3, ($t2)              # load array[(left+right)/2] into $t3
  sw    $t3, ($t0)              # save $t3 in array[left]
  sw    $t1, ($t2)              # save $t1=tmp in array[(left+right)/2] ($t2)
  add   $t2, $a1, $zero         # copy left to $t2 = last
  # $t1 = array[left]; $t2 = last = left; all other temp regs are done with.

  add   $t0, $a1, $zero         # i ($t0) = left ($a1)

  jal   printarray
  
#jal   loop                    # jump to for loop

loop:
  addi  $t0, $t0, 1             # increment i by one
  slt   $t3, $a2, $t0           # loop condition: if right < i then set $t3 = 1
  bne   $t3, $zero, continue    # branch to continue label if $t3 = 1
  
  sll   $t3, $t0, 2             # $t3 = $t0 * 4
  add   $t3, $a0, $t3           # address of array[i] in $t3 

  #hack
  add   $s2,  $zero, $t3

  lw    $t4, ($t3)              # load array[i] into $t4

  slt   $t5, $t4, $t1           # set $t5 to 1 if $t4 (array[i]) < $t1 (array[left])
  beq   $t5, $zero, loop        # if $t5 is 0 (array[i] >= array[left]), branch to loop

  addi  $t2, $t2, 1             # increment last ($t2) by 1

  sll   $t5, $t2, 2             # multiply last by 4 and put result in $t5
  add   $t5, $a0, $t5           # $t5 = array address + last * 4
  lw    $t6, ($t5)              # load array[last] (addr in $t5) into $t6 (tmp) 
  sw    $t4, ($t5)              # store array[i] ($t4) in array[last] (addr in $t5)
  sw    $t6, ($t3)              # store tmp ($t6) in array[i] (addr in $t3)

  j     loop

continue:
  #lw    $t6, ($t3)              # load array[left] (addr in $t3) into $t6 (tmp)
  lw    $t6, ($s2)              # load array[left] (addr in $t3) into $t6 (tmp)

  # Hack
  sll   $s3, $t2, 2             # multiply last by 4 and put result in $s3
  add   $s3, $a0, $s3           # $s3 = array address + last * 4

  #lw    $t7, ($t5)              # load array[last] (addr in $t5) into $t7
  lw    $t7, ($s3)              # load array[last] (addr in $t5) into $t7
  #sw    $t7, ($t3)              # store array[last] ($t7) in array[left] (addr in $3)
  sw    $t7, ($s2)              # store array[last] ($t7) in array[left] (addr in $3)
  #sw    $t6, ($t5)              # store tmp (array[left] / $t6) in array[last] (addr in $t5)
  sw    $t6, ($s3)              # store tmp (array[left] / $t6) in array[last] (addr in $t5)

  # Recursive calls 
  add   $s0, $zero, $a2         # store arg right in $s0
  addi  $a2, $t2, -1            # $a2 (3. arg) = last - 1
  jal   qsort                   # recursive call qsort

  addi  $a1, $t2, 1             # $a1 (2. arg) = last + 1
  add   $a2, $zero, $s0         # move right ($s0) back in $a2 (3. arg)
  jal   qsort                   # recursive call qsort

restore:
  lw    $a0,  0($sp)    # pop arguments
  lw    $a1,  4($sp)
  lw    $a2,  8($sp)
  lw    $ra, 12($sp)    # pop return address
  addi  $sp, $sp, 16    # adjust stack pointer to pop 4 items
  jr    $ra


printarray:
  addi  $sp, $sp, -4
  sw    $v0, 0($sp)

  # Array address is assumed to be in $a0
  add   $s0, $zero, $a0     # move $a0 (address) into $s0
printloop:
  slt   $t0, $a2, $a1       # set $t0 = 1 if $a2 (right) < $a1 (left)
  bne   $t0, $zero, loopend # end loop if right < left
  sll   $t1, $a1, 2         # multiply left ($a1) by 4
  add   $t1, $s0, $t1       # $t1 = array address + left * 4
  lw    $a0, ($t1)          # load array[left] into $a0 (arg for syscall)
  li    $v0, 1              # syscall service number for print int
  syscall                   # issue syscall for print int
  la    $a0, comma          # load address of comma string into $a0
  li    $v0, 4              # syscall service number for print string
  syscall                   # issue syscall for print string
  addi  $a1, $a1, 1         # increment left by 1
  j     printloop
loopend:
  add   $a0, $zero, $s0     # move $s0 (address) into $a0
  addi  $sp, $sp, 4
  lw    $v0, 0($sp)
  jr $ra
