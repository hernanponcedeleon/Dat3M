#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>


#ifndef NTHREADS
#define NTHREADS 3
#endif

// ==========================================
//                   Spinlock
// ==========================================

struct spinlock_s {
        _Atomic(int32_t) lock;
};
typedef struct spinlock_s spinlock_t;

void await_for_lock(struct spinlock_s *l)
{
    while (atomic_load_explicit(&l->lock, memory_order_relaxed) != 0);
    return;
}

int try_get_lock(struct spinlock_s *l)
{
    int val = 0;
    return atomic_compare_exchange_strong_explicit(&l->lock, &val, 1, memory_order_acquire, memory_order_acquire);
}

void spin_lock(struct spinlock_s *l)
{
    do {
        await_for_lock(l);
    } while(!try_get_lock(l));
    return;
}

void spin_unlock(struct spinlock_s *l)
{
    atomic_store_explicit(&l->lock, 0, memory_order_release);
}

// ==========================================
//                   Lockref
// ==========================================

typedef struct {
    union {
        struct {
            atomic_int lock;
            int count;
        };
        atomic_long lock_count;
    };
} lockref_t;

void lockref_get(lockref_t *lockref) {
    long old_val = atomic_load_explicit(&lockref->lock_count, memory_order_relaxed);

    while (((lockref_t *)&old_val)->lock == 0) {
        long new_val = old_val;
        ((lockref_t *)&new_val)->count++;
        if (atomic_compare_exchange_strong_explicit(
                &lockref->lock_count, &old_val, new_val,
                memory_order_relaxed, memory_order_relaxed)) {
            return;
        }
    }

    spin_lock(&lockref->lock);
    lockref->count++;
    spin_unlock(&lockref->lock);
}

// ==========================================
//                     Main
// ==========================================

lockref_t my_lockref;

void *thread_n(void *unsued) {

    lockref_get(&my_lockref);

    return NULL;
}

int main() {

    pthread_t t[NTHREADS];

    atomic_store(&my_lockref.lock_count, 0);

    for (int i = 0; i < NTHREADS; i++)
        pthread_create(&t[i], 0, thread_n, (void *)(size_t)i);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], 0);

    assert(my_lockref.count == NTHREADS);
    return 0;
}