;%include "../io.mac"
section .data
    myString: db "Hello, World!", 0
section .text
	global sort
	extern printf

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0

	; [ebp+8] numarul de noduri din lista
	; [ebp+12] adresa de inceput listei(vectorului)
	xor esi,esi	
cauta:	
	mov ebx, [ebp+12]
	mov ecx, [ebp+8]

	xor eax, eax
;caut val cea mai mare din lista

compare:
	cmp eax, [ebx+ecx*8-8]
	jge check_end
	mov eax, [ebx+ecx*8-8] ; val nod din lista
	lea edx, [ebx+ecx*8-8]	;pastrez adresa nod lista in edx
check_end:
	loopnz compare
	neg dword [edx] ; transform val nodului intr-o val negatva pt a nu mai participa
	mov [edx+4],esi	;esi - adresa next
	mov esi,edx		;aceasta va fi val lui next pt. urmatorul nod
;verific daca toate val din lista sunt negative
	mov ebx, [ebp+12]
	mov ecx, [ebp+8]
	xor eax,eax	;pun 0 in eax

gata:	
	cmp [ebx+ecx*8-8],eax
	jge cauta
	loop gata

;s-a terminat
;refac valorile nodurilor
	mov ebx, [ebp+12]
	mov ecx, [ebp+8]
refac:	
	neg dword [ebx+ecx*8-8]
	loop refac
; in edx a ramas adresa ultimului nod din lista adica cel cu valoarea cea mai mica
	mov eax,edx
;registrul in care se face returnarea raspunsului functiei	
	leave
	ret
