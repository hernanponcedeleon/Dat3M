#include <stdatomic.h>
#include <pthread.h>
#include <assert.h>
#include "spinlock.c"

#define CMPXCHG_LOOP(CODE, SUCCESS) do {                                    \
        struct lockref old;                                                 \
        old.lock_count = atomic_load(&lockref->lock_count);                 \
        while (old.lock.lock == 0) {                                        \
                struct lockref new = old;                                   \
                CODE                                                        \
                if (atomic_compare_exchange_strong(&lockref->lock_count,    \
                                            (int64_t *) &old.lock_count,    \
                                            new.lock_count)) {              \
                        SUCCESS;                                            \
                }                                                           \
        }                                                                   \
} while (0)

struct lockref {
    union {
        _Atomic(int64_t) lock_count;
        struct {
            spinlock_t lock;
            _Atomic(int32_t) count;
        };
    };
};

/**
 * lockref_get - Increments reference count unconditionally
 * @lockref: pointer to lockref structure
 *
 * This operation is only valid if you already hold a reference
 * to the object, so you know the count cannot be zero.
 */
void lockref_get(struct lockref *lockref)
{
        CMPXCHG_LOOP(
                new.count++;
        ,
                return;
        );

        spin_lock(&lockref->lock);
        lockref->count++;
        spin_unlock(&lockref->lock);
}

/**
 * lockref_put_return - Decrement reference count if possible
 * @lockref: pointer to lockref structure
 *
 * Decrement the reference count and return the new value.
 * If the lockref was dead or locked, return an error.
 */
int lockref_put_return(struct lockref *lockref)
{
        CMPXCHG_LOOP(
                new.count--;
                if (old.count <= 0)
                        return -1;
        ,
                return new.count;
        );
        return -1;
}