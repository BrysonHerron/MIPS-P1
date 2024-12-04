########################################
#
# Bryson Herron and John Hollis
#
# Project 2
#
########################################

.data

# Input character array (32 characters)
input_array: .byte 'A','P','L','I','_','Z','K','F','Z','P','P','P','E','E','A','Z','I','_','Z','F','_','O','L','O','L','_','R','T','L','S','_','Z'

# Output array (32 characters)
output_array: .space 32 

# Prompts
ROW_PROMPT: .asciiz "Enter rows: "
COL_PROMPT: .asciiz "Enter cols: "

# Exit message
EXIT_MSG: .asciiz "Exiting program..."

# Constants for syscall
PRINT_STR = 4
PRINT_CHAR = 11
PRINT_INT = 1
READ_INT = 5
NEWLINE: .asciiz "\n"
NEWLINE_CHAR = 10
AT_SIGN = 64

# Size of input array
size: .word 32

.text
.globl main
main:
########################################
#
# $s0, holds the current index for traversal
# $s1, holds the current count of characters added to output
# $s2, holds the size of the input array
# $s3, holds the address of the input array
# $s4, holds the address of the output array
# $v0, holds the user input for number of rows
# $v1, holds the user input for number of cols
# $a0-$a3, used as temporary registers as $t registers are not allowed
#
########################################

# Call the print_result function
jal print_result

# Print out the exit message
li $v0, PRINT_STR
la $a0, EXIT_MSG
syscall

# Exit program
li $v0, 10
syscall


########################################
#
# Function: print_result
# Parameters: none
# Returns: none
#
########################################

print_result:
    # Prompt for Rows
    li $v0, PRINT_STR             # Load syscall for printing string
    la $a0, ROW_PROMPT            # Load address of ROW_PROMPT
    syscall                       # Display ROW_PROMPT

    # Read Integer
    li $v0, READ_INT              # Load syscall for reading integer
    syscall                       # Read the number of rows

    # Move row value 
    add $a1, $v0, $zero           # Store number of rows in $a1

    # Prompt for Cols
    li $v0, PRINT_STR             # Load syscall for printing string
    la $a0, COL_PROMPT            # Load address of COL_PROMPT
    syscall                       # Display COL_PROMPT

    # Read Integer
    li $v0, READ_INT              # Load syscall for reading integer
    syscall                       # Read the number of columns

    # Move col value
    add $a2, $v0, $zero           # Store number of columns in $a2

    # Call print_array
    jal print_array

    # Print newline after completing a row
    li $v0, PRINT_CHAR            # PRINT_CHAR syscall
    li $a0, NEWLINE_CHAR          # ASCII code for newline
    syscall                       # Print newline

    # Save num_rows and num_cols to stack
    add $sp, $sp, 8               # Allocate 8 bytes on the stack
    sw $a1, 0($sp)                # Save numRows on stack
    sw $a2, 4($sp)                # Save numCols on stack

    # Initialize parameters for traversal
    li $a0, 0                     # Start index for tree traversal
    li $a1, 0                     # Initial count of characters in output
    la $s0, input_array           # Load address of input array
    la $s1, output_array          # Load address of output array
    lw $s2, size                  # Load the size of the input array


    # Call the traverse_tree function
    jal traverse_tree

    # Print 2 newlines after completing output
    li $v0, PRINT_CHAR            # PRINT_CHAR syscall
    li $a0, NEWLINE_CHAR          # ASCII code for newline
    syscall                       # Print newline
    syscall                       # Print newline

    # Restore num_rows and num_cols from stack
    lw $a1, 0($sp)                # Load numRows from stack
    lw $a2, 4($sp)                # Load numCols from stack
    add $sp, $sp, -8              # Free 8 bytes from stack

    # Call print_array
    jal print_array 

    jr $ra                        # Return to main program




########################################
#
# Function: print_array
# Parameters: $a1 - numRows, $a2 - numCols
# Returns: none
#
########################################
print_array:
    # Initialize row counter
    li $s1, 0                     # $s1 will hold the current row index

