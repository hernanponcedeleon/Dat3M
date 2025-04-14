#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: IH is disabled forever. IH should never run.
// Expected: PASS.

void *handler(void *arg)
{
    assert(0);
}

int main()
{
    __VERIFIER_disable_irq();
    __VERIFIER_register_interrupt_handler(handler);

    return 0;
}
