.data
test_n: .double 0.0 1.0 2.0 3.0 4.0 5.0 10.0 2.25 15.0 100.0 2.1 15.23232 0.0001 15.9999999999
test_n_end:
correct_answers: .double 0.0 1.0 1.414213562373095 1.7320508075688772 2.0 2.23606797749979 3.162277660168379 1.5 
			3.872983346207417 10.0 1.449137674618944 3.9028604894359216 0.01 3.9999999999874998
entered_text: .asciz "Entered N: "
.include "macrolib.s"
.global tests_setup
.text
tests_setup:
	addi sp sp -36
	sw ra (sp)
	sw s0 4(sp)
	sw s1 8(sp)
	fsw fs0 12(sp)
	fsw fs1 20(sp)
	fsw fs2 28(sp)
	la s0 test_n			# test_n address
	la s1 correct_answers		# correct_answers address
tests:
	fld fs0 (s0)			# test_n value
	fld fs1 (s1)			# corect_answers value
	li a7 4
	la a0 entered_text
	ecall
	li a7 3
	fmv.d fa0 fs0
	ecall
	li a7 11
	li a0 '\n'
	ecall
	square_root_calculations(fa0)	# Pass n(fa0) return calculaded root(fa0)
	fmv.d fs2 fa0
	fmv.d fa1 fs0
	print_result(fa1, fa0)		# Pass n(fa1) and calculaded root(fa0) return nothing
	fmv.d fa0 fs1
	fmv.d fa1 fs2
	correct_answer_check(fa0 fa1)	# Pass correct answer(fa0) and calculated root(fa1) return nothing
	li a7 11
	li a0 '\n'
	ecall
	addi s0 s0 8
	addi s1 s1 8
	la a0 test_n_end		# test_n_end address
	blt s0 a0 tests 
done:
	lw ra (sp)
	lw s0 4(sp)
	lw s1 8(sp)
	flw fs0 12(sp)
	flw fs1 20(sp)
	flw fs1 28(sp)
	addi sp sp 36
	ret