.data
	sr1: .asciiz "Enter 10 characters: "


.text ## Instructions section, goes in text segment.

main:
    li $v0, 4 ## System call to print a string.
	la $a0, sr1 ## Load string to be printed.
	syscall ## Print string.
	
	li $v0, 10 ## Exit program system call.
	syscall