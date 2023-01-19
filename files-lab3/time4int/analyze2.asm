  # analyze.asm
  # This file written 2015 by F Lundevall
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30	# load immediate
loop:
	move	$a0,$s0		# copy from s0 to a0
	
	li	$v0,11		# syscall with v0 = 11 (print character) will print out
	syscall			# one byte from a0 to the Run I/O window

	addi	$s0,$s0,0x3	# what happens if the constant is changed?
	
	li	$t0,0x5b
	ble	$s0,$t0,loop	# branch if less than or equal (bne: branch on not equal - if s0 = t0 branch)
	nop			# delay slot filler (just in case)

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)

