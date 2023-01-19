  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30
	li 	$t1,0x3
loop:	
	addi	$t1,$t1,1	
	move	$a0,$s0		# copy from s0 to a0
	
	li	$s2,0x4
	beq	$s2,$t1,print	
	b	cont
	nop
print: 
	li	$v0,11		# syscall with v0 = 11 will print out	
	syscall			# one byte from a0 to the Run I/O window
	add	$t1,$t1,-3	
cont:	
	addi	$s0,$s0,1	# what happens if the constant is changed?
	
	
	li	$t0,0x5b	#Stops at ASCII character 90 = Z
	bne	$s0,$t0,loop
	nop			# delay slot filler (just in case)
	
stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)


