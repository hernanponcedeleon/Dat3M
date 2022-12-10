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

struct ttaslock_s {
    atomic_int state;
};
typedef struct ttaslock_s ttaslock_t;

static inline void ttaslock_init(struct ttaslock_s *l)
{
    atomic_init(&l->state, 0);
}

static inline void await_for_lock(struct ttaslock_s *l)
{
    while (atomic_load_explicit(&l->state, memory_order_relaxed) != 0)
        ;
    return;
}

static inline int try_acquire(struct ttaslock_s *l)
{
    return atomic_exchange_explicit(&l->state, 1, mo_lock);
}

static inline void ttaslock_acquire(struct ttaslock_s *l)
{
    while (1) {
        await_for_lock(l);
        if (!try_acquire(l))
            return;
    }
}

static inline void ttaslock_release(struct ttaslock_s *l)
{
    atomic_store_explicit(&l->state, 0, mo_unlock);
}