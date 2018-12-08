# Nick DiMonti
# ndimonti
# 111861608

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
# $a0 = The first index of ADFGVX.
# $a1 = The first index of ADFGVX.
# $v0 = The character in ADFGVX at the first given index 
# $v1 = The character in ADFGVX at the second given index 
get_adfgvx_coords:
bgt $a0, 5, get_adfgvx_error
blt $a0, 0, get_adfgvx_error
bgt $a1, 5, get_adfgvx_error
blt $a1, 0, get_adfgvx_error

beq $a0, 0, returnA_0
beq $a0, 1, returnD_0
beq $a0, 2, returnF_0
beq $a0, 3, returnG_0
beq $a0, 4, returnV_0
beq $a0, 5, returnX_0

returnA_0:
li $v0, 'A'
j check_second_arg

returnD_0:
li $v0, 'D'
j check_second_arg

returnF_0:
li $v0, 'F'
j check_second_arg

returnG_0:
li $v0, 'G'
j check_second_arg

returnV_0:
li $v0, 'V'
j check_second_arg

returnX_0:
li $v0, 'X'
j check_second_arg

check_second_arg:
beq $a1, 0, returnA_1
beq $a1, 1, returnD_1
beq $a1, 2, returnF_1
beq $a1, 3, returnG_1
beq $a1, 4, returnV_1
beq $a1, 5, returnX_1

returnA_1:
li $v1, 'A'
j finish_get_adfgvx

returnD_1:
li $v1, 'D'
j finish_get_adfgvx

returnF_1:
li $v1, 'F'
j finish_get_adfgvx

returnG_1:
li $v1, 'G'
j finish_get_adfgvx

returnV_1:
li $v1, 'V'
j finish_get_adfgvx

returnX_1:
li $v1, 'X'
j finish_get_adfgvx

finish_get_adfgvx:
jr $ra


get_adfgvx_error:
li $v0, -1
li $v1, -1
j finish_get_adfgvx


# Part II
# $a0 = A 6 × 6 2D char array containing the 26 letters of the alphabet in uppercase and the digit
#characters 0-9. The characters are randomly ordered in the grid.
# $a1 = The character whose 2D indices we want to find.
# $v0 = The row index of plaintext char in adfgvx grid.
# $v1 = The column index of plaintext char in adfgvx grid.
search_adfgvx_grid:
li $t0, 6 	# the number of rows/columns
li $t1, 0 	# $t1 = row counter (i)
rowLoop:
li $t2, 0 		# $t2 = column counter (j)
colLoop:
mul $t4, $t1, $t0  	# $t4 = i * num_columns 	
add $t4, $t4, $t2 	# $t4 = i * num_columns + j	
add $t4, $t4, $a0	# base_addr + 4*(i * num_columns + j)
lb  $t5, 0($t4)		# $t5 = char[i][j]
beq $t5, $a1, charMatch # if (char[i][j] = char were looking for) then match found
addi $t2, $t2, 1	# j++
blt $t2, 6, colLoop	# if (i < # of rows)
colLoopDone:
addi $t1, $t1, 1  	# i++
blt $t1, 6, rowLoop	# if (j < # of columns)
rowLoopDone:
li $v0, -1		# if no character was found return -1
li $v1, -1		# if no character was found return -1
finish_search_adfgvx_grid:
jr $ra


charMatch:
move $v0, $t1		# $v0 = row char was found at
move $v1, $t2		# $v1 = column char was found at
j finish_search_adfgvx_grid


# Part III
# $a0 = A 6 × 6 2D char array containing the 26 letters of the alphabet in uppercase and the digit
#characters 0-9. The characters are randomly ordered in the grid.
# $a1 = The null-terminated plaintext message to convert to ADFGVX coordinates. You may assume
#that the plaintext consists only of uppercase letters and digits.
# $a2 = A 2D char array that has enough space to hold the mapped plaintext in rowmajor
#order characters
map_plaintext:
addi $sp, $sp, -16
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
move $s0, $a0
move $s1, $a1
move $s2, $a2
loop_plaintext:		
lb $t0, 0($s1)		# $t0 = character[i]
beqz $t0, finish_map_plaintext
addi $s1, $s1, 1	# increment
move $a0, $s0		# load arg0
move $a1, $t0		# load arg1
jal search_adfgvx_grid	# getting the corresponding row and column values for the letter
move $a0, $v0		# load arg0
move $a1, $v1		# load arg1
jal get_adfgvx_coords	# call search_adfgvx_grid here
move $t1, $v0		
move $t2, $v1
sb $t1, 0($s2)		# writing the first ADFGVX character to the given address
sb $t2, 1($s2)		# writing the second ADFGVX character to the given address
addi $s2, $s2, 2	# increment to write the next two ADFGVX character
j loop_plaintext
finish_map_plaintext:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
addi $sp, $sp, 16
jr $ra


