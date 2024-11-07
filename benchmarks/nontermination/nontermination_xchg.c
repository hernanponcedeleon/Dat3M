#include <pthread.h>
#include <stdatomic.h>

/*
    Test case: Xchg-based (side-effectful) spinning on taken lock
    Expected result: FAIL under all memory models.
*/

atomic_int lock;

void *thread(void *unused)
{
    while (atomic_exchange(&lock, 1) == 1);
}

void *thread2(void *unused) {
    lock = 1;
}

int main()
{
    pthread_t t1, t2;

    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread2, NULL);

    return 0;
}