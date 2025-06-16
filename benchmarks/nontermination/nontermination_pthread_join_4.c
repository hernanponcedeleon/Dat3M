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

atomic_int x;

void* thread(void* arg) {
    await_while (atomic_load(&x) == 0);
    return NULL;
}

int main() {
    pthread_t t;
    atomic_init(&x, 0);

    pthread_create(&t, NULL, thread, NULL);
    pthread_join(t, NULL);

    atomic_store(&x, 1);

    return 0;
}
