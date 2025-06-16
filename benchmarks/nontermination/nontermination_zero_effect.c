#include <pthread.h>
#include <stdatomic.h>
#ifdef USE_GENMC
#include <genmc.h>
#ifdef ANNOTATE_LOOPS
#define await_while(cond)                                                  \
        for (__VERIFIER_loop_begin();                                      \
             (__VERIFIER_spin_start(),                                     \
              (cond) ? 1 : (__VERIFIER_spin_end(1), 0));                   \
             __VERIFIER_spin_end(0))
#else
#define await_while while
#endif
#define __VERIFIER_loop_bound(x)
#else
#include <dat3m.h>
#define await_while while
#endif

/*
    Test case: Zero-effect spinloop via FADD/FSUB on taken lock.
    Expected result: FAIL under all memory models.
*/

atomic_int lock;

void acquireLock() {
    await_while (1) {
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