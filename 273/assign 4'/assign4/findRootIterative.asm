#Duan Li, 260683698

findRoot:
#    ADD YOUR CODE HERE.   ONLY SUBMIT THIS CODE (INCLUDING findRoot LABEL above).   
#    WE WILL TEST YOUR CODE WITH DIFFERENT STARTER CODE. 
# temporary register $f10 is changed to store b
# temporary register $f7 is changed to store a
# temporary register $f8 is changed to store (c-a)/i
# temporary register $f9 is changed to store i
# temporary register $f5 is changed to store p(b)

	#f7 = a
	mov.s	$f7, $f12
	
	#f9=i=2
	li	$t1, 2
	mtc1	$t1, $f9
	cvt.s.w $f9, $f9
	
	#f8 = (c-a)/i
	sub.s	$f8, $f13, $f12
	div.s	$f8, $f8, $f9
	
	#f10 = b, initialize b to a+(c-a)/i
	add.s	$f10, $f7, $f8
	
	Floop:
		#evaluate p(b), stores the result in $f5
		#set the argument for the evaluate
		mov.s $f12, $f10
		#save $ra in stack
		addi	$sp, $sp, -4
		sw	$ra, 0($sp)
		#call evaluate to get p(b)
		jal evaluate
		#save the result to $f5, f5=p(b)
		mov.s	$f5, $f0
		#reload $ra
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		

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
		addi	$sp, $sp, -4
		sw	$ra, 0($sp)
		#calcuate p(a)
		mov.s	$f12, $f7
		jal	evaluate
		lw	$ra, 0($sp)		#save $ra, updates $sp
		addi	$sp, $sp, 4
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
	div.s	$f8, $f8, $f9		#f8=f8/2
	add.s	$f10, $f7, $f8	#b= a+ f8
	j	Floop
	
	
case2:
	#c=b
	mov.s	$f13, $f10
	#update b
	div.s	$f8, $f8, $f9		#f8=f8/2
	sub.s	$f10, $f13, $f8
	j Floop
	
	
rootFound:
	#return b
	mov.s	$f0, $f10	
	jr	$ra
