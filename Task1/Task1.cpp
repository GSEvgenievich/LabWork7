#include <iostream>

extern "C" int SumProc();

int main()
{
    int sum;
    __asm {
        push 3
        push 5
        call SumProc
        mov sum, eax
    }

    std::cout << "Summa: " << sum;
}