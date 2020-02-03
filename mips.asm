#####################################################################
#                                                                   #
# Name: Hakan Sahin                                                 #
# KUSIS ID:                                             	        #
#####################################################################

# This file serves as a template for creating 
# your MIPS assembly code for assignment 2

.eqv MAX_LEN_BYTES 400

#====================================================================
# Variable definitions
#====================================================================

.data
input_data:        .space    MAX_LEN_BYTES     #Define length of input list
arg_err_msg:       .asciiz   "Argument error"
input_msg:         .asciiz   "Input integers"
#  You can define other data as per your need.
input_n_msg:	   .asciiz   "-n "
input_data_msg:    .asciiz   "Enter Integers\n"
sorted_list_msg:   .asciiz   "Sorted List\n"
sorted_list_nd_msg:.asciiz   "\nSorted list without duplicates\n"
list_sum_msg:      .asciiz   "\nList Sum\n"
space_msg:         .asciiz   " "

#==================================================================== 
# Program start
#====================================================================

.text
.globl main

main:
   #
   # Main program entry
   #
   #
   # Main body
   # 
   
   # Check for command line arguments count and validity
   li $v0, 4							# Telling the system that I will print out a message
   la $a0, input_n_msg						# Loading the system which message I will print on console in this case: "-n "
   syscall							# Telling the system to do it
   
   li $v0, 5							# Telling the system that I will read the next input from console, integer which will be stored in $v0
   syscall							# Telling the system to do it
   
   addi $t0, $zero, 100						# we need to check validity of the argument in n, therefore if (n < 0) and (n > 100), we goto Arg_Err
   if_check_on_the_n:						# the rest is handled automaticly. the reason why it cannot be higher than 100 is because max_len_bytes is 
      blt $v0, $zero, Arg_Err					# equal to 400, which can store up to 100 integers.
      bgt $v0, $t0, Arg_Err
   if_check_on_the_n_end:
   
   add $s0, $v0, $zero						# Transferring the integer we recieved from user to $s0, in this case, the array length
   
   # Since our next job is to go to Data_Input part, we don't need to jump there since it is in the next lines.
   
   
   


 
   

Data_Input:
   # Get integers from user as per value of n
   
   ##################  YOUR CODE  ####################
   li $v0, 4							# Telling the system that I will print out a message
   la $a0, input_data_msg					# Loading the system which message I will print on console in this case: "Enter Integers\n"
   syscall							# Telling the system to do it
   
   add $t0, $zero, $zero					# Two variables are needed, one for the for loop and one for iterating inside the array
   add $t1, $zero, $zero
   Data_Input_Loop:   						# for loop begin
      beq $t0, $s0, Data_Input_Loop_Exit			# if (i==array.length), go to loop exit, since our for loop would be done
      li $v0, 5							# Telling the system that I will read the next input from console, integer which will be stored in $v0
      syscall							# Telling the system to do it
      sw $v0, input_data($t1)					# A[i] = inputRecieved
      addi $t0, $t0, 1						# i++
      addi $t1, $t1, 4						# to go to next empty space in Array
      j Data_Input_Loop						# go to the start of the loop since we might not be done with iterations
   Data_Input_Loop_Exit:
   
   # Since our next task is to do the sorting, it happens to be the next one, so there is no need to use jump
   
   
   
   
# Insertion sort begins here
sort_data:

   ##################  YOUR CODE  ####################
   # insertion sort can be done with two loops, a main for loop and a while loop inside that loop, 
   # therefore ending with O(n^2)
   addi $t0, $zero, 1						# int i = 1
   addi $t1, $zero, 4						# for iterating over in array for i
   sort_data_main_loop:						# start of our main for loop
      beq $t0, $s0, sort_data_main_loop_exit			# if (i==array.length), exit the loop
      lw $t2, input_data($t1)					# int key = A[i]
      addi $t3, $t0, -1						# int j = i - 1
      sort_data_main_loop_2:					# start of the while loop
         blt $t3, $zero, sort_data_main_loop_2_exit		# if (j < 0), get out of the while loop
         sll $t4, $t3, 2					# we require A[j], but in order to get it, we need to multiply it by 4
         lw $t5, input_data($t4)				# int temp = A[j]
         ble $t5, $t2, sort_data_main_loop_2_exit 		# if (A[j] <= key), get out of the while loop
         addi $t6, $t3, 1					# int temp2 = j + 1
         sll $t7, $t6, 2					# we require A[j+1], but in order to get it, we need to multiply it by 4
         sw $t5, input_data($t7)				# A[j+1] = A[j]
         addi $t3, $t3, -1					# j = j -1
         j sort_data_main_loop_2				# goto while loop start
      sort_data_main_loop_2_exit:				# while loop exit
      addi $t3, $t3, 1						# we require j = j + 1, again
      sll $t8, $t3, 2						# we require A[j+1] again
      sw $t2, input_data($t8)					# A[j+1] = key
      addi $t0, $t0, 1						# i++
      addi $t1, $t1, 4						# incrementing by 4 to get value from the array again
      j sort_data_main_loop					# goto start of for loop
   sort_data_main_loop_exit:					# exit of the for loop
   j print_w_dup						# since will print out the sorted array, we need to jump to that part

