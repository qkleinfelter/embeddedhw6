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


	   AREA DATA
A 	   SPACE 7 ; 6 characters of space + an ending byte for null term

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
	BL initString
	LDR R0, =A ; Load address of beginning of string into R0
	MOV R1, #3 ; Set our shift value to 3
	BL caesarShift
	
initString
	LDR R0, =A
	MOV R1, #67 ; Character C
	STRB R1, [R0], #1 ; Store it in the first element of array
	
	MOV R1, #97 ; Character a
	STRB R1, [R0], #1 
	
	MOV R1, #101 ; e
	STRB R1, [R0], #1
	
	MOV R1, #115 ; s
	STRB R1, [R0], #1
	
	MOV R1, #97 ; a 
	STRB R1, [R0], #1
	
	MOV R1, #114 ; r
	STRB R1, [R0], #1
	BX LR
	
caesarShift
caesarLoop
	LDRB R2, [R0] ; Read the value at R0 into R2
	CMP R2, #0 ; compare that to 0
	BXEQ LR ; If we hit the null-term exit
	CMP R2, #97 ; Compare the value to lowercase a
	ADD R2, R1 ; Shift it by the specified amount of characters
	BHS lowercase ; branch out if we need to do some rollover with lowercase
	CMP R2, #90 ; Compare R2 to Z
	SUBHI R2, #26 ; If we're greater than 90 (Z) we need to roll over
	B continue ; continue looping
lowercase
	CMP R2, #122 ; Check if we're greater than 122 (z)
	SUBHI R2, #26 ; rollover to the beginning of the alphabet
continue
	STRB R2, [R0] ; Store the byte at R2 into the address at R0
	ADD R0, #1 ; add one byte to R0 so we go to the next char in the string
	B caesarLoop ; Continue the loop

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
	
	; XORing the values of R0 and R1 will make it so that all bits that differ
	; between the 2 numbers will be a 1 in the updated register, then we just
	; need to count the number of ones in our new R0 register to determine the 
	; hamming distance, so we can use the subroutine from question 4 to accomplish this
	MOV R0, #0x000F
	MOVT R0, #0x0000
	MOV R1, #0x0000
	MOVT R1, #0x0000
	EOR R0, R1 
	B countOneBits
	
loop   B    loop


       ALIGN      ; make sure the end of this section is aligned
       END        ; end of file
       