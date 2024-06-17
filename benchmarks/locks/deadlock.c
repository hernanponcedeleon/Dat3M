#include <pthread.h>
#include <assert.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

void *thread(void *unused)
{
    pthread_mutex_lock(&mutex);
    return NULL;
}

int main()
{
    pthread_t t1, t2;

    pthread_mutex_init(&mutex, 0);

    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread, NULL);

    return 0;
}
