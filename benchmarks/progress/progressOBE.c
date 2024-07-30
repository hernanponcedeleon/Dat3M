#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

atomic_int x = 0;

void *thread_1(void *unused)
{
    while (x != 1);
    return 0;
}

void *thread_2(void *unused)
{
    x = 1;
}

int main()
{
    pthread_t t1, t2;
    pthread_create(&t2, NULL, thread_2, NULL); // May not get scheduled under OBE, but would under HSA
    pthread_create(&t1, NULL, thread_1, NULL);
    return 0;
}
