#include <pthread.h>
#include <stdatomic.h>
#ifdef USE_GENMC
#define __VERIFIER_loop_bound(x)
#else
#include <dat3m.h>
#endif

/*
    Test case: Zero-effect spinloop via FADD/FSUB on taken lock.
    Expected result: FAIL under all memory models.
*/

atomic_int lock;

void acquireLock() {
    while (1) {
        if (atomic_fetch_add(&lock, 1) == 0) {
            break;
        }
        atomic_fetch_add(&lock, -1);
    }
}

void releaseLock() {
    atomic_fetch_add(&lock, -1);
}

void *thread(void *unused)
{
    acquireLock();
    releaseLock();
    return 0;
}

int main()
{
    pthread_t t1, t2, t3;

    acquireLock(); // Occupy lock

    pthread_create(&t1, NULL, thread, NULL);
    pthread_create(&t2, NULL, thread, NULL);
    pthread_create(&t3, NULL, thread, NULL);
    return 0;
}