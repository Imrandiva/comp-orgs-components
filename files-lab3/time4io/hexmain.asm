  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,17	# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

   #You can write your own code for hexasc here
  	
hexasc:	
	andi 	$a0, $a0, 0xf	 #  Stores only the 4 lsb, Oxf=1111
	addi	$t0, $0, 10
	li	$v0,0x30	 #  Starting from 0x30 when values under 10
	
	slt 	$t1, $a0, $t0 	# If t1 < 10, return 1, else return 0
	bne	$t1,$0, cont	 # Go directly to adding value to return var if $t1 returned 1
	nop
	li	$v0,0x37	 #  Starting from 0x37 when values over 9
cont:
	add 	$v0, $v0,$a0  	# Returning the correct index value chosen by argument
	jr	$ra
	nop
