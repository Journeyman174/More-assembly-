;%include "../io.mac"
section .data
    myString: db "Hello, World!", 0
    myString1: db "	1	===Hello, World!", 0
    myString2: db "	2	===Hello, World!", 0
    myString3: db "	3	===Hello, World!", 0
    myString4: db "	4	===Hello, World!", 0
    myString5: db "	5	===Hello, World!", 0
    myString6: db "	6	===Hello, World!", 0
    myString7: db "	7	===Hello, World!", 0
    myString8: db "	8	===Hello, World!", 0
    myString9: db "	9	===Hello, World!", 0
    myString10: db "	10	===Hello, World!", 0
    myString11: db "	11	===Hello, World!", 0 
    myString12: db "	12	===Hello, World!", 0
    myString13: db "	13	===Hello, World!", 0
    myString14: db "	14	===Hello, World!", 0
    myString15: db "	15	===Hello, World!", 0
    myString16: db "	16	===Hello, World!", 0
    myString17: db "	17	===Hello, World!", 0
    myString18: db "	18	===Hello, World!", 0
    strformat: db "%s", 0
    ten	db	10

section .text

global expression
global term
global factor
extern	printf

; `factor(char *p, int *i)`
;       Evaluates "(expression)" or "number" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
factor:
        push    ebp
        mov     ebp, esp
        
        mov	edx,[ebp+8]

        mov	ebx,[ebp+12]
	mov	ecx,[ebx]
	
	xor	eax,eax

	cmp	byte [edx+ecx],'('	; (
	je	expr
	cmp	byte [edx+ecx],')'	; )
	je	expr
	cmp	byte [edx+ecx],'+'	; +
	je	expr
	cmp	byte [edx+ecx],'-'	;-
	je 	expr
	cmp	byte [edx+ecx],'*'	; *
	je	expr
	cmp	byte [edx+ecx],'/'	;/
	je 	expr
	cmp	byte [edx+ecx],0	;sfarsit de expresie
	je	end_fact

numar:
	mov	ebx,10
	push 	edx
	mul 	ebx
	pop 	edx
	xor	ebx,ebx
	mov	bl, byte [edx+ecx]
;	PRINTF32 `%c\n\x0`,ebx
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
	sub 	ebx,'0'
	add	eax,ebx
	inc 	ecx
	cmp	byte [edx+ecx],'('	; (
	je	expr
	cmp	byte [edx+ecx],')'	; )
	je	end_fact
	cmp	byte [edx+ecx],'+'	; +
	je	end_fact
	cmp	byte [edx+ecx],'-'	;-
	je 	end_fact
	cmp	byte [edx+ecx],'*'	; *
	je	end_fact
	cmp	byte [edx+ecx],'/'	;/
	je 	end_fact
	cmp	byte [edx+ecx],0	;sfarsit de expresie
	je	end_fact
	
	jmp	numar
	
expr:
;	mov	[ebp+16],eax
	inc 	ecx
	mov	ebx,[ebp+12]
	mov	[ebx],ecx

	push	ebx
	push	edx
	call	expression
end_fact:
;	inc ecx
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString9

	leave
	ret

; `term(char *p, int *i)`
;       Evaluates "factor" * "factor" or "factor" / "factor" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
term:
        push    ebp
        mov     ebp, esp

        mov	edx,[ebp+8]
        mov	ebx,[ebp+12]
	mov	ecx,[ebx]
	
;	xor	eax,eax

	cmp	byte [edx+ecx],')'	; )
	je	end_term
	cmp	byte [edx+ecx],'+'	; +
	je	end_term1
	cmp	byte [edx+ecx],'-'	;-
	je 	end_term1
	cmp	byte [edx+ecx],'*'	; *
	je	ori
	cmp	byte [edx+ecx],'/'	;/
	je 	div
	cmp	byte [edx+ecx],0	;sfarsit de expresie
	je	end_term1
       
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString10
	
	call	factor
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString3
	mov	edi,eax
;
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx
	call	term
end_term1:
        leave
        ret
end_term:
	inc	ecx
	leave
	ret
