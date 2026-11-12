#include <pthread.h>
#include <stdlib.h>

/*
    A thread writes into a heap buffer allocated next to another object.
    Run with --program.processing.memoryBoundsChecks=true.

    Expected verdicts for valid-memsafety.prp:
      default:     true
      -DFAIL:      false (the last write is out of bounds, but lands inside the neighboring object)
*/

extern int __VERIFIER_nondet_int(void);

#ifdef FAIL
#define LIMIT 5
#else
#define LIMIT 4
#endif

int *buf;
int *neighbor;

void *worker(void *arg) {
    for (int i = 0; i < LIMIT; i++) {
        buf[i] = i;
    }
    return 0;
}

int main() {
    buf = malloc(4 * sizeof(int));
    neighbor = malloc(4 * sizeof(int));
    if (buf == 0 || neighbor == 0) return 0;
    pthread_t t;
    pthread_create(&t, 0, worker, 0);
    pthread_join(t, 0);
    return 0;
}
