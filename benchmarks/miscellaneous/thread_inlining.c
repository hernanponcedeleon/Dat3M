#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

/*
    The test checks if inlining of thread-creating functions works properly.
    Expected result: PASS
*/

atomic_int data;

void *thread2(void *arg)
{
    data = 42;
    return NULL;
}

void threadCreator(pthread_t *t) {
    pthread_create(t, NULL, thread2, NULL);
}

void *thread1(void *arg)
{
    pthread_t t;
    threadCreator(&t);
    pthread_join(t, NULL);
    return NULL;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_join(t1, NULL);

    assert(data == 42);
}
