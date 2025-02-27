.386
.model flat, c
.code

SumProc PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+8] 
    mov ebx, [ebp+12] 
    
    add eax, ebx

    pop ebp
    ret
SumProc ENDP

end
