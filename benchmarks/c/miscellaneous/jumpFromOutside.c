#include <stdint.h>
#include <assert.h>
#include <dat3m.h>

volatile int32_t x = 0;

int main()
{
    int x = __VERIFIER_nondet_uint();

    if (x <= 0) {
        return 0;
    }

A:
    if (x >= 10) {
        x = 5;
        goto C;
    }
B:
    x = x + 1;
C:
    if (x < 10) {
        goto B;
    }

	return 0;
}
