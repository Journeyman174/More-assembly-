section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
cpu_manufact_id:
	enter 0, 0
	pusha
	
	; seteaza eax la 0 si foloseste cpuid
	xor eax, eax
	cpuid
	
	; pune in ordine (ebx, edx, ecx) substring-urile din registrii in parametru
	mov eax, [ebp + 8]
	mov dword[eax], ebx
	add eax, 4
	mov dword[eax], edx
	add eax, 4
	mov dword[eax], ecx
	add eax, 4
	
	popa
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
features:
	enter 0, 0
	pusha

ia_vmx:
	; seteaza eax la 1 pentru cpuid
	mov eax, 1
	cpuid
	
	; creeaza numarul cu unicul bit activ 
	; corespunzator pozitiei feature-ului cautat
	mov ebx, 1
	shl ebx, 5
	
	; pastreaza doar bitul necesar
	and ecx, ebx
	mov eax, [ebp + 8]
	
	; daca rezultatul este diferit de 0, este disponibil acel feature
	cmp ecx, 0
	jne are_vmx
	
	; altfel, pune 0 in variabila corespunzatoare
	xor ebx, ebx
	mov [eax], ebx
	
; idem vmx
ia_rdrand:
	mov eax, 1
	cpuid
	mov ebx, 1
	shl ebx, 30
	and ecx, ebx
	mov eax, [ebp + 12]
	cmp ecx, 0
	jne are_rdrand
	xor ebx, ebx
	mov [eax], ebx

; idem vmx si rdrand
ia_avx:
	mov eax, 1
	cpuid
	mov ebx, 1
	shl ebx, 28
	and ecx, ebx
	mov eax, [ebp + 16]
	cmp ecx, 0
	jne are_avx
	xor ebx, ebx
	mov [eax], ebx
	jmp end

; daca este disponibil feature-ul, pune 1 in variabila corespunzatoare
are_vmx:
	mov ebx, dword 1
	mov [eax], ebx
	jmp ia_rdrand
	
are_rdrand:
	mov ebx, dword 1
	mov [eax], ebx
	jmp ia_avx
	
are_avx:
	mov ebx, dword 1
	mov [eax], ebx
	
end:
	
	popa
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
l2_cache_info:
	enter 0, 0
	pusha
	
	mov eax, 80000006h
	cpuid
	
	; selecteaza doar bitii 0-7, respectiv 16-31 din ecx, unde
	; se afla informatiile cautate dupa utilizarea cpuid cu eax = 80000006h
	mov eax, [ebp + 8]
	movzx ebx, cl
	mov [eax], ebx
	mov eax, [ebp + 12]
	shr ecx, 16
	movzx ebx, cx
	mov [eax], ebx
	
	popa
	leave
	ret
