global _main          ; declare main() method
extern _printf        ; link to printf function
extern _scanf         ; link to scanf function
extern _exit          ; link to exit function

section .data
    format_in db "%d", 0     ; format string for scanf
    format_out db "%d is %s", 10, 0  ; format string for printf and new line
    num dd 0                  ; number entered by the user
    even_msg db "even", 0     ; message for even numbers
    odd_msg db "odd", 0       ; message for odd numbers

section .text
_main:                      ; entry point
    ; Prompt user to enter a number
    push num                ; push address of num
    push format_in          ; push format string
    call _scanf             ; call scanf to read user input
    add esp, 8              ; clean up the stack

    ; Check if the number is even or odd
    mov eax, [num]          ; move user input into eax
    and eax, 1              ; perform bitwise AND with 1 to check if the least significant bit is set
    jz num_is_even          ; jump if the result is zero (even number)
    mov ebx, odd_msg        ; move address of odd_msg into ebx
    jmp print_result        ; jump to print_result
num_is_even:
    mov ebx, even_msg       ; move address of even_msg into ebx
print_result:
    ; Display the result
    push ebx                ; push message (even or odd)
    push dword [num]        ; push user input
    push format_out         ; push format string
    call _printf            ; call printf to display the result
    add esp, 12             ; clean up the stack after printf

    ; Exit the program
    push 0                  ; exit code 0
    call _exit              ; call exit to terminate the program
