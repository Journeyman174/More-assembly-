;%include "../io.mac"
section .data
    myString: db "Hello, World!", 0

section .text
	global cmmmc
	extern printf
;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	enter 0, 0
;  	PRINTF32 `%s\n\x0`, myString
	; [ebp+8]  a
	; [ebp+12] b
	mov ebx, [ebp+8]	;valoarea lui a
	mov ecx, [ebp+12]	;valoarea lui b
	
	mov eax, ebx		;n=a
	mov edx, ecx		;m=b
;	PRINTF32 `%u\n\x0`, ebx
;	PRINTF32 `%u\n\x0`, ecx
bucla:
	cmp eax,edx
	je gata
	cmp eax,edx
	jl npa
	add edx,ecx
	jmp bucla
npa:
	add eax,ebx
	jmp bucla
	
gata:	

	leave
	ret
