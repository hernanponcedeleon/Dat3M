#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Compiler barrier should include same-loc writes.
// Expected: PASS

volatile int x;

void *handler(void *arg)
{
    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);

    x = 1;
    x = 2;

    assert (x == 2);

    return 0;
}
