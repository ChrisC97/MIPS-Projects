.data
	base: .word 23
	sr1: .asciiz "Enter 10 characters: "
	newLine: .asciiz "\n"
	userNumber: .space 11

.text # Instructions section, goes in text segment.

main:
	add $t5, $t5, $zero # set t5 to zero.
	lw $t6, base
	# PRINT PROMPT #
    li $v0, 4 # System call to print a string.
	la $a0, sr1 # Load string to be printed.
	syscall # Print string.
	
	# READ USER INPUT #
	li $v0, 8 # System call for taking in input.
	la $a0, userNumber # Where the string is saved.
	li $a1, 11 # Max number of characters to read.
	syscall
	
	# MAIN LOOP (LOOP OVER MESSAGE) #
	la $s0, userNumber # The address of the string entered.
	add $t0, $t0, $zero # $t0 will iterate over the characters.
messageLoop:
	add $s1, $s0, $t0 # mesage[i]
	lb $s2, 0($s1) # Load the character into $s2.
	beq $s2, 0, endProgram # End of string, exit out.
	jal toUppercase # Convert the character to uppercase. 
	jal isCharInRange # Is the character in our range? (0-9 and A-Z)
	bgt $s2, $t6, messageLoopEnd # If the number is larger than our base, ignore it.
	add $t5, $t5, $s2 # result += value.
messageLoopEnd:
	addi $t0, $t0, 1 # i++
	j messageLoop # Check the next character.
	
	# CHECK IF CHAR IN RANGE #
isCharInRange:
	blt $s2, 48, messageLoopEnd # Value is less that '0', ignore it.
	bgt $s2, 90, messageLoopEnd # Value is more than 'Z', ignore it.
	bgt $s2, 57, checkIfIgnore # Value is more than '9', but it could still be a character.
	sub $s2, $s2, 48 # The value is between '0' and '9', make it values 0-9.
	j endCharCheck
checkIfIgnore:
	blt $s2, 65, messageLoopEnd # Value is between '9' and 'A', ignore it.
	sub $s2, $s2, 55 # The value is between 'A' and 'Z', make it values 10-35.
endCharCheck:
	jr $ra
	
	# CONVERT TO UPPERCASE #
toUppercase: # Convert characters to their uppercase version.
	blt $s2, 'a', toUppercaseEnd  # If less than a, return. No change needed.
	bgt $s2, 'z', toUppercaseEnd  # If more than z, return. No change needed.
	sub $s2, $s2, 32  # Lowercase characters are offset from uppercase by 32.
toUppercaseEnd:
	jr $ra
	
	# END OF PROGRAM #
endProgram:
	li $v0, 4 # Printing new line.
	la $a0, newLine
	syscall 
	li $v0, 1 # System call to print a integer.
	add $a0, $t5, $zero # Set a0 to the result.
	syscall # Print integer.
	li $v0, 10 # Exit program system call.
	syscall
	
## GENERAL VARIABLES #
## $t5 = Result.
## $t6 = base.
## MESSAGE LOOP VARIABLES #
## $s0 = The base address of the string we're iterating over.
## St0 = The character index of the string.
## $s1 = message[i]
## $s2 = The character at message[i]