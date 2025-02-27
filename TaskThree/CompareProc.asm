.386
.model flat, c
.stack 4096

.data
	MB_OK equ 0
	str1 db "Hello", 0
	str2 db "Hello", 0
	caption db "Result", 0
	messageEqual db "������ �����", 0
	messageNotEqual db "������ �� �����", 0
	EXTERN MessageBoxA@16: NEAR

.code

CompareProc proc
	;������������� ������ ����� ��� ���������
    lea esi, [str1]            ; ��������� ����� ������ ������ � ESI
    lea edi, [str2]            ; ��������� ����� ������ ������ � EDI

    ;���������� ������
    mov ecx, 5               ; ������������� ������� ��� ������� ������ � ������
    cld                      ; ������������� ����������� ��� ������������� (������)
    repe cmpsb               ; ���������� ����� �����, ���� ��� ����� � ���� �� ��������� ������� ����������

    ;��������� ���������
    jne strings_not_equal    ; ���� ������ �� �����, ��������� � ����� strings_not_equal

    push MB_OK
    push offset caption
    push offset messageEqual
    push 0
    call MessageBoxA@16
    jmp end_compare          ; ��������� � ���������� ���������

    strings_not_equal:       ;���� ������ �� �����, ������� ������ ���������
        push MB_OK
        push offset caption
        push offset messageNotEqual
        push 0
        call MessageBoxA@16

    end_compare:
        ret
CompareProc endp

end
