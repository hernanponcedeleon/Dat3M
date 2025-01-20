#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

void *thread_1(void *arg)
{
    int *arr = *((int**)arg);
    free(arr);

	return NULL;
}

int main()
{
    pthread_t t1;
    int *arr;

    pthread_create(&t1, NULL, thread_1, (void*)&arr);
    arr = malloc(2 * sizeof(int));
    pthread_join(t1, NULL);

    free(arr);

	return 0;
}
