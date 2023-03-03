;%include "../io.mac"
section .text
	global par
	extern printf
section .data
    myString: db "Hello, World!", 0

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression

par:
;	PRINTF32 `%s\n\x0`, myString
;	jmp sfarsit0

	enter 0, 0
	; [ebp+8]  lungime sir
	; [ebp+12] adresa de inceput a sitului
	mov ecx, [ebp+8]	;lungime sir
	mov ebx, [ebp+12]	;sir
	xor eax, eax	;eax=0
	xor edx, edx	;edx=0
bucla:	
	mov dl, byte [ebx+ecx-1]
;	PRINTF32 `%u\n\x0` ,  eax
	cmp dl,41,
	je aduna
	cmp dl,40
	je scade
continua:
	loop bucla
	jmp gata
aduna:
	inc eax
	jmp continua
scade:
	dec eax
	jmp continua
gata:
	cmp eax,0
	jnz sfarsit0
	mov eax,1
	leave
	ret
sfarsit0:
	xor eax, eax
	leave
	ret
	
