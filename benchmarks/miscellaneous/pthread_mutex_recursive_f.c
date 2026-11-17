#include <pthread.h>
#include <assert.h>

// The last unlock releases a recursive mutex, so the second increment can race (the assertion can fail).

pthread_mutex_t mutex;
int counter;

void *worker(void *arg)
{
    pthread_mutex_lock(&mutex);
    pthread_mutex_lock(&mutex);
    counter++;
    pthread_mutex_unlock(&mutex);
    pthread_mutex_unlock(&mutex);
    counter++;
    return NULL;
}

int main()
{
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&mutex, &attr);

    pthread_t t0, t1;
    pthread_create(&t0, NULL, worker, NULL);
    pthread_create(&t1, NULL, worker, NULL);
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    assert(counter == 4);
    return 0;
}
