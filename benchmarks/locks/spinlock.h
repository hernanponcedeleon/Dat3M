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

struct spinlock_s {
    atomic_int lock;
};

typedef struct spinlock_s spinlock_t;

static inline void spinlock_init(struct spinlock_s *l)
{
    atomic_init(&l->lock, 0);
}

static inline void await_for_lock(struct spinlock_s *l)
{
    while (atomic_load_explicit(&l->lock, memory_order_relaxed) != 0)
        ;
    return;
}

static inline int try_get_lock(struct spinlock_s *l)
{
    int val = 0;
    return atomic_compare_exchange_strong_explicit(&l->lock, &val, 1,
                               mo_lock,
                               mo_lock);
}

static inline void spinlock_acquire(struct spinlock_s *l)
{
    do {
        await_for_lock(l);
    } while(!try_get_lock(l));
    return;
}

static inline int spinlock_tryacquire(struct spinlock_s *l)
{
    return try_get_lock(l);
}

static inline void spinlock_release(struct spinlock_s *l)
{
    atomic_store_explicit(&l->lock, 0, mo_unlock);
}