                .data
str:		.asciiz  "k: "
				
lengthOfList:	.word   10                  
list:		.word	0, 10, 30, 80, 20, 90, 70, 50, 40, 60  #  the list L 
partitionedList:
		.space  40	#  allocate space for partitioned list [L1, L2, L3]
                                #  allocated space = lengthOfList*4,  i.e.  40 = 10*4
                                #
                                #  Your solution must not use more space than this.      
                .text                                                      
                .globl main                     	
main: 

#  For testing purposes only.
#  Verify that MIPS convention for save registers are obeyed.
#  Set dummy values in save registers.   
#  After the call, verify that the registers have these dummy values. 
				
	addi	$s0, $0, 16		
	addi	$s1, $0, 17		
	addi	$s2, $0, 18		
	addi	$s3, $0, 19		
	addi	$s4, $0, 20		
	addi	$s5, $0, 21		
	addi	$s6, $0, 22
	addi	$s7, $0, 23

# prepare to call findRankK

        li      $v0, 4                  # print message "k: " to console
        la      $a0, str
        syscall

        li      $v0, 5                  # read integer value k (rank index)
        syscall				# (syscall puts the read value into $v0)
         
	move	$a0, $v0		# move rank to the argument register $a0 for function call

	la	$a1, list		# argument $a1 holds base address of list
	
	la	$t0, lengthOfList
	lw	$a2, 0($t0)		# argument $a2 holds the length of list L 
				
	jal	findRankK
	
	move    $a0, $v0		# move returned value into register where print syscall expects it 
        li      $v0, 1                  # print result
        syscall
        
	li	$v0, 10			# exit
	syscall

# --------------------------------------------------
#    REMOVE CODE ABOVE HERE WHEN YOU PREPARE TO SUBMIT.    YOU MUST ONLY SUBMIT THE 
#    FUNCTION findRankK AND YOU MUST DO SO IN A SEPARATE FILE  findRankK.asm THAT ONLY
#   HAS YOUR CODE BELOW (INCLUDING LABEL findRankK).   THIS FILE WILL BE USED FOR TESTING.
#   THE GRADER WILL CALL YOUR findRankK FUNCTION FROM A MAIN PROGRAM THAT IS DIFFERENT FROM ABOVE.  

findRankK:  
	#   $a0 holds k,  the index of the desired element
	#   $a1 is the base address of list  (list is size L words, buffer of size L words 
	#    - so array is of size 2L words)
	#   $a2 holds the length L of the list
	#
	
	#t1 = i
	li	$t1, 0		#int i
	
	#s0 = len
	#first save the original value of s0
	sw	$s0, -4($sp)
	move	$s0, $a2
	
	
	
	
	#create a  buffer for the partitioned list
	#s1 is the starting address of the list
	sw	$s1, -8($sp)
	move	$s1, $a1
	#s2 is the starting address of the partitionedList (buffer)
	sll	$t0, $s0, 2
	sw	$s2, -12($sp)
	add	$s2, $s1, $t0
	
	li	$t1, 1		#i=1
	#t2 = low = 0
	li	$t2, 0		
	#t3 = high = len-1
	addi	$t3, $s0, -1
	#s3 = pivot = list[0]
	sw	$s3, -16($sp)
	lw	$s3, 0($s1)
	
	#save return address
	sw	$ra, -20($sp)
	
	#update sp
	addi	$sp, $sp, -20
	
	jal	MakeL1L2L3
	
	
	
	
	 # The partitionedList array will have L1,L2,L3 in [0,low-1],[low,high], [high+1,len-1]
	 #Now make a new list to be used for the recursion.

	# k< low
	slt	$t0, $a0, $t2
	bnez	$t0, Less
	
	#k<=high
	slt	$t0, $t3, $a0
	beq	$t0, $zero, Equal
	
	#else (k>high)
	j	More

