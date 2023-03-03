section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
intertwine:
	enter 0, 0
	
add_position:
	; pune elementul curent din v1 in v, trece la urmatoarele
	; pozitii in v si v1 si decrementeaza nuamrul de elemente ramase in v1
	mov eax, dword[rdi]
	mov [r8], eax
	add r8, 4
	add rdi, 4
	dec rsi
	
	; idem v1
	mov eax, dword[rdx]
	mov [r8], eax
	add r8, 4
	add rdx, 4
	dec rcx
	
	; verifica daca unul din vectori s-a terminat
	cmp rsi, 0
	je unu
	cmp rcx, 0
	je doi
	
	; trece la urmatorul set de elemente
	jmp add_position
	
; daca s-a terminat intai primul vector, continua cu adaugarea celuilalt
unu:
	; daca si al doilea vector s-a terminat, incheie programul
	cmp rcx, 0
	je end
	mov eax, dword[rdx]
	mov [r8], eax
	add r8, 4
	add rdx, 4
	dec rcx
	jmp unu
	
; idem unu
doi:
	cmp rsi, 0
	je end
	mov eax, dword[rdi]
	mov [r8], eax
	add r8, 4
	add rdi, 4
	dec rsi
	jmp doi
	
end:
	
	leave
	ret
