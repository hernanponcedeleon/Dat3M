#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
#include <dat3m.h>

/*
    The test shows that pthread_self and __VERIFIER_tid return the same value.
    Furthermore, it shows that the id written by pthread_create(&t, ...) into "t" matches the
    the id returned by pthread_self within the spawned child thread.
    Expected result: PASS
*/

pthread_t childTid;

void *thread1(void *arg)
{
    childTid = pthread_self();
    return NULL;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, thread1, NULL);
    pthread_join(t1, NULL);

    assert(childTid == t1);
    assert(__VERIFIER_tid() == pthread_self());
}
