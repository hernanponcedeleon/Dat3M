#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: Does IH always have to run?
// Expected: FAIL if IT may not run, otherwise PASS.
// Current verdict: PASS

void *handler(void *arg)
{
    __VERIFIER_assume(0);
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);

    __VERIFIER_assert(0);

    return 0;
}