remove_duplicates:
   ##################  YOUR CODE  ####################
   # A simple code that removes duplicates inside a sorted array, as an example if our array contains 1, 1, 3, 3, 5. It will be 1, 3, 5.
   # The algorithm is in place since I don't know if we were allowed to use extra space or not.
   addi $t0, $zero, 1						# int i = 1
   add $t1, $zero, $zero					# int j = 0
   ble $s0, $t0, remove_duplicates_loop_exit			# if(array.length <= 1) we don't need to do these instructions
   remove_duplicates_loop:					# start of the loop
   beq $t0, $s0, remove_duplicates_loop_exit			# if (i==array.length), goto the end of the loop
   sll $t2, $t0, 2						# we require A[i]
   sll $t3, $t1, 2						# we require A[j]
   lw $t4, input_data($t2)					# temp = A[i]
   lw $t5, input_data($t3)					# temp2 = A[j]
   remove_duplicates_loop_if:					# if start
      beq $t4, $t5, remove_duplicates_loop_if_exit		# if (A[i]==A[j]) goto the end of the if
      addi $t1, $t1, 1						# j++
      sll $t6, $t1, 2						#  since we require A[j] once again
      sw $t4, input_data($t6)					# A[j]=A[i]
   remove_duplicates_loop_if_exit:				# if end
   addi $t0, $t0, 1						# i++
   j remove_duplicates_loop					# goto the start of the loop
   remove_duplicates_loop_exit:					# loop exit
   addi $s0, $t1, 1						# modifying $s0 since our new array length is j + 1
   j print_wo_dup						# jump to print_wo_dup since it is our next task
      
       
   
      

# Print sorted list with and without duplicates



print_w_dup:

   ##################  YOUR CODE  ####################
   # Just a simple method to print out every element in the Array, 
   # since it is already sorted, it will give us a sorted list
   li $v0, 4							# Telling the system that I will print out a message
   la $a0, sorted_list_msg					# Loading the system which message I will print on console in this case: "Sorted List\n"
   syscall							# Telling the system to do it
   
   add $t0, $zero, $zero					# int i = 0;
   add $t1, $zero, $zero 					# for iterating inside the array
   print_w_dup_loop:						# start of the printing process
      beq $t0, $s0, print_w_dup_loop_exit			# if(i==array.length), jump to exit
      lw $t2, input_data($t1)					# temp = A[i]
      
      li $v0, 1							# Telling the system that I will print out an integer
      add $a0, $t2, $zero					# Telling the system that which integer I will print out
      syscall							# Telling the system to do it
      
      li $v0, 4							# Telling the system that I will print out a message
      la $a0, space_msg						# Loading the system which message I will print on console in this case: " ", since I want a space between those elements to match the output
      syscall							# Telling the system to do it
      
      addi $t0, $t0, 1						# i++
      addi $t1, $t1, 4						# incrementing to iterate inside the array
      j print_w_dup_loop					# goto the start of the loop
   print_w_dup_loop_exit:					# loop exit
   j remove_duplicates						# since our next task is to remove duplicates in the array, we go to that part
   
   
   
print_wo_dup:

   ##################  YOUR CODE  ####################
   # this is just a recycled version of print_w_dup, therefore there is no need to use comments, however
   # the only difference is that different message is loaded and printed this time. Also there is no need
   # to jump at the end of the method since our next task is reduction
   li $v0, 4							
   la $a0, sorted_list_nd_msg
   syscall
   
   add $t0, $zero, $zero
   add $t1, $zero, $zero 
   print_wo_dup_loop:
      beq $t0, $s0, print_wo_dup_loop_exit
      lw $t2, input_data($t1)
      
      li $v0, 1
      add $a0, $t2, $zero
      syscall
      
      li $v0, 4
      la $a0, space_msg
      syscall
      
      addi $t0, $t0, 1
      addi $t1, $t1, 4
      j print_wo_dup_loop
   print_wo_dup_loop_exit:

# Perform reduction
   
   ##################  YOUR CODE  ####################
   # This method simply iterates over the array according to its length and sums up each element
   # then prints it out in the console
reduction:
   li $v0, 4							# Telling the system that I will print out a message
   la $a0, list_sum_msg						# Loading the system which message I will print on console in this case: "\nList Sum\n"
   syscall							# Telling the system to do it
   
   add $t0, $zero, $zero					# int i = 0
   add $t1, $zero, $zero 					# for iterating inside the array
   add $t3, $zero, $zero					# int sum = 0
   reduction_loop:						# start of the loop
      beq $t0, $s0, reduction_loop_exit				# if(i==array.length), goto exit
      lw $t2, input_data($t1)					# temp = A[i]
      add $t3, $t3, $t2						# sum = sum + temp
      addi $t0, $t0, 1						# i++
      addi $t1, $t1, 4						# incrementing the inside of the array to move to next element
      j reduction_loop						# goto start of the loop
   reduction_loop_exit:						# loop exit
# Print sum
  # this part was already given therefore, it is the reason why I used $t3 up at the top.
  li  $v0, 1
  addi $a0, $t3, 0      # $t3 contains the sum  
  syscall

   j Exit							# we are jumping to exit since we are done with the program
   
Arg_Err:
   # Error message when no input arguments specified
   # or when argument format is not valid
   la $a0, arg_err_msg
   li $v0, 4
   syscall
   j Exit

Exit:   
   # Jump to this label at the end of the program
   li $v0, 10
   syscall