# Part IV
# $a0 = The 2D array to be modified.
# $a1 = Number of rows in matrix.
# $a2 = Number of columns in matrix.
# $a3 = Index of first column to swap.
# 0($sp) = Index of second column to swap.
# $v0 = 0 on success -1 on failure
swap_matrix_columns:
lw $t0, 0($sp)

blez $a1, swap_matrix_columns_error
blez $a2, swap_matrix_columns_error

bltz $a3, swap_matrix_columns_error
bltz $t0, swap_matrix_columns_error

bge $a3, $a2, swap_matrix_columns_error
bge $t0, $a2, swap_matrix_columns_error

beq $a2, 1, finish_swap_matrix_columns

move $t2, $a0

blt $a3, $t0, columnsInOrder
move $t3, $a3
move $a3, $t0
move $t0, $t3
columnsInOrder:
sub $t7, $t0, $a3 	# calculating the difference between the columns 

li $t3, 0
li $t5, 0	# boolean (gets set to true after first char of the row has been saved to the stack)
li $t4, 0 	# row counter
j swap_columns_loop

swap_columns_loop_init:
li $t3, 0	# column counter
li $t5, 0	# re-setting boolean value 
addi $t4, $t4, 1
beq  $t4, $a1, break_swap_columns_loop
swap_columns_loop:
lb $t1, 0($t2)		# load character of current index
beq $t3, $a3, swap	# if at col1 index of current row then swap
beq $t3, $t0, swap 	# if at col2 index of current row then swap
j nextIndex
swap:
bnez $t5, writeToCol2	# if (current element is col2 element of current row) then handle col2 case
li $t5, 1		# setting boolean value true
addi $sp, $sp, -1	# allocating stack space 
sb $t1, 0($sp)		# storing the character in col1 of current row to the stack
add $t2, $t2, $t7	# incrementing to the col2 index
lb $t6 0($t2)		# loading character from the col2 index
sub $t2, $t2, $t7	# decrementing back from col2 index
sb $t6, 0($t2)		# storing the character from col2 index into col1 index
j nextIndex
writeToCol2:
lb $t6, 0($sp)		# loading the first row index to swap in the pos of the second row index
addi $sp, $sp, 1	# removing memory from the stack
sb $t6, 0($t2)		# now write this to the index your at
nextIndex:
addi $t2, $t2, 1        # incrementing array index
addi $t3, $t3, 1	# incrementing column counter
beq  $t3, $a2, swap_columns_loop_init
j swap_columns_loop
break_swap_columns_loop:
li $v0, 0 		# loading 0 in $v0 for success
finish_swap_matrix_columns:
jr $ra


swap_matrix_columns_error:
li $v0, -1
j finish_swap_matrix_columns


# Part V
# $a0 = Matrix that is manipulated as a result of sorting the key.
# $a1 = The number of rows in the matrix
# $a2 = The number of columns in the matrix
# $a3 = The array of items being sorted
# $sp = Size in bytes of one element in key. Available at 0($sp). elem size is guaranteed to be
#1 or 4. Elements are unsigned values.
# IT IS ASSUMED THE LENGTH OF Key[] IS THE SAME AS THE NUMBER OF COLUMNS
key_sort_matrix:
lw $t0, 0($sp)

addi $sp, $sp, -24
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3
move $s4, $a3

beq $a2, 1, finish_key_sort_matrix
beq $t0, 1, sort_by_bytes
beq $t0, 4, sort_by_words

