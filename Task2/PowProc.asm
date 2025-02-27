.386
.model flat, c
.code

public PowProc

PowProc PROC
    mov eax, 1      ; Устанавливаем начальное значение EAX в 1 (2^0 = 1).
    cmp ecx, 0
    je done

    pow:            ; ЦИКЛ
        shl eax, 1  ; Умножаем eax на 2 (сдвиг влево)
    loop pow                

    done:           ; Метка завершения.
        ret         ; Возвращаем управление в вызывающую функцию. Результат находится в EAX.
PowProc ENDP

end
