#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: Multiple IHs for the same thread: IHs are ordered
// Expected: PASS

volatile int x;
atomic_int y, z;

void *handler(void *arg)
{
    x++;
    z = 1;

    return NULL;
}

void *handler2(void *arg)
{
    x++;
    y = 1;

    return NULL;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);
    __VERIFIER_register_interrupt_handler(handler2);

    if (y == 1 && z == 1) {
        // No increment is lost, because IHs are always ordered
        assert (x == 2);
    }

    return 0;
}
