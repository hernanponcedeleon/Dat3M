#include <pthread.h>
#include <stdatomic.h>

// A write-only counter in a loop that ends once the other thread sets the flag.
atomic_int stop;
long rounds;

void *worker(void *unused)
{
    while (!atomic_load(&stop)) {
        rounds++;
    }
    return 0;
}

void *stopper(void *unused)
{
    atomic_store(&stop, 1);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, worker, NULL);
    pthread_create(&t2, NULL, stopper, NULL);
    return 0;
}