print_row:
    # Check if we reached the end of rows
    bge $s1, $a1, print_array_end # Exit if row index >= numRows

    # Initialize column counter
    li $s2, 0                     # $s2 will hold the current column index

print_column:
    # Check if we reached the end of columns
    bge $s2, $a2, print_newline   # If col index >= numCols, go to newline

    # Print '@' character
    li $v0, PRINT_CHAR            # PRINT_CHAR syscall
    li $a0, AT_SIGN               # ASCII code for '@'
    syscall                       # Print '@'

    # Increment column counter
    addi $s2, $s2, 1              # Increment col index

    # Loop back to print next column in the row
    j print_column

print_newline:
    # Print newline after completing a row
    li $v0, PRINT_CHAR            # PRINT_CHAR syscall
    li $a0, NEWLINE_CHAR          # ASCII code for newline
    syscall                       # Print newline

    # Increment row counter
    addi $s1, $s1, 1              # Increment row index

    # Loop back to print next row
    j print_row

print_array_end:
    jr $ra                        # Return to caller


########################################
#
# Function: traverse_tree
# Parameters: $a0 - index, $a1 - count
# Returns: updated count in $s1
#
########################################
traverse_tree:
    # Store parameters on stack
    addi $sp, $sp, -24            # Allocate stack space
    sw $a0, 0($sp)                # Save index
    sw $ra, 4($sp)                # Save return address
    sw $s0, 8($sp)                # Save $s0
    sw $s1, 12($sp)               # Save $s1
    sw $s3, 16($sp)               # Save $s3
    sw $s4, 20($sp)               # Save $s4

    # Output the current character  
    add $s0, $s0, $a0             # Calculate address in input array
    lb $s5, 0($s0)                # Load character from input array
    add $s1, $s1, $a1             # Calculate address in output array
    sb $s5, 0($s1)                # Store character in output array
    lw $s0, 8($sp)                # Restore $s0
    lw $s1, 12($sp)               # Restore $s1
    addi $a1, $a1, 1              # Increment count

    # Print the current character in the output array
    addi $sp, $sp, -4             # Allocate 4 bytes on stack
    sw $a0, 0($sp)                # Save index for printing
    li $v0, PRINT_CHAR            # PRINT_CHAR syscall
    move $a0, $s5                 # Move character to $a0
    syscall                       # Print character
    lw $a0, 0($sp)                # Restore index
    addi $sp, $sp, 4              # Free 4 bytes from stack


    # Calculate child indices
    mul $s3, $a0, 2               # s3 = index * 2
    addi $s3, $s3, 1              # s3 = index * 2 + 1 (child_one)
    addi $s4, $s3, 1              # s4 = index * 2 + 2 (child_two)

    # Check if child_two is within bounds and recurse if valid
    slt $s5, $s4, $s2             # Check if child_two < size
    beq $s5, $zero, check_child_one # Skip if out of bounds
    add $a0, $s4, $zero           # Update index to child_two
    jal traverse_tree             # Recursive call for child_two
    add $a1, $v0, $zero           # Update count from return value

check_child_one:
    # Check if child_one is within bounds and recurse if valid
    slt $s5, $s3, $s2             # Check if child_one < size
    beq $s5, $zero, traverse_done # Skip if out of bounds
    add $a0, $s3, $zero           # Update index to child_one
    jal traverse_tree             # Recursive call for child_one
    add $a1, $v0, $zero           # Update count from return value


traverse_done:
    # Restore parameters and return
    lw $a0, 0($sp)                # Restore index
    lw $ra, 4($sp)                # Restore return address
    lw $s0, 8($sp)                # Restore $s0
    lw $s1, 12($sp)               # Restore $s1
    lw $s3, 16($sp)               # Restore $s3
    lw $s4, 20($sp)               # Restore $s4
    addi $sp, $sp, 24             # Free stack space

    move $v0, $a1                 # Move updated count to return value
    jr $ra                        # Return to caller
