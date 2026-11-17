#include <pthread.h>
#include <assert.h>
#include <errno.h>

// A recursive mutex stays locked until its owner unlocked it as often as it locked it,
// and a normal mutex still blocks when it is locked twice.

pthread_mutex_t recursive;
pthread_mutex_t normal;

void *other(void *arg)
{
    assert(pthread_mutex_trylock(&recursive) == EBUSY);
    return NULL;
}

void *relock(void *arg)
{
    pthread_mutex_lock(&normal);
    pthread_mutex_lock(&normal);
    assert(0);
    return NULL;
}

int main()
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&recursive, &attr);
    pthread_mutex_init(&normal, NULL);

    pthread_mutex_lock(&recursive);
    pthread_mutex_lock(&recursive);
    pthread_mutex_unlock(&recursive);

    pthread_t t0, t1;
    pthread_create(&t0, NULL, other, NULL);
    pthread_create(&t1, NULL, relock, NULL);
    pthread_join(t0, NULL);
    pthread_mutex_unlock(&recursive);
    return 0;
}
