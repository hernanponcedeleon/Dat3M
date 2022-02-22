#include <stdint.h>

typedef enum memory_order {
  memory_order_relaxed = __ATOMIC_RELAXED,
  memory_order_consume = __ATOMIC_CONSUME,
  memory_order_acquire = __ATOMIC_ACQUIRE,
  memory_order_release = __ATOMIC_RELEASE,
  memory_order_acq_rel = __ATOMIC_ACQ_REL,
  memory_order_seq_cst = __ATOMIC_SEQ_CST,
  memory_order_mb,
} memory_order;

/*******************************************************************************
 **                         ONCE, FENCES AND FRIENDS
 ******************************************************************************/

/* ONCE */
#define READ_ONCE(x)     __LKMM_READ_ONCE(&x)
#define WRITE_ONCE(x, v) __LKMM_WRITE_ONCE(&x, v)

/* atomic_signal_fence(memory_order_relaxed) is useless for barrier() */
#define barrier() __asm__ __volatile__ (""   : : : "memory")

/* Acquire/Release and friends */
#define smp_load_acquire(p)      __LKMM_load(p, memory_order_acquire)
#define smp_store_release(p, v)  __LKMM_store(p, v, memory_order_release)
#define rcu_dereference(p)       READ_ONCE(p)
#define rcu_assign_pointer(p, v) smp_store_release(&(p), v)
#define smp_store_mb(x, v)                    \
do {                                \
    atomic_store_explicit(&x, v, memory_order_relaxed);    \
    smp_mb();                        \
} while (0)

/* Exchange */
#define __xchg(p, v, m) __LKMM_xchg(p, v, m)
#define xchg(p, v) __xchg(p, v, memory_order_mb);
#define xchg_relaxed(p, v) __xchg(p, v, memory_order_relaxed)
#define xchg_release(p, v) __xchg(p, v, memory_order_release)
#define xchg_acquire(p, v) __xchg(p, v, memory_order_acquire)

#define __cmpxchg(p, o, n, s, f) __LKMM_cmpxchg(p, o, n, s, f)
#define cmpxchg(p, o, n) __cmpxchg(p, o, n, memory_order_mb, memory_order_mb)
#define cmpxchg_relaxed(p, o, n)                \
    __cmpxchg(p, o, n, memory_order_relaxed, memory_order_relaxed)
#define cmpxchg_acquire(p, o, n)                \
    __cmpxchg(p, o, n, memory_order_acquire, memory_order_acquire)
#define cmpxchg_release(p, o, n)                \
    __cmpxchg(p, o, n, memory_order_release, memory_order_release)

/*******************************************************************************
 **                            ATOMIC OPERATIONS
 ******************************************************************************/

/* Atomic data types */
typedef struct {
    int counter;
} atomic_t;

typedef struct {
    int64_t counter;
} atomic64_t;
typedef atomic64_t  atomic_long_t;

/* Initialization */
#define ATOMIC_INIT(i) { (i) }

/* Basic operations */
#define atomic_read(v)   READ_ONCE((v)->counter)
#define atomic_set(v, i) WRITE_ONCE(((v)->counter), (i))
#define atomic_read_acquire(v)   smp_load_acquire(&(v)->counter)
#define atomic_set_release(v, i) smp_store_release(&(v)->counter, (i))

/* Non-value-returning atomics */
#define __atomic_add(i, v, m) atomic_fetch_add_explicit(&(v)->counter, i, m)
#define __atomic_sub(i, v, m) atomic_fetch_sub_explicit(&(v)->counter, i, m)

#define atomic_add(i, v) __atomic_add(i, v, memory_order_relaxed)
#define atomic_sub(i, v) __atomic_sub(i, v, memory_order_relaxed)
#define atomic_inc(v) atomic_add(1, v)
#define atomic_dec(v) atomic_sub(1, v)

/* Value-returning atomics */
#define __atomic_fetch_add(i, v, m) atomic_fetch_add_explicit(&(v)->counter, i, m)
#define __atomic_fetch_sub(i, v, m) atomic_fetch_sub_explicit(&(v)->counter, i, m)
#define __atomic_add_return(i, v, m) __LKMM_atomic_add_return(&(v)->counter, i, m)
#define __atomic_sub_return(i, v, m) __LKMM_atomic_sub_return(&(v)->counter, i, m)

