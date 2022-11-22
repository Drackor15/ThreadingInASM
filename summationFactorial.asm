;##### INCLUDES #####;
%include "thread.asm"

;##### DEFINITIONS #####;
; Input/Output (unistd.h)
%define STDIN		0
%define STDOUT		1

segment .data

segment .bss

segment .text
	global	main

main:
	push	ebp
	mov		ebp, esp
	
	push	4			 ; parameter
	call	factorial
	mov		ebx, eax	 ; return value
	
	mov		eax, 0
	mov		esp, ebp
	pop		ebp
	ret

;Math Functions
factorial:
    push 	ebp
    mov		ebp, esp

    mov		eax, DWORD [ebp]
    cmp		eax, 1
    je 		exit_factorial

    dec		eax
    push	eax
    call	factorial

    mov		ebx, DWORD [ebp]
    imul	eax, ebx

exit_factorial:
    mov		esp, ebp
    pop		ebp
    ret