sort_by_bytes:
li $t2, 0	# boolean isSorted = false
init_byte_bubblesort:
li $t0, 0 	# i = 0
li $t1, 1	# j = 0
beq $t2, 1, finish_key_sort_matrix
li $t2, 1	# boolean isSorted = true
move $s3, $s4	# re-setting the string arrays address to the first index
byte_bubblesort:
lb $t3, 0($s3)		# $t3 = char[i]
lb $t4, 1($s3)		# $t4 = char[j]
beqz $t4, dont_swap_bytes
ble $t3, $t4, dont_swap_bytes
li $t2, 0		# boolean isSorted = false
sb $t4, 0($s3)		# swapping character
sb $t3, 1($s3)		# swapping character
move $a0, $s0		# loading arguments 0
move $a1, $s1		# loading arguments 1
move $a2, $s2		# loading arguments 2
move $a3, $t0		# loading arguments 3
addi $sp, $sp, -12	# allocating stack space
sw   $t0, 0($sp)	# saving temporary registers needed
sw   $t1, 4($sp)	# saving temporary registers needed
sw   $t2, 8($sp)	# saving temporary registers needed
addi $sp, $sp, -4	# allocating stack space for the fifth argument 
sw   $t1, 0($sp)	# loading arguments 4
jal  swap_matrix_columns
addi $sp, $sp, 4	
lw   $t0, 0($sp)	# loading temporary registers needed
lw   $t1, 4($sp)	# loading temporary registers needed
lw   $t2, 8($sp)	# loading temporary registers needed
addi $sp, $sp, 12
dont_swap_bytes:
addi $s3, $s3, 1	# incrementing into the next character
addi $t0, $t0, 1	# i++
addi $t1, $t1, 1	# j++
bgt  $t1, $s2, init_byte_bubblesort
j byte_bubblesort

sort_by_words:
li $t2, 0	# boolean isSorted = false
init_word_bubblesort:
li $t0, 0 	# i = 0
li $t1, 1	# j = 0
beq $t2, 1, finish_key_sort_matrix
li $t2, 1	# boolean isSorted = true
move $s3, $s4	# re-setting the string arrays address to the first index
word_bubblesort:
lw $t3, 0($s3)		# $t3 = char[i]
lw $t4, 4($s3)		# $t4 = char[j]
beq $t1, $s2, dont_swap_words
ble $t3, $t4, dont_swap_words
li $t2, 0		# boolean isSorted = false
sw $t4, 0($s3)		# swapping word
sw $t3, 4($s3)		# swapping word
move $a0, $s0		# loading arguments 0
move $a1, $s1		# loading arguments 1
move $a2, $s2		# loading arguments 2
move $a3, $t0		# loading arguments 3
addi $sp, $sp, -12	# allocating stack space
sw   $t0, 0($sp)	# saving temporary registers needed
sw   $t1, 4($sp)	# saving temporary registers needed
sw   $t2, 8($sp)	# saving temporary registers needed
addi $sp, $sp, -4	# allocating stack space for the fifth argument 
sw   $t1, 0($sp)	# loading arguments 4
jal  swap_matrix_columns
addi $sp, $sp, 4	
lw   $t0, 0($sp)	# loading temporary registers needed
lw   $t1, 4($sp)	# loading temporary registers needed
lw   $t2, 8($sp)	# loading temporary registers needed
addi $sp, $sp, 12
dont_swap_words:
addi $s3, $s3, 4	# incrementing into the next word
addi $t0, $t0, 1	# i++
addi $t1, $t1, 1	# j++
bgt  $t1, $s2, init_word_bubblesort
j word_bubblesort

finish_key_sort_matrix:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
addi $sp, $sp, 24
jr $ra


# Part IV
# $a0 = A 2D matrix of characters to transpose
# $a1 = The buffer in which to store the transposed matrix. The buffer will be large enough to
#store the result.
# $a2 = The number of rows in matrix src
# $a3 = The number of columns in matrix src.
transpose:
addi $sp, $sp, -20
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
sw $s3, 12($sp)
sw $s4, 16($sp)

blez $a2, transpose_error
blez $a3, transpose_error

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3
move $s4, $a0

init_transpose:
li $t0, 0	# i = 0 (row index counter)
li $t1, 0	# j = 0 (current row counter)
li $t2, 0	# k = 0 (current column counter) only increments after a column has been written
j transpose_loop

