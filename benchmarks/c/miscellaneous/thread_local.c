#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>

/*
    The test shows thread-local storage + initialization.
    Expected result: PASS
*/

__thread atomic_int data;
__thread int val = 5; // All threads should see the same init value

void check(int value) {
   // Extra indirection, so that if thread locals are (wrongly) created
   // per function rather than per thread, we get an error.
   assert (data == value);
   assert (val == 5);
}

void *thread2(void *arg)
{
    data = (int)arg;
    check(2);
    return NULL;
}

void *thread1(void *arg)
{
    data = (int)arg;

    pthread_t t2;
    pthread_create(&t2, NULL, thread2, (void*)2);
    pthread_join(t2, NULL);

    check(1);
    return NULL;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, thread1, (void*)1);
    pthread_join(t1, NULL);

    check(0);
}
