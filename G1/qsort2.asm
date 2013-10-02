# Quicksort implemented in MIPS assembly. 2nd version.
# To be executed in MARS (MIPS Assembler and Runtime Simulator).
# The MIPS jump and branch delay slot is not considered in the following.

.data
nl:     .asciiz "\n"
comma:  .asciiz ", "

array:  .word   56, 54, 32, 78, 59, 16, 32, 1, 77, -17

.text
main:
  # Place arguments and run quicksort
  la    $a0, array            # load address of array into reg $s0 (1. argument for qsort)
  addi  $a1, $zero, 0         # store the value 0 in reg $s1 (2. argument for qsort)
  addi  $a2, $zero, 9         # store the value 9 in reg $s2 (3. argument for qsort)
  jal   qsort                 # jump to the qsort procedure and save the return address

  # Print array
  la    $a0, array
  addi  $a1, $zero, 0
  addi  $a2, $zero, 9
  jal printIntArray

  # Exit syscall
  li    $v0, 10               # exit / stop execution service number
  syscall                     # syscall to perform exit


qsort:
  #addi  $sp, $sp, -16         # adjust stack for 4 items / 4 words
  #sw    $ra, 12($sp)          # push the return address
  #sw    $a2,  8($sp)          # push the 3 arguments $a0=address, $a1=left, $a2=right
  #sw    $a1,  4($sp)
  #sw    $a0,  0($sp)
  addi  $sp, $sp, -4          # adjust stack pointer for 1 item / 1 word
  sw    $ra, 0($sp)           # push the return address

  slt   $t0, $a1, $a2         # compare indices left and right
                              # $t0 = $a1 < $a2, i.e. left < right
  beq   $t0, $zero, restore   # branch to restore if $t0 is 0, i.e. left >= right

  sll   $t0, $a1, 2           # shift 2 left on left index (multiply by 4), save in $t0
  add   $t0, $a0, $t0         # add left*4 ($t0) to array address ($a0) and save in $t0
  lw    $t1, ($t0)            # load array[left] into $t1 (= tmp)

  add   $t2, $a1, $a2         # sum of left and right indices in $t2
  srl   $t2, $t2, 1           # divided by 2 (shift right by 1) (truncated)
  sll   $t2, $t2, 2           # converted to bytes (index * 4)
  add   $t2, $a0, $t2         # add (left+right)/2 to array address ($a0) and save in $t2
  lw    $t3, ($t2)            # load array[(left+right)/2] into $t3
  sw    $t3, ($t0)            # store array[(left+right)/2] in array[left] (addr in $t0)

  sw    $t1, ($t2)            # store array[left] / tmp ($t1) in array[(left+right)/2]

  add   $t0, $zero, $a1       # last ($t0) = left ($a1)
  add   $t2, $zero, $a1       # i ($t2) = left ($a1)

  # Relevant registers: $t0 = last, $t1 = array[left] (value), $t2 = i
loop:
  addi  $t2, $t2, 1           # increment i ($t2) by 1
  slt   $t3, $a2, $t2         # set $t3 = 1 if right ($a2) < i ($t2)
  bne   $t3, $zero, continue  # branch to continue label if $t3 = 1
  
  # If conditional
  sll   $t3, $t2, 2           # $t3 = i * 4
  add   $t3, $a0, $t3         # $t3 = array addr + i * 4
  lw    $t4, ($t3)            # load array[i] into $t4
  
  slt   $t5, $t4, $t1         # set $t5 = 1 if array[i] ($t4) < array[left] ($t1)
  beq   $t5, $zero, loop      # branch to loop if $t5 is 0 (array[i] >= array[left])

  addi  $t0, $t0, 1           # increment last ($t0) by 1

  sll   $t5, $t0, 2           # multiply last by 4 and put result in $t5
  add   $t5, $a0, $t5         # $t5 = array addr + last * 4
  lw    $t6, ($t5)            # load array[last] into $t6
  sw    $t4, ($t5)            # store array[i] ($t4) in array[last] (addr in $t5)
  sw    $t6, ($t3)            # store array[last] ($t6) in array[i] (addr in $t3)

  j     loop                  # loop

  # Relevant registers: $t0 = last, $1 = array[left] (value), $t5 = array[last] (addr),
  #                     $t6 = array[last] (value)
continue:
  add   $t2, $zero, $t1       # move array[left] into $t2

  sll   $t3, $a1, 2           # multiply left by 4 and put result in $t3
  add   $t3, $a0, $t3         # $t3 = array addr + 4 * left
  sw    $t6, ($t3)            # store array[last] ($t6) in array[left] (addr in $t3)
  sw    $t2, ($t5)            # store array[left] ($t2) in array[last] (addr in $t5)

  # Preserve right, left and last across recursive calls
  #add   $s0, $zero, $a1       # copy left index ($a1) to $s0
  #add   $s1, $zero, $a2       # copy right index ($a2) to $s1
  #add   $s2, $zero, $t0       # copy last ($t0) to $s2

  addi  $sp, $sp, -12         # adjust stack for 3 words
  sw    $a2, 8($sp)           # push right ($a2) onto stack
  sw    $a1, 4($sp)           # push left ($a2) onto stack
  sw    $t0, 0($sp)           # push last ($t0) onto stack

  # Recursive calls
  add   $a2, $zero, $t0       # copy last ($t0) to ($a2)
  addi  $a2, $a2, -1          # subtract 1 from $a2 (last)
  jal   qsort                 # recursive call qsort and place return address in $ra

  lw    $t0, 0($sp)           # pop last from stack and place in $t0
  lw    $a1, 4($sp)           # pop left from stack and place in $a1
  lw    $a2, 8($sp)           # pop right from stack and place in $a2
  addi  $sp, $sp, 12          # adjust stack

  add   $a1, $zero, $t0       # copy last ($t0) to $a1
  addi  $a1, $a1, 1           # add 1 to $a1 (last)
  jal   qsort                 # recursive call qsort and place return address in $ra

restore:
  #lw    $a0,  0($sp)          # pop arguments
  #lw    $a1,  4($sp)
  #lw    $a2,  8($sp)
  #lw    $ra, 12($sp)          # pop return address
  #addi  $sp, $sp, 16          # adjust stack pointer to pop 4 items

  lw    $ra, 0($sp)           # pop return address
  addi  $sp, $sp, 4           # adjust stack pointer to pop 1 item / 1 word

  jr    $ra


# Print integer array.
# Array address is assumed to be in $a0 and indices in $a1 and $a2.
printIntArray:
  add   $t0, $zero, $a0       # move $a0 (array address) into temp reg $t0
  add   $t1, $zero, $a1       # move $a1 (left index) into temp reg $t1 (index)

printLoop:
  slt   $t2, $a2, $t1         # set $t2 = 1 if right index < $t1 (index)
  bne   $t2, $zero, printEnd  # end loop if $t0 is 1
  sll   $t2, $t1, 2           # multiply index $t1 by 4
  add   $t3, $t0, $t2         # $t3 = array address + index * 4 (addr of next element)
  lw    $a0, ($t3)            # load array[index] into $a0 (arg for syscall)
  li    $v0, 1                # syscall service number for print int
  syscall                     # issue syscall for print int
  la    $a0, comma            # load address of comma string into $a0
  li    $v0, 4                # syscall service number for print string
  syscall                     # issue syscall for print string
  addi  $t1, $t1, 1           # increment index ($t1) by 1
  j     printLoop             # loop

printEnd:
  # Print newline
  la    $a0, nl
  li    $v0, 4
  syscall

  jr    $ra                   # Jump to return address

