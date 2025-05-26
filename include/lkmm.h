#include <stdint.h>

typedef enum __LKMM_memory_order {
  __LKMM_once,
  __LKMM_acquire,
  __LKMM_release,
  __LKMM_mb,
  __LKMM_wmb,
  __LKMM_rmb,
  __LKMM_rcu_lock,
  __LKMM_rcu_unlock,
  __LKMM_rcu_sync,
  __LKMM_before_atomic,
  __LKMM_after_atomic,
  __LKMM_after_spinlock,
  __LKMM_barrier,
} __LKMM_memory_order;

typedef enum __LKMM_operation {
  __LKMM_op_add,
  __LKMM_op_sub,
  __LKMM_op_and,
  __LKMM_op_or,
} __LKMM_operation;

typedef typeof(sizeof(int)) __LKMM_size_t;
typedef intmax_t __LKMM_int_t;

/* Intrinsics defined by the verifier */
extern __LKMM_int_t __LKMM_load(const volatile void*, __LKMM_size_t, __LKMM_memory_order);
extern void __LKMM_store(volatile void*, __LKMM_size_t, __LKMM_int_t, __LKMM_memory_order);
extern __LKMM_int_t __LKMM_xchg(volatile void*, __LKMM_size_t, __LKMM_int_t, __LKMM_memory_order);
extern __LKMM_int_t __LKMM_cmpxchg(volatile void*, __LKMM_size_t, __LKMM_int_t, __LKMM_int_t, __LKMM_memory_order, __LKMM_memory_order);
extern void __LKMM_atomic_op(volatile void*, __LKMM_size_t, __LKMM_int_t, __LKMM_operation);
extern __LKMM_int_t __LKMM_atomic_op_return(volatile void*, __LKMM_size_t, __LKMM_int_t, __LKMM_memory_order, __LKMM_operation);
extern __LKMM_int_t __LKMM_atomic_fetch_op(volatile void*, __LKMM_size_t, __LKMM_int_t, __LKMM_memory_order, __LKMM_operation);
extern void __LKMM_fence(__LKMM_memory_order);

/* Converting macros being used below */
#define __LKMM_LOAD(p, mo) (typeof(*p))__LKMM_load(p, sizeof(*(p)), __LKMM_##mo)
#define __LKMM_STORE(p, v, mo) __LKMM_store(p, sizeof(*(p)), (__LKMM_int_t)(v), __LKMM_##mo)
#define __LKMM_XCHG(p, v, mo) (typeof(*p)) __LKMM_xchg(p, sizeof(*(p)), (__LKMM_int_t)(v), __LKMM_##mo)
#define __LKMM_CMPXCHG(p, c, v, mo0, mo1) (typeof(*p)) __LKMM_cmpxchg(p, sizeof(*(p)), (__LKMM_int_t)(c), (__LKMM_int_t)(v), __LKMM_##mo0, __LKMM_##mo1)
#define __LKMM_ATOMIC_OP(p, v, op) __LKMM_atomic_op(p, sizeof(*(p)), (__LKMM_int_t)(v), __LKMM_##op)
#define __LKMM_ATOMIC_OP_RETURN(p, v, mo, op) (typeof(*p)) __LKMM_atomic_op_return(p, sizeof(*(p)), (__LKMM_int_t)(v), __LKMM_##mo, __LKMM_##op)
#define __LKMM_ATOMIC_FETCH_OP(p, v, mo, op) (typeof(*p)) __LKMM_atomic_fetch_op(p, sizeof(*(p)), (__LKMM_int_t)(v), __LKMM_##mo, __LKMM_##op)
#define __LKMM_FENCE(mo) __LKMM_fence(__LKMM_##mo)

/*******************************************************************************
 **                         ONCE, FENCES AND FRIENDS
 ******************************************************************************/

/* ONCE */
#define READ_ONCE(x)     __LKMM_LOAD(&x, once)
#define WRITE_ONCE(x, v) __LKMM_STORE(&x, v, once)

/* Fences */

#define barrier() __LKMM_FENCE(barrier)

#define smp_mb()  __LKMM_FENCE(mb)
#define smp_rmb() __LKMM_FENCE(rmb)
#define smp_wmb() __LKMM_FENCE(wmb)
#define smp_mb__before_atomic() __LKMM_FENCE(before_atomic)
#define smp_mb__after_atomic() __LKMM_FENCE(after_atomic)
#define smp_mb__after_spinlock() __LKMM_FENCE(after_spinlock)
#define smp_mb__after_unlock_lock() __LKMM_FENCE(after_unlock_lock)

