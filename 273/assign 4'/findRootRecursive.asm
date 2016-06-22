#Duan Li, 260683698



findRoot:
#    ADD YOUR CODE HERE.   ONLY SUBMIT THIS CODE (INCLUDING findRoot LABEL above).   
#    WE WILL TEST YOUR CODE WITH DIFFERENT STARTER CODE. 
# temporary $f10 is changed to store b
	#f7 = a
	mov.s	$f7, $f12
	#b=(a+c)/2
	add.s	$f4, $f7, $f13	#f4 = a+c
	
	li	$t1, 2
	mtc1	$t1, $f5
	cvt.s.w $f5, $f5		#f5 = 2
	
	addi	$sp, $sp, -16
	sw	$ra, 0($sp)          
	div.s	$f10, $f4, $f5	#f10 = b		

	#save a, b, c (f7, f10, f13) before calling another function
	swc1	$f7, 4($sp)
	swc1	$f10, 8($sp)
	swc1	$f13, 12($sp)
	
	#if (p(b) == 0)
	#calcuate p(b), store the result in f9
	mov.s	$f12, $f10
	jal	evaluate
	
	#load a and b (f7 and f10) and ra
	lw	$ra, 0($sp)		#save $ra, updates $sp
	lwc1	$f7, 4($sp)
	lwc1	$f10, 8($sp)
	lwc1	$f13, 12($sp)
	addi	$sp, $sp, 16
	
	mtc1	$zero, $f4
	mov.s	$f9, $f0		#f9 = p(b)
	c.eq.s	$f9, $f4
	bc1t	rootFound
	
	
	
	#if ( abs (a-c) < epsilon )
	sub.s	$f4, $f7, $f13
	abs.s	$f4, $f4
	c.lt.s	$f4, $f14
	bc1t	rootFound
	
	
	#if  ( p(a)*p(b) > 0) then a=b
	addi	$sp, $sp, -20
	sw	$ra, 0($sp)
	#save a, b, p(b), c (f7, f10, f9, f13) before calling another function
	swc1	$f7, 4($sp)
	swc1	$f10, 8($sp)
	swc1	$f9, 12($sp)
	swc1	$f13, 16($sp)
	#calcuate p(a)
	mov.s	$f12, $f7
	jal	evaluate
	lw	$ra, 0($sp)		#save $ra, updates $sp
	lwc1	$f7, 4($sp)
	lwc1	$f10, 8($sp)
	lwc1	$f9, 12($sp)
	lwc1	$f13, 16($sp)
	addi	$sp, $sp, 20

	#calcuate p(a)*p(b)
	mul.s	$f4, $f0, $f9	
	#set f5 to zero
	mtc1	$zero, $f5
	#compare p(a)*p(b) with 0
	c.lt.s	$f5, $f4	#f4= p(a)*p(b), f5=0
	bc1t	recursiveCall1
	
	
	#else
	j	recursiveCall2
	
	
	
	
rootFound:
	#return b
	mov.s	$f0, $f10
	jr	$ra

	
recursiveCall1:
	#a = b
	mov.s	$f12, $f10
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	findRoot
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

recursiveCall2:
	#c = b
	mov.s	$f13, $f10
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal	findRoot
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
