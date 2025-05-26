#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
// Issue: Store-to-Load Forwarding may cause mixed-size atomic accesses to appear non-atomic.
// Expected: FAIL on ARMv8

union { atomic_ushort full; struct { atomic_uchar half0; atomic_uchar half1; }; } lock;

void *thread1(void *arg)
{
    atomic_store_explicit(&lock.full, 0xff00, memory_order_relaxed);
    return 0;
}

void *thread2(void *arg)
{
    atomic_store_explicit(&lock.full, 0x00ff, memory_order_relaxed);
    return 0;
}

void *thread3(void *arg)
{
    atomic_fetch_add_explicit(&lock.half0, 0, memory_order_relaxed);
    unsigned short val = atomic_load_explicit(&lock.full, memory_order_relaxed);
    assert(val != 0xffff);
    return 0;
}

int main() {

    pthread_t t1, t2, t3;

    pthread_create(&t1, 0, thread1, 0);
    pthread_create(&t2, 0, thread2, 0);
    pthread_create(&t3, 0, thread3, 0);

    return 0;
}