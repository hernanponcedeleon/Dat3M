#include <assert.h>
#include <dat3m.h>
// Issue: Mixed-size accesses and a misaligned access.
// Expected: FAIL if mixedSize enabled, else PASS.

volatile struct { short i00, i01, i02; } x;

int main()
{
    x.i00 = 0x1111;
    x.i01 = 0x2222;
    int r = *(volatile int*)(&x);
    int s = *(volatile int*)(((volatile char*)(&x))+1);
#ifdef __LITTLE_ENDIAN__
    assert(r != 0x22221111 || s != 0x222211);
#else
#ifdef __BIG_ENDIAN__
    assert(r != 0x11112222 || s != 0x11222200);
#else
#error Undefined byte order
#endif
#endif
    return 0;
}
