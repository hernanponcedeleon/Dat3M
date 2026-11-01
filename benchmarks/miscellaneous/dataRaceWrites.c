#include <pthread.h>

/*
    Two threads write to x without synchronization.
    EXPECTED: data race (CAT specification violation under vmm)
*/

int x = 0;

void *writer(void *arg)
{
    x = 1;
    return NULL;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t1, NULL, writer, NULL);
    pthread_create(&t2, NULL, writer, NULL);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    return 0;
}
