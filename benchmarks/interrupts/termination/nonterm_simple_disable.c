#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Simple interrupt without reordering would lead to non-termination, but the interrupt is disabled.
// Expected: PASS

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

    __VERIFIER_disable_irq();
    x = 1;
    // Interrupt here would result in non-termination, but it is disabled
    y = 1;
    __VERIFIER_enable_irq();

    return 0;
}
