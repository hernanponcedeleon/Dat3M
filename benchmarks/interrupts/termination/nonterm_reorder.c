#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Compiler reordering leads to non-termination.
// Expected: FAIL

volatile int x, y;
atomic_int z;

void *handler(void *arg)
{
    z = 1; // SC-store
    if (y == 1) {
        while (y == 0) {  }
    }

    return NULL;
}

void *thread(void *arg) {
    if (z == 1 && x == 0) { // SC-load from z, so if x was not reordered, we would have to see x == 1 here
        y = 0;
    }
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    pthread_t t;
    pthread_create(&t, NULL, thread, NULL);

    // Swap stores + interrupt between both stores should give non-termination
    x = 1;
    // __VERIFIER_make_cb();  // Shall give PASS
    y = 1;

    return 0;
}
