#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Simple interrupt without reordering leads to non-termination.
// Expected: FAIL

volatile int x, y, z;

void *handler(void *arg)
{
    if (x == 1) {
        while (z == 0) {  }
    }

    return NULL;
}

void *thread(void *arg) {
    while (y == 0) { }
    z = 1;
}

int main()
{
    __VERIFIER_register_interrupt_handler(handler);

    pthread_t t;
    pthread_create(&t, NULL, thread, NULL);

    x = 1;
    // Interrupt here should result in non-termination
    y = 1;

    return 0;
}
