#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Multiple IHs for the same thread, all can interrupt at the same point.
// Expected: FAIL

atomic_int x, y;

void *handler(void *arg)
{
    if (x == 1) {
        y++;
    }

    return NULL;
}

void *handler2(void *arg)
{
    if (x == 1) {
        y++;
    }

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_register_interrupt_handler(handler2);

    x = 1;
    // Both IHs interrupt here
    x = 2;

    assert (y != 2);

    return 0;
}
