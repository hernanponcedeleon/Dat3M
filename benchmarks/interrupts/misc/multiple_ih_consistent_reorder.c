#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Multiple IHs for the same thread: IHs should agree on the compiler reordering
// Expected: PASS

volatile int x, y, z;


void *handler(void *arg)
{
    if (x == 1 && y == 0) {
        z++;
    }

    return NULL;
}

void *handler2(void *arg)
{
    if (y == 1 && x == 0) {
        z++;
    }

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_register_interrupt_handler(handler2);

    x = 1;
    y = 1;

    assert (z != 2);

    return 0;
}
