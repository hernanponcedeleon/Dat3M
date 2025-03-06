#include <assert.h>
#include <ck_spinlock.h>
#include <dat3m.h>
#include <pthread.h>

// nthreads is 3
#define NTHREADS 3

ck_spinlock_cas_t lock;
int x = 0, y = 0;

void *run(void *arg) {
    int tid = (int)(long)arg;

    if (tid == NTHREADS - 1) {
        bool acquired = ck_spinlock_cas_trylock(&lock);
        __VERIFIER_assume(acquired);
    } else {
        ck_spinlock_cas_lock(&lock);
    }
    x++;
    y++;
    ck_spinlock_cas_unlock(&lock);
    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;
    ck_spinlock_cas_init(&lock);
    for (i = 0; i < NTHREADS; i++) {
        if (pthread_create(&threads[i], NULL, run, (void *)(long)i) != 0) {
            exit(EXIT_FAILURE);
        }
    }
    for (i = 0; i < NTHREADS; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        };
    }
    assert(x == NTHREADS && y == NTHREADS);
    return 0;
}
