#define _GNU_SOURCE
#include <pthread.h>
#include <assert.h>
#include <errno.h>

// An error-checking mutex reports being locked again by its owner instead of blocking.

#ifdef PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP
pthread_mutex_t initialized = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;
#else
pthread_mutex_t initialized = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER;
#endif

void check(pthread_mutex_t *mutex)
{
    assert(pthread_mutex_lock(mutex) == 0);
    assert(pthread_mutex_lock(mutex) == EDEADLK);
    assert(pthread_mutex_trylock(mutex) == EBUSY);
    assert(pthread_mutex_unlock(mutex) == 0);
    assert(pthread_mutex_trylock(mutex) == 0);
    assert(pthread_mutex_unlock(mutex) == 0);
}

int main()
{
    pthread_mutex_t mutex;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);
    pthread_mutex_init(&mutex, &attr);
    check(&mutex);
    check(&initialized);
    return 0;
}
