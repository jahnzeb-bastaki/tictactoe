.data
newline:		.asciiz "\n"
output1:		.asciiz " | "
output2:		.asciiz "\t\t---+---+---\n"
output3:		.asciiz "\t\t "
instruction1:		.asciiz "\t\tTic-Tac-Toe\n\n"
instruction2:		.asciiz "INSTRUCTIONS: PLAYER will take turns with COMPUTER to play a game of Tic-Tac-Toe!\nChoose a cell numbered from 1 to 9 as below and play!\n\n"
instruction3:		.asciiz "\t\t 1 | 2 | 3  \n"
instruction4:		.asciiz "\t\t 4 | 5 | 6  \n"
instruction5:		.asciiz "\t\t 7 | 8 | 9  \n\n"
instruction6:		.asciiz "PLAYER is X\n"
instruction7:		.asciiz "COMPUTER is O\n\n"
userprompt1:		.asciiz "PLAYER's turn. Pick a space with its corresponding number: "
userprompt2:		.asciiz "\nPLAYER has put a X in cell "
invalidprompt1:		.asciiz "\nPLAYER input was not in valid. Please pick a number from 1 to 9\nPlease try again\n\n"
invalidprompt2:		.asciiz "\nPLAYER has choose space that is already taken\nPlease try again\n\n"
breakline:		.asciiz "-\t-\t-\t-\t-\t-\t-\t-\t-\t-\n\n"
computerPrompt:		.asciiz "\nCOMPUTER has put O in cell "
tiePrompt:		.asciiz "\nNeither PLAYER nor COMPUTER has won the game, the game is a tie!\n"
board:			.byte   ' ' , ' ', ' ', ' ' , ' ', ' ', ' ' , ' ', ' '
#board:			.byte	'X' , 'O' , 'X', 'O', 'X', 'O', 'X', 'O', 'X'

.text
main:
	jal	printInstruction
	li	$s0, 0		# counter for moves
	li	$s1, 9		# max number of moves in the game

mainLoop:
	jal	userInput
	jal	displayBoard
	# check to see winner, if there is winner, game will end in winner
	addi	$s0, $s0, 1		# increment s0 by one
	beq	$s0, $s1, tieGame	# check to see if the game has tied
	
	jal	computerInput
	jal	displayBoard
	#check to see winner, if winner game will end in winner
	addi	$s0, $s0, 1
	beq	$s0, $s1, tieGame	
	
	j	mainLoop
tieGame:
	li	$v0, 4
	la	$a0, tiePrompt
	syscall
	# End program
	li	$v0, 10			
	syscall
######################## End of main ###########################

######################## start of displayBoard #################
displayBoard:
	addi	$sp, $sp, -4	# increase stack pointer by 4 bytes
	sw	$ra, 0($sp)	# store return address in stack
	li	$t0, 0		# loop counter = 0
	li	$t1, 2		# loop size = 3
	la	$t2, board	# base address of board
	li	$t3, 0		# offset pointer for board array
loop1:
	# Print output 3
	li	$v0, 4
	la	$a0, output3
	syscall
	# Print the character at relative array position
	jal	printArray
	# Print output1
	li	$v0, 4
	la	$a0, output1
	syscall
	# Print the character at relative array position
	jal	printArray
	# Print output1
	li	$v0, 4
	la	$a0, output1
	syscall
	# Print the character at relative array position
	jal	printArray
	# Print a new line
	li	$v0, 4
	la	$a0, newline
	syscall
	# if t0 == t1 (t1 = 2) then jump to exit1
	beq	$t0, $t1, exit1
	# Print output2
	li	$v0, 4
	la	$a0, output2
	syscall
	# t0 = t + 1
	addi	$t0, $t0, 1
	j	loop1
printArray:
	add	$t4, $t2, $t3	# t4 = offset + base address of array
	lbu	$t4, 0($t4)	# t4 = character at the specified location
	li	$v0, 11		
	la	$a0, ($t4)
	syscall			# print the character on screen
	addi	$t3, $t3, 1	# t3 = t3 + 1
	jr	$ra
exit1:
	lw	$ra, 0($sp)	# pop off register address from stack
	addi	$sp, $sp, 4	# restore stack
	jr	$ra	
######################## End of displayBoard ######################

######################## Start of instructions ######################
printInstruction:
	li	$v0, 4
	la	$a0, instruction1
	syscall
	la	$a0, instruction2
	syscall
	la	$a0, instruction3
	syscall
	la	$a0, output2
	syscall
	la	$a0, instruction4
	syscall
	la	$a0, output2
	syscall
	la	$a0, instruction5
	syscall
	la	$a0, instruction6
	syscall
	la	$a0, instruction7
	syscall
	la	$a0, breakline
	syscall
	jr	$ra
######################## End of instructions ######################

######################## Start of User Input ######################
userInput:
start:
	#prompt the user for input
	li	$v0, 4
	la	$a0, userprompt1
	syscall
	#get the user input
	li	$v0, 5
	syscall
	move	$t2, $v0
	#validate move
	li	$t0, 9
validateNum:
	beqz	$t0, invalidNum
	beq	$t0, $t2, validNum
	addi	$t0, $t0, -1
	j	validateNum
invalidNum:
	li	$v0, 4
	la	$a0, invalidprompt1
	syscall
	j	userInput
validNum:
	la	$t0, board	# Load address of board array
	li	$t1, 32		# ASCII Value of the space character
	addi	$t3, $t2, -1	# Subtract 1 from userinput for correct position
	add	$t0, $t0, $t3	# Add offset from userinput and base address of board array
	lbu	$t5, 0($t0)	# Load the character from the array
	beq	$t5, $t1, validUserSpace	#if the space is the same as a space character jump to validSpace
	#print invalidpromt2
	li	$v0, 4
	la	$a0, invalidprompt2
	syscall
	j	userInput
	#input 'X' in the correct position
validUserSpace:
	li	$t4, 88
	sb	$t4, 0($t0)
	#Print the user input on to screen
	li	$v0, 4
	la	$a0, userprompt2
	syscall
	li	$v0, 1
	move	$a0, $t2
	syscall
	li	$v0, 4
	la	$a0, newline
	syscall
	syscall
	
	#jump back to register address
	jr	$ra
######################## End of User Input ######################

######################## Start of Computer Input ################
computerInput:
	li 	$a1, 9  	# Here you set $a1 to the max bound to 9
    	li 	$v0, 42 	# generates the random number between 0-8
    	syscall
    	move	$t0, $a0	# Computer move stored in t0
    	
    	la	$t1, board	# base address of board array
    	li	$t2, 32		# ASCII Value of space
    	add	$t3, $t1, $t0	# add the computer move to the base address
    	lbu	$t1, 0($t3)	# store value of board at offset into t1
    	beq	$t1, $t2, validComputerSpace
	j	computerInput
validComputerSpace:
	li	$t1, 79
	sb	$t1, 0($t3)
	# Print Computer Prompt
	li	$v0, 4
	la	$a0, computerPrompt
	syscall
	li	$v0, 1
	addi	$t0, $t0, 1
	move	$a0, $t0
	syscall
	li	$v0, 4
	la	$a0, newline
	syscall
	syscall
    	jr	$ra
######################## End of Computer Input ##################

