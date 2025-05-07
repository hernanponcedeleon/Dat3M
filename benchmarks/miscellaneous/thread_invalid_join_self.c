#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
#include <dat3m.h>

/*
    The test shows wrong pthread_join usage.
    EXPECTED: FAIL
*/

void *thread1(void *arg)
{
    pthread_join(pthread_self(), NULL); // Invalid: cannot join with self
    return 0;
}

int main()
{
    pthread_t t1;
    pthread_create(&t1, NULL, thread1, NULL);
    return 0;
}
