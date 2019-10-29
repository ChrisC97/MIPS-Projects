.data
	base: .word 23
	sr1: .asciiz "Enter 10 characters: "
	userNumber: .space 11
	result: .space 3 # The max number is 23*10, which is 230.

.text # Instructions section, goes in text segment.

main:
	# PRINT PROMPT #
    li $v0, 4 # System call to print a string.
	la $a0, sr1 # Load string to be printed.
	syscall # Print string.
	
	# READ USER INPUT #
	li $v0, 8 # System call for taking in input.
	la $a0, userNumber # Where the string is saved.
	li $a1, 11 # Max number of characters to read.
	syscall
	
	# LOOP OVER MESSAGE #
	la $s0, userNumber # The address of the string entered.
	add $t0, $t0, $zero # $t0 will iterate over the characters.
messageLoop:
	add $s1, $s0, $t0 # mesage[i]
	lb $s2, 0($s1) # Load the character into $s2.
	beq $s2, 0, endProgram # End of string, exit out.
	jal toUppercase # Convert the character to uppercase. 
	jal isCharInRange # Is the character in our range? (0-9 and A-Z)
	sub $s2, $s2, 48 # Make the char '0' the start of the table.
	addi $t0, $t0, 1 # i++
	j messageLoop # Check the next character.
	
	# CONVERT TO LOWERCASE #
toUppercase: # Convert characters to their lowercase version.
	blt $s2, 'a', toUppercaseEnd  # If less than a, return. No change needed.
	bgt $s2, 'z', toUppercaseEnd  # If more than z, return. No change needed.
	sub $s2, $s2, 32  # Lowercase characters are offset from uppercase by 32.
toUppercaseEnd:
	jr $ra
	
	# CHECK IF CHAR IN RANGE #
isCharInRange:
	blt $s2, 48, endCharCheck # Value is less that '0', ignore it.
	bgt $s2, 90, endCharCheck # Value is more than 'Z', ignore it.
endCharCheck:
	jr $ra
endProgram:
	li $v0, 10 # Exit program system call.
	syscall
	
## MESSAGE LOOP VARIABLES #
## $s0 = The base address of the string we're iterating over.
## St0 = The character index of the string.
## $s1 = message[i]
## $s2 = The character at message[i]