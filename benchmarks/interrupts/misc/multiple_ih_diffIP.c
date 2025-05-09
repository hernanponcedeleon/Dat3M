#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Multiple IHs for the same thread: each can interrupt at a different point
// Expected: FAIL

atomic_int x;

void *handler(void *arg)
{
    x = 1;

    return NULL;
}

void *handler2(void *arg)
{
    x = 2;

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_register_interrupt_handler(handler2);

    int r1 = x;
    // IH1
    int r2 = x;
    // IH2

    assert ((r1 == 0 || r2 == 0) || (r1 == r2));

    return 0;
}
