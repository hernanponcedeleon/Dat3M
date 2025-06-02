#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Compiler reordering leads to non-termination.
// Expected: FAIL

volatile int x, y;

void *handler(void *arg)
{
    if (y == 1 && x == 0) {
        while (1) {  }
    }

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);

    // Swap stores + interrupt between both stores should give non-termination
    x = 1;
    // __VERIFIER_make_cb();
    y = 1;

    return 0;
}