/* Acquire/Release and friends */
#define smp_load_acquire(p)      __LKMM_LOAD(p, acquire)
#define smp_store_release(p, v)  __LKMM_STORE(p, v, release)
#define rcu_dereference(p)       READ_ONCE(p)
#define rcu_assign_pointer(p, v) smp_store_release(&(p), v)
#define smp_store_mb(x, v)                    \
do {                                \
    WRITE_ONCE(x, v);    \
    smp_mb();                        \
} while (0)

/* Exchange */
#define xchg(p, v)                      __LKMM_XCHG(p, v, mb);
#define xchg_relaxed(p, v)              __LKMM_XCHG(p, v, once)
#define xchg_release(p, v)              __LKMM_XCHG(p, v, release)
#define xchg_acquire(p, v)              __LKMM_XCHG(p, v, acquire)

#define xchg_long(p, v)                 __LKMM_XCHG(p, v, mb);
#define xchg_long_relaxed(p, v)         __LKMM_XCHG(p, v, once)
#define xchg_long_release(p, v)         __LKMM_XCHG(p, v, release)
#define xchg_long_acquire(p, v)         __LKMM_XCHG(p, v, acquire)

#define cmpxchg(p, o, n)                __LKMM_CMPXCHG(p, o, n, mb, mb)
#define cmpxchg_relaxed(p, o, n)        __LKMM_CMPXCHG(p, o, n, once, once)
#define cmpxchg_acquire(p, o, n)        __LKMM_CMPXCHG(p, o, n, acquire, acquire)
#define cmpxchg_release(p, o, n)        __LKMM_CMPXCHG(p, o, n, release, release)

#define cmpxchg_long(p, o, n)           __LKMM_CMPXCHG(p, o, n, mb, mb)
#define cmpxchg_long_relaxed(p, o, n)   __LKMM_CMPXCHG(p, o, n, once, once)
#define cmpxchg_long_acquire(p, o, n)   __LKMM_CMPXCHG(p, o, n, acquire, acquire)
#define cmpxchg_long_release(p, o, n)   __LKMM_CMPXCHG(p, o, n, release, release)

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
#define atomic_read(v)                        READ_ONCE((v)->counter)
#define atomic_set(v, i)                      WRITE_ONCE(((v)->counter), (i))
#define atomic_read_acquire(v)                smp_load_acquire(&(v)->counter)
#define atomic_set_release(v, i)              smp_store_release(&(v)->counter, (i))

#define atomic_long_read(v)                   READ_ONCE((v)->counter)
#define atomic_long_set(v, i)                 WRITE_ONCE(((v)->counter), (i))
#define atomic_long_read_acquire(v)           smp_load_acquire(&(v)->counter)
#define atomic_long_set_release(v, i)         smp_store_release(&(v)->counter, (i))

/* Non-value-returning atomics */
#define atomic_add(i, v)                      __LKMM_ATOMIC_OP(&(v)->counter, i, op_add)
#define atomic_sub(i, v)                      __LKMM_ATOMIC_OP(&(v)->counter, i, op_sub)
#define atomic_inc(v)                         __LKMM_ATOMIC_OP(&(v)->counter, 1, op_add)
#define atomic_dec(v)                         __LKMM_ATOMIC_OP(&(v)->counter, 1, op_sub)
#define atomic_and(i, v)                      __LKMM_ATOMIC_OP(&(v)->counter, i, op_and)
#define atomic_andnot(i, v)                   __LKMM_ATOMIC_OP(&(v)->counter, ~(i), op_and)
#define atomic_or(i, v)                       __LKMM_ATOMIC_OP(&(v)->counter, i, op_or)

#define atomic_long_add(i, v)                 __LKMM_ATOMIC_OP(&(v)->counter, i, op_add)
#define atomic_long_sub(i, v)                 __LKMM_ATOMIC_OP(&(v)->counter, i, op_sub)
#define atomic_long_inc(v)                    __LKMM_ATOMIC_OP(&(v)->counter, 1, op_add)
#define atomic_long_dec(v)                    __LKMM_ATOMIC_OP(&(v)->counter, 1, op_sub)
#define atomic_long_and(i, v)                 __LKMM_ATOMIC_OP(&(v)->counter, i, op_and)
#define atomic_long_andnot(i, v)              __LKMM_ATOMIC_OP(&(v)->counter, ~(i), op_and)
#define atomic_long_or(i, v)                  __LKMM_ATOMIC_OP(&(v)->counter, i, op_or)

/* Value-returning atomics */

#define atomic_fetch_add(i, v)                __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_add)
#define atomic_fetch_add_relaxed(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_add)
#define atomic_fetch_add_acquire(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_add)
#define atomic_fetch_add_release(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_add)

