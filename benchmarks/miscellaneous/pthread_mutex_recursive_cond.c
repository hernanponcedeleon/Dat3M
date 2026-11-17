#include <pthread.h>
#include <assert.h>

// Waiting on a condition variable unlocks a recursive mutex once, so it stays locked if it was locked twice.

pthread_mutex_t mutex;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
int released;

void *worker(void *arg)
{
    if (pthread_mutex_trylock(&mutex) == 0) {
        assert(released);
        pthread_mutex_unlock(&mutex);
    }
    return NULL;
}

int main()
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&mutex, &attr);

    pthread_mutex_lock(&mutex);
    pthread_mutex_lock(&mutex);
    pthread_t t;
    pthread_create(&t, NULL, worker, NULL);
    pthread_cond_wait(&cond, &mutex);
    released = 1;
    pthread_mutex_unlock(&mutex);
    pthread_mutex_unlock(&mutex);
    pthread_join(t, NULL);
    return 0;
}
