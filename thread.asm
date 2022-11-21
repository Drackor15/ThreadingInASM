;##### DEFINITIONS #####;
; System Calls (sys/syscall.h)
%define SYS_write	4
%define SYS_mmap2	192
%define SYS_clone	120
%define SYS_exit	1

; Memory Management Flags (sys/mman.h)
%define MAP_GROWSDOWN	0x0100
%define MAP_ANONYMOUS	0x0020
%define MAP_PRIVATE		0x0002
%define PROT_READ		0x1
%define PROT_WRITE		0x2
%define PROT_EXEC		0x4

; Clone Flags (sched.h)
%define CLONE_VM	0x00000100
%define CLONE_FS	0x00000200
%define CLONE_FILES	0x00000400
%define CLONE_SIGHAND	0x00000800
%define CLONE_PARENT	0x00008000
%define CLONE_THREAD	0x00010000
%define CLONE_IO	0x80000000

%define THREAD_FLAGS \
 CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_PARENT|CLONE_THREAD|CLONE_IO
 
%define STACK_SIZE	(4096 * 1024)

segment .data
num_threads:		dw	1
thread_func_addr:	dw	0
counter:			dw	0

segment .bss

segment .text

; void multi_thread(void)
; Opens & Closes multiple threads. This process is the main driver thread
; Depends on the the global variable num_threads
; num_threads:		the number of threads a user needs (default=1)
multi_thread:
	push	ebx						; push address of threadfn to the stack
	mov		esi, [num_threads]
	mov		DWORD [counter], esi
	init_thread_loop:
		call 	new_thread			; for every call to thread_create a new thread is made
		dec		DWORD [counter]
		cmp		DWORD [counter], 0
		jne		init_thread_loop

	
	; exit
	mov		ebx, 0
	mov 	eax, SYS_exit
	int 	0x80

; long new_thread(void (*)(void))
; Helper Function for void multi_thread(void)
; Finalizes the space in which a new thread can work
new_thread:
	call 	new_stack
	lea 	ecx, [eax + STACK_SIZE - 8]		; use return value & compute high-end of stack, store in ecx (which is the 2nd param of sys clone)
	add		esp, 4
	mov		ebx, DWORD [esp]
	mov 	dword [ecx], ebx				; put address of threadfn at the top of thread stack
	sub		esp, 4
	mov 	ebx, THREAD_FLAGS				; flags
	mov 	eax, SYS_clone					; now our thread has it's own stack & a reference to threadfn to run through without interfering with main or other threads; from top to bottom this looks like *threadfn -> thread stack
	int 	0x80
	ret

; void *new_stack(void)
; Helper Function for long new_thread(void (*)(void))
; Prepares a space on the stack for a new thread to work in
new_stack:
	mov 	ebx, 0												; address pointer
	mov 	ecx, STACK_SIZE										; stack size
	mov 	edx, PROT_WRITE | PROT_READ							; protections/priviledges
	mov 	esi, MAP_ANONYMOUS | MAP_PRIVATE | MAP_GROWSDOWN	; flags
	mov 	eax, SYS_mmap2										; returns the low-end of the stack
	int 	0x80
	ret