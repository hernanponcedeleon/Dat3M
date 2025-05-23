#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Racing assume and assert.
// Expected: FAIL, IH may interrupt before assume, fail its assertion and therefore terminate the program.

void *handler(void *arg)
{
    assert(0);                  // FAIL (assert failure terminates both IH and IT before assume executes)
    // __VERIFIER_assert(0);    // PASS (assert failure does not terminate IH nor IT, therefore assume will execute)
    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);

    __VERIFIER_assume(0);

    return 0;
}