ori:
	mov	[ebp+16],eax
	inc 	ecx
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
;	PRINTF32 `%c\n\x0`,[edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString7
	push	ebx
	push	edx

	call	factor
	
;	mov	edi,[ebp+16]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%u\n\x0`,edi
;	PRINTF32 `%c\n\x0`,[edx+ecx]

;	PRINTF32 `%s\n\x0`, myString12
	push	edx
	mul	word [ebp+16]
	pop	edx
;	add	eax,edi
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax
;	PRINTF32 `%s\n\x0`, myString13
	mov	edi,eax

	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx
	call	term

        leave
        ret	
	
div:
	mov	[ebp+16],eax
;        mov	edx,[ebp+8]
	inc 	ecx
	mov	ebx,[ebp+12]
	mov	[ebx],ecx

	push	ebx
	push	edx

	call	factor

	
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax
;	PRINTF32 `%u\n\x0`,[ebp+16]
;	PRINTF32 `%s\n\x0`, myString17
	cmp	eax,0
	jz	div1
	push	edx
;	PRINTF32 `%s\n\x0`, myString18
	div	word [ebp+16]
	pop	edx
div1:
	mov	edi,eax

	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx
	call	term

        leave
        ret	

; `expression(char *p, int *i)`
;       Evaluates "term" + "term" or "term" - "term" expressions 
; @params:
;	p -> the string to be parsed
;	i -> current position in the string
; @returns:
;	the result of the parsed expression
expression:
	push    ebp
        mov     ebp, esp
;	PRINTF32 `%s\n\x0`, myString	
        mov	edx,[ebp+8]
        mov	ebx,[ebp+12]
	mov	ecx,[ebx]
	
;	xor	eax,eax
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
	cmp	byte [edx+ecx],')'	; )
	je	end_expr
	cmp	byte [edx+ecx],'+'	; +
	je	plus
	cmp	byte [edx+ecx],'-'	;-
	je 	minus
	cmp	byte [edx+ecx],0	;sfarsit de expresie
	je	end_expr
	
;	mov	[ebp+16],eax
;	mov	edi,eax
        mov	edx,[ebp+8]
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
;	PRINTF32 `%u\n\x0`,eax
	
	 
;	PRINTF32 `%s\n\x0`, myString		
	push	ebx
	push	edx

	call	term
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString4
continua:
	mov	edi,eax
;	inc 	ecx
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx
;	PRINTF32 `%c\n\x0`,byte [edx+ecx]

	call	expression
end_expr:
;	inc	ecx
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%u\n\x0`,byte [edx+ecx]
;	PRINTF32 `%s\n\x0`, myString16

        leave
        ret

plus:
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString5

	mov	[ebp+16],eax
 ;       mov	edx,[ebp+8]
	inc 	ecx
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx

	call	term
	mov	edi,[ebp+16]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%u\n\x0`,edi 

;	PRINTF32 `%s\n\x0`, myString5

	add	eax,edi
;	PRINTF32 `%c\n\x0`,[edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%s\n\x0`, myString11
;	inc	ecx
	jmp	continua
;        leave
;        ret	
	
minus:
	mov	[ebp+16],eax
;        mov	edx,[ebp+8]
;	mov	edi,eax
	inc 	ecx
	mov	ebx,[ebp+12]
	mov	[ebx],ecx
	push	ebx
	push	edx
	
;	PRINTF32 `%c\n\x0`,[edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%u\n\x0`,edi 
;	PRINTF32 `%u\n\x0`,[ebp+16]
;	PRINTF32 `%s\n\x0`, myString15

	call	term

	mov	edi,eax
	mov	eax,[ebp+16]
;	PRINTF32 `%c\n\x0`,[edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%u\n\x0`,edi 
;	PRINTF32 `%s\n\x0`, myString14

	sub	eax,edi
	inc	ecx
;	PRINTF32 `%u\n\x0`,byte [edx+ecx]
;	PRINTF32 `%u\n\x0`,eax 
;	PRINTF32 `%u\n\x0`,edi 
;	PRINTF32 `%s\n\x0`, myString17
	cmp	byte [edx+ecx],0
	jmp	continua
;	leave
;	PRINTF32 `%s\n\x0`, myString18
;	ret