#define atomic_add_return(i, v) __atomic_add_return(i, v, memory_order_mb)
#define atomic_add_return_relaxed(i, v) __atomic_add_return(i, v, memory_order_relaxed)
#define atomic_add_return_acquire(i, v) __atomic_add_return(i, v, memory_order_acquire)
#define atomic_add_return_release(i, v) __atomic_add_return(i, v, memory_order_release)

#define atomic_fetch_add(i, v)                        \
({                                    \
    __typeof__((i)) _i_ = (i);                    \
    smp_mb__before_atomic();                    \
    _i_ = __atomic_fetch_add(i, v, memory_order_relaxed);        \
    smp_mb__after_atomic();                        \
    _i_;                                \
})
#define atomic_fetch_add_relaxed(i, v) __atomic_fetch_add(i, v, memory_order_relaxed)
#define atomic_fetch_add_acquire(i, v) __atomic_fetch_add(i, v, memory_order_acquire)
#define atomic_fetch_add_release(i, v) __atomic_fetch_add(i, v, memory_order_release)

#define atomic_inc_return(v)         atomic_add_return(1, v)
#define atomic_inc_return_relaxed(v) atomic_add_return_relaxed(1, v)
#define atomic_inc_return_acquire(v) atomic_add_return_acquire(1, v)
#define atomic_inc_return_release(v) atomic_add_return_release(1, v)
#define atomic_fetch_inc(v)         atomic_fetch_add(1, v)
#define atomic_fetch_inc_relaxed(v) atomic_fetch_add_relaxed(1, v)
#define atomic_fetch_inc_acquire(v) atomic_fetch_add_acquire(1, v)
#define atomic_fetch_inc_release(v) atomic_fetch_add_release(1, v)

#define atomic_sub_return(i, v) __atomic_sub_return(i, v, memory_order_mb)
#define atomic_sub_return_relaxed(i, v) __atomic_sub_return(i, v, memory_order_relaxed)
#define atomic_sub_return_acquire(i, v) __atomic_sub_return(i, v, memory_order_acquire)
#define atomic_sub_return_release(i, v) __atomic_sub_return(i, v, memory_order_release)

#define atomic_fetch_sub(i, v)                        \
({                                    \
    __typeof__((i)) _i_ = (i);                    \
    smp_mb__before_atomic();                    \
    _i_ = __atomic_fetch_sub(i, v, memory_order_relaxed);        \
    smp_mb__after_atomic();                        \
    _i_;                                \
})
#define atomic_fetch_sub_relaxed(i, v) __atomic_fetch_sub(i, v, memory_order_relaxed)
#define atomic_fetch_sub_acquire(i, v) __atomic_fetch_sub(i, v, memory_order_acquire)
#define atomic_fetch_sub_release(i, v) __atomic_fetch_sub(i, v, memory_order_release)

#define atomic_dec_return(v)         atomic_sub_return(1, v)
#define atomic_dec_return_relaxed(v) atomic_sub_return_relaxed(1, v)
#define atomic_dec_return_acquire(v) atomic_sub_return_acquire(1, v)
#define atomic_dec_return_release(v) atomic_sub_return_release(1, v)
#define atomic_fetch_dec(v)         atomic_fetch_sub(1, v)
#define atomic_fetch_dec_relaxed(v) atomic_fetch_sub_relaxed(1, v)
#define atomic_fetch_dec_acquire(v) atomic_fetch_sub_acquire(1, v)
#define atomic_fetch_dec_release(v) atomic_fetch_sub_release(1, v)

#define atomic_xchg(x, i)         xchg(&(x)->counter, i)
#define atomic_xchg_relaxed(x, i) xchg_relaxed(&(x)->counter, i)
#define atomic_xchg_release(x, i) xchg_release(&(x)->counter, i)
#define atomic_xchg_acquire(x, i) xchg_acquire(&(x)->counter, i)
#define atomic_cmpxchg(x, o, n)         cmpxchg(&(x)->counter, o, n)
#define atomic_cmpxchg_relaxed(x, o, n) cmpxchg_relaxed(&(x)->counter, o, n)
#define atomic_cmpxchg_acquire(x, o, n) cmpxchg_acquire(&(x)->counter, o, n)
#define atomic_cmpxchg_release(x, o, n) cmpxchg_release(&(x)->counter, o, n)

#define atomic_sub_and_test(i, v) (atomic_sub_return(i, v) == 0)
#define atomic_dec_and_test(v)    (atomic_dec_return(v) == 0)
#define atomic_inc_and_test(v)    (atomic_inc_return(v) == 0)
#define atomic_add_negative(i, v) (atomic_add_return(i, v) < 0)
