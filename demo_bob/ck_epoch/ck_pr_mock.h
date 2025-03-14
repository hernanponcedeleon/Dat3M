#include <stdatomic.h>

/*
    NOTE: All atomic operations are relaxed.
    Fences must be explicitly placed to obtain stronger ordering.
*/

#define ck_pr_cas_ptr(PTR, EXP, TARGET) ({typeof(EXP) A = EXP; atomic_compare_exchange_strong_explicit(PTR, &A, TARGET, memory_order_relaxed, memory_order_relaxed);})
#define ck_pr_cas_ptr_value(PTR, EXP, TARGET, EXP_ADR) atomic_compare_exchange_strong_explicit(PTR, &EXP, TARGET, memory_order_relaxed, memory_order_relaxed)
#define ck_pr_cas_uint(PTR, EXP, TARGET) ({unsigned A = EXP; atomic_compare_exchange_strong_explicit(PTR, &A, TARGET, memory_order_relaxed, memory_order_relaxed);})
#define ck_pr_cas_uint_value(PTR, EXP, TARGET, EXP_ADR) atomic_compare_exchange_strong_explicit(PTR, &EXP, TARGET, memory_order_relaxed, memory_order_relaxed)
#define ck_pr_fas_ptr(PTR, VAL) atomic_exchange_explicit(PTR, VAL, memory_order_relaxed)
#define ck_pr_fas_uint(PTR, VAL) atomic_exchange_explicit(PTR, VAL, memory_order_relaxed)

#define ck_pr_load_ptr(ADR) atomic_load_explicit(ADR, memory_order_relaxed)
#define ck_pr_load_uint(ADR) atomic_load_explicit(ADR, memory_order_relaxed)

#define ck_pr_store_uint(ADR, VAL) atomic_store_explicit(ADR, VAL, memory_order_relaxed)
#define ck_pr_store_ptr(ADR, VAL) atomic_store_explicit(ADR, VAL, memory_order_relaxed)

#define ck_pr_add_uint(ADR, VAL) atomic_fetch_add_explicit(ADR, VAL, memory_order_relaxed)
#define ck_pr_sub_uint(ADR, VAL) atomic_fetch_add_explicit(ADR, -VAL, memory_order_relaxed)

#define ck_pr_dec_uint(ADR) atomic_fetch_add_explicit(ADR, -1, memory_order_relaxed)
#define ck_pr_inc_uint(ADR) atomic_fetch_add_explicit(ADR, 1, memory_order_relaxed)

#define ck_pr_fence_store() atomic_thread_fence(memory_order_release)
#define ck_pr_fence_store_atomic() atomic_thread_fence(memory_order_release)
#define ck_pr_fence_release() atomic_thread_fence(memory_order_release)
#define ck_pr_fence_load() atomic_thread_fence(memory_order_acquire)
#define ck_pr_fence_atomic_load() atomic_thread_fence(memory_order_acquire)
#define ck_pr_fence_acqrel() atomic_thread_fence(memory_order_acq_rel)
#define ck_pr_fence_memory() atomic_thread_fence(memory_order_seq_cst)


#define	ck_pr_stall() {}

