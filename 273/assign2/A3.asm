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
	
	
#Copy elements from list into the buffer, making L1, L2, L3
MakeL1L2L3:
	
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
			
			FBack:
				j	$ra

			
			#jump back to main
		 	

#Elements smalller than the pivot go in the low part of the buffer		
Low:
	sll	$t5, $t2, 2
	add	$t5, $t5, $s2	#s5 is the address of list[low]
	sw	$t4, 0($t5)		#partitionedList[low] = list[i]
	addi	$t2, 1			#low ++
	j	MBack
	
#Elements larger than the pivot go in the high part of the buffer.
High:
	sll	$t5, $t3, 2
	add	$t5, $t5, $s2	#s5 is the address of list[high]
	sw	$t4, 0($t5)		#partitionedList[high] = list[i]
	addi	$t3, 1			#high ++
	j	MBack
	
	
	
	
	
	
	
	#load the original value of  s0
	