#define atomic_long_fetch_add(i, v)           __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_add)
#define atomic_long_fetch_add_relaxed(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_add)
#define atomic_long_fetch_add_acquire(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_add)
#define atomic_long_fetch_add_release(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_add)

#define atomic_fetch_inc(v)                   atomic_fetch_add(1, v)
#define atomic_fetch_inc_relaxed(v)           atomic_fetch_add_relaxed(1, v)
#define atomic_fetch_inc_acquire(v)           atomic_fetch_add_acquire(1, v)
#define atomic_fetch_inc_release(v)           atomic_fetch_add_release(1, v)

#define atomic_long_fetch_inc(v)              atomic_long_fetch_add(1, v)
#define atomic_long_fetch_inc_relaxed(v)      atomic_long_fetch_add_relaxed(1, v)
#define atomic_long_fetch_inc_acquire(v)      atomic_long_fetch_add_acquire(1, v)
#define atomic_long_fetch_inc_release(v)      atomic_long_fetch_add_release(1, v)

#define atomic_fetch_sub(i, v)                __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_sub)
#define atomic_fetch_sub_relaxed(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_sub)
#define atomic_fetch_sub_acquire(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_sub)
#define atomic_fetch_sub_release(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_sub)

#define atomic_long_fetch_sub(i, v)           __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_sub)
#define atomic_long_fetch_sub_relaxed(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_sub)
#define atomic_long_fetch_sub_acquire(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_sub)
#define atomic_long_fetch_sub_release(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_sub)

#define atomic_fetch_dec(v)                   atomic_fetch_sub(1, v)
#define atomic_fetch_dec_relaxed(v)           atomic_fetch_sub_relaxed(1, v)
#define atomic_fetch_dec_acquire(v)           atomic_fetch_sub_acquire(1, v)
#define atomic_fetch_dec_release(v)           atomic_fetch_sub_release(1, v)

#define atomic_long_fetch_dec(v)              atomic_long_fetch_sub(1, v)
#define atomic_long_fetch_dec_relaxed(v)      atomic_long_fetch_sub_relaxed(1, v)
#define atomic_long_fetch_dec_acquire(v)      atomic_long_fetch_sub_acquire(1, v)
#define atomic_long_fetch_dec_release(v)      atomic_long_fetch_sub_release(1, v)

#define atomic_fetch_and(i, v)                __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_and)
#define atomic_fetch_and_relaxed(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_and)
#define atomic_fetch_and_acquire(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_and)
#define atomic_fetch_and_release(i, v)        __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_and)

#define atomic_long_fetch_and(i, v)           __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_and)
#define atomic_long_fetch_and_relaxed(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_and)
#define atomic_long_fetch_and_acquire(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_and)
#define atomic_long_fetch_and_release(i, v)   __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_and)

#define atomic_fetch_andnot(i, v)             atomic_fetch_and(~(i), v)
#define atomic_fetch_andnot_relaxed(i, v)     atomic_fetch_and_relaxed(~(i), v)
#define atomic_fetch_andnot_acquire(i, v)     atomic_fetch_and_acquire(~(i), v)
#define atomic_fetch_andnot_release(i, v)     atomic_fetch_and_release(~(i), v)

#define atomic_long_fetch_andnot(i, v)          atomic_long_fetch_and(~(i), v)
#define atomic_long_fetch_andnot_relaxed(i, v)  atomic_long_fetch_and_relaxed(~(i), v)
#define atomic_long_fetch_andnot_acquire(i, v)  atomic_long_fetch_and_acquire(~(i), v)
#define atomic_long_fetch_andnot_release(i, v)  atomic_long_fetch_and_release(~(i), v)

#define atomic_fetch_or(i, v)                 __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_or)
#define atomic_fetch_or_relaxed(i, v)         __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_or)
#define atomic_fetch_or_acquire(i, v)         __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_or)
#define atomic_fetch_or_release(i, v)         __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_or)

#define atomic_long_fetch_or(i, v)            __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_or)
#define atomic_long_fetch_or_relaxed(i, v)    __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, once, op_or)
#define atomic_long_fetch_or_acquire(i, v)    __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, acquire, op_or)
#define atomic_long_fetch_or_release(i, v)    __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, release, op_or)

#define atomic_add_return(i, v)               __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, mb, op_add)
#define atomic_add_return_relaxed(i, v)       __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, once, op_add)
#define atomic_add_return_acquire(i, v)       __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, acquire, op_add)
#define atomic_add_return_release(i, v)       __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, release, op_add)

#define atomic_inc_return(v)                  atomic_add_return(1, v)
#define atomic_inc_return_relaxed(v)          atomic_add_return_relaxed(1, v)
#define atomic_inc_return_acquire(v)          atomic_add_return_acquire(1, v)
#define atomic_inc_return_release(v)          atomic_add_return_release(1, v)

