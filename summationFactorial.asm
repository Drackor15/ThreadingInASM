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
	
	;mov		edx, len
	;mov 	ecx, str
	;mov 	ebx, STDOUT
	;mov 	eax, SYS_write
	;int 	0x80
	
	mov		eax, 0
	mov		esp, ebp
	pop		ebp
	ret

;Math Functions
factorial:
    push 	ebp
    mov		ebp, esp

	add		esp, 8
    mov		eax, DWORD [esp]
	sub		esp, 8
    cmp		eax, 1
    je 		exit_factorial

    dec		eax
    push	eax
    call	factorial

	add		esp, 12
    mov		ebx, DWORD [esp]
	sub		esp, 12
    imul	eax, ebx

exit_factorial:
    mov		esp, ebp
    pop		ebp
    ret