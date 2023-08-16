#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

/*
    The test shows chaining of thread creations + parameter passing, i.e, the spawned thread
    spawns another thread and passes its argument to that one.
    Expected result: PASS
*/

atomic_int data;

void *thread2(void *arg)
{
    data = (int)arg;
    return NULL;
}

void *thread1(void *arg)
{
    pthread_t t2;
    pthread_create(&t2, NULL, thread2, arg);
    pthread_join(t2, NULL);
    return NULL;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, thread1, (void*)42);
    pthread_join(t1, NULL);

    assert(data == 42);
}
