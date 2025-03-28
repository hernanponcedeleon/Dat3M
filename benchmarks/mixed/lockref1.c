#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>

typedef struct {
    union {
        struct {
            atomic_int lock;
            int count;
        };
        atomic_long lock_count;
    };
} lockref_t;

void spin_lock(atomic_int *lock) {
    while (atomic_exchange_explicit(lock, 1, memory_order_acquire)) {}
}

void spin_unlock(atomic_int *lock) {
    atomic_store_explicit(lock, 0, memory_order_release);
}

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

lockref_t shared_lockref;

void *worker(void *unsued) {
    lockref_get(&shared_lockref);
    return NULL;
}

int main() {
    pthread_t t1, t2;

    atomic_store(&shared_lockref.lock_count, 0);

    pthread_create(&t1, NULL, worker, 0);
    pthread_create(&t2, NULL, worker, 0);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);

    assert(shared_lockref.count == 2);
    return 0;
}