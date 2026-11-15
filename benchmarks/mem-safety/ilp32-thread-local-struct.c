/*
    On ILP32, the data layout aligns long long to 4 bytes, so struct S has 12 bytes (the natural layout has 16).
    Thread-local copies of s must keep the size of the original object.

    Expected verdicts:
      default: true
      -DFAIL:  false (byte 12 is out of bounds)
*/

typedef unsigned long pthread_t;
extern int pthread_create(pthread_t *thread, const void *attr, void *(*start)(void *), void *arg);
extern int pthread_join(pthread_t thread, void **ret);

struct S {
    long long b;
    int a;
};

__thread struct S s;

#ifdef FAIL
volatile int idx = 12;
#else
volatile int idx = 11;
#endif

void *worker(void *arg) {
    ((char *)&s)[idx] = 1;
    return 0;
}

int main(void) {
    pthread_t t;
    pthread_create(&t, 0, worker, 0);
    pthread_join(t, 0);
    return 0;
}
