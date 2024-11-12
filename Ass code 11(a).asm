.STACK 100h

.DATA
    num1 DB 6                ; First number (single byte)
    num2 DB 4                ; Second number (single byte)
    gcd_res DB 0             ; To store GCD result (single byte)
    lcm_res DW 0             ; To store LCM result (two bytes for larger result)
    resultMsg DB 'The LCM is: $' ; Message to display

.CODE
main:
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Load num1 and num2 into AL and BL for GCD calculation
    MOV AL, num1
    MOV BL, num2
    CALL gcd                  ; Calculate GCD of num1 and num2
    MOV gcd_res, AL           ; Store GCD in gcd_res

    ; Calculate LCM using (num1 * num2) / GCD
    MOV AL, num1              ; Load num1 into AL
    MOV AH, 0                 ; Clear AH for 16-bit multiplication
    MOV DL, num2              ; Load num2 into DL
    MUL DL                    ; AX = num1 * num2 (result in AX)

    ; Divide AX by the GCD (stored in gcd_res)
    MOV CL, gcd_res           ; Load GCD into CL
    DIV CL                    ; AX = (num1 * num2) / GCD

    ; Store the result in lcm_res
    MOV lcm_res, AX

    ; Print result message
    LEA DX, resultMsg
    MOV AH, 09h               ; DOS function to print a string
    INT 21h                   ; Display result message

    ; Display the LCM value
    MOV AX, lcm_res           ; Load LCM result into AX for display
    CALL PrintDecimal         ; Call procedure to print AX as a decimal

    ; End the program
    MOV AH, 4Ch               ; DOS interrupt to exit
    INT 21h

; Procedure to calculate GCD using the Euclidean algorithm
gcd PROC
    ; If BL = 0, GCD is in AL
    CMP BL, 0
    JE end_gcd
gcd_loop:
    MOV AH, 0                 ; Clear AH for division
    DIV BL                    ; Divide AL by BL, remainder in AH
    MOV AL, BL                ; Move BL to AL (new A)
    MOV BL, AH                ; Move remainder to BL (new B)
    CMP BL, 0
    JNE gcd_loop              ; Repeat until remainder (B) = 0
end_gcd:
    RET                       ; Final GCD is in AL
gcd ENDP

; Procedure to print a 16-bit number in AX as decimal
PrintDecimal PROC
    ; Convert the number in AX to decimal and print each digit
    MOV CX, 10                ; Set divisor to 10 for decimal conversion
    MOV BX, 0                 ; Initialize BX to store each digit

decimal_loop:
    XOR DX, DX                ; Clear DX for division
    DIV CX                    ; Divide AX by 10, quotient in AX, remainder in DX
    PUSH DX                   ; Save the remainder (digit) on stack
    INC BX                    ; Count the digits
    CMP AX, 0                 ; If AX is 0, we’re done
    JNE decimal_loop          ; Repeat until AX is 0

print_digits:
    POP DX                    ; Retrieve digit from stack
    ADD DL, '0'               ; Convert to ASCII
    MOV AH, 02h               ; DOS function to print character
    INT 21h                   ; Display digit
    DEC BX                    ; Decrease digit count
    JNZ print_digits          ; Repeat until all digits are printed

    RET
PrintDecimal ENDp

END main