;##### INCLUDES #####;
%include "thread.asm"

;##### DEFINITIONS #####;
; Input/Output (unistd.h)
%define STDIN		0
%define STDOUT		1

segment .data
	hello_world_str		db	0,0,'Hello World!',10,0
	hello_world_str_len	equ $ - hello_world_str

segment .bss

segment .text
	global	main

main:
	push	ebp
	mov		ebp, esp
	
	; To call multple threads change num_threads
	mov		DWORD [num_threads], 6
	mov 	ebx, hello_world				; puts address of func in stack, so that thread is passed a pointer to a func; Similar to pthread
	call	multi_thread
	
	mov		eax, 0
	mov		esp, ebp
	pop		ebp
	ret

hello_world:
	mov		edx, hello_world_str_len
	mov 	ecx, hello_world_str
	mov 	ebx, STDOUT
	mov 	eax, SYS_write
	int 	0x80
	
	;exit thread once func is done
	mov		ebx, 0
	mov 	eax, SYS_exit
	int 	0x80