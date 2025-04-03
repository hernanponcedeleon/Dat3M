#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: IH is disabled forever. Do we assume implicit IRQ-enable once the IT terminates or not?
// Expected: PASS if IT does not implicitly enable IRQ on termination. FAIL, otherwise.
// Current verdict: FAIL

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
