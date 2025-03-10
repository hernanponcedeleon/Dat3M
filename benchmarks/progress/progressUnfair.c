#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

// Required progress: Unfair (terminates under all progress models)

atomic_int x = 0;

void *thread_1(void *unused)
{
    while (x != 1);
    return 0;
}

int main()
{
    pthread_t t1, t2;
    x = 1;
    pthread_create(&t1, NULL, thread_1, NULL);
    return 0;
}
