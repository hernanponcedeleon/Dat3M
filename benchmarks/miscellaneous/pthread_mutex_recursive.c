#include <pthread.h>
#include <assert.h>

// A recursive mutex can be locked again by its owner and is released by the matching number of unlocks.

pthread_mutex_t mutex;
int counter;

void *worker(void *arg)
{
    assert(pthread_mutex_lock(&mutex) == 0);
    assert(pthread_mutex_lock(&mutex) == 0);
    counter++;
    assert(pthread_mutex_unlock(&mutex) == 0);
    counter++;
    assert(pthread_mutex_unlock(&mutex) == 0);
    return NULL;
}

int main()
{
    pthread_mutexattr_t attr;
    int type;
    assert(pthread_mutexattr_init(&attr) == 0);
    assert(pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE) == 0);
    assert(pthread_mutexattr_gettype(&attr, &type) == 0 && type == PTHREAD_MUTEX_RECURSIVE);
    assert(pthread_mutex_init(&mutex, &attr) == 0);
    assert(pthread_mutexattr_destroy(&attr) == 0);

    assert(pthread_mutex_lock(&mutex) == 0);
    assert(pthread_mutex_trylock(&mutex) == 0);
    assert(pthread_mutex_unlock(&mutex) == 0);
    assert(pthread_mutex_unlock(&mutex) == 0);

    pthread_t t0, t1;
    pthread_create(&t0, NULL, worker, NULL);
    pthread_create(&t1, NULL, worker, NULL);
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    assert(counter == 4);
    return 0;
}
