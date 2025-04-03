#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: Compiler reordering + dynamic fairness characterization leads to non-termination.
// Expected: FAIL, but this requires fairness reasoning for non-termination to be relativized in the CAT model.
// Current verdict: PASS due to non-relativized fairness.

volatile int x, y;

void *handler(void *arg)
{
    if (x == 1) {
        while (y == 0) {  }
    }

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);

    // Swap stores + interrupt between both stores should give non-termination
    y = 1;
    // __VERIFIER_make_cb();  // Shall give PASS
    x = 1;

    return 0;
}
