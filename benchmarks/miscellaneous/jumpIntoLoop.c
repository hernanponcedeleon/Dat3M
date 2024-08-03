#include <stdint.h>
#include <assert.h>
#include <dat3m.h>

volatile int32_t x = 0;

int main()
{
    int i = 0;
    int jumpIntoLoop = __VERIFIER_nondet_bool();
    if (jumpIntoLoop) goto L;

    __VERIFIER_loop_bound(6);
    for (i = 1; i < 5; i++) {
L:
        x++;
    }

    assert ((jumpIntoLoop && x == 5) || (!jumpIntoLoop && x == 4));
    return 0;
}
