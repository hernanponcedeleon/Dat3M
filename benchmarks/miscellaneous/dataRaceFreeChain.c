#include <pthread.h>
#include <stdatomic.h>

/*
    The write and the read of data are only ordered through a chain of two release/acquire pairs,
    i.e., by a path of length two in the happens-before relation.
    EXPECTED: no data race under vmm
*/

int data = 0;
atomic_int f1 = 0;
atomic_int f2 = 0;

void *first(void *arg)
{
    data = 1;
    atomic_store_explicit(&f1, 1, memory_order_release);
    return NULL;
}

void *second(void *arg)
{
    if (atomic_load_explicit(&f1, memory_order_acquire) == 1) {
        atomic_store_explicit(&f2, 1, memory_order_release);
    }
    return NULL;
}

void *third(void *arg)
{
    if (atomic_load_explicit(&f2, memory_order_acquire) == 1) {
        int r = data;
        (void) r;
    }
    return NULL;
}

int main()
{
    pthread_t t1, t2, t3;
    pthread_create(&t1, NULL, first, NULL);
    pthread_create(&t2, NULL, second, NULL);
    pthread_create(&t3, NULL, third, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);
    return 0;
}
