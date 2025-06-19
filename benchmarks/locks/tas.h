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

struct taslock_s {
    atomic_int state;
};
typedef struct taslock_s taslock_t;

static inline void taslock_init(struct taslock_s *l)
{
    atomic_init(&l->state, 0);
}

static inline void taslock_acquire(struct taslock_s *l)
{
    while (atomic_exchange_explicit(&l->state, 1, mo_lock));
}

static inline void taslock_release(struct taslock_s *l)
{
    atomic_store_explicit(&l->state, 0, mo_unlock);
}