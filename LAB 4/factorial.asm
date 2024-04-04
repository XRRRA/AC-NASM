global _main          ; declare main() method
extern _printf        ; link to printf function
extern _scanf         ; link to scanf function
extern _exit          ; link to exit function

section .data
    format_in db "%d", 0     ; format string for scanf
    format_out db "The factorial is: %d for %d", 10, 0  ; format string for printf and new line
    num dd 0                  ; number entered by the user
    factorial dd 1            ; variable to store factorial result

section .text
_main:                      ; entry point
    ; Prompt user to enter a number
    push num                ; push address of num
    push format_in          ; push format string
    call _scanf             ; call scanf to read user input
    add esp, 8              ; clean up the stack

    ; Calculate factorial
    mov ecx, [num]          ; move user input into ecx
    mov eax, 1              ; initialize eax to 1
calc_factorial:
    mul ecx                 ; multiply eax by ecx
    loop calc_factorial     ; decrement ecx and repeat until ecx becomes 0

    ; Display the result
    push dword [num]        ; push user input
    push eax                ; push factorial result
    push format_out         ; push format string
    call _printf            ; call printf to display the result
    add esp, 12             ; clean up the stack after printf

    ; Exit the program
    push 0                  ; exit code 0
    call _exit              ; call exit to terminate the program