write_next_col:
li $t0, 0	# i = 0 (row index counter)
li $t1, 0	# j = 0 (current row counter)
move $s0, $s4	# back to first index of 2d matrix to transpose
addi $t2, $t2, 1
beq  $t2, $s3, transpose_success
j transpose_loop

next_row:
li $t0, 0	# i = 0 (row index counter)
addi $t1, $t1, 1
beq $t1, $s2, write_next_col
transpose_loop:
lb $t3, 0($s0)
bne $t0, $t2, wrong_column
sb $t3, 0($s1)
addi $s1, $s1, 1
wrong_column:
addi $s0, $s0, 1
addi $t0, $t0, 1
beq $t0, $s3, next_row
j transpose_loop

transpose_success:
li $v0, 0

finish_transpose:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
lw $s3, 12($sp)
lw $s4, 16($sp)
addi $sp, $sp, 20
jr $ra

transpose_error:
li $v0, -1
j finish_transpose


# Part VII
# $a0 = A 6 × 6 2D char array containing the 26 letters of the alphabet in uppercase and the digit
#characters 0-9. The characters are randomly ordered in the grid.
# $a1 = The plaintext message to be encrypted. You may assume that the plaintext will consist only
#of uppercase letters and digit characters.
# $a2 = The keyword being used to encrypt the message. You may assume that the keyword will consist
#only of uppercase letters and digit characters.
# $a3 = A buffer that will contain the encrypted ciphertext. The buffer is guaranteed to be large
#enough to store the null-terminated encrypted message.
encrypt:
addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $s7, 32($sp)

move $s0, $a0	# $s0 = ADFGVX grid
move $s1, $a1	# $s1 = plaintext message to encrypt
move $s2, $a2	# $s2 = keyword being used to encrypt
move $s3, $a3	# $s3 = buffer that contains the ciphertext

li   $t0, 0	# initializing character counter
move $t1, $s2	# $t1 = keyword being counted
count_key_length:	
lb   $t2, 0($t1)
beqz $t2, init_column_value	
addi $t1, $t1, 1
addi $t0, $t0, 1
j count_key_length

init_column_value:
move $s6, $t0	# $s6 = # of columns in buffer that contains the 2D ciphertext

li $t0, 0
move $t1, $s1
calculate_cipher_size:
lb $t2, 0($t1)
beqz $t2, calculate_heap_size
addi $t1, $t1, 1
addi $t0, $t0, 1 
j calculate_cipher_size

calculate_heap_size:
sll $t0, $t0, 1	# $t0 = (cipherSize * 2)
move $s5, $t0	# $s5 = size in bytes (characters) of encrypted ciphertext

li $t0, 0
calculate_heap_size_loop:
add $t0, $t0, $s6
bge $t0, $s5, initialize_heap
j calculate_heap_size_loop

initialize_heap:
move $s5, $t0
move $a0, $s5	# initializing heap
li $v0, 9	# initializing heap
syscall		# initializing heap
move $s4, $v0	# $s4 = empty heap

li $t0, 0
li $t1, '*'
move $t2, $s4
init_with_asterisks:
beq $t0, $s5, call_map_plaintext
sb $t1, 0($t2)
addi $t2, $t2, 1
addi $t0, $t0, 1
j init_with_asterisks

call_map_plaintext:
move $a0, $s0	
move $a1, $s1
move $a2, $s4
jal map_plaintext

calculate_row_value:
div  $s5, $s6	# divide # of characters in cipher by # of columns in cipher
mflo $s7 	# $s7 = # of rows in 2D buffer that contains the ciphertext

move $a0, $s4
move $a1, $s7
move $a2, $s6
move $a3, $s2
addi $sp, $sp, -4
li $t0, 1
sw $t0, 0($sp)
jal key_sort_matrix
addi $sp, $sp, 4

move $a0, $s4
move $a1, $s3
move $a2, $s7
move $a3, $s6
jal transpose

li $t0, '\0'
move $t1, $s3
add  $t1, $t1, $s5
sb   $t0, 0($t1)

finish_encrypt:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 28($sp)
lw $s7, 32($sp)
addi $sp, $sp, 36
jr $ra


