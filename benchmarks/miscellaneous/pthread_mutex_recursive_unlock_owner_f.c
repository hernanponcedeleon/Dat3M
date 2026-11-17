#include <pthread.h>

// Unlocking a recursive mutex owned by another thread is a bug.

pthread_mutex_t mutex;

void *worker(void *arg)
{
    pthread_mutex_unlock(&mutex);
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
