# COMP 273 2016,  Assignment #4
# prepared by Michael Langer 
#
# findRootStarter.asm

.data

#  define the polynomial
POLYORDER:              .word    3	       # Order of polynomial.
COEFFICIENTS:	        .word    1, -2, -1, 2  # Integer coefficient of highest order comes first in list                     

#  define the interval in which we search for the root,  and the tolerance for the solution
INTERVAL:		.float	-1.53, 0.51	    # Root is between these values.
EPSILON:		.float	0.000001     # Value e in algorithm above.
errorMessage:		.asciiz "invalid input:  two arguments of p() must be of opposite sign"
solutionMessage:	.asciiz "solution is "
.text
.globl	main

main:
	la	$t0, INTERVAL
	lwc1	$f8,0($t0)      #  put a into $f8 temporarily
	lwc1	$f9,4($t0)	#  put c into $f9 temporarily
	la	$t0, EPSILON	
	lwc1	$f14,0($t0)     #  $f14 has the epsilon tolerance.  
	
	#  check if inputs are valid  (evalute polynomial at endpoints 
	#  p(a) and p(c) and check if p(a)* p(c) < 0
		
	mov.s 	$f12, $f8
	jal	evaluate		# evaluate p(a),  i.e.  $f12 has a.  result in $f0
	mov.s    $f7, $f0  

	mov.s 	$f12, $f9
	jal	evaluate		# evaluate p(b),  i.e.  $f12 has c.  result in $f0
	mov.s   $f6, $f0  
	mul.s	$f6, $f7, $f6		#  check if p(a) * p(c) < 0 
	mtc1	$zero, $f7              #  (putting $0 into $f7 and p(a)*p(c) into $f6)		
	c.lt.s	$f6, $f7
	bc1f	printErrorInvalidInput
	
	mov.s 	$f12, $f8		#  set up the argument registers for findRoot
	mov.s 	$f13, $f9		#  a goes in $f12,  c goes in $f13
	
	jal	findRoot
	
	#  print out the solution

	la	$a0, solutionMessage	
	li	$v0, 4
	syscall 
	
	mov.s	$f12, $f0	#  $f12 needed to print float
	li	$v0, 2
	syscall

	j	exit
	
printErrorInvalidInput:
	la	$a0, errorMessage	
	li	$v0, 4
	syscall 
	
exit:
	li	$v0, 10		#  exit
	syscall

# End of main

# ----------- Helper functions (part of starter code)  ------------------------------------

#  evaluate the polynomial p(x) at some float value x

evaluate:		
	# expects argument in $f12
	# returns the value of p( $f12 ) in register $f0
	# temporary register $f4 used for conversion of integer coefficient a_i & product with x^i 
	# save register $f20 will be used to accumulate the result	 
	# $s0 will hold the power n of x^n
	# $s1 will hold polynomial coefficients

	addi	$sp, $sp, -16		# make room on the stack   
	sw	$ra, 0($sp)		# save $ra
	swc1	$f20, 4($sp)
	sw	$s0, 8($sp)
	sw	$s1, 12($sp)
	
	  
	lw	$s0, POLYORDER		# set up index (will count down)
	la	$s1, COEFFICIENTS	# $s1 indexes words in coefficient array
					#  coeff[0] has exponent polyorder,  coeff[1] has exponent polyorder-1, ... 
	mtc1	$0, $f20		# initialize save register which will accumulate the result	

evaluate_loop:
	blt	$s0, $zero, evaluate_return    #  instead of beq
	addi	$a0, $s0, 0	      #  power's $a0 argument is the exponent
#	addi	$sp, $sp, -4
#	swc1	$f20, 0($sp)     # store save register used to accumulate result
	jal	power			# returns $f0 = x^n = ($f12)^$a0
#	lwc1	$f20, 0($sp)     # restore accumulated result
#	addi	$sp, $sp, 4             
	
	lw	$t2,0($s1)		# convert polynomial coefficient to float
	mtc1	$t2, $f4	
	cvt.s.w	$f4, $f4
	mul.s	$f0,$f0,$f4		# multiply coefficient $f4 by power(x,n)
	add.s	$f20,$f20,$f0	#   and then add this term to the accumulated total

	addi	$s0, $s0, -1	# decrease polynomial order index
	addi	$s1, $s1, 4		# increment coefficient index to next word
	j	evaluate_loop

evaluate_return:
	mov.s	$f0, $f20		# prepare return valued

	lw	$ra, 0($sp)		# restore $ra 
	lwc1	$f20, 4($sp)
	lw	$s0, 8($sp)
	lw	$s1, 12($sp)
	addi	$sp, $sp, 16		# restore stack
	jr	$ra

#---------------------- power	-----------------------------------------

# computes power($f12, $a0)  i.e.  $f12 ^ $a0,  note exponent is an integer
# returns the result in $f0
# assumes $a0 >= 0 

power:
	addi	$t0, $zero, 1
	mtc1	$t0, $f4		
	cvt.s.w $f4, $f4	        #  $f4 = 1.0 

	move	$t0, $a0		# use temporary register for backwards counter rather than modifying $a0
		
p_loop:	
	beq	$t0, $zero, r_power
	mul.s	$f4, $f4, $f12		# temp = temp * $f12
	addi	$t0, $t0, -1		# decrement counter
	j	p_loop

r_power:
	mov.s	$f0,$f4			# set return value
	jr	$ra			# return



# -----------------   findRoot  ----------------------------- 

#  arguments:
#  a       in $f12
#  c       in $f13
#  epsilon in $f14

#  returns result in $f0

findRoot:


#    ADD YOUR CODE HERE.   ONLY SUBMIT THIS CODE (INCLUDING findRoot LABEL above).   
#    WE WILL TEST YOUR CODE WITH DIFFERENT STARTER CODE. 
