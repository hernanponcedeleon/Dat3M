#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: IH is disabled forever before entering a bad state.
// Expected: PASS.
volatile int x;

void *handler(void *arg)
{
    assert(x != 1);
    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_disable_irq();
    x = 1;

    return 0;
}
