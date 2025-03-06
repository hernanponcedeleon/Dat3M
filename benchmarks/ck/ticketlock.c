#include <assert.h>
#include <ck_spinlock.h>
#include <pthread.h>
#include <stdlib.h>

#ifndef NTHREADS
    #define NTHREADS 3
#endif


int x = 0, y = 0;
ck_spinlock_ticket_t *ticket_lock;

void *run(void *arg) {

    ck_spinlock_ticket_lock(ticket_lock);

    x++;
    y++;

    ck_spinlock_ticket_unlock(ticket_lock);

    return NULL;
}

int main() {
    pthread_t threads[NTHREADS];
    int i;

    ticket_lock = (ck_spinlock_ticket_t *)malloc(sizeof(ck_spinlock_ticket_t));
    ck_spinlock_ticket_init(ticket_lock);

    for (i = 0; i < NTHREADS; i++) {
        if (pthread_create(&threads[i], NULL, run, NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    for (i = 0; i < NTHREADS; i++) {
        if (pthread_join(threads[i], NULL) != 0) {
            exit(EXIT_FAILURE);
        }
    }

    assert(x == NTHREADS && y == NTHREADS);

    free(ticket_lock);

    return 0;
}
