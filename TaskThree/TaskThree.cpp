#include <iostream>

extern "C" int CompareProc();// Объявление ассемблерной функции сравнения строк

int main()
{
    int sum;
    __asm {
        call CompareProc
    }

}