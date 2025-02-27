.386
.model flat, c
.code

public PowProc

PowProc PROC
    mov eax, 1      ; ������������� ��������� �������� EAX � 1 (2^0 = 1).
    cmp ecx, 0
    je done

    pow:            ; ����
        shl eax, 1  ; �������� eax �� 2 (����� �����)
    loop pow                

    done:           ; ����� ����������.
        ret         ; ���������� ���������� � ���������� �������. ��������� ��������� � EAX.
PowProc ENDP

end