#define atomic_long_inc_return(v)             atomic_long_add_return(1, v)
#define atomic_long_inc_return_relaxed(v)     atomic_long_add_return_relaxed(1, v)
#define atomic_long_inc_return_acquire(v)     atomic_long_add_return_acquire(1, v)
#define atomic_long_inc_return_release(v)     atomic_long_add_return_release(1, v)

#define atomic_sub_return(i, v)               __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, mb, op_sub)
#define atomic_sub_return_relaxed(i, v)       __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, once, op_sub)
#define atomic_sub_return_acquire(i, v)       __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, acquire, op_sub)
#define atomic_sub_return_release(i, v)       __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, release, op_sub)

#define atomic_long_sub_return(i, v)          __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, mb, op_sub)
#define atomic_long_sub_return_relaxed(i, v)  __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, once, op_sub)
#define atomic_long_sub_return_acquire(i, v)  __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, acquire, op_sub)
#define atomic_long_sub_return_release(i, v)  __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, release, op_sub)

#define atomic_dec_return(v)                  atomic_sub_return(1, v)
#define atomic_dec_return_relaxed(v)          atomic_sub_return_relaxed(1, v)
#define atomic_dec_return_acquire(v)          atomic_sub_return_acquire(1, v)
#define atomic_dec_return_release(v)          atomic_sub_return_release(1, v)

#define atomic_long_dec_return(v)             atomic_long_sub_return(1, v)
#define atomic_long_dec_return_relaxed(v)     atomic_long_sub_return_relaxed(1, v)
#define atomic_long_dec_return_acquire(v)     atomic_long_sub_return_acquire(1, v)
#define atomic_long_dec_return_release(v)     atomic_long_sub_return_release(1, v)

#define atomic_xchg(x, i)                     xchg(&(x)->counter, i)
#define atomic_xchg_relaxed(x, i)             xchg_relaxed(&(x)->counter, i)
#define atomic_xchg_release(x, i)             xchg_release(&(x)->counter, i)
#define atomic_xchg_acquire(x, i)             xchg_acquire(&(x)->counter, i)

#define atomic_long_xchg(x, i)                xchg_long(&(x)->counter, i)
#define atomic_long_xchg_relaxed(x, i)        xchg_long_relaxed(&(x)->counter, i)
#define atomic_long_xchg_release(x, i)        xchg_long_release(&(x)->counter, i)
#define atomic_long_xchg_acquire(x, i)        xchg_long_acquire(&(x)->counter, i)

#define atomic_cmpxchg(x, o, n)               cmpxchg(&(x)->counter, o, n)
#define atomic_cmpxchg_relaxed(x, o, n)       cmpxchg_relaxed(&(x)->counter, o, n)
#define atomic_cmpxchg_acquire(x, o, n)       cmpxchg_acquire(&(x)->counter, o, n)
#define atomic_cmpxchg_release(x, o, n)       cmpxchg_release(&(x)->counter, o, n)

#define atomic_long_cmpxchg(x, o, n)          cmpxchg_long(&(x)->counter, o, n)
#define atomic_long_cmpxchg_relaxed(x, o, n)  cmpxchg_long_relaxed(&(x)->counter, o, n)
#define atomic_long_cmpxchg_acquire(x, o, n)  cmpxchg_long_acquire(&(x)->counter, o, n)
#define atomic_long_cmpxchg_release(x, o, n)  cmpxchg_long_release(&(x)->counter, o, n)

#define atomic_sub_and_test(i, v)             (atomic_sub_return(i, v) == 0)
#define atomic_dec_and_test(v)                (atomic_dec_return(v) == 0)
#define atomic_inc_and_test(v)                (atomic_inc_return(v) == 0)
#define atomic_add_negative(i, v)             (atomic_add_return(i, v) < 0)

#define atomic_long_sub_and_test(i, v)        (atomic_long_sub_return(i, v) == 0)
#define atomic_long_dec_and_test(v)           (atomic_long_dec_return(v) == 0)
#define atomic_long_inc_and_test(v)           (atomic_long_inc_return(v) == 0)
#define atomic_long_add_negative(i, v)        (atomic_long_add_return(i, v) < 0)

/*******************************************************************************
 **                               SPINLOCKS
 ******************************************************************************/

/* Spinlocks */
typedef struct spinlock {
    int unused;
} spinlock_t;

extern int __LKMM_SPIN_LOCK(spinlock_t*);
extern int __LKMM_SPIN_UNLOCK(spinlock_t*);

#define spin_lock(l)      __LKMM_SPIN_LOCK(l)
#define spin_unlock(l)    __LKMM_SPIN_UNLOCK(l)
