#include <pthread.h>
#include <assert.h>
#include <errno.h>

// Only the owner can unlock a recursive mutex.

pthread_mutex_t mutex;

void *worker(void *arg)
{
    assert(pthread_mutex_unlock(&mutex) == EPERM);
    assert(pthread_mutex_trylock(&mutex) == EBUSY);
    return NULL;
}

int main()
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&mutex, &attr);

    pthread_mutex_lock(&mutex);
    pthread_t t;
    pthread_create(&t, NULL, worker, NULL);
    pthread_join(t, NULL);
    pthread_mutex_unlock(&mutex);
    return 0;
}
