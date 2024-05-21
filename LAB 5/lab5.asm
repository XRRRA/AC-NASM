section .data
    menuMsg db 'Enter a number (1-10 for tasks, 0 to print random numbers, -1 to exit): ', 0
    randomFormat db 'Random Number: %d', 10, 0
    usedNumbers db 55 dup(0)   ; Array to track used numbers, initialized to 0
    newLine db 10, 0           ; New line character (ASCII newline), null-terminated
 
    inputFormat db '%d', 0   ; Format for scanf for integer input
    stringInputFormat db '%s', 0  ; Format for scanf for string input

    promptUppercase db 'Uppercased String: ', 0
    promptEnterUppercaseString db 'Enter a string to uppercase: ', 0

    promptInverted db 'Inverted String: ', 0
    promptEnterInvertString db 'Enter a string to invert: ', 0

    num1 dd 0
    num2 dd 0
    promptNumerator db 'Enter the numerator: ', 0
    promptDenominator db 'Enter the denominator: ', 0

    formatScanf db '%d', 0
    formatDivisionResult db 'Result of division: %d', 0
    errorMsgDivisionByZero db 'Error: Division by zero.', 0

    number dd 0.0
    result dd 0.0
    promptSquareRoot db 'Enter a number to find its square root: ', 0
    formatFloatScanf db '%f', 0   ; format for float
    formatSqrtResult db 'The square root is: %f', 0

    promptFirstNumber db 'Enter the first number: ', 0
    promptSecondNumber db 'Enter the second number: ', 0
    formatSmallestResult db 'The smallest number is: %d', 0

    array dd 10, 7, 8, 3, 2, 11, 42, 5, 9  ; Example array of integers
    length_of_array dd 9     ; Number of elements in the array

    format db "%d ", 0       ; Format for printing numbers
    prompt db "Enter numbers separated by spaces: ", 0
    formatInput db "%s", 0
    formatOutput db "%d ", 0
    inputLine db 256 dup(0)
    debugSortedMsg db "Array sorted.", 10, 0

    promptEnterString db 'Enter a string: ', 0
    promptEnterBaseString db 'Enter the base string: ', 0
    promptEnterSuffix db 'Enter the suffix: ', 0
    outputMsg db 'Resulting String: ', 0

    promptEnterIntegerString db 'Enter a string to convert to an integer: ', 0
    outputInteger db 'Converted Integer: %d', 0

    promptPoint1X db 'Enter x-coordinate for Point 1: ', 0
    promptPoint1Y db 'Enter y-coordinate for Point 1: ', 0
    promptPoint2X db 'Enter x-coordinate for Point 2: ', 0
    promptPoint2Y db 'Enter y-coordinate for Point 2: ', 0
    formatResultDistance db 'Euclidean distance: %f', 10, 0

    x1 dd 0.0
    y1 dd 0.0
    x2 dd 0.0
    y2 dd 0.0
    distance dd 0.0 
 

section .bss
    inputRes resd 1          ; Reserve space for input result
    secondNumber resd 1     ; Reserve space for the second number
    stringBuffer resb 256    ; Reserve 256 bytes for the input string
    suffixBuffer resb 256    ; Reserve 256 bytes for the suffix string
    integerBuffer resb 256   ; Reserve 256 bytes for the string to convert to integer
    input_line resb 256            ; Reserve 256 bytes for input line
    numbers resd 20          ; Array to hold up to 20 integers
    count resd 1


section .text
    extern printf
    extern scanf
    extern rand
    extern srand
    extern atoi
    extern sscanf
    extern sqrt
    extern fstcw   ; Store FPU Control Word
    extern fldcw   ; Load FPU Control Word
    extern ExitProcess
    global _start


_start:
    push ebp
    mov ebp, esp

    ; Seed the random number generator with a constant value
    push 19
    call srand
    add esp, 4

main_menu:
    push menuMsg            ; Display menu message
    call printf
    add esp, 4

    push inputRes           ; Pointer to store input
    push inputFormat        ; Format for input
    call scanf
    add esp, 8              ; Clean up stack from scanf parameters

    mov eax, [inputRes]     ; Move the input result into eax
    cmp eax, -1             ; Check if input is -1 to exit
    je exit_program

    cmp eax, 0              ; Check if input is 0 to generate random numbers
    je generate_random_numbers

    cmp eax, 1
    je task_1
    cmp eax, 2
    je task_2
    cmp eax, 3
    je task_3
    cmp eax, 4
    je task_4
    cmp eax, 5
    je task_5
    cmp eax, 6
    je task_6
    cmp eax, 7
    je task_7
    cmp eax, 8
    je task_8
    cmp eax, 9
    je task_9
    cmp eax, 10
    je task_10

    jmp main_menu           ; Loop back to main menu if no valid input

