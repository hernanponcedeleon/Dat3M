#include <stdlib.h>
#include <pthread.h>
#include <stdatomic.h>

extern void abort(void);
extern void __assert_fail(const char *, const char *, unsigned int, const char *) __attribute__ ((__nothrow__ , __leaf__)) __attribute__ ((__noreturn__));
void reach_error() { __assert_fail("0", "array-1.c", 3, "reach_error"); }

void __VERIFIER_assert(int cond) {
  if (!(cond)) {
    ERROR: {reach_error();abort();}
  }
  return;
}

typedef atomic_int lock_t;

lock_t my_lock;
int a = 0;

void lock_init(lock_t *lock){
    atomic_store_explicit(lock, 0, memory_order_seq_cst);
}

void lock_acquire(lock_t *lock){
    do {
        while(atomic_load_explicit(lock, memory_order_relaxed)) {}
    } while(atomic_exchange_explicit(lock, 1, memory_order_acquire));
}

void lock_release(lock_t *lock){
    atomic_store_explicit(lock, 0, memory_order_release);
}

void *thread_1(void *unused)
{
    lock_acquire(&my_lock);
    a++;
    lock_release(&my_lock);
    return NULL;
}

int main()
{
    lock_init(&my_lock);

    pthread_t t1, t2, t3;

    if (pthread_create(&t1, NULL, thread_1, NULL))
        abort();
    if (pthread_create(&t2, NULL, thread_1, NULL))
        abort();
    if (pthread_create(&t3, NULL, thread_1, NULL))
        abort();

    if (pthread_join(t1, NULL))
        abort();
    if (pthread_join(t2, NULL))
        abort();
    if (pthread_join(t3, NULL))
        abort();

    __VERIFIER_assert(a == 3);
    
    return 0;
}
