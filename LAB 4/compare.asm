global _main                ; declare main() method
extern _printf              ; link to printf function
extern _scanf               ; link to scanf function

section .data
    format db "%d", 0       ; format string for scanf
    num1 dd 0               ; first number
    num2 dd 0               ; second number
    max_msg db "Maximum of the two numbers: %d", 10, 0  ; message for maximum

section .text
_main:                         ; entry point
    ; Prompt user for first number
    push num1                 ; push address of num1
    push format               ; push format string
    call _scanf               ; call scanf to read first number
    add esp, 8                ; clear stack after scanf

    ; Prompt user for second number
    push num2                 ; push address of num2
    push format               ; push format string
    call _scanf               ; call scanf to read second number
    add esp, 8                ; clear stack after scanf

    mov eax, [num1]           ; move num1 into eax
    mov ebx, [num2]           ; move num2 into ebx
    cmp eax, ebx              ; compare num1 with num2
    jge num1_is_greater       ; jump if num1 is greater or equal to num2
    mov eax, ebx              ; num1 is not greater, so move num2 into eax
num1_is_greater:
    push eax                  ; push maximum number
    push max_msg              ; push format string
    call _printf              ; print maximum number
    add esp, 8                ; clear stack after printf

    ret                        ; return