Less:
	#search L1
	#make new List
	li	$t1, 0	#i = 0
	MakeNewList:
		#if  i = low, the List is finished
		beq	$t1, $t2, Less2
		
		#compute the address of newlist[i]
		sll	$t6, $t1, 2
		add	$t6, $t6, $s1	#t6 holds the address of newlist[i]
		#get the value of partitionedList[i]
		sll	$t7, $t1, 2		
		add	$t7, $t7, $s2	#t7 holds the address of partitionedList[i]
		lw	$t7, 0($t7)		#t7 holds the value of partitionedList[i]
		#newlist[i] = partitionedList[i]
		sw	$t7, 0($t6)
		#i++
		addi	$t1, $t1, 1
		
		#jump to the beginning of MakeNewList
		j	MakeNewList
		
	Less2:
		#a0, a1 remains the same
		#a2 = new len = low 
		move	$a2, $t2
		# call findRankK on the new list
		jal	findRankK
		j	Next
		
		
	
Equal:
	move	$v0, $s3
	j	Next

More:
	#search L3
	#make new list
	addi	$t1, $t3, 1	#i = high + 1
	MakeNewList2:
		#if  i = len, the List is finished
		beq	$t1, $s0, More2
		
		#compute the address of newlist[i-(high+1)]
		sub	$t6, $t1, $t3
		add	$t6, $t6, -1		#t6 = i - high -1
		sll	$t6, $t6, 2		#t6*4
		add	$t6, $t6, $s1	#t6 holds the address of newlist[i]
		#get the value of partitionedList[i]
		sll	$t7, $t1, 2		
		add	$t7, $t7, $s2	#t7 holds the address of partitionedList[i]
		lw	$t7, 0($t7)		#t7 holds the value of partitionedList[i]
		#newlist[i] = partitionedList[i]
		sw	$t7, 0($t6)
		#i++
		addi	$t1, $t1, 1
		
		#jump to the beginning of MakeNewList2
		j	MakeNewList2
		
	More2:
		#a1 remains the same
		#a2 = new len = len -high -1
		sub	$a2, $s0, $t3
		addi	$a2, $a2, -1
		#a0 = new k = k- high -1
		sub	$a0, $a0, $t3
		addi	$a0, $a0, -1
		# call findRankK on the new list
		jal	findRankK
		j	Next
		
	
		
			
					
Next:	
	#recover s0, s1, s2, s3, return to main
	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$ra, 0($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
	
	
#Copy elements from list into the buffer, making L1, L2, L3
MakeL1L2L3:
	
	# if i >= len, jump to Skip
	sge	$t0, $t1, $s0
	bnez	$t0, Skip
	
	#t4 = list[i]
	sll	$t0, $t1, 2		#t0 = 4*i
	add	$t0, $t0, $s1	#t0 is the address of list[i]
	lw	$t4, 0($t0)
	
	slt	$t0, $t4, $s3	# if  (list[i]< pivot) then jump to Low
	bnez	$t0, Low

	slt	$t0, $s3, $t4
	bnez	$t0, High		#if (list[i]> pivot) then jump to High 
	
	MBack:
		addi	$t1, $t1, 1	#i++	
		#if  i<len, jump to the beginning of the loop 
		slt	$t0, $t1, $s0
		bnez	$t0, MakeL1L2L3
		
		Skip:
		#fill space in between with L2 (pivot)
		addi	$t1, $t2, 0	#i = low
		FillBlank:
			#if i > high, jump out of FillBlank loop and MakeL1L2L3 and return to FindRankK 
			sgt	$t0, $t1, $t3
			bnez	$t0, FBack
			
			#partitionedList[i] = pivot
			sll	$t5, $t1, 2		#t5 = i*4
			add	$t5, $t5, $s2	#t5 is the address of partionedList[i]
			sw	$s3, 0($t5)
			
			addi	$t1, $t1, 1	#i++	
			j	FillBlank
			
			FBack:
				jr	$ra

			
			#jump back to main
		 	

#Elements smalller than the pivot go in the low part of the buffer		
Low:
	sll	$t5, $t2, 2
	add	$t5, $t5, $s2	#t5 is the address of list[low]
	sw	$t4, 0($t5)		#partitionedList[low] = list[i]
	addi	$t2, $t2, 1			#low ++
	j	MBack
	
#Elements larger than the pivot go in the high part of the buffer.
High:
	sll	$t5, $t3, 2
	add	$t5, $t5, $s2	#t5 is the address of list[high]
	sw	$t4, 0($t5)		#partitionedList[high] = list[i]
	addi	$t3, $t3, -1			#high --
	j	MBack
	
	
	
	
	
	
	
	#load the original value of  s0
	
