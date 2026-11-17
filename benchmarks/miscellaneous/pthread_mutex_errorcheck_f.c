#define _GNU_SOURCE
#include <pthread.h>
#include <assert.h>

// Locking an error-checking mutex again does not block (the assertion is reachable).

#ifdef PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP
pthread_mutex_t initialized = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;
#else
pthread_mutex_t initialized = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER;
#endif

int main()
{
    pthread_mutex_t mutex;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_ERRORCHECK);
    pthread_mutex_init(&mutex, &attr);
    pthread_mutex_lock(&mutex);
    pthread_mutex_lock(&mutex);
    pthread_mutex_lock(&initialized);
    pthread_mutex_lock(&initialized);
    assert(0);
    return 0;
}
