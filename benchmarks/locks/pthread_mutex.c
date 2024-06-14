#include <pthread.h>
#include <assert.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
int x;

void *thread(void *unused)
{
    pthread_mutex_lock(&mutex);
    x++;
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    assert(x == 2);

    return 0;
}
