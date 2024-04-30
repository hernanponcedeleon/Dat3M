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
// VMM does not preserve certain dependencies, thus we need stronger
// orderings than for other models like ARM8, RISCV and IMM
#ifdef VMM
#define mo_read_lock memory_order_acquire
#define mo_write_lock memory_order_acquire
#else
#define mo_read_lock memory_order_relaxed
#define mo_write_lock memory_order_relaxed
#endif

#define RW_LOCK_BIAS            0x00100000

typedef union {
    atomic_int lock;
} rwlock_t;

static inline int read_can_lock(rwlock_t *lock)
{
    return atomic_load_explicit(&lock->lock, memory_order_relaxed) > 0;
}

static inline int write_can_lock(rwlock_t *lock)
{
    return atomic_load_explicit(&lock->lock, memory_order_relaxed) == RW_LOCK_BIAS;
}

static inline void read_lock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, 1, mo_lock);
    while (priorvalue <= 0) {
        atomic_fetch_add_explicit(&rw->lock, 1, mo_read_lock);
        while (atomic_load_explicit(&rw->lock, memory_order_relaxed) <= 0);
        priorvalue = atomic_fetch_sub_explicit(&rw->lock, 1, memory_order_acquire);
    }
}

static inline void write_lock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_acquire);
    while (priorvalue != RW_LOCK_BIAS) {
        atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS, mo_write_lock);
        while (atomic_load_explicit(&rw->lock, memory_order_relaxed) != RW_LOCK_BIAS);
        priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_acquire);
    }
}

static inline int read_trylock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, 1, memory_order_acquire);
    if (priorvalue > 0)
        return 1;

    atomic_fetch_add_explicit(&rw->lock, 1, memory_order_relaxed);
    return 0;
}

static inline int write_trylock(rwlock_t *rw)
{
    int priorvalue = atomic_fetch_sub_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_acquire);
    if (priorvalue == RW_LOCK_BIAS)
        return 1;

    atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS, memory_order_relaxed);
    return 0;
}

static inline void read_unlock(rwlock_t *rw)
{
    atomic_fetch_add_explicit(&rw->lock, 1, memory_order_release);
}

static inline void write_unlock(rwlock_t *rw)
{
    atomic_fetch_add_explicit(&rw->lock, RW_LOCK_BIAS, mo_unlock);
}
