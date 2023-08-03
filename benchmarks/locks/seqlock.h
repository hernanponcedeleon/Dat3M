#include <stdatomic.h>
#include <assert.h>

struct seqlock_s {
    // Sequence for reader consistency check
    atomic_int seq;
    // It needs to be atomic to avoid data races
    atomic_int data;
};

typedef struct seqlock_s seqlock_t;

static inline void seqlock_init(struct seqlock_s *l)
{
    atomic_init(&l->seq, 0);
    atomic_init(&l->data, 0);
}

static inline int read(struct seqlock_s *l)
{
    while (1) {
        int old_seq = atomic_load_explicit(&l->seq, memory_order_acquire);
        if (old_seq % 2 == 1) {
            continue;
        }

        int res = atomic_load_explicit(&l->data, memory_order_acquire);
        if (atomic_load_explicit(&l->seq, memory_order_relaxed) == old_seq) {
            return res;
        }
    }
}

static inline void write(struct seqlock_s *l, int new_data)
{
    while (1) {
        // This might be a relaxed too
        int old_seq = atomic_load_explicit(&l->seq, memory_order_acquire);
        if (old_seq % 2 == 1)
            continue; // Retry

        // Should be relaxed!!!
        if (atomic_compare_exchange_strong_explicit(&l->seq, &old_seq, old_seq + 1, memory_order_relaxed, memory_order_relaxed))
            break;
    }

    // Update the data
    atomic_store_explicit(&l->data, new_data, memory_order_release);
    
    assert(atomic_load_explicit(&l->data, memory_order_relaxed) == new_data);

    atomic_fetch_add_explicit(&l->seq, 1, memory_order_release);
}