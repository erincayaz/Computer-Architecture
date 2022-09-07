.data

prompt1: .asciiz  "\Enter a decimal(x): "

array1: .word 15, 4, 5, 8, 9, 7, 2, 1, 10, 3, 0, 14, 6, 12, 13, 11
array2: .word 4, 10, 1, 6, 8, 15, 7, 12, 3, 0, 14, 13, 5, 9, 11, 2
array3: .word 2, 15, 12, 1, 5, 6, 10, 13, 14, 8, 3, 4, 0, 11, 9, 7
array4: .word 7, 12, 14, 9, 2, 1, 5, 15, 11, 6, 13, 0, 4, 8, 10, 3
array5: .word 15, 4, 5, 8, 9, 7, 2, 1, 10, 3, 0, 14, 6, 12, 13, 11, 4, 10, 1, 6, 8, 15, 7, 12, 3, 0, 14, 13, 5, 9, 11, 2, 2, 15, 12, 1, 5, 6, 10, 13, 14, 8, 3, 4, 0, 11, 9, 7, 7, 12, 14, 9, 2, 1, 5, 15, 11, 6, 13, 0, 4, 8, 10, 3

keyfour: .word 0, 0, 0, 0

initialvec: .word 13330, 30806, 48282, 61662
keyvec: .word 8961, 26437, 43913, 61389, 56574, 39098, 21622, 4146
statevec: .word 0, 0, 0, 0, 0, 0, 0, 0
plaintextP: .word 4352, 13090, 21828, 30566, 39304, 48042, 56780, 65518
tempvec: .word 0, 0, 0, 0, 0, 0, 0, 0
ciphertext: .word 0, 0, 0, 0, 0, 0, 0, 0

length: .word 8

.text

main:
    	#la $a0,  prompt1          
	#li $v0,4
	#syscall              

	#li $v0, 5
	#syscall        
	#move $t0, $v0    # $t0 = x

    	la $s0, array1   
	la $s1, array2  
	la $s2, array3  
	la $s3, array4
	la $s4, array5
      
    	jal statefunc
    	move $s5, $v0
    	
    	add $s6, $zero, 0 # i = 0
mainloop:
	beq $s6, 8, endmainloop # i == 8

	addi $t2, $s6, 0
	sll $t2, $t2, 2 
    	la $t0, plaintextP
    	add $t0, $t0, $t2
    	lw $t0, 0($t0) # $t0 = P[i]
    	
    	add $a3, $t0, 0
    	jal statefunc2
    	move $s5, $v0
    	
    	addi $t2, $s6, 0
	sll $t2, $t2, 2
    	la $t0, ciphertext
    	add $t0, $t0, $t2
    	sw $s5, 0($t0)
    	
    	addi $s6, $s6, 1
    	j mainloop
endmainloop:
	
	la $t0, ciphertext
	lw $s5, 28($t0)
    	
    	li $v0, 10
    	syscall

nonlinear1:
	addi $t3, $a0, 0
	andi $t3, $t3, 15
	# t3 => first 4 bit
	addi $t2, $a0, 0
	srl  $t2, $t2, 4
	andi $t2, $t2, 15
	# t2 => second 4 bit
	addi $t1, $a0, 0
	srl  $t1, $t1, 8
	andi $t1, $t1, 15
	# t1 => third 4 bit
	addi $t0, $a0, 0
	srl  $t0, $t0, 12
	andi $t0, $t0, 15
	# t0 => last 4 bit
	
	# get new values by index
	# s0
	sll $t0, $t0, 2
	add $t0, $t0, $s0
	lw  $t0, 0($t0)
	# s1
	sll $t1, $t1, 2
	add $t1, $t1, $s1
	lw  $t1, 0($t1)
	# s2
	sll $t2, $t2, 2
	add $t2, $t2, $s2
	lw  $t2, 0($t2)
	# s3
	sll $t3, $t3, 2
	add $t3, $t3, $s3
	lw  $t3, 0($t3)
	
	# shift t's to left
	sll $t2, $t2, 4
	sll $t1, $t1, 8
	sll $t0, $t0, 12
	
	# sum of all temps
	add $t0, $t0, $t1
	add $t0, $t0, $t2
	add $t0, $t0, $t3
	
	addi $v0, $t0, 0
	jr $ra
	
