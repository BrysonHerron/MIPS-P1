########################################
#
# Katelyn Sinsel and Bryson Herron
#
# Project 1
#
########################################

.data

MASK_SIX = 0x3F
MASK_FIVE = 0x1F
PRINT_STR = 4
PRINT_INT = 1
READ_INT = 5

PROMPT: .asciiz "Enter Code > "
HIDDEN: .asciiz "Hidden value: "
DIFF: .asciiz "Hidden value diff: "
NEWLINE: .asciiz "\n"

.text

.globl main

main:

########################################
#
# $s0, holds the original input
# $s1, holds the hidden value's digits
# $t1, holds the masked information 
# 	of the first 6 digits, then the 
# 	amount we need to shift
# $t2, holds the constant number 4 for 
# 	shifting, then the digits after 
# 	they were shifted
# $t0, holds the hidden value after 
# 	retrieving it from the mask
#
########################################

#Prompt for an Integer
li $v0, PRINT_STR
la $a0, PROMPT
syscall

#Read Integer
li $v0, READ_INT
syscall

#Move the input into a temp register
add $s0, $v0, $zero

#Find position location
andi $t1, $s0, MASK_SIX

#Find shift amount
li $t2, PRINT_STR
sub $t1, $t1, $t2

#Find secret hidden value
srlv $t2, $s0, $t1
andi $s1, $t2, MASK_FIVE

#Print hidden value text
li $v0, PRINT_STR
la $a0, HIDDEN
syscall

#Print hidden value number
li $v0, PRINT_INT
add $a0, $s1, $zero
syscall

#Print 2 newlines
li $v0, PRINT_STR
la $a0, NEWLINE
syscall
syscall


########## Second Hidden Value #########


########################################
#
# $s2, holds the original input
# $s3, holds the hidden value's digits
# $t1, holds the masked information 
# 	of the first 6 digits, then the 
# 	amount we need to shift
# $t2, holds the constant number 4 for 
# 	shifting, then the digits after 
# 	they were shifted
# $t0, holds the hidden value after 
# 	retrieving it from the mask
#
########################################

#Prompt for an Integer
li $v0, PRINT_STR
la $a0, PROMPT
syscall

#Read Integer
li $v0, READ_INT
syscall

#Move the input into a temp register
add $s2, $v0, $zero

#Find position location
andi $t1, $s2, MASK_SIX

#Find shift amount
li $t2, PRINT_STR
sub $t1, $t1, $t2

#Find secret hidden value
srlv $t2, $s2, $t1
andi $s3, $t2, MASK_FIVE

#Print hidden value text
li $v0, PRINT_STR
la $a0, HIDDEN
syscall

#Print hidden value number
li $v0, PRINT_INT
add $a0, $s3, $zero
syscall

#Print 2 newlines
li $v0, PRINT_STR
la $a0, NEWLINE
syscall
syscall

############ Find Difference ############

########################################
#
# $t1, holds the result of each bit after
#   shifting and masking
# $s1, holds the first hidden number
# $s3, holds the second hidden number
# $s4, holds the result of using the xor
#   operator, i.e. the difference
#
########################################

#Find the difference using the xor operator
xor $s4, $s1, $s3

#Print out the difference message
li $v0, PRINT_STR
la $a0, DIFF
syscall

#Print out difference number bit by bit

#Shift right by 4 bits and mask the least significant bit (5th bit)
srl $t1, $s4, 4           
andi $t1, $t1, 1

#Print fifth bit
li $v0, PRINT_INT
add $a0, $t1, $zero
syscall

#Shift right by 3 bits and mask the least significant bit (4th bit)
srl $t1, $s4, 3           
andi $t1, $t1, 1     

#Print fourth bit
li $v0, PRINT_INT
add $a0, $t1, $zero
syscall

#Shift right by 2 bits and mask the least significant bit (3rd bit)
srl $t1, $s4, 2
andi $t1, $t1, 1

#Print third bit
li $v0, PRINT_INT
add $a0, $t1, $zero
syscall

#Shift right by 1 bit and mask the least significant bit (2nd bit)
srl $t1, $s4, 1
andi $t1, $t1, 1

#Print second bit
li $v0, PRINT_INT
add $a0, $t1, $zero
syscall

#Mask the least significant bit (1st bit)
andi $t1, $s4, 1

#Print first bit
li $v0, PRINT_INT
add $a0, $t1, $zero
syscall

#Exit program
li $v0, 10
syscall