generate_random_numbers:
    xor edi, edi            ; Zero out EDI for counter
    mov edi, 10             ; Set counter for 10 numbers

random_loop:
    call rand
    mov ebx, 55
    xor edx, edx
    div ebx
    mov eax, edx
    add eax, 1

    ; Check if number has been used
    mov ebx, eax
    dec ebx
    cmp byte [usedNumbers + ebx], 0
    jne random_loop         ; If number used, get another number

    ; Mark number as used
    mov byte [usedNumbers + ebx], 1

    ; Print number
    push eax
    push randomFormat
    call printf
    add esp, 8

    dec edi
    jnz random_loop         ; Continue until 10 numbers are generated

    jmp main_menu           ; Return to main menu after printing


task_1:
    push promptEnterUppercaseString  ; Prompt user to enter a string
    call printf
    add esp, 4

    push stringBuffer       ; Pointer to buffer that will store the input string
    push stringInputFormat  ; Format string for scanf
    call scanf              ; Read a string from the console
    add esp, 8              ; Clean up the stack

    ; Convert the string to uppercase
    lea esi, [stringBuffer] ; ESI points to the start of the string
    mov ecx, 0              ; ECX is the counter for the string length

loop_convert_uppercase:
    mov al, [esi + ecx]     ; Load the character into AL
    cmp al, 0               ; Check for end of string
    je done_convert_uppercase

    cmp al, 'a'             ; Compare with lowercase 'a'
    jl not_lowercase        ; If below 'a', it's not a lowercase letter
    cmp al, 'z'             ; Compare with lowercase 'z'
    jg not_lowercase        ; If above 'z', it's not a lowercase letter

    sub al, 32              ; Convert lowercase to uppercase
    mov [esi + ecx], al     ; Store the uppercase character back

not_lowercase:
    inc ecx                 ; Move to the next character
    jmp loop_convert_uppercase

done_convert_uppercase:
    push promptUppercase       ; Print the converted string
    call printf
    add esp, 4

    push stringBuffer       ; Print the converted string
    call printf
    add esp, 4

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu           ; Return to the main menu

task_2:
    push promptEnterInvertString
    call printf
    add esp, 4

    push stringBuffer       ; Pointer to buffer that will store the input string
    push stringInputFormat  ; Format string for scanf
    call scanf              ; Read a string from the console
    add esp, 8              ; Clean up the stack

    ; Calculate the length of the string and set up pointers
    lea esi, [stringBuffer] ; ESI points to the start of the string
    mov edi, esi            ; EDI will find the end of the string
    xor ecx, ecx            ; ECX is the counter

find_end:
    cmp byte [edi], 0       ; Check if it's the end of the string
    je setup_inversion      ; Jump to setup if end is found
    inc edi                 ; Move to the next character
    inc ecx                 ; Increment counter
    jmp find_end            ; Continue until the end of the string is found

setup_inversion:
    dec edi                 ; Step back to the last valid character (not the null terminator)

invert_loop:
    cmp esi, edi            ; Check if the start pointer has met or passed the end pointer
    jge print_inverted      ; If so, we're done inverting

    mov al, [esi]           ; Swap the characters:
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al

inc esi                 ; Move the start pointer right
    dec edi                 ; Move the end pointer left
    jmp invert_loop         ; Continue the inversion loop

print_inverted:
    push promptInverted
    call printf
    add esp, 4
    push stringBuffer
    call printf
    add esp, 4

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu           ; Return to the main menu


task_3:
    ; Prompt the user to enter the string to convert
    push promptEnterIntegerString
    call printf
    add esp, 4

    ; Read the string
    push integerBuffer      ; Pointer to buffer that will store the string
    push stringInputFormat  ; Format string for scanf
    call scanf              ; Read a string from the console
    add esp, 8              ; Clean up the stack

    ; Convert the string to an integer
    lea esi, [integerBuffer] ; ESI points to the string
    xor eax, eax            ; Clear EAX (will hold the result)
    xor ebx, ebx            ; Clear EBX (will be used for the multiplier)
    mov ebx, 1              ; Set the initial multiplier to 1

    ; Calculate the length of the string
    mov ecx, 0
find_length:
    cmp byte [esi + ecx], 0 ; Check for the null terminator
    je start_conversion
    inc ecx
    jmp find_length

start_conversion:
    dec ecx                 ; Adjust for the length minus one
    mov edx, 0              ; Clear EDX (will be used for the digit value)

convert_loop:
    mov dl, [esi + ecx]     ; Load the current character
    sub dl, '0'             ; Convert ASCII to integer
    imul edx, ebx           ; Multiply the digit by the current place value
    add eax, edx            ; Add the result to EAX
    imul ebx, ebx, 10       ; Update the place value (multiply by 10)
    dec ecx                 ; Move to the next character
    jns convert_loop        ; Continue until all characters are processed

    ; Print the resulting integer
    add eax, 10
    push eax
    push outputInteger
    call printf
    add esp, 8

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu           ; Return to the main menu




