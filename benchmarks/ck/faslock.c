#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdlib.h>
#include <dat3m.h>

#define NTHREADS 3

int x = 0, y = 0;
ck_spinlock_fas_t lock;

void *run(void *arg) {
    int tid = (int)(long)arg;
    
    if(tid == NTHREADS - 1){
        bool acquired = ck_spinlock_fas_trylock(&lock);
        __VERIFIER_assume(acquired);
    } else {
        ck_spinlock_fas_lock(&lock);
    }
    x++;
    y++;
    ck_spinlock_fas_unlock(&lock);
    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;
    ck_spinlock_fas_init(&lock);
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