nonlinear2:
	addi $t3, $a0, 0
	andi $t3, $t3, 15
	# t3 => first 4 bit
	addi $t2, $a0, 0
	srl  $t2, $t2, 4
	andi $t2, $t2, 15
	# t2 => second 4 bit
	addi $t1, $a0, 0
	srl  $t1, $t1, 8
	andi $t1, $t1, 15
	# t1 => third 4 bit
	addi $t0, $a0, 0
	srl  $t0, $t0, 12
	andi $t0, $t0, 15
	# t0 => last 4 bit
 	
	# get new values by index
    	sll $t0, $t0, 2
    	add $t0, $t0, $s4
    	lw  $t0, 0($t0)

    	add $t1, $t1, 16
    	sll $t1, $t1, 2
    	add $t1, $t1, $s4
    	lw $t1, 0($t1)

    	add $t2, $t2, 32
    	sll $t2, $t2, 2
    	add $t2, $t2, $s4
    	lw $t2, 0($t2)

    	add $t3, $t3, 48
    	sll $t3, $t3, 2
	add $t3, $t3, $s4
    	lw $t3, 0($t3)

    	# shift t's to left
    	sll $t2, $t2, 4
    	sll $t1, $t1, 8
    	sll $t0, $t0, 12

    	add $t0, $t0, $t1
    	add $t0, $t0, $t2
    	add $t0, $t0, $t3

    	addi $v0, $t0, 0
	jr $ra
	
linear:
    	addi $t0, $a0, 0
    	sll $t0, $t0, 6	 # shift 6
    	srl $t3, $t0, 16	 # upper half
    	andi $t4, $t0, 65535 # lower half
    	or $t0, $t3, $t4 	 # left 6 shift
	
    	addi $t1, $a0, 0
    	sll $t1, $t1, 16
    	srl $t1, $t1, 6
    	srl $t3, $t1, 16	 # upper half
    	andi $t4, $t1, 65535 # lower half
    	or $t1, $t3, $t4	 # right 6 shift

    	xor $t0, $t0, $t1	 # xor $t0 $t1
    	xor $t0, $t0, $a0    # xor $t0 $a0

    	addi $v0, $t0, 0
    	jr $ra
    	
ffunction:
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    
    	jal nonlinear2    # large table
    	move $t0, $v0

    	move $a0, $t0
    	jal linear	      # linear function
    	move $v0, $v0
    
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    
    	jr $ra
    	
wfunction:
	addi $sp, $sp, -4
	sw $ra, 0($sp) # save return address

	la $t0, keyfour
	lw $t0, 0($t0)
	xor $t0, $t0, $a0 # X xor A
	
	move $a0, $t0
	jal ffunction
	move $a0, $v0 # F(X xor A) => 1
	
	la $t0, keyfour
	lw $t0, 4($t0)
	xor $t0, $a0, $t0 # 1 xor B
	
	move $a0, $t0
	jal ffunction
	move $a0, $v0 # F(1 xor B) => 2
	
	la $t0, keyfour
	lw $t0, 8($t0)
	xor $t0, $a0, $t0 # 2 xor C
	
	move $a0, $t0
	jal ffunction
	move $a0, $v0 # F(2 xor C) => 3
	
	la $t0, keyfour
	lw $t0, 12($t0)
	xor $t0, $a0, $t0 # 3 xor D
	
	move $a0, $t0
	jal ffunction
	move $v0, $v0
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
statefunc:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	addi $t0, $zero, 0 # i = 0
loop1:
	beq $t0, 8, endloop1
	
	la $t1, initialvec
	addi $t2, $t0, 0
	andi $t2, $t2, 3 # mod(4)
	sll $t2, $t2, 2
	add $t1, $t1, $t2 
	lw $t1, 0($t1) # IV[i % 4]
	
	la $t2, statevec
	addi $t3, $t0, 0
	sll $t3, $t3, 2
	add $t2, $t3, $t2
	sw $t1, 0($t2) # R[i] = IV[i % 4]
	
	addi $t0, $t0, 1
	j loop1
endloop1:
	
	addi $t7, $zero, 0 # i = 0
