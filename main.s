;*******************************************************************
; main.s
; Author: Quinn Kleinfelter
; Date Created: 10/11/2020
; Last Modified: 10/11/2020
; Section Number: 001/003
; Instructor: Devinder Kaur / Suba Sah
; Homework Number: 6
;   Brief description of the program
;
;*******************************************************************



       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
       EXPORT  Start
Start

main
	BL question1
	BL question2
	BL question3
	BL question4
	BL question5
	B loop

question1
	; This calls a subroutine (calcProduct) which takes 8 integer arguments
	; and computes the product of these integers
	; Extra arguments are passed via the stack & return value is in R0
	MOV R0, #1
	MOV R1, #2
	MOV R2, #3
	MOV R3, #4
	; These first 4 args are used normally, the next ones we need to put on the stack
	MOV R4, #5
	MOV R5, #6
	MOV R6, #7
	MOV R7, #8
	PUSH {R4-R7} ; Push these ones onto the stack
	B calcProduct
	
calcProduct
	MUL R0, R1 ; R0 = R0 * R1
	MUL R0, R2 ; R0 = R0 * R2
	MUL R0, R3 ; R0 = R0 * R3
	; Now we need to loop through our registers that are on the stack
	; and multiply them into our current product
	; we know there are 4 of them so we start with a counter variable in R1
	MOV R1, #4
loopProduct
	POP {R2} ; pops the top value of the stack into R2
	MUL R0, R2 ; R0 = R0 * R2 (top of the stack)
	SUBS R1, #1 ; Subtract 1 from the counter
	BXEQ LR ; If our counter is 0 then we can return to the caller (main)
	B loopProduct ; Continue looping if our counter isn't 0
	
question2
	; This subroutine implements a Caesar Shift Encryption

question3
	; This uses a subroutine called MoviePrice to calculate the movie ticket price based
	; on the input argument (R0) called age, if age <= 12 price (returned in R0)
	; is $6.00, if 12 < age < 65, price = $8.00 and if age >= 65 price = $7.00
	B MoviePrice
	
MoviePrice
	MOV R0, #15 ; age = 15
	CMP R0, #12 ; Compare the age to 12
	BLT child ; Branch to child (age < 12)
	BEQ child ; Branch to child (age = 12)
	BGT adultOrSenior ; Branch to deciding whether they are an adult or senior (age > 12)
	BX LR ; redundant
	
child
	MOV R0, #6 ; Age is less than 12 so price is 6
	BX LR ; go back to main
	
adultOrSenior
	CMP R0, #65 ; Compare the age to 65
	BLT adult ; Branch to adult (age < 65)
	BEQ senior; Branch to senior (age = 65)
	BGT senior; Branch to senior (age > 65)
	BX LR ; redundant
	
adult
	MOV R0, #8 ; 12 < age < 65 so price is 8
	BX LR ; go back to main

senior
	MOV R0, #7 ; age >= 65 so price is 7
	BX LR ; go back to main

question4
	; Uses a subroutine to determine how many 1-bits exist in a 32 bit number,
	; i.e. determines the parity of the 32-bit number
	; Arguments: R0 = number to check
	; Returns: R0 = Number of 1 bits
	MOV R0, #0x0F0F
	MOVT R0, #0x0F0F ; sets our 32 bit number to be half 1's
	B countOneBits
	
countOneBits
	MOV R1, #32 ; counter variable for our 32 bit number
	MOV R2, #0 ; count of the 1 bits
countingLoop
	CMP R0, #0 ; compare our R0 value to 0, to check if there is a 1 in the MSB
	; If our LT flag is set, than we know the MSB is a 1 because only negative
	; numbers are less than 0 and all negative numbers have a 1 in the MSB, so add 1 to the counter
	ADDLT R2, #1 
	LSL R0, #1 ; Now shift the value one bit to the left to update the MSB
	SUBS R1, #1 ; Subtract 1 from our loop counter
	BNE countingLoop ; Check if the loop counter is 0, if it isn't continue looping
	MOV R0, R2 ; otherwise move the value in R2 (the number of 1's) into R0 to return it
	BX LR ; and go back to the main function
	
question5
	; Uses a subroutine to find out how many bits differ in 2 32-bit numbers
	; i.e. determines the Hamming Distance
	; Arguments: R0 = first number, R1 = second number
	; Returns: R0 = number of bits that differ
	
loop   B    loop


       ALIGN      ; make sure the end of this section is aligned
       END        ; end of file
       