task_4:
    ; Prompt the user to enter the base string
    push promptEnterBaseString
    call printf
    add esp, 4

    ; Read the base string
    push stringBuffer       ; Pointer to buffer that will store the base string
    push stringInputFormat  ; Format string for scanf
    call scanf              ; Read a string from the console
    add esp, 8              ; Clean up the stack

    ; Prompt the user to enter the suffix
    push promptEnterSuffix
    call printf
    add esp, 4

    ; Read the suffix string
    push suffixBuffer       ; Pointer to buffer that will store the suffix string
    push stringInputFormat  ; Format string for scanf
    call scanf              ; Read a string from the console
    add esp, 8              ; Clean up the stack

    ; Concatenate the strings
    lea esi, [stringBuffer] ; ESI points to the base string
    lea edi, [suffixBuffer] ; EDI points to the suffix string
    xor ecx, ecx            ; ECX will be used as a counter

find_end_of_base:
    cmp byte [esi + ecx], 0 ; Find the end of the base string
    je concat_suffix
    inc ecx
    jmp find_end_of_base

concat_suffix:
    lea edi, [suffixBuffer] ; Reset EDI to the start of the suffix string
    mov ebx, ecx            ; Save the current position in the base string

copy_suffix:
    mov al, [edi]
    mov [esi + ebx], al
    inc edi
    inc ebx
    cmp al, 0
    jne copy_suffix

    ; Print the resulting string
    push outputMsg
    call printf
    add esp, 4
    push stringBuffer
    call printf
    add esp, 4

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu           ; Return to the main menu






task_5:
    ; Ask for the first number
    push promptNumerator
    call printf
    add esp, 4
    
    ; Read the first number
    push num1
    push formatScanf
    call scanf
    add esp, 8

    ; Ask for the second number
    push promptDenominator
    call printf
    add esp, 4
    
    ; Read the second number
    push num2
    push formatScanf
    call scanf
    add esp, 8
    
    ; Move the read values into registers
    mov eax, [num1]       ; First number
    mov ebx, [num2]       ; Second number

    ; Check if the second number is zero (division by zero)
    cmp ebx, 0
    je division_by_zero

    cdq                   ; Clear EDX (for 64-bit division)
    idiv ebx              ; Divide the first number (EDX:EAX) by the second number (EBX)

    ; Print the result
    push eax
    push formatDivisionResult
    call printf
    add esp, 8

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu         ; Return to the main menu

division_by_zero:
    push dword errorMsgDivisionByZero  ; Push the error message
    call printf
    add esp, 4

    jmp main_menu         ; Return to the main menu




task_6:
    finit                   ; Initialize the FPU

    ; Ask for the number
    push promptSquareRoot
    call printf
    add esp, 4

    ; Read the number
    push number
    push formatFloatScanf
    call scanf
    add esp, 8

    ; Load the number into the FPU stack
    fld dword [number]      ; Load float from memory into ST(0)

    ; Compute the square root
    fsqrt                   ; Replace ST(0) with its square root

    ; Directly print from FPU
    sub esp, 8              ; Make space on stack for the float
    fstp qword [esp]        ; Store ST(0) in memory and pop the register stack
    push formatSqrtResult
    call printf
    add esp, 12             ; Clean up stack (8 bytes for double, 4 for format pointer)

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu           ; Return to the main menu






task_7:
    ; Ask for the first number
    push promptFirstNumber
    call printf
    add esp, 4
    
    ; Read the first number
    push num1
    push formatScanf
    call scanf
    add esp, 8

    ; Ask for the second number
    push promptSecondNumber
    call printf
    add esp, 4
    
    ; Read the second number
    push num2
    push formatScanf
    call scanf
    add esp, 8
    
    ; Compare the two numbers
    mov eax, [num1]
    mov ebx, [num2]
    cmp eax, ebx            ; Compare num1 and num2
    jle num1_is_smaller_or_equal

    ; If num2 is smaller
    mov eax, ebx            ; Move num2 into eax

    jmp print_result

num1_is_smaller_or_equal:
    ; EAX already contains num1

print_result:
    ; Print the smallest number
    push eax
    push formatSmallestResult
    call printf
    add esp, 8

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu           ; Return to the main menu








task_8:
    mov ecx, [length_of_array] ; Number of elements in the array
    dec ecx                    ; Subtract 1 because the last element has no next element to compare

start_sort:
    mov esi, 0                 ; Array index starts at 0
    mov ebx, 0                 ; Flag to check if a swap occurred

