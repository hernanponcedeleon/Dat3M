#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
#include <dat3m.h>

/*
    This test shows that threads can return values.
    Furthermore, it shows that "return X" and "pthread_exit(X)" are equivalent on the top level of the executing thread.
    EXPECTED: PASS
*/

void *thread1(void *arg)
{
    return 42;
}

void *thread2(void *arg)
{
    pthread_exit(42);
    return 0;   // Unreachable
}

void returnValue(void *arg) {
    pthread_exit(arg); // Here we cannot put "return arg"
}

void *thread3(void *arg)
{
    returnValue(41);
    return 0;   // Unreachable
}

int main()
{
    pthread_t t1, t2;
    void *retVal1, *retVal2;

    pthread_create(&t1, NULL, thread1, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    pthread_join(t1, &retVal1);
    pthread_join(t2, &retVal2);
    assert(retVal1 == retVal2 && retVal1 == 42);

    pthread_create(&t1, NULL, thread3, NULL);
    pthread_join(t1, &retVal1);
    assert(retVal1 == 41);
}
