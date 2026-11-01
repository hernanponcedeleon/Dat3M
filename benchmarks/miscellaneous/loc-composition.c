#include <pthread.h>
#include <assert.h>

// The write through p may alias x and y, but x and y never alias.
// Hence (rf^-1;co) may relate the read of x with the write to y unless
// the relation analysis knows that fr is contained in loc.

extern int __VERIFIER_nondet_int(void);

int x, y;

void *worker(void *arg)
{
    y = 3;
    return NULL;
}

int main()
{
    pthread_t t;
    pthread_create(&t, NULL, worker, NULL);
    int *p = __VERIFIER_nondet_int() ? &x : &y;
    *p = 1;
    int r = x;
    y = 2;
    pthread_join(t, NULL);
    assert(r == 1 || r == 0);
    return 0;
}
