#include <pthread.h>

// Waiting on a condition variable with a recursive mutex that the caller does not own is a bug.

pthread_mutex_t mutex;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

int main()
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&mutex, &attr);

    pthread_cond_wait(&cond, &mutex);
    return 0;
}