# Part VIII
# $a0 = A 6 × 6 2D char array containing the 26 letters of the alphabet in uppercase and the digit
#characters 0-9. The characters are randomly ordered in the grid.
# $a1 = The ADFGVX character to serve as the row “coordinate”.
# $a2 = The ADFGVX character to serve as the column “coordinate”.
lookup_char:
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)

move $s0, $a0

beq $a1, 'A', char1_A
beq $a1, 'D', char1_D
beq $a1, 'F', char1_F
beq $a1, 'G', char1_G
beq $a1, 'V', char1_V
beq $a1, 'X', char1_X
j lookup_char_error

char1_A:
li $s1, 0
j valid_ADFGVX_char1

char1_D:
li $s1, 1
j valid_ADFGVX_char1

char1_F:
li $s1, 2
j valid_ADFGVX_char1

char1_G:
li $s1, 3
j valid_ADFGVX_char1

char1_V:
li $s1, 4
j valid_ADFGVX_char1

char1_X:
li $s1, 5
j valid_ADFGVX_char1

valid_ADFGVX_char1:
beq $a2, 'A', char2_A
beq $a2, 'D', char2_D
beq $a2, 'F', char2_F
beq $a2, 'G', char2_G
beq $a2, 'V', char2_V
beq $a2, 'X', char2_X
j lookup_char_error

char2_A:
li $s2, 0
j valid_ADFGVX_char2

char2_D:
li $s2, 1
j valid_ADFGVX_char2

char2_F:
li $s2, 2
j valid_ADFGVX_char2

char2_G:
li $s2, 3
j valid_ADFGVX_char2

char2_V:
li $s2, 4
j valid_ADFGVX_char2

char2_X:
li $s2, 5
j valid_ADFGVX_char2

valid_ADFGVX_char2:
li $t0, 0		# initializing row counter (i)
li $t1, 0		# initializing col counter (j)
move $t2, $s0		# initializing ADFGVX matrix
j loop_ADFGVX_grid

next_row_to_loop:
li $t1, -1		# initializing col counter (j)
addi $t0, $t0, 1	# next row
loop_ADFGVX_grid:	
lb  $t3, 0($t2)		# load char	
bne $t0, $s1, next_char # if row matches
bne $t1, $s2, next_char # and column matches
j lookup_char_success   # then were at the character we are looking for in the matrix
next_char:	
beq  $t1, 5, next_row_to_loop	
addi $t1, $t1, 1	# increment column counter
addi $t2, $t2, 1	# increment into the next character 
j loop_ADFGVX_grid

lookup_char_success:
li   $v0, 0
move $v1, $t3
finish_lookup_char:
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
addi $sp, $sp, 12
jr $ra


lookup_char_error:
li $v0, -1
li $v1, -1
j finish_lookup_char


# Part IX
# $a0 = The string to sort.
string_sort:
addi $sp, $sp, -4
sw $s0, 0($sp)

move $s0, $a0
move $t0, $s0
li $t3, 0
j string_sort_loop

reset_current_index:
move $t0, $s0
beq $t3, 1, finish_string_sort
li $t3, 1
string_sort_loop:
lb $t1, 0($t0)
lb $t2, 1($t0)
beq $t2, $zero reset_current_index 
ble $t1, $t2, skip_the_swap
sb $t1, 1($t0)
sb $t2, 0($t0)
li $t3, 0
skip_the_swap:
addi $t0, $t0, 1
j string_sort_loop

finish_string_sort:
lw $s0, 0($sp)
addi $sp, $sp, 4
jr $ra


