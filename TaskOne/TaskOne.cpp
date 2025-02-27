#include <iostream>

extern "C" int SumProc();// Объявление ассемблерной функции сложения

int main()
{
    int sum;
    __asm {
        ;ПАРМЕТРЫ:
        push 1
        push 5

        ;ВЫЗОВ ФУНКЦИИ:
        call SumProc

        ;ОЧИСТКА СТЕКА(2 параметра по 4 байта):
        add esp, 8

        ;ЗАНЕСЕНИЕ ЗНАЧЕНИЯ ИЗ РЕГИСТРА EAX В ПЕРЕМЕННУЮ В ПАМЯТИ:
        mov sum, eax
    }

    std::cout << "Summa: " << sum;
}