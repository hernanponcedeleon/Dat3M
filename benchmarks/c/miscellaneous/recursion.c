#include <assert.h>
#include <pthread.h>
#include <stdatomic.h>
int fib(int);
int fibonacci(int n)
{
    return n == 0 ? 1 : n == 1 ? 1 : fib(n - 1) + fibonacci(n - 2);
}
int fib(int n)
{
    return fibonacci(n);
}
// known values: ack(0,0) == 1, ack(1,1) == 3, ack(2,2) == 7, ack(3,3) == 61
int ack(int,int);
int ackermann(int m, int n)
{
    return m == 0 ? n + 1 : n == 0 ? ack(m - 1, 1) : ack(m - 1, ack(m, n - 1));
}
int ack(int m, int n)
{
    return ackermann(m, n);
}
int fun(int n)
{
#if defined(ACKERMANN_LARGE) || defined(ACKERMANN_SMALL)
    return ackermann(n, n);
#else
    return fibonacci(n);
#endif
}
atomic_int x;
void* worker(void* p)
{
    (void) p;
    int n = atomic_load_explicit(&x, memory_order_relaxed);
    int a = fun(n);
    atomic_store_explicit(&x, a, memory_order_relaxed);
    return NULL;
}
int main()
{
    pthread_t t0;
#ifdef ACKERMANN_LARGE
    atomic_init(&x, 1);
#else
#ifdef ACKERMANN_SMALL
    atomic_init(&x, 0);
#else//fib(fib(2)) == 2
    atomic_init(&x, 2);
#endif
#endif
    pthread_create(&t0, NULL, worker, NULL);
    int n = atomic_load_explicit(&x, memory_order_relaxed);
    int a = fun(n);
    atomic_store_explicit(&x, a, memory_order_relaxed);
    int result = atomic_load_explicit(&x, memory_order_relaxed);
    pthread_join(t0, NULL);
#ifdef ACKERMANN_LARGE
    //ack(ack(1,1),ack(1,1)) needs a recursion bound of 64.
    assert(result == 3 || result == 61);
#else
#ifdef ACKERMANN_SMALL
    //ack(ack(0,0),ack(0,0)) needs recursion bound of 4 and mem2reg after unrolling to be feasible.
    assert(result == 1 || result == 3);
#else
    assert(result == 2);
#endif
#endif
    return 0;
}