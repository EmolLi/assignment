#Duan Li, 260683698



findRoot:
#    ADD YOUR CODE HERE.   ONLY SUBMIT THIS CODE (INCLUDING findRoot LABEL above).   
#    WE WILL TEST YOUR CODE WITH DIFFERENT STARTER CODE. 
# temporary register $f10 is changed to store b
# temporary register $f7 is changed to store a
# save register $f21 stores (c-a)/i
# save register $f20 stores 2
# temporary register $f5 is changed to store p(b)

	#f7 = a
	mov.s	$f7, $f12
	
	#f20=2
	addi	$sp, $sp, -8
	swc1	$f20, 0($sp)
	swc1	$f21, 4($sp)
	li	$t1, 2
	mtc1	$t1, $f20
	cvt.s.w $f20, $f20
	
	#f20 = (c-a)/i
	sub.s	$f21, $f13, $f12
	div.s	$f21, $f21, $f20
	
	#f10 = b, initialize b to a+(c-a)/i
	add.s	$f10, $f7, $f21
	
	Floop:
		#evaluate p(b), stores the result in $f5
		#set the argument for the evaluate
		mov.s $f12, $f10
		#save $ra and a, b, c (f7, f10, f13) in stack
		addi	$sp, $sp, -16
		sw	$ra, 0($sp)
		swc1	$f7, 4($sp)
		swc1	$f10, 8($sp)
		swc1	$f13, 12($sp)
		#call evaluate to get p(b)
		jal evaluate
		#save the result to $f5, f5=p(b)
		mov.s	$f5, $f0
		#reload $ra, a, b, c
		lw	$ra, 0($sp)
		lwc1	$f7, 4($sp)
		lwc1	$f10, 8($sp)
		lwc1	$f13, 12($sp)
		addi	$sp, $sp, 16
		

		#if p(b)==0, then jump out of the loop and return b
		mtc1	$zero, $f4
		c.eq.s	$f5, $f4
		bc1t	rootFound
		
		
		#else if ( abs (a-c) < epsilon ), then jump out of the loop and return b
		sub.s	$f4, $f7, $f13
		abs.s	$f4, $f4
		c.lt.s	$f4, $f14
		bc1t	rootFound
		
		
		#if  ( p(a)*p(b) > 0) then a=b
		addi	$sp, $sp, -20
		sw	$ra, 0($sp)
		swc1	$f7, 4($sp)
		swc1	$f10, 8($sp)
		swc1	$f13, 12($sp)
		swc1	$f5, 16($sp)
		#calcuate p(a)
		mov.s	$f12, $f7
		jal	evaluate
		lw	$ra, 0($sp)		#save $ra, updates $sp
		lwc1	$f7, 4($sp)
		lwc1	$f10, 8($sp)
		lwc1	$f13, 12($sp)
		lwc1	$f5, 16($sp)
		addi	$sp, $sp, 20
		#calcuate p(a)*p(b)
		mul.s	$f4, $f0, $f5	
		#set f6 to zero
		mtc1	$zero, $f6
		#compare p(a)*p(b) with 0
		c.lt.s	$f6, $f4	#f4= p(a)*p(b), f6=0
		bc1t	case1


		#else
		j	case2
case1:
	#a=b
	mov.s	$f7, $f10
	#update b
	div.s	$f21, $f21, $f20		#f21=f21/2
	add.s	$f10, $f7, $f21	#b= a+ f21
	j	Floop
	
	
case2:
	#c=b
	mov.s	$f13, $f10
	#update b
	div.s	$f21, $f21, $f20		#f21=f21/2
	sub.s	$f10, $f13, $f21
	j Floop
	
	
rootFound:
	#load f20
	lwc1	$f20, 0($sp)
	lwc1	$f21, 4($sp)
	addi	$sp, $sp, 8
	#return b
	mov.s	$f0, $f10	
	jr	$ra
