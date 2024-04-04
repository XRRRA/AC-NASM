extern _printf            ; external C library function
extern _scanf             ; external C library function
extern _exit              ; external C library function

global _main              ; declare main() method

section .data
format_in db "%d", 0     ; format string for scanf
format_out db "%d", 10, 0; format string for printf and new line
num1 dd 0                 ; first number
num2 dd 0                 ; second number

section .text
_main:                    ; entry point
    ; Prompt user to enter the first number
    push num1              ; push address of num1 onto the stack
    push format_in         ; push format string onto the stack
    call _scanf            ; call scanf to read user input
    add esp, 8             ; clean up the stack

    ; Prompt user to enter the second number
    push num2              ; push address of num2 onto the stack
    push format_in         ; push format string onto the stack
    call _scanf            ; call scanf to read user input
    add esp, 8             ; clean up the stack

    ; Perform addition
    mov eax, [num1]        ; move num1 into eax
    add eax, [num2]        ; add num2 to eax

    ; Display the result
    push eax               ; push the result onto the stack
    push format_out        ; push format string onto the stack
    call _printf           ; call printf to display the result
    add esp, 8             ; clean up the stack

    ; Exit the program
    push 0                 ; exit code 0
    call _exit             ; call exit to terminate the program
