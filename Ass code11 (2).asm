.model small
.stack 100h

.data
    msg db 'Enter a single-digit number (0-9): $'
    result_msg db 'Factorial is: $'
    newline db 0Ah, 0Dh, '$'
    num db ?
    fact dw 1
.code
main:
    ; Set up the data segment
    mov ax, @data
    mov ds, ax

    ; Display message to enter a number
    mov ah, 09h
    lea dx, msg
    int 21h

    mov ah, 09h
    lea dx,newline
    int 21h
    
    ; Read a single-digit character from input
    mov ah, 01h
    int 21h
    sub al, '0'           ; Convert ASCII to integer
    mov num, al           ; Store input number in 'num'

    mov ah, 09h
    lea dx,newline
    int 21h
    ; Initialize factorial result to 1
    mov ax, 1
    mov fact, ax

    ; Calculate factorial using a loop if input is not zero
    mov cl, num
    cmp cl, 0
    je display_result     ; If input is 0, skip multiplication

factorial_loop:
    mov ax, fact
    mul cl
    mov fact, ax
    dec cl
    jnz factorial_loop

display_result:
    ; Display the result message
    mov ah, 09h
    lea dx, result_msg
    int 21h

    ; Print the factorial result stored in 'fact'
    mov ax, fact
    call print_number

    ; Print newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h

; Procedure to print the number in AX
print_number proc
    ; Check if the number is zero and print '0'
    cmp ax, 0
    jne convert_digit
    mov dl, '0'
    mov ah, 02h
    int 21h
    ret

convert_digit:
    ; Print each digit by dividing by 10
    mov cx, 10
    push ax               ; Save AX for later
    xor bx, bx            ; Clear BX to store digits in reverse

convert_loop:
    xor dx, dx            ; Clear DX before division
    div cx                ; AX / 10, remainder in DX
    push dx               ; Push remainder (next digit)
    inc bx                ; Track number of digits
    cmp ax, 0
    jne convert_loop

print_digits:
    pop dx                ; Pop a digit
    add dl, '0'           ; Convert to ASCII
    mov ah, 02h           ; Print character function
    int 21h
    dec bx                ; Decrement digit counter
    jnz print_digits      ; Repeat until all digits are printed

    pop ax                ; Restore AX
    ret
print_number endp

end main
