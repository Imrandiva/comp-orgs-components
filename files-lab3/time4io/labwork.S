  # labwork.S
  # Written 2015-2017 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1.
  # The macros PUSH and POP are in the public domain.
  # Please add your own code at the end of the file.

  # make install TTYDEV=/dev/cu.usbserial-A503WFU0
  # Please keep the two macros PUSH and POP unchanged
  #
.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
  #
  
.global hexasc
.global delay
.global time2string

 .data
 .align 2
.text

	 
hexasc:	
	andi 	$a0, $a1, 0xf	 #  Stores only the 4 lsb, Oxf=1111
	addi	$t0, $0, 10
	li	$v0,0x30	 #  Starting from 0x30 when values under 10
	
	slt 	$t1, $a0, $t0 	# If t1 < 10, return 1, else return 0
	bne	$t1,$0, cont	 # Go directly to adding value to return variable if $t1 returned 1
	li	$v0,0x37	 #  Starting from 0x37 when values over 9
cont:
	add 	$v0, $v0,$a0	# Returning the correct index value chosen by argument
	jr	$ra
	nop

delay:
	li	$t0, 5300		# For loop constant: 5300 with chipkit
	
while:
	ble	$a0,$0,exitwhile	# Exit while loop if arg < 0
	li	$t1,0	# counter i=0
	addi	$a0,$a0,-1	# ms = ms-1
	b 	for
	nop
for:
	beq	$t0,$t1,exitfor	# Exit for loop if we have looped the number of times determined by constant
	addi	$t1,$t1, 1	# Add one during every loop
	b	for	# Continue for-loop
	nop
exitfor:
	b	while	# Go back to while loop
	nop

exitwhile:
	jr 	$ra
	nop
	
	
time2string:
	PUSH $ra
	PUSH $s0
	PUSH $s1
	PUSH $s2
	PUSH $s3
	PUSH $s4
	
	 
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
	
	move 	$a0,$s4		# Stores time data in argument adress
	
	POP $s4
	POP $s3
	POP $s2
	POP $s1
	POP $s0
	POP $ra

	jr	$ra
	nop				
	

