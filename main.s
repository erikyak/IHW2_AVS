.data
option: .asciz "If you want to run tests enter 1, else if you want input from keyboard, enter 0: "

.global main

.text
main:
	li a7 4
	la a0 option
	ecall
	li a7 5
	ecall
	beqz a0 keyboard_input		# Choose between tests and keyboard input
	jal tests_setup
	j tests_input
	keyboard_input:
	jal keyboard
	tests_input:
	li a7 10
	ecall
