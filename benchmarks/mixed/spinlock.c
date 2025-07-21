#include <stdatomic.h>

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