inner_loop:
    mov eax, [array + esi*4]   ; Load current element
    mov edx, [array + esi*4 + 4] ; Load next element
    cmp eax, edx               ; Compare current element with next element
    jle no_swap                ; Jump if current element is less or equal to next

    ; Swap elements
    mov [array + esi*4], edx
    mov [array + esi*4 + 4], eax
    mov ebx, 1                 ; Set flag to indicate swap

no_swap:
    inc esi                    ; Move to next element
    cmp esi, ecx               ; Check if end of array is reached
    jl inner_loop              ; If not, continue inner loop

    dec ecx                    ; Reduce the comparison length by one after a full pass
    test ecx, ecx              ; Test if ecx is zero, which means sorting is done
    jg start_sort              ; If greater than zero, repeat the sorting process

print_array:
    mov esi, 0                 ; Reset index for printing


print_loop:
    mov eax, [array + esi*4]   ; Get element from array
    push eax
    push format
    call printf
    add esp, 8
    inc esi
    cmp esi, [length_of_array] ; Check end of array
    jl print_loop              ; If not end, continue printing

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu              ; Return to the main menu




task_9:
    mov ecx, [length_of_array] ; Number of elements in the array
    dec ecx                    ; Subtract 1 because the last element has no next element to compare

start_sort_desc:
    mov esi, 0                 ; Array index starts at 0
    mov ebx, 0                 ; Flag to check if a swap occurred

inner_loop_desc:
    mov eax, [array + esi*4]   ; Load current element
    mov edx, [array + esi*4 + 4] ; Load next element
    cmp eax, edx               ; Compare current element with next element
    jge no_swap_desc           ; Jump if current element is greater or equal to next

    ; Swap elements
    mov [array + esi*4], edx
    mov [array + esi*4 + 4], eax
    mov ebx, 1                 ; Set flag to indicate swap

no_swap_desc:
    inc esi                    ; Move to next element
    cmp esi, ecx               ; Check if end of array is reached
    jl inner_loop_desc         ; If not, continue inner loop

    dec ecx                    ; Reduce the comparison length by one after a full pass
    test ecx, ecx              ; Test if ecx is zero, which means sorting is done
    jg start_sort_desc         ; If greater than zero, repeat the sorting process

print_array_desc:
    mov esi, 0                 ; Reset index for printing


print_loop_desc:
    mov eax, [array + esi*4]   ; Get element from array
    push eax
    push format
    call printf
    add esp, 8
    inc esi
    cmp esi, [length_of_array] ; Check end of array
    jl print_loop_desc         ; If not end, continue printing

    ; Print a newline for better output formatting
    push newLine
    call printf
    add esp, 4

    jmp main_menu              ; Return to the main menu




task_10:
    finit                   ; Initialize the FPU to clear any previous state

    ; Ask for the number
    push promptPoint1X
    call printf
    add esp, 4

    ; Read the number
    push x1
    push formatFloatScanf
    call scanf
    add esp, 8


    ; Ask for the number
    push promptPoint1Y
    call printf
    add esp, 4

    ; Read the number
    push y1
    push formatFloatScanf
    call scanf
    add esp, 8



    ; Ask for the number
    push promptPoint2X
    call printf
    add esp, 4

    ; Read the number
    push x2
    push formatFloatScanf
    call scanf
    add esp, 8


    ; Ask for the number
    push promptPoint2Y
    call printf
    add esp, 4

    ; Read the number
    push y2
    push formatFloatScanf
    call scanf
    add esp, 8


    ; Load x-coordinates and calculate the squared difference
    fld dword [x2]          ; Load x2
    fsub dword [x1]         ; Subtract x1, st(0) = x2 - x1
    fld st0                 ; Duplicate top of stack
    fmul st0, st0           ; Square the difference, st(0) = (x2 - x1)^2
    fstp dword [distance]   ; Store temporarily

    ; Load y-coordinates and calculate the squared difference
    fld dword [y2]          ; Load y2
    fsub dword [y1]         ; Subtract y1, st(0) = y2 - y1
    fld st0                 ; Duplicate top of stack
    fmul st0, st0           ; Square the difference, st(0) = (y2 - y1)^2
    fadd dword [distance]   ; Add the squared x-coordinate difference
    fsqrt                   ; Compute the square root of the sum
    fstp dword [distance]   ; Store the result in 'distance'

    ; Print the result
    sub esp, 8              ; Make space on stack for the float
    fld dword [distance]    ; Load the distance
    fstp qword [esp]        ; Store the result from ST(0)
    push formatResultDistance
    call printf
    add esp, 12             ; Clean up the stack


    ; Return to main menu
    jmp main_menu


exit_program:
    mov esp, ebp
    pop ebp
    push dword 0
    call ExitProcess