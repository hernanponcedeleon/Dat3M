#include <stdint.h>
#include <assert.h>
#include <dat3m.h>

volatile int32_t x = 0;

int main()
{
    int i = __VERIFIER_nondet_int();
    if (i == 42) goto L;

    for (i = 0; i < 5; i++) {
L:
    x++;
    }

    assert(x <= 5);
	return 0;
}
