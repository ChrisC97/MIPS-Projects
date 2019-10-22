.data
	base: .word 23
	sr1: .asciiz "Enter 10 characters: "
	userNumber: .space 11

.text # Instructions section, goes in text segment.

main:
	# PRINT SR1 #
    li $v0, 4 # System call to print a string.
	la $a0, sr1 # Load string to be printed.
	syscall # Print string.
	
	# READ USER INPUT #
	li $v0, 8 # System call for taking in input.
	la $a0, userNumber # Where the string is saved.
	li $a1, 11 # Max number of characters to read.
	syscall
	
	li $v0, 10 # Exit program system call.
	syscall