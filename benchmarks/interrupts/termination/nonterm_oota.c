#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// ISSUE: Non-termination of IH should prohibit execution of events after it.
//  However, IH's non-termination indirectly depends on the later events, giving a notion of OOTA non-termination.

volatile int x, y, z;

void *handler(void *arg)
{
    if (x == 1 && z == 0) {
        while (y == 1) {  }
    }

    return NULL;
}

void *thread(void *arg) {

    if (z == 1) {
        y = 1;
    }

    return NULL;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, thread, NULL);
    __VERIFIER_register_interrupt_handler(handler);

    x = 1;
    // IH must interrupt here, but then "z=1" should never get executed if IH fails to terminate.
    // However, IH only fails to terminate if the other thread observes "z=1".
    __VERIFIER_make_cb();
    z = 1;

    return 0;
}