# Part X
# $a0 = A 6 × 6 2D char array containing the 26 letters of the alphabet in uppercase and the digit
#characters 0-9. The characters are randomly ordered in the grid.
# $a1 = The null-terminated ciphertext to be decrypted. You may assume that the ciphertext is
#valid.
# $a2 = The keyword used to encrypt the original plaintext. You may assume that this is the correct
#keyword that was used to encrypt the original plaintext.
# $a3 = Space allocated to save the null-terminated decrypted ciphertext. You may assume that the
#buffer is large enough to store the null-terminated result.
decrypt:
addi $sp, $sp, -36
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $s7, 32($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

li   $t0, 0	# initializing character counter
move $t1, $s2	# $t1 = keyword being counted
count_key_length_decrypt:	
lb   $t2, 0($t1)
beqz $t2, init_column_value_decrypt	
addi $t1, $t1, 1
addi $t0, $t0, 1
j count_key_length_decrypt

init_column_value_decrypt:
move $s4, $t0	# $s4 = the length of the keyword
move $a0, $t0
li $v0, 9
syscall
move $s5, $v0	# $s5 = heap_keyword (to be copied into and sorted)

move $t0, $s2
move $t1, $s5
copy_keyword:
lb $t2, 0($t0)
beqz $t2, sort_key_copy
sb $t2, 0($t1)
addi $t0, $t0, 1
addi $t1, $t1, 1
j copy_keyword

sort_key_copy:
move $a0, $s5
jal string_sort

build_heap_keyword_indices:
move $a0, $s4	# $s4 = the number of bytes (characters) in the keyword
sll $a0, $a0, 2 # here we multiply by 4 since each integer is a word
li $v0, 9
syscall
move $s6, $v0	# $s6 = heap_keyword_indices (to store the indices of the unsorted key in sorted order)

move $t0, $s2	# keyword
li   $t1, 0	# keyword index counter
init_heap_keyword_indices:
lb $t2, 0($t0)
beqz $t2, get_ciphertext_size
addi $sp, $sp, -8
sw $t0, 0($sp)
sw $t1, 4($sp)
move $a0, $t2
move $s7, $t1
jal match_to_sorted_key
lw $t0, 0($sp)
lw $t1, 4($sp)
addi $sp, $sp, 8
addi $t0, $t0, 1
addi $t1, $t1, 1
j init_heap_keyword_indices

get_ciphertext_size:
move $t0, $s1
li $t1, 0
loop_ciphertext_size:
lb $t2, 0($t0)
beqz $t2, transpose_ciphertext  
addi $t1, $t1, 1
addi $t0, $t0, 1
j loop_ciphertext_size

transpose_ciphertext:
div $t1, $s4 
mflo $s7	# $s7 = the number of rows in the 2D cipher
move $a0, $t1
li $v0, 9
syscall
move $s5, $v0

move $a0, $s1
move $a1, $s5
move $a2, $s4
move $a3, $s7
jal transpose

move $a0, $s5
move $a1, $s7
move $a2, $s4
move $a3, $s6
addi $sp, $sp, -4
li $t0, 4
sw $t0, 0($sp)
jal key_sort_matrix
addi $sp, $sp, 4

move $t0, $s5
move $t3, $s3
li $s7, 0
decode_cipher:
lb $t1, 0($t0)
lb $t2, 1($t0)
beqz $t2, break_decode_cipher
beq  $t2, '*', break_decode_cipher
move $a0, $s0
move $a1, $t1
move $a2, $t2
addi $sp, $sp, -8
sw $t0, 0($sp)
sw $t3, 4($sp)
jal lookup_char
lw $t0, 0($sp)
lw $t3, 4($sp)
addi $sp, $sp, 8
sb $v1, 0($t3)
addi $t3, $t3, 1
addi $t0, $t0, 2
addi $s7, $s7, 1
j decode_cipher

break_decode_cipher:
move $t0, $s3
add  $t0, $t0, $s7
li $t1, '\0'
sb $t1, 0($t0)

finish_decrypt:
lw $ra, 0($sp)
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 24($sp)
lw $s7, 32($sp)
addi $sp, $sp, 36
jr $ra


# $a0 = the character whos index we need to find
match_to_sorted_key:
addi $sp, $sp, -4
sw $ra, 0($sp)
move $t0, $s5	# sorted keyword
li   $t1, 0	# current index counter
match_to_sorted_key_loop:
lb $t6 0($t0)
bne $t6, $a0, check_next_char
j write_int_to_indices_array # if (characters match) then write index value to correct index
check_next_char:
beq  $t1, $s4, finish_match_to_sorted_key
addi $t1, $t1, 1
addi $t0, $t0, 1
j match_to_sorted_key_loop
finish_match_to_sorted_key:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# $a0 = index from original key value (number to store in array)
# $a1 = index of indices array to write it to (index to store it at)
write_int_to_indices_array:
move $t3, $s6
move $t4, $t1
sll $t4, $t4, 2
add $t3, $t3, $t4
sw  $s7, 0($t3)
j check_next_char



#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
