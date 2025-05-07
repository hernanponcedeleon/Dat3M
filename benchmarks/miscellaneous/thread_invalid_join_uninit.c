#include <pthread.h>
#include <stdatomic.h>
#include <assert.h>
#include <dat3m.h>

/*
    The test shows wrong pthread_join usage.
    EXPECTED: FAIL
*/

int main()
{
    pthread_t t1;
    pthread_join(t1, NULL); // Invalid: t1 is uninitialized
    return 0;
}
