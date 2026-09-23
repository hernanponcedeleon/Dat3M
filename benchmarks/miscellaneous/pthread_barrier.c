#include <pthread.h>
#include <assert.h>
#include <stdint.h>
#include <stdatomic.h>

// Writes before a barrier are visible after it, the phases of a reused barrier are kept apart,
// each phase has exactly one serial thread, and the barrier fits into pthread_barrier_t.

struct { pthread_barrier_t barrier; int guard; } s = { .guard = 42 };
int data[3];
atomic_int serial;

void wait_barrier()
{
    int status = pthread_barrier_wait(&s.barrier);
    assert(status == 0 || status == PTHREAD_BARRIER_SERIAL_THREAD);
    if (status == PTHREAD_BARRIER_SERIAL_THREAD) {
        atomic_fetch_add(&serial, 1);
    }
}

void *worker(void *arg)
{
    int i = (int)(intptr_t)arg;
    data[i] = 1;
    wait_barrier();
    assert(data[(i + 1) % 3] == 1 && data[(i + 2) % 3] == 1);
    wait_barrier();
    data[i] = 2;
    wait_barrier();
    assert(data[(i + 1) % 3] == 2 && data[(i + 2) % 3] == 2);
    return NULL;
}

int main()
{
    pthread_t t0, t1, t2;
    assert(pthread_barrier_init(&s.barrier, NULL, 3) == 0);
    assert(s.guard == 42);
    pthread_create(&t0, NULL, worker, (void *)0);
    pthread_create(&t1, NULL, worker, (void *)1);
    pthread_create(&t2, NULL, worker, (void *)2);
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    assert(serial == 3);
    assert(pthread_barrier_destroy(&s.barrier) == 0);
    return 0;
}
