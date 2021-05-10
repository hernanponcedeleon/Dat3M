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

typedef struct rte_mcslock {
    struct rte_mcslock *next;
    int locked; /* 1 if the queue locked, 0 otherwise */
} rte_mcslock_t;

rte_mcslock_t global_lock;
rte_mcslock_t* global_lock_p;
int a = 0;

void rte_mcslock_lock(rte_mcslock_t** msl, rte_mcslock_t* me) {
    
    rte_mcslock_t *prev;

    /* Init me node */
    atomic_store_explicit(&me->locked, 1, memory_order_relaxed);
    atomic_store_explicit(&me->next, NULL, memory_order_relaxed);

    /* If the queue is empty, the exchange operation is enough to acquire
     * the lock. Hence, the exchange operation requires acquire semantics.
     * The store to me->next above should complete before the node is
     * visible to other CPUs/threads. Hence, the exchange operation requires
     * release semantics as well.
     */
    prev = atomic_exchange_explicit(msl, me, memory_order_relaxed);
    if (prev == NULL) {
        return;
    }

    /* The store to me->next above should also complete before the node is
     * visible to predecessor thread releasing the lock. Hence, the store
     * prev->next also requires release semantics. Note that, for example,
     * on ARM, the release semantics in the exchange operation is not
     * strong as a release fence and is not sufficient to enforce the
     * desired order here.
     */
    atomic_store_explicit(&prev->next, me, memory_order_relaxed);

    /* The while-load of me->locked should not move above the previous
     * store to prev->next. Otherwise it will cause a deadlock. Need a
     * store-load barrier.
     */
    atomic_thread_fence(memory_order_relaxed);

    /* If the lock has already been acquired, it first atomically
     * places the node at the end of the queue and then proceeds
     * to spin on me->locked until the previous lock holder resets
     * the me->locked using mcslock_unlock().
     */
    while (atomic_load_explicit(&me->locked, memory_order_relaxed));
}

void rte_mcslock_unlock(rte_mcslock_t** msl, rte_mcslock_t* me) {
    if (atomic_load_explicit(&me->next, memory_order_relaxed) == NULL) {
        // **ignore this branch**
    }
    /* Pass lock to next waiter. */
    atomic_store_explicit(&me->next->locked, 0, memory_order_relaxed);
}

void *thread_1(void *unused)
{
    rte_mcslock_t self_lock;
    rte_mcslock_lock(&global_lock_p, &self_lock);
    a++;
    rte_mcslock_unlock(&global_lock_p, &self_lock);
    return NULL;
}

int main()
{

    global_lock_p = &global_lock;
    
    pthread_t t1, t2, t3;

    pthread_create(&t1, NULL, thread_1, NULL);
    pthread_create(&t2, NULL, thread_1, NULL);
    pthread_create(&t3, NULL, thread_1, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);

    __VERIFIER_assert(a == 3);
    
    return 0;
}
