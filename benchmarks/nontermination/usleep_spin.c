#include <pthread.h>
#include <stdatomic.h>
#include <unistd.h>

// usleep is a no-op like sleep: the waiter spins until the other thread sets the flag.
atomic_int flag;

void *waiter(void *unused)
{
    while (!atomic_load(&flag)) {
        usleep(1);
    }
    return 0;
}

void *setter(void *unused)
{
    atomic_store(&flag, 1);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, waiter, NULL);
    pthread_create(&t2, NULL, setter, NULL);
    return 0;
}
