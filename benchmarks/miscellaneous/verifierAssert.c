#include <stdlib.h>
#include <pthread.h>
#include <stdatomic.h>
#include <dat3m.h>

/*
    Tests that __VERIFIER_assert does not add control-flow (and thus no dependencies) whereas the standard assert does.
    EXPECTED: Fail under ARM8 (PASS if a standard assert would be used).
*/

atomic_int x, y;

void *thread_1(void *unused)
{
    int r = atomic_load_explicit(&x, memory_order_relaxed);
    __VERIFIER_assert(r == 0);
    atomic_store_explicit(&y, 1, memory_order_relaxed);
    return NULL;
}

void *thread_2(void *unused)
{

    int r = atomic_load_explicit(&y, memory_order_relaxed);
    if (r == 1) {
        atomic_store_explicit(&x, 1, memory_order_relaxed);
    }
    return NULL;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_2, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    return 0;
}
