# Quicksort implemented in MIPS assembly.
# To be executed in MARS (MIPS Assembler and Runtime Simulator).
# The MIPS jump and branch delay slot is not considered in the following.
.data
banner:  .ascii  "------------------------\n"
         .ascii  "--   MIPS Quicksort   --\n"
         .asciiz "------------------------\n"

nl:      .asciiz "\n"

array:   .word   56, 54, 32, 78, 59, 16, 32, 1, 77, -17

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

  la    $s7, array

  lw    $a0, 0($s7)
  li    $v0, 1
  syscall

  la    $a0, nl
  li    $v0, 4
  syscall

  lw    $a0, 4($s7)
  li    $v0, 1
  syscall

  la    $a0, nl
  li    $v0, 4
  syscall

  lw    $a0, 8($s7)
  li    $v0, 1
  syscall

  la    $a0, nl
  li    $v0, 4
  syscall

  lw    $a0, 12($s7)
  li    $v0, 1
  syscall

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

  sll   $t2, $t2, 2

  add   $t2, $a0, $t2           # address of array[(left+right)/2] in $t2
  lw    $t3, ($t2)              # load array[(left+right)/2] into $t3
  sw    $t3, ($t0)              # save $t3 in array[left]
  sw    $t1, ($t2)              # save $t1=tmp in array[(left+right)/2] ($t2)
  add   $t2, $a1, $zero         # copy left to $t2 = last
  # $t1 = array[left]; $t2 = last = left; all other temp regs are done with.

  add   $t0, $a1, $zero         # i ($t0) = left ($a1)
  jal   loop                    # jump to for loop

  #add   $t0, $t1, $zero         # move array[left] ($t1) into $t0

  sll   $t3, $a1, 2             # multiply index left by 4 and put in $t3
  add   $t3, $a0, $t3           # address of array[left] in $t3
  sw    $t5, ($t3)              # store array[last] $t5 in array[left] ($t3)
  sw    $t1, ($t4)              # store array[left] in array[last]
  
  add   $s0, $zero, $a2
  addi  $a2, $t2, -1
  jal   qsort

  addi  $a1, $t2, 1
  add   $a2, $zero, $s0
  jal   qsort

  j     restore


loop:
  addi  $t0, $t0, 1             # increment i by one
  slt   $t3, $a2, $t0           # loop condition: if right < i then set $t3 = 1
  bne   $t3, $zero, end         # branch to end label if $t3 = 1
  
  sll   $t3, $t0, 2             # $t3 = $t0 * 4
  add   $t3, $a0, $t3           # address of array[i] in $t3 

  add   $t7, $t3, $zero # TODO: hack

  lw    $t3, ($t3)              # load array[i] into $t3
  slt   $t4, $t3, $t1           # $t4 = 1 if $t3 (array[i]) < $t1 (array[left])
  beq   $t4, $zero, loop        # if array[i] < array[left] then jump to loop

  addi  $t2, $t2, 1             # increment last ($t2) by one
  sll   $t4, $t2, 2             # multiply last by 4 and put result in $t4
  add   $t4, $a0, $t4           # $t4 = array address + last*4
  lw    $t5, ($t4)              # load array[last] into $t5 (tmp)
  sw    $t3, ($t4)              # save array[i] ($t3) to array[last] ($t4)

  # TODO: hack
  sw    $t5, ($t7)              # save tmp in array[i] ($t3)

  j     loop

end:
  jr    $ra                     # return to qsort


restore:
  lw    $a0,  0($sp)    # pop arguments
  lw    $a1,  4($sp)
  lw    $a2,  8($sp)
  lw    $ra, 12($sp)    # pop return address
  addi  $sp, $sp, 16    # adjust stack pointer to pop 4 items
  jr    $ra
