.data 
	read_n: .asciz "Enter N from which we will take the root: "
	n_less_than_0: .asciz "N is less than 0, you can't take square root of negative number, enter again: "
	equals_text: .asciz "\nThe calculated answer is equals to the correct answer taking into account the error\n"
	not_equals_text: .asciz "\nThe calculated answer isn't equals to the correct answer taking into account the error\n"
	square: .asciz "Square root of "
	is: .asciz " is: "
	correct_text: .asciz "\nCorrect answer: "


.macro input_n ()			# Pass nothing, return fa0
	fcvt.d.w ft0 zero
	la a0 read_n
	li a7 4
	ecall
	less_than_0:
	li a7 7
	ecall
	fge.d a0 fa0 ft0
	bgtz a0 gtr_than_0_or_eq	# You can't take square root of negative number
	li a7 4
	la a0 n_less_than_0
	ecall
	j less_than_0
	gtr_than_0_or_eq:
.end_macro 


.macro square_root_calculations(%n)	# Pass original value(n) return root of that value(fa0)
fmv.d ft1 %n
fcvt.d.w ft0 zero
feq.d a0 ft1 ft0
bnez a0 zero_case		# Check if n is zero
li t0 1
fcvt.d.w ft0 t0
fmv.d ft4 ft0
li t0 2
fcvt.d.w ft2 t0
li t0 20000000
fcvt.d.w ft5 t0
fdiv.d ft4 ft4 ft5
loop:					# x_n+1 = 1/2 (x_n + a/x_n)  ft0 = 1/2(ft0 + ft1/ft0)
	fmv.d ft5 ft0
	fdiv.d ft3 ft1 ft0		# temp = a/x_n		ft3 = ft1/ft0
	fadd.d ft3 ft3 ft0		# temp += x_n		ft3 = ft3 + ft0
	fdiv.d ft0 ft3 ft2		# x_n+1 = temp/2	ft0 = ft3/2
	fsub.d ft5 ft5 ft0
	fabs.d ft5 ft5
	fgt.d t0 ft5 ft4		# |x_n-x_n+1|
	bgtz t0 loop			# if difference between x_n+1 and x_n is greater than 1/20000000 make another iteration
loopend:
zero_case:
fmv.d fa0 ft0
.end_macro

 .macro print_result(%n %result)	# Pass original value(n) and root of that value(result) return nothing
 	fmv.d ft0 %result
 	fmv.d ft1 %n
 	li a7 4
 	la a0 square
 	ecall
 	li a7 3
 	fmv.d fa0 ft1
 	ecall
 	li a7 4
 	la a0 is
 	ecall
 	fmv.d fa0 ft0
 	li a7 3
	ecall
.end_macro 

.macro correct_answer_check(%n %answer)	# Pass original value(n) and calculated root(answer) return nothing
	fmv.d ft0 %n
	fmv.d ft1 %answer
	li a7 4
	la a0 correct_text
	ecall
	li a7 3
	fsqrt.d fa0 ft0				# Calculate square with built-in command
	ecall
	li t0 1
	fcvt.d.w ft4 t0
	li t0 20000000			
	fcvt.d.w ft5 t0
	fdiv.d ft4 ft4 ft5
	fsub.d fa0 ft1 fa0
	fabs.d fa0 fa0				# |sqrt(n) - answer|
	fge.d a0 ft4 fa0			# 1/20000000 >= |sqrt(n) - answer| ? 
	bnez a0 answer_is_correct		# Check if calculated root is equal to the correct answer taking into account the error
	li a7 4
	la a0 not_equals_text
	ecall
	j answer_is_wrong
	answer_is_correct:
	li a7 4
	la a0 equals_text
	ecall
	answer_is_wrong:
.end_macro 
