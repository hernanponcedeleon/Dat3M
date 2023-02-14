#include "futex.h"
#include <stdatomic.h>

#ifdef ACQ2RX
#define mo_lock memory_order_relaxed
#else
#define mo_lock memory_order_acquire
#endif

#ifdef REL2RX
#define mo_unlock memory_order_relaxed
#else
#define mo_unlock memory_order_release
#endif

typedef atomic_int mutex_t;

static inline void mutex_init(mutex_t *m)
{
    atomic_init(m, 0);
}

static inline int mutex_lock_fastpath(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(m, &r, 1,
                               mo_lock,
                               mo_lock);
}

static inline int mutex_lock_try_acquire(mutex_t *m)
{
    int r = 0;
    return atomic_compare_exchange_strong_explicit(m, &r, 2,
                               memory_order_acquire,
                               memory_order_acquire);
}

static inline void mutex_lock(mutex_t *m)
{
    if (mutex_lock_fastpath(m))
        return;

    while (1) {
        int r = 1;
        atomic_compare_exchange_strong_explicit(m, &r, 2,
                            memory_order_relaxed,
                            memory_order_relaxed);
        __futex_wait(m, 2);
        if (mutex_lock_try_acquire(m))
            return;
    }
}

static inline int mutex_unlock_fastpath(mutex_t *m)
{
    int r = 1;
    return atomic_compare_exchange_strong_explicit(m, &r, 0,
                               mo_unlock,
                               mo_unlock);
}

static inline void mutex_unlock(mutex_t *m)
{
    if (mutex_unlock_fastpath(m))
        return;

    atomic_store_explicit(m, 0, memory_order_release);
    __futex_wake(m, 1);
}