########################################
#	CYPHER 							                 #
#		---- Lankathilaka, Nirmal          #
#            @Srdyel                   #
########################################

	.text
	.global main

#begin
main:
	sub	sp, sp, #4
	str	lr, [sp, #0]


#	CHOOSE ACTION
__print:
	ldr 	r0, =f_text_1
	bl 	printf
	b 	__scanf_d_e

__scanf_d_e:
	sub	sp, sp, #4
	ldr 	r0, =f_string
	mov r1, sp
	bl 	scanf
	mov		r3, sp
__scanf_d_e_ldrb:
	ldrb 	r2, [r3, #0]
__scanf_d_e_end:
	add sp, sp, #4

#	BRANCH TO APPROPRIATE ACTION
	cmp		r2, #'E'
	beq	__ENC__
	cmp		r2, #'D'
	beq __DEC__
	ldr r0, =f_text_7
	bl 	printf
	b 	__print

# ENCRIPTION -- initiate
__ENC__:

#	GET PLAINTEXT
__scanf:
	ldr		r0, =f_text_2
	bl	printf
	sub	sp, sp, #44
	ldr		r0, =f_string
	mov	r1, sp
	bl	scanf
	mov		r5, sp
	# memory-clear at #__scanfEnd
#	GET KEY
__scanf_key:
	ldr		r0, =f_text_4
	bl	printf
	sub	sp, sp, #4
	ldr 	r0, =f_digit
	mov r1, sp
	bl 	scanf
	mov		r3, sp
__scanf_key_ldrb:
	ldr 	r6, [r3, #0]
# __scanf_key_end:
	add sp, sp, #4

#	START PRINTING CYPHERTEXT
	ldr		r0, =f_text_6
	bl	printf

	# skip __DEC__
	b __encript


# DECRIPTION -- initiate
__DEC__:

#	GET CYPHERTEXT
__dec__scanf:
	ldr		r0, =f_text_3
	bl	printf
	sub	sp, sp, #44
	ldr		r0, =f_string
	mov	r1, sp
	bl	scanf
	mov		r5, sp
	# memory-clear at #__dec__scanfEnd

#	GET KEY
__dec__scanf_key:
	ldr		r0, =f_text_4
	bl	printf
	sub	sp, sp, #4
	ldr 	r0, =f_digit
	mov r1, sp
	bl 	scanf
	mov		r3, sp
__dec__scanf_key_ldrb:
	ldr 	r6, [r3, #0]
# __dec__scanf_key_end:
	add sp, sp, #4

	#make key negative
	mov r8, #-1
	mul	r9, r6, r8
	mov r6, r9

#	START PRINTING PLAINTEXT
	ldr		r0, =f_text_5
	bl	printf


# DO ENCRIPTION/DECRIPTION
__encript:

#	"FOR EACH CHAR"
__encript_loop_start:
	mov		r4, #0
__encript_loop:
	ldr 	r0, =f_char
	ldrb	r7, [r5, r4]
	mov	r1, r7
__encript_EOF:
		cmp	r7, #0
		beq	__encript_loop_end
__encript_encript:
	add		r1, r1, r6

#	SKIP NON-ALPHABET CHARS
__encript_specialchar:
	cmp		r7, #'A'
	bge	__maybe_cap
	mov r1, r7
	b 	__encript_printchar
	__maybe_cap:
		cmp 	r7, #'Z'
		bgt		__check_sim
		mov 	r11, #'A'
		b 	__encript_range
		__check_sim:
			cmp 	r7, #'a'
			bge __maybe_sim
			mov r1, r7
			b 	__encript_printchar
			__maybe_sim:
				cmp 	r7, #'z'
				movle 	r11, #'a'
				ble 	__encript_range
				mov r1, r7
				b 	__encript_printchar
__encript_specialchar_end:

#	KEEP CHARS IN RANGE
__encript_range:

	add	r1, r7, r6
	mov r10, r1
	add r12, r11, #26

	cmp 	r10, r11
	blt	 __add_26

	cmp 	r10, r12
	bgt	 __sub_26

	b 	__encript_printchar

	__add_26:

		cmp 	r10, r11
		blt	 __add_26_iter
		b 	 __add_26_end
		__add_26_iter:
			add 	r10, r10, #26
			mov 	r1, r10
			b 	__add_26
		__add_26_end:
			b 	__encript_printchar

	__sub_26:

		cmp 	r10, r12
		bgt	 __sub_26_iter
		b 	 __sub_26_end
		__sub_26_iter:
			sub 	r10, r10, #26
			mov 	r1, r10
			b 	__sub_26
		__sub_26_end:
			b 	__encript_printchar

__encript_range_end:

#	PRINT THE CHAR
__encript_printchar:
	bl printf
__encript_iterate:
	add		r4, r4, #1
	cmp		r4, #40
	blt	__encript_loop
__encript_loop_end:
#encript_loop_end_print:
	ldr		r0, =f_n
	bl	printf

# FINISH
b __end



#end
__end:

	#__scanfEnd memory-clear
	add	sp, sp, #44
	
	ldr	lr, [sp, #0]
	add	sp, sp, #4
	mov	pc, lr


# STRINGS AND FORMATS
	.data
f_text_1:	.asciz "Encrypt(E) or Decrypt(D)? "
f_text_2: 	.asciz "Plaintext? "
f_text_3: 	.asciz "Ciphertext? "
f_text_4:	.asciz "Key? "
f_text_5:	.asciz "The plaintext is "
f_text_6:	.asciz "The ciphertext is "
f_text_7:	.asciz "Invalid Input, Please Try Again!\n"
f_string:	.asciz "%s"
f_string_n:	.asciz "%s\n"
f_digit:	.asciz "%d"
f_digit_n:	.asciz "%d\n"
f_char:		.asciz "%c"
f_char_n:	.asciz "%c\n"
f_n: 		.asciz "\n"
