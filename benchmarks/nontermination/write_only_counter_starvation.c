#include <pthread.h>
#include <stdatomic.h>

// The greedy thread re-takes the test-and-set lock at once, so the waiter may never get it.
// Each round also increments a statistics counter that nothing reads.
atomic_flag lock = ATOMIC_FLAG_INIT;
atomic_int stop;
long rounds;

void *greedy(void *unused)
{
    while (!atomic_load(&stop)) {
        while (atomic_flag_test_and_set(&lock)) {}
        rounds++;
        atomic_flag_clear(&lock);
    }
    return 0;
}

void *waiter(void *unused)
{
    while (atomic_flag_test_and_set(&lock)) {}
    atomic_store(&stop, 1);
    atomic_flag_clear(&lock);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, greedy, NULL);
    pthread_create(&t2, NULL, waiter, NULL);
    return 0;
}