loop2:

	beq $t7, 4, endloop2
	
	# 5. satir
	la $t0, statevec
	lw $t0, 0($t0) # t0 = R0
	add $t0, $t0, $t7 # t0 += i
	andi $t0, $t0, 65535 # mod(2^16)
	
	la $t1, keyfour
	la $t2, keyvec
	
	lw $t3, 0($t2)
	sw $t3, 0($t1) # A = K0
	lw $t3, 4($t2) 
	sw $t3, 4($t1) # B = K1
	lw $t3, 8($t2)
	sw $t3, 8($t1) # C = K2
	lw $t3, 12($t2)
	sw $t3, 12($t1) # D = K3
	
	move $a0, $t0 # a0 = R0...
	addi $sp, $sp, -4
	sw $t7, 0($sp) # save i to sp
	jal wfunction
	lw $t7, 0($sp) # load i from sp
	addi $sp, $sp, 4
	
	move $t0, $v0 # t0 = wfunction return
	
	la $t1, initialvec
	sw $t0, 0($t1) # R0 = $t0
	
	# 6. satir
	# $t0 = R1 & $t1 = t0
	la $t0, statevec 
	la $t1, initialvec
	lw $t1, 0($t1) # $t1 = t0
	lw $t0, 4($t0) # $t0 = R1
	add $t0, $t0, $t1 # $t0 = R1 + t0
	andi $t0, $t0, 65535 # $t0 = $t0->mod(2^16)
	
	la $t1, keyfour
	la $t2, keyvec
	
	lw $t3, 16($t2)
	sw $t3, 0($t1) # A = K4
	lw $t3, 20($t2) 
	sw $t3, 4($t1) # B = K5
	lw $t3, 24($t2)
	sw $t3, 8($t1) # C = K6
	lw $t3, 28($t2)
	sw $t3, 12($t1) # D = K7
	
	move $a0, $t0 # a0 = R1...
	addi $sp, $sp, -4
	sw $t7, 0($sp) # save i to sp
	jal wfunction
	lw $t7, 0($sp) # load i from sp
	addi $sp, $sp, 4
	
	move $t0, $v0 # $t0 = wfunction return
	
	la $t1, initialvec
	sw $t0, 4($t1) # R1 = $t0
	
	# 7. satir
	la $t0, statevec 
	la $t1, initialvec
	lw $t1, 4($t1) # $t1 = t1
	lw $t0, 8($t0) # $t0 = R2
	add $t0, $t0, $t1 # $t0 = R2 + t1
	andi $t0, $t0, 65535 # $t0 = $t0->mod(2^16)
	
	la $t1, keyfour
	la $t2, keyvec
	
	lw $t3, 0($t2)
	sw $t3, 0($t1) # A = K0
	lw $t3, 8($t2) 
	sw $t3, 4($t1) # B = K2
	lw $t3, 16($t2)
	sw $t3, 8($t1) # C = K4
	lw $t3, 24($t2)
	sw $t3, 12($t1) # D = K6
	
	move $a0, $t0 # a0 = R2...
	addi $sp, $sp, -4
	sw $t7, 0($sp) # save i to sp
	jal wfunction
	lw $t7, 0($sp) # load i from sp
	addi $sp, $sp, 4
	
	move $t0, $v0 # $t0 = wfunction return
	
	la $t1, initialvec
	sw $t0, 8($t1) # R2 = $t0
	
	# 8. satir
	la $t0, statevec 
	la $t1, initialvec
	lw $t1, 8($t1) # $t1 = t2
	lw $t0, 12($t0) # $t0 = R3
	add $t0, $t0, $t1 # $t0 = R3 + t2
	andi $t0, $t0, 65535 # $t0 = $t0->mod(2^16)
	
	la $t1, keyfour
	la $t2, keyvec
	
	lw $t3, 4($t2)
	sw $t3, 0($t1) # A = K1
	lw $t3, 12($t2) 
	sw $t3, 4($t1) # B = K3
	lw $t3, 20($t2)
	sw $t3, 8($t1) # C = K5
	lw $t3, 28($t2)
	sw $t3, 12($t1) # D = K7
	
	move $a0, $t0 # a0 = R3...
	addi $sp, $sp, -4
	sw $t7, 0($sp) # save i to sp
	jal wfunction
	lw $t7, 0($sp) # load i from sp
	addi $sp, $sp, 4
	
	move $t0, $v0 # $t0 = wfunction return
	
	la $t1, initialvec
	sw $t0, 12($t1) # R3 = $t0
	
	# 9. satir
	la $t0, initialvec
	la $t1, statevec
	
	lw $t0, 12($t0) # $t0 = t3
	lw $t1, 0($t1) # $t1 = R0
	add $t0, $t0, $t1 # $t0 = t3 + R0
	andi $t0, $t0, 65535 # $t0 = mod(2^16)($t0)
	
	sll $t0, $t0, 3	 # shift 3 to left
    	srl $t3, $t0, 16	 # upper half
    	andi $t4, $t0, 65535 # lower half
    	or $t0, $t3, $t4 	 # $t0 = $t0 <<< 3
	
	la $t1, statevec
	sw $t0, 0($t1) # R0 = $t0
	
	# 10. satir
	la $t0, initialvec
	la $t1, statevec
	
	lw $t0, 0($t0) # $t0 = t0
	lw $t1, 4($t1) # $t1 = R1
	add $t0, $t0, $t1 # $t0 = R1 + t0
	andi $t0, $t0, 65535 # $t0 = mod(2^16)($t0)
	
	sll $t0, $t0, 16
    	srl $t0, $t0, 5
    	srl $t3, $t0, 16	 # upper half
    	andi $t4, $t0, 65535 # lower half
    	or $t0, $t3, $t4	 # $t0 = $t0 >>> 5
	
	la $t1, statevec
	sw $t0, 4($t1) # R1 = $t0
	
	# 11. satir
	la $t0, initialvec
	la $t1, statevec
	
	lw $t0, 4($t0) # $t0 = t1
	lw $t1, 8($t1) # $t1 = R2
	add $t0, $t0, $t1 # $t0 = R2 + t1
	andi $t0, $t0, 65535 # $t0 = mod(2^16)($t0)
	
	sll $t0, $t0, 8	 # shift 8 to left
    	srl $t3, $t0, 16	 # upper half
    	andi $t4, $t0, 65535 # lower half
    	or $t0, $t3, $t4 	 # $t0 = $t0 <<< 8
	
	la $t1, statevec
	sw $t0, 8($t1) # R2 = $t0
	
	# 12. satir
	la $t0, initialvec
	la $t1, statevec
	
	lw $t0, 8($t0) # $t0 = t2
	lw $t1, 12($t1) # $t1 = R3
	add $t0, $t0, $t1 # $t0 = R3 + t2
	andi $t0, $t0, 65535 # $t0 = mod(2^16)($t0)
	
	sll $t0, $t0, 6	 # shift 6 to left
    	srl $t3, $t0, 16	 # upper half
    	andi $t4, $t0, 65535 # lower half
    	or $t0, $t3, $t4 	 # $t0 = $t0 <<< 6
	
	la $t1, statevec
	sw $t0, 12($t1) # R3 = $t0
	
	# 13. satir
	la $t0, statevec
	
	lw $t1, 16($t0) # $t1 = R4
	lw $t2, 12($t0) # $t2 = R3
	xor $t1, $t1, $t2 
	sw $t1, 16($t0) # R4 = $t0
	
	# 14. satir
	la $t0, statevec
	
	lw $t1, 20($t0) # $t1 = R5
	lw $t2, 4($t0) # $t2 = R1
	xor $t1, $t1, $t2 
	sw $t1, 20($t0) # R5 = $t0
	
	# 15. satir
	la $t0, statevec
	
	lw $t1, 24($t0) # $t1 = R6
	lw $t2, 8($t0) # $t2 = R2
	xor $t1, $t1, $t2 
	sw $t1, 24($t0) # R6 = $t0
	
	# 16. satir
	la $t0, statevec
	
	lw $t1, 28($t0) # $t1 = R7
	lw $t2, 0($t0) # $t2 = R0
	xor $t1, $t1, $t2 
	sw $t1, 28($t0) # R7 = $t0
	
	addi $t7, $t7, 1
	j loop2
