#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Multiple IHs for the same thread: one is stuck and should stop the other.
// Expected: FAIL

atomic_int x;

void *handler(void *arg)
{
    x = 1;
    return NULL;
}

void *handler2(void *arg)
{
    while (x != 1);

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_register_interrupt_handler(handler2);

    return 0;
}
