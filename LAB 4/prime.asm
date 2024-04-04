section .data
    prompt db "Enter the count of prime numbers: ", 0   ; prompt message
    count dd 0                ; variable to store the count of prime numbers
    format_in db "%d", 0      ; format string for scanf
    num dd 2                  ; number to check for prime
    format_out db "%d ", 0    ; format string for printf

section .bss
    prime_count resd 1       ; variable to keep track of the count of prime numbers found

section .text
    global _main            ; declare main() method
    extern _printf          ; link to printf function
    extern _scanf           ; link to scanf function
    extern _exit            ; link to exit function

_main:                      ; entry point
    ; Prompt user to enter the count of prime numbers
    push prompt              ; push prompt message
    call _printf             ; call printf to display the prompt
    add esp, 4               ; clean up the stack after printf
    ; Read user input for the count of prime numbers
    push count               ; push address of count variable
    push format_in           ; push format string
    call _scanf              ; call scanf to read user input
    add esp, 8               ; clean up the stack
    ; Initialize prime_count
    mov dword [prime_count], 0

prime_loop:
    ; Check if num is prime
    mov eax, [num]           ; move num into eax
    call is_prime            ; call the is_prime function
    cmp eax, 1               ; check if eax (return value) is 1 (prime)
    jne not_prime            ; if eax is not 1, num is not prime, jump to not_prime
    ; If the number is prime, print it
    push dword [num]         ; push current number onto the stack
    push format_out          ; push format string
    call _printf             ; call printf to display the current number
    add esp, 8               ; clean up the stack after printf
    ; Increment prime_count
    inc dword [prime_count]

not_prime:
    ; Move to the next number
    inc dword [num]          ; increment num
    ; Check if desired count of prime numbers found
    mov eax, [count]         ; load desired count of prime numbers
    cmp dword [prime_count], eax
    jl prime_loop            ; if prime count is less than desired count, continue finding primes
    ; Exit the program
    push 0                   ; exit code 0
    call _exit               ; call exit to terminate the program

print_num:
    ; Print the current number
    push dword [num]         ; push current number onto the stack
    push format_out          ; push format string
    call _printf             ; call printf to display the current number
    add esp, 8               ; clean up the stack after printf

next_num:
    ; Move to the next number
    inc dword [num]          ; increment num
    ; Check if desired count of prime numbers found
    mov eax, [count]         ; load desired count of prime numbers
    cmp dword [prime_count], eax
    jl prime_loop            ; if prime count is less than desired count, continue finding primes
    ; Exit the program
    push 0                   ; exit code 0
    call _exit               ; call exit to terminate the program

is_prime:                   ; function to check if a number is prime
    mov ebx, 2               ; start divisor from 2
    mov eax, [num]           ; move num into eax
    test eax, eax            ; check if num is less than 2
    jle not_prime            ; if num is less than or equal to 1, it's not prime
    cmp eax, 2               ; check if num is equal to 2
    je prime                 ; if num is equal to 2, it's prime
    mov ecx, 2               ; initialize divisor counter

test_divisible:
    mov eax, [num]           ; move num into eax
    mov edx, 0               ; clear edx for division
    div ecx                  ; divide eax by ecx
    cmp edx, 0               ; check remainder
    je not_prime             ; if remainder is 0, not prime
    inc ecx                  ; increment divisor counter
    cmp ecx, eax             ; compare divisor counter with num
    jle test_divisible       ; if divisor counter is less than or equal to num, continue testing
    jmp prime                ; if divisor counter exceeds num, num is prime

prime:
    mov eax, 1               ; set eax to 1 (prime)
    ret

increment_count:
    ; Increment prime_count
    inc dword [prime_count]
    ret
