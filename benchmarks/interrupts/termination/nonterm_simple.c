#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Simple interrupt without reordering leads to non-termination.
// Expected: FAIL

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

    x = 1;
    // Interrupt here should result in non-termination
    y = 1;

    return 0;
}
