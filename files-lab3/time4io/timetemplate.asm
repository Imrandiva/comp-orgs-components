  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0,1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

  # you can write your code for subroutine "hexasc" below this line
  #
  
  hexasc:	
	andi 	$a0, $a1, 0xf	 #  Stores only the 4 lsb, Oxf=1111
	addi	$t0, $0, 10
	li	$v0,0x30	 #  Starting from 0x30 when values under 10
	
	slt 	$t1, $a0, $t0 	# If t1 < 10, return 1, else return 0
	bne	$t1,$0, cont	 # Go directly to adding value to return var if $t1 returned 1
	nop
	li	$v0,0x37	 #  Starting from 0x37 when values over 9
cont:
	add 	$v0, $v0,$a0
	jr	$ra
	nop

delay:
	li	$t0, 10	# For loop constant: 300 for 1000 ms delay and 100 for 3000 ms delay
	
while:
	ble	$a0,$0,exitwhile	# Exit while loop if arg < 0
	nop
	li	$t1,0	# counter i=0
	addi	$a0,$a0,-1	# ms = ms-1
	b 	for
	nop
for:
	beq	$t0,$t1,exitfor	# Exit for loop if we have looped the number of times determined by constant
	nop
	addi	$t1,$t1, 1	# Add one during every loop
	b	for
	nop
exitfor:
	b	while	# Go back to while loop
	nop

exitwhile:
	jr 	$ra
	nop
	
	
time2string:
	PUSH($ra)
	PUSH($s0)
	PUSH($s1)
	PUSH($s2)
	PUSH($s3)
	PUSH($s4)
	
	srl $s0,$a1,12 # Shift to right so first 4 bits in 16 lsb sequence becomes the 4 lsb
	srl $s1,$a1,8 # Shift to right so bites of index 4-8 in 16 lsb sequence becomes the 4 lsb
	srl $s2,$a1,4 # Shift to right so bites of index 8-12  in 16 lsb sequence becomes the 4 lsb
	move $s3,$a1 # The 4 lsb in 16 lsb sequence
	
	move $s4,$a0 # Adress of area in memory
	
	move 	$a1, $s0	# Work on the first 4-bit sequence of the 16 lsb 
	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)
	sb	$v0, 0( $s4)  	# Stores the return value in chosen adress
	
	move 	$a1, $s1
	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)
	sb	$v0,1( $s4)  		
	
	li 	$t0,0x3A 	# Colon ASCII character
	sb	$t0,2( $s4)
	
	move 	$a1, $s2
	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)
	sb	$v0,3( $s4)  
	
	move 	$a1, $s3
	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)
	sb	$v0,4( $s4)  
		
	li 	$t1,0x00 	# NULL byte
	sb	$t1,5( $s4)
	
	jal	zerotime
	nop
	move 	$a0,$s4		# Stores time data in argument adress
	
	
	POP($s4)
	POP($s3)
	POP($s2)
	POP($s1)
	POP($s0)
	POP($ra)

	jr	$ra
	nop				
	

zerotime:
	
	andi 	$t0, $s3, 0xf	 #  Stores only the 4 lsb, Oxf=1111
	bne	$t0,$zero,continue
	nop	
	li	$t1, 0x48
	sb	$t1,0($s4)
	
	li	$t2, 0x4f
	sb	$t2,1($s4)
	
	li	$t3, 0x55
	sb	$t3,2($s4)
	
	li	$t4, 0x52
	sb	$t4,3($s4)
	
	li	$t4, 0x00
	sb	$t4,4($s4)
continue: 	
	jr 	$ra
	nop
	