endloop2:

	la $t0, statevec
	lw $v0, 28($t0)

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
statefunc2:
	addi $sp, $sp, -16
	sw $ra, 0($sp)

	# 1. sat?r
	la $t9, statevec
	lw $t0, 0($t9) # $t0 = R0
	
	add $t0, $t0, $a3 # $t0 = R0 + P
	andi $t0, $t0, 0xffff # $t0 = mod(2^16)($t0)
	
	la $t1, keyvec
	
	lw $t2, 0($t1) # $t2 = K0
	lw $t3, 0($t9) # $t3 = R0
	xor $t2, $t2, $t3 # $t2 = K0 xor R0
	la $t3, keyfour 
	sw $t2, 0($t3) # keyfour[0] = $t2
	
	lw $t2, 4($t1) # $t2 = K1
	lw $t3, 4($t9) # $t3 = R1
	xor $t2, $t2, $t3 # $t2 = K1 xor R1
	la $t3, keyfour 
	sw $t2, 4($t3) # keyfour[1] = $t2
	
	lw $t2, 8($t1) # $t2 = K2
	lw $t3, 8($t9) # $t3 = R2
	xor $t2, $t2, $t3 # $t2 = K2 xor R2
	la $t3, keyfour 
	sw $t2, 8($t3) # keyfour[2] = $t2
	
	lw $t2, 12($t1) # $t2 = K3
	lw $t3, 12($t9) # $t3 = R3
	xor $t2, $t2, $t3 # $t2 = K3 xor R3
	la $t3, keyfour 
	sw $t2, 12($t3) # keyfour[3] = $t2
	
	addi $a0, $t0, 0
	jal wfunction
	addi $t0, $v0, 0 
	sw $t0, 4($sp)
	
	# 2. sat?r
	lw $t1, 4($t9) # $t1 = R1  	
	add $t1, $t1, $t0 # $t1 = R1 + t0
	andi $t1, $t1, 0xffff # $t1 = mod(2^16)($t1)
	addi $t0, $t1, 0 # $t0 = $t1
	
	la $t1, keyvec
	
	lw $t2, 16($t1) # $t2 = K4
	lw $t3, 16($t9) # $t3 = R4
	xor $t2, $t2, $t3 # $t2 = K4 xor R4
	la $t3, keyfour 
	sw $t2, 0($t3) # keyfour[0] = $t2
	
	lw $t2, 20($t1) # $t2 = K5
	lw $t3, 20($t9) # $t3 = R5
	xor $t2, $t2, $t3 # $t2 = K5 xor R5
	la $t3, keyfour 
	sw $t2, 4($t3) # keyfour[1] = $t2
	
	lw $t2, 24($t1) # $t2 = K6
	lw $t3, 24($t9) # $t3 = R6
	xor $t2, $t2, $t3 # $t2 = K6 xor R6
	la $t3, keyfour 
	sw $t2, 8($t3) # keyfour[2] = $t2
	
	lw $t2, 28($t1) # $t2 = K7
	lw $t3, 28($t9) # $t3 = R7
	xor $t2, $t2, $t3 # $t2 = K7 xor R7
	la $t3, keyfour 
	sw $t2, 12($t3) # keyfour[3] = $t2
	
	addi $a0, $t0, 0
	jal wfunction
	addi $t0, $v0, 0 
	sw $t0, 8($sp)
	
	# 3. sat?r
	lw $t1, 8($t9) # $t1 = R2  	
	add $t1, $t1, $t0 # $t1 = R2 + t1
	andi $t1, $t1, 0xffff # $t1 = mod(2^16)($t1)
	addi $t0, $t1, 0 # $t0 = $t1
	
	la $t1, keyvec
	
	lw $t2, 0($t1) # $t2 = K0
	lw $t3, 16($t9) # $t3 = R4
	xor $t2, $t2, $t3 # $t2 = K0 xor R4
	la $t3, keyfour 
	sw $t2, 0($t3) # keyfour[0] = $t2
	
	lw $t2, 4($t1) # $t2 = K1
	lw $t3, 20($t9) # $t3 = R5
	xor $t2, $t2, $t3 # $t2 = K1 xor R5
	la $t3, keyfour 
	sw $t2, 4($t3) # keyfour[1] = $t2
	
	lw $t2, 8($t1) # $t2 = K2
	lw $t3, 24($t9) # $t3 = R6
	xor $t2, $t2, $t3 # $t2 = K2 xor R6
	la $t3, keyfour 
	sw $t2, 8($t3) # keyfour[2] = $t2
	
	lw $t2, 12($t1) # $t2 = K3
	lw $t3, 28($t9) # $t3 = R7
	xor $t2, $t2, $t3 # $t2 = K3 xor R7
	la $t3, keyfour 
	sw $t2, 12($t3) # keyfour[3] = $t2
	
	addi $a0, $t0, 0
	jal wfunction
	addi $t0, $v0, 0 
	sw $t0, 12($sp)
	
	# 4. sat?r
	lw $t1, 12($t9) # $t1 = R3  	
	add $t1, $t1, $t0 # $t1 = R3 + t2
	andi $t1, $t1, 0xffff # $t1 = mod(2^16)($t1)
	addi $t0, $t1, 0 # $t0 = $t1
	
	la $t1, keyvec
	
	lw $t2, 16($t1) # $t2 = K4
	lw $t3, 0($t9) # $t3 = R0
	xor $t2, $t2, $t3 # $t2 = K4 xor R0
	la $t3, keyfour 
	sw $t2, 0($t3) # keyfour[0] = $t2
	
	lw $t2, 20($t1) # $t2 = K5
	lw $t3, 4($t9) # $t3 = R1
	xor $t2, $t2, $t3 # $t2 = K5 xor R1
	la $t3, keyfour 
	sw $t2, 4($t3) # keyfour[1] = $t2
	
	lw $t2, 24($t1) # $t2 = K6
	lw $t3, 8($t9) # $t3 = R2
	xor $t2, $t2, $t3 # $t2 = K6 xor R2
	la $t3, keyfour 
	sw $t2, 8($t3) # keyfour[2] = $t2
	
	lw $t2, 28($t1) # $t2 = K7
	lw $t3, 12($t9) # $t3 = R3
	xor $t2, $t2, $t3 # $t2 = K7 xor R3
	la $t3, keyfour 
	sw $t2, 12($t3) # keyfour[3] = $t2
	
	addi $a0, $t0, 0
	jal wfunction
	addi $t0, $v0, 0 
	
	lw $t3, 0($t9) # $t3 = R0
	add $t0, $t0, $t3
	andi $t0, $t0, 0xffff # $t1 = mod(2^16)($t1)
	add $v0, $t0, 0 # $v0 = C 
	
	# 5. sat?r
	lw $t2, 12($sp) # $t2 = t2
	lw $t1, 0($t9) # $t1 = R0
	add $t0, $t1, $t2 # $t0 = R0 + t2
	andi $t0, $t0, 0xffff # T0 = mod(2^16)($t0)
	
	la $t1, tempvec
	sw $t0, 0($t1)
	
	# 6. sat?r
	lw $t2, 4($sp) # $t2 = t0
	lw $t1, 4($t9) # $t1 = R1
	add $t0, $t1, $t2 # $t0 = R1 + t0
	andi $t0, $t0, 0xffff # T1 = mod(2^16)($t0)
	
	la $t1, tempvec
	sw $t0, 4($t1)
	
	# 7. sat?r
	lw $t2, 8($sp) # $t2 = t1
	lw $t1, 8($t9) # $t1 = R2
	add $t0, $t1, $t2 # $t0 = R2 + t1
	andi $t0, $t0, 0xffff # T2 = mod(2^16)($t0)
	
	la $t1, tempvec
	sw $t0, 8($t1)
	
	# 8. sat?r
	lw $t0, 12($t9) # $t0 = R3
	lw $t1, 0($t9) # $t1 = R0
	lw $t2, 12($sp) # $t2 = t2
	lw $t3, 4($sp) # $t3 = t0
	
	add $t0, $t0, $t1 # $t0 = R3 + R0
	add $t0, $t0, $t2 # $t0 = $t0 + t2
	add $t0, $t0, $t3 # $t0 = $t0 + t0	
	andi $t0, $t0, 0xffff # T3 = mod(2^16)($t0)
	
	la $t1, tempvec
	sw $t0, 12($t1)
	
	# 9. sat?r
	lw $t1, 16($t9) # $t1 = R4
	xor $t0, $t0, $t1 # $t0 = T3 xor R4
	
	la $t1, tempvec
	sw $t0, 16($t1)
	
	# 10. sat?r
	la $t0, tempvec
	lw $t0, 4($t0) # $t0 = T1
	lw $t1, 20($t9) # $t2 = R5
	
	xor $t0, $t0, $t1 # T1 xor R5
	
	la $t1, tempvec
	sw $t0, 20($t1)
	
	# 11. sat?r
	la $t0, tempvec
	la $t9, statevec
	lw $t0, 8($t0) # $t0 = T2
	lw $t1, 24($t9) # $t2 = R6
	
	xor $t0, $t0, $t1 # T1 xor R6
	
	la $t1, tempvec
	sw $t0, 24($t1)
	
	# 12. sat?r
	la $t0, tempvec
	lw $t0, 0($t0) # $t0 = T0
	lw $t1, 28($t9) # $t2 = R7
	
	xor $t0, $t0, $t1 # T0 xor R7
	
	la $t1, tempvec
	sw $t0, 28($t1)
	
	# 13. sat?r
	add $t0, $zero, 0 # i = 0
loop3:
	beq $t0, 8, endloop3 # i == 8
	
	la $t1, tempvec
	add $t2, $t0, 0
	sll $t2, $t2, 2
	add $t1, $t1, $t2
	lw $t1, 0($t1) # $t1 = T[i]
	
	la $t3, statevec	
	add $t3, $t3, $t2
	
	sw $t1, 0($t3)
	
	addi $t0, $t0, 1
	j loop3
endloop3:

	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	jr $ra	

