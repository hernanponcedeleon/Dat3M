#define _GNU_SOURCE
#include <pthread.h>
#include <assert.h>

// Statically initialized mutexes work, and a recursive one can be locked twice (the assertion is reachable).

#ifdef PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP
pthread_mutex_t recursive = PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP;
#else
pthread_mutex_t recursive = PTHREAD_RECURSIVE_MUTEX_INITIALIZER;
#endif
pthread_mutex_t normal = PTHREAD_MUTEX_INITIALIZER;

int main()
{
    pthread_mutex_lock(&normal);
    pthread_mutex_unlock(&normal);
    pthread_mutex_lock(&recursive);
    pthread_mutex_lock(&recursive);
    assert(0);
    return 0;
}
