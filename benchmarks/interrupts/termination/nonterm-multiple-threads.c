#include <stdlib.h>
#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include <dat3m.h>

// Test case: Simple interrupt without reordering leads to non-termination.
// Expected: FAIL

// NOTE: This benchmark would be very complex if the control-flow of IT and IH was independent and CAT had to compute the actual
// events that were executed. Since the memory accessed by IH and IT is disjoint, there is no communication between them at all
// making it hard to define the interrupt point deterministically.


volatile int x, y;

void *ih1(void *arg) {
    while (y != 1);
}

void *ih2(void *arg) {
    while (x != 1);
}

void *thread1(void *arg) {
    __VERIFIER_register_interrupt_handler(ih1);
    // <-- Interrupt
    x = 1;
}

void *thread2(void *arg) {
    __VERIFIER_register_interrupt_handler(ih2);
    // <-- Interrupt
    y = 1;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, NULL, thread1, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    return 0;
}
