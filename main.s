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
	; This subroutine takes 8 integer arguments and computes the product of these integers
	; Extra arguments are passed via the stack & return value is in R0
	
question2
	; This subroutine implements a Caesar Shift Encryption

question3
	; This uses a subroutine called MoviePrice to calculate the movite ticket price based
	; on the input argument (R0) called age, if age < 12 price (returned in R0)
	; is $6.00, if 13 < age < 64, price = $8.00 and if age > 65 price = $7.00

question4
	; Uses a subroutine to determine how many 1-bits exist in a 32 bit number,
	; i.e. determines the parity of the 32-bit number
	; Arguments: R0 = number to check
	; Returns: R0 = Number of 1 bits
	
question5
	; Uses a subroutine to find out how many bits differ in 2 32-bit numbers
	; i.e. determines the Hamming Distance
	; Arguments: R0 = first number, R1 = second number
	; Returns: R0 = number of bits that differ
	
loop   B    loop


       ALIGN      ; make sure the end of this section is aligned
       END        ; end of file
       