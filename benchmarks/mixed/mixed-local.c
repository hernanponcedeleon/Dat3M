#include <dat3m.h>
// Issue: Mixed-size access on a thread-local variable.  ProgramProcessor Mem2Reg should promote x, if performed after Tearing.
// Expected: PASS if mixedSize enabled, else undefined

int main()
{
    union { int as_int; short as_short; } x;
    x.as_int = 0x1e240;
    x.as_short = 0;
#ifdef __LITTLE_ENDIAN__
    assert(x.as_int == 0x10000);
#else
#ifdef __BIG_ENDIAN__
    assert(x.as_int == 0xe240);
#else
#error Undefined byte order
#endif
#endif
    return 0;
}
