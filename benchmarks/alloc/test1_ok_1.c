#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <stdatomic.h>

void *thread_1(void *arg)
{
    int *arr = *((int**)arg);
    arr[0] = 0;
    arr[1] = 1;

	return NULL;
}

int main()
{
    pthread_t t1;
    int *arr = malloc(2 * sizeof(int));

    pthread_create(&t1, NULL, thread_1, (void*)&arr);
    pthread_join(t1, NULL);

    free(arr);

	return 0;
}
