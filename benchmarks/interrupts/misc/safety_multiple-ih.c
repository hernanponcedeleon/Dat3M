#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: Multiple IHs for the same thread: one is stuck and should stop the other from running
// Expected: FAIL for termination, PASS for program_spec

volatile int x, y;

void *handler(void *arg)
{
    assert (y != 1);
    return NULL;
}

void *handler2(void *arg)
{
    y = 1;
    while (x != 1);

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_register_interrupt_handler(handler2);

    return 0;
}
