#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Non-termination in nested interrupt handler IH_2 with two reorderings in IT and first IH_1.
// Expected: FAIL. If any of the two compiler barriers are enabled, then PASS.

volatile int x, y, z;

void *handler2(void *arg)
{
    if (x == 0) {
        while (y == 1 && z == 1) {}
    }

    return NULL;
}

void *handler(void *arg)
{
    __VERIFIER_register_interrupt_handler(handler2);
    x = 1;
    // __VERIFIER_make_cb();
    z = 1;

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    x = 1;
    // __VERIFIER_make_cb();
    y = 1;

    return 0;
}
