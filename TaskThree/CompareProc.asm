.386
.model flat, c
.stack 4096

.data
	MB_OK equ 0
	str1 db "Hello", 0
	str2 db "Hello", 0
	caption db "Result", 0
	messageEqual db "Строки равны", 0
	messageNotEqual db "Строки не равны", 0
	EXTERN MessageBoxA@16: NEAR

.code

CompareProc proc
	;Устанавливаем адреса строк для сравнения
    lea esi, [str1]            ; Загружаем адрес первой строки в ESI
    lea edi, [str2]            ; Загружаем адрес второй строки в EDI

    ;Сравниваем строки
    mov ecx, 5               ; Устанавливаем счётчик для размера данных в словах
    cld                      ; Устанавливаем направление для инкрементации (вперед)
    repe cmpsb               ; Сравниваем байты строк, пока они равны и пока не достигнут нулевой терминатор

    ;Проверяем результат
    jne strings_not_equal    ; Если строки не равны, переходим к метке strings_not_equal

    push MB_OK
    push offset caption
    push offset messageEqual
    push 0
    call MessageBoxA@16
    jmp end_compare          ; Переходим к завершению процедуры

    strings_not_equal:       ;Если строки не равны, выводим другое сообщение
        push MB_OK
        push offset caption
        push offset messageNotEqual
        push 0
        call MessageBoxA@16

    end_compare:
        ret
CompareProc endp

end
