

section .text
	size equ 8
	global get_words
	global compare_func
	global sort
	extern qsort
	;extern compare_func

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
	enter 0, 0
	mov eax, [ebp + 8]  ; vectorul de stringuri
	mov ebx, [ebp + 12] ; numarul de cuvinte din text
	mov edx, [ebp + 16] ; nr de octeti pe caracter
     
        push	dword compare_func
        push	dword edx
        push	ebx
        push	eax
;	PRINTF32 `%s\n\x0`, myString
;	jmp iesire        
        call    qsort
;
;	PRINTF32 `%s\n\x0`, myString4
;iesire:      
        leave 
        ret
 
 
    
compare_func:
	enter 0,0
       push edx
	mov edx, [ebp + 8]  ; string 1
	mov eax,[edx]
	pop edx
	call strlen	;pentru string1
	mov ecx,eax
	push ecx
	
	push edx
	mov edx, [ebp + 12]
	mov eax,[edx]
	pop edx
	call strlen	;pentru string2
	
;	pop ecx
	cmp ecx,eax
	je strcmp	;au aceasi lungime fac comparare lexicografica
;	je ret
	jl mic
	mov eax,1
	jmp ret
mic:
	mov eax,-1
	jmp ret
;strcmp needs two strings (one in eax, other in ebx) and returns into ecx 0 
;if strings are equal or 1/-1 if they are not.        
	
strcmp:
;	PRINTF32 `%s\n\x0`, myString4	
;	push edi
	push ebx

	mov ebx, [ebp + 8]  ; string 1
	mov eax,[ebx]
	
	mov ebx, [ebp + 12] ; string 2
	mov edx,[ebx]
	

	pop ebx

	mov ecx,0
;	jmp ret
strcmp_loop:
 ;       mov byte dl,[eax+ecx]
 ;      mov byte dh,[edx+ecx]
 ;       cmp dl,0
        cmp byte [eax+ecx],0
        je strcmp_end_0
        push ebx
        mov bl,byte [edx+ecx]
        cmp byte [eax+ecx],bl
        je strcmp_loop1
        pop ebx
        jl strcmp_end_1
        jg strcmp_end_2
strcmp_loop1:
        inc ecx
        pop ebx
	jmp strcmp_loop
strcmp_end_0:
;       cmp dh,0
;      jne strcmp_end_1
        xor eax,eax
	jmp ret

strcmp_end_1:	
       mov eax,-1
;	PRINTF32 `%s\n\x0`, myString3
        jmp ret
strcmp_end_2:
        mov eax,1
ret:
;	pop ebx
        leave
	ret       

strlen:
	enter 0,0
	push ebx
	mov ebx,0
strlen_loop:
;	PRINTF32 `%c\n\x0`, byte [eax+ebx]
        cmp byte [eax+ebx],0
        je strlen_end
    inc ebx
      jmp strlen_loop
strlen_end:
	mov eax,ebx
	pop ebx
	leave
       ret


;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte

get_words:
	enter 0, 0
	mov eax, [ebp + 8]  ; textul
;	PRINTF32 `%u\n\x0`, eax

	mov edi, [ebp + 12] ; vectorul de stringuri adica edi contine adrese de 32 biti
	mov ebx, [edi]	;la fiecare adresa se memoreza stringul
	
;	PRINTF32 `%u\n\x0`, ebx
	mov edx, [ebp + 16] ; nu PRINTF32 `%c\n\x0`, [eax+25]
; PRINTF32 `%c\n\x0`, byte [eax+26]marul de cuvinte din text
;	PRINTF32 `%s\n\x0`, myString1
;	jmp gata       
	xor ecx, ecx
;	xor eax, eax
;	dec edx
cauta:
;	mov edx,eax
;  PRINTF32 `%c\n\x0`, [eax+25]
; PRINTF32 `%c\n\x0`, byte [eax+26]
;  PRINTF32 `%c\n\x0`, byte [eax+27]
; PRINTF32 `%c\n\x0`, byte [eax+28]
;  PRINTF32 `%c\n\x0`, byte [eax+29]
;  PRINTF32 `%c\n\x0`, byte [eax+30]
;  PRINTF32 `%u\n\x0`, byte [eax+31]
;  PRINTF32 `%u\n\x0`, byte [eax+32]
;  PRINTF32 `%u\n\x0`, byte [eax+33]
;  PRINTF32 `%u\n\x0`, byte [eax+34]
;  jmp gata
	cmp byte [eax+ecx], ' '
	je cuvint
	cmp byte [eax+ecx], ','
	je cuvint1
	cmp byte [eax+ecx], '.'
	je cuvint1
	cmp byte  [eax+ecx], 10
	je cuvint
	cmp byte  [eax+ecx], 0
	je cuvint0

;	cmp edx,1
;	je cuvint
	push edx
	mov dl, byte [eax+ecx] 
	mov byte [ebx+ecx], dl
	pop edx
;	PRINTF32 `%c\n\x0`, byte [ebx+ecx]
;	PRINTF32 `%u\n\x0`, edx
;	PRINTF32 `%s\n\x0`, myString1

	inc ecx
	jmp cauta  
punct:
	mov byte [ebx+ecx],0
	add ecx,4
	jmp cuvint01
	
cuvint2:
	mov byte [ebx+ecx],0
	inc ecx
	inc ecx
;	PRINTF32 `%s\n\x0`, myString1
	jmp cuvint01
	
cuvint1:
;	PRINTF32 `%s\n\x0`, myString1
   	cmp byte [eax+ecx+1], ' '
  	je cuvint2
  	cmp byte [eax+ecx+1],'.'
  	je punct
 ; 	dec ecx
cuvint:
	mov byte [ebx+ecx],0
	inc ecx

;  PRINTF32 `%c\n\x0`, byte [edi]
;  PRINTF32 `%c\n\x0`, byte [edi+1]
;  PRINTF32 `%c\n\x0`, byte [edi+2]
;  PRINTF32 `%c\n\x0`, byte [edi+3]
cuvint01:	
		
	lea eax,[eax+ecx]
	add edi,4
	 mov ebx,[edi]
	
	xor ecx,ecx
cuvint0:
	dec edx	;am copiat in vector 1 cuvint
	cmp edx,0
	je gata
	jmp cauta
gata:	
;	PRINTF32 `%s\n\x0`, myString2
	mov ebx,[ebp + 12]
	mov eax,[ebx]
 ; PRINTF32 `%c\n\x0`, [eax]
 ;PRINTF32 `%c\n\x0`, byte [eax+1]
 ; PRINTF32 `%c\n\x0`, byte [eax+2]
; PRINTF32 `%u\n\x0`, byte [eax+3]
 ; PRINTF32 `%c\n\x0`, byte [eax+4]
 ; PRINTF32 `%c\n\x0`, byte [eax+5]
 ; PRINTF32 `%c\n\x0`, byte [eax+6]
  ;PRINTF32 `%c\n\x0`, byte [eax+7]
 ; PRINTF32 `%c\n\x0`, byte [eax+8]
 ; PRINTF32 `%c\n\x0`, byte [eax+9]

	leave
	ret
