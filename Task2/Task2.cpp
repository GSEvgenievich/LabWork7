#include <iostream>

extern "C" int PowProc(unsigned int x); //Объявляем ассемблерную функцию PowProc, которая принимает беззнаковое целое.

int main()
{
    unsigned int x = 4;
    int result;
    __asm {
        mov ecx, x
        call PowProc
        mov result, eax
    }

    std::cout <<"2^" << x << "=" <<result;
}
