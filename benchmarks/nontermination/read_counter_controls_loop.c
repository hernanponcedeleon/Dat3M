#include <pthread.h>
#include <stdatomic.h>

// The counter is read by the loop condition, so it is not write-only and must be kept.
atomic_int stop;
unsigned long rounds;

void *worker(void *unused)
{
    while (!atomic_load(&stop) && rounds != 1000000) {
        rounds++;
    }
    return 0;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, worker, NULL);
    return 0;
}
