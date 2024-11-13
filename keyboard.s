.include "macrolib.s"
.global keyboard

.text 
keyboard:
	addi sp sp -12
	sw ra (sp)
	fsw fs0 4(sp)
	input_n()			# Pass nothing, return fa0
	fmv.d fs0 fa0			# Save fa0
	square_root_calculations(fa0)	# Pass n(fa0) return calculaded root(fa0)
	fmv.d fa1 fs0
	print_result(fa1, fa0)		# Pass n(fa1) and calculaded root(fa0) return nothing
	lw ra (sp)
	flw fs0 4(sp)
	addi sp sp 12
	ret
