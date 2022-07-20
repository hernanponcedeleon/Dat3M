#include <stdint.h>

typedef enum memory_order {
  memory_order_relaxed,
  memory_order_once,
  memory_order_acquire,
  memory_order_release,
  mb,
  wmb,
  rmb,
  rcu_lock,
  rcu_unlock,
  rcu_sync,
  before_atomic,
  after_atomic,
  after_spinlock,
} memory_order;

typedef enum operation {
  op_add,
  op_sub,
  op_and,
  op_or,
} operation;

extern int __LKMM_LOAD(int*, memory_order);
extern void __LKMM_STORE(int*, int, memory_order);
extern void __LKMM_FENCE(int);
extern int __LKMM_XCHG(int*, int, memory_order);
extern int __LKMM_CMPXCHG(int*, int, int, memory_order, memory_order);
extern void __LKMM_ATOMIC_OP(int*, int, operation);
extern int __LKMM_ATOMIC_FETCH_OP(int*, int, memory_order, operation);
extern int __LKMM_ATOMIC_OP_RETURN(int*, int, memory_order, operation);

/*******************************************************************************
 **                         ONCE, FENCES AND FRIENDS
 ******************************************************************************/

/* ONCE */
#define READ_ONCE(x)     __LKMM_LOAD(&x, memory_order_once)
#define WRITE_ONCE(x, v) __LKMM_STORE(&x, v, memory_order_once)

/* Fences */

#define barrier() __asm__ __volatile__ (""   : : : "memory")

#define smp_mb()  __LKMM_FENCE(mb)
#define smp_rmb() __LKMM_FENCE(rmb)
#define smp_wmb() __LKMM_FENCE(wmb)
#define smp_mb__before_atomic() __LKMM_FENCE(before_atomic)
#define smp_mb__after_atomic() __LKMM_FENCE(after_atomic)
#define smp_mb__after_spinlock() __LKMM_FENCE(after_spinlock)
#define smp_mb__after_unlock_lock() __LKMM_FENCE(after_unlock_lock)

/* Acquire/Release and friends */
#define smp_load_acquire(p)      __LKMM_LOAD(p, memory_order_acquire)
#define smp_store_release(p, v)  __LKMM_STORE(p, v, memory_order_release)
#define rcu_dereference(p)       READ_ONCE(p)
#define rcu_assign_pointer(p, v) smp_store_release(&(p), v)
#define smp_store_mb(x, v)                    \
do {                                \
    atomic_store_explicit(&x, v, memory_order_relaxed);    \
    smp_mb();                        \
} while (0)

/* Exchange */
#define xchg(p, v) __LKMM_XCHG(p, v, mb);
#define xchg_relaxed(p, v) __LKMM_XCHG(p, v, memory_order_relaxed)
#define xchg_release(p, v) __LKMM_XCHG(p, v, memory_order_release)
#define xchg_acquire(p, v) __LKMM_XCHG(p, v, memory_order_acquire)

#define cmpxchg(p, o, n) __LKMM_CMPXCHG(p, o, n, mb, mb)
#define cmpxchg_relaxed(p, o, n) __LKMM_CMPXCHG(p, o, n, memory_order_relaxed, memory_order_relaxed)
#define cmpxchg_acquire(p, o, n) __LKMM_CMPXCHG(p, o, n, memory_order_acquire, memory_order_acquire)
#define cmpxchg_release(p, o, n) __LKMM_CMPXCHG(p, o, n, memory_order_release, memory_order_release)

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
#define atomic_add(i, v) __LKMM_ATOMIC_OP(&(v)->counter, i, op_add)
#define atomic_sub(i, v) __LKMM_ATOMIC_OP(&(v)->counter, i, op_sub)
#define atomic_inc(v) __LKMM_ATOMIC_OP(&(v)->counter, 1, op_add)
#define atomic_dec(v) __LKMM_ATOMIC_OP(&(v)->counter, 1, op_sub)
#define atomic_and(i, v) __LKMM_ATOMIC_OP(&(v)->counter, i, op_and)
#define atomic_andnot(i, v) __LKMM_ATOMIC_OP(&(v)->counter, ~(i), op_and)
#define atomic_or(i, v) __LKMM_ATOMIC_OP(&(v)->counter, i, op_or)

/* Value-returning atomics */

#define atomic_fetch_add(i, v)  __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_add)
#define atomic_fetch_add_relaxed(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_relaxed, op_add)
#define atomic_fetch_add_acquire(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_acquire, op_add)
#define atomic_fetch_add_release(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_release, op_add)

#define atomic_fetch_inc(v)         atomic_fetch_add(1, v)
#define atomic_fetch_inc_relaxed(v) atomic_fetch_add_relaxed(1, v)
#define atomic_fetch_inc_acquire(v) atomic_fetch_add_acquire(1, v)
#define atomic_fetch_inc_release(v) atomic_fetch_add_release(1, v)

#define atomic_fetch_sub(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_sub)
#define atomic_fetch_sub_relaxed(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_relaxed, op_sub)
#define atomic_fetch_sub_acquire(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_acquire, op_sub)
#define atomic_fetch_sub_release(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_release, op_sub)

#define atomic_fetch_dec(v)         atomic_fetch_sub(1, v)
#define atomic_fetch_dec_relaxed(v) atomic_fetch_sub_relaxed(1, v)
#define atomic_fetch_dec_acquire(v) atomic_fetch_sub_acquire(1, v)
#define atomic_fetch_dec_release(v) atomic_fetch_sub_release(1, v)

#define atomic_fetch_and(i, v)  __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_and)
#define atomic_fetch_and_relaxed(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_relaxed, op_and)
#define atomic_fetch_and_acquire(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_acquire, op_and)
#define atomic_fetch_and_release(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_release, op_and)

#define atomic_fetch_andnot(i, v)  atomic_fetch_and(~(i), v)
#define atomic_fetch_andnot_relaxed(i, v) atomic_fetch_and_relaxed(~(i), v)
#define atomic_fetch_andnot_acquire(i, v) atomic_fetch_and_acquire(~(i), v)
#define atomic_fetch_andnot_release(i, v) atomic_fetch_and_release(~(i), v)

#define atomic_fetch_or(i, v)  __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, mb, op_or)
#define atomic_fetch_or_relaxed(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_relaxed, op_or)
#define atomic_fetch_or_acquire(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_acquire, op_or)
#define atomic_fetch_or_release(i, v) __LKMM_ATOMIC_FETCH_OP(&(v)->counter, i, memory_order_release, op_or)

#define atomic_add_return(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, mb, op_add)
#define atomic_add_return_relaxed(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, memory_order_relaxed, op_add)
#define atomic_add_return_acquire(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, memory_order_acquire, op_add)
#define atomic_add_return_release(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, memory_order_release, op_add)

#define atomic_inc_return(v)         atomic_add_return(1, v)
#define atomic_inc_return_relaxed(v) atomic_add_return_relaxed(1, v)
#define atomic_inc_return_acquire(v) atomic_add_return_acquire(1, v)
#define atomic_inc_return_release(v) atomic_add_return_release(1, v)

#define atomic_sub_return(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, mb, op_sub)
#define atomic_sub_return_relaxed(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, memory_order_relaxed, op_sub)
#define atomic_sub_return_acquire(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, memory_order_acquire, op_sub)
#define atomic_sub_return_release(i, v) __LKMM_ATOMIC_OP_RETURN(&(v)->counter, i, memory_order_release, op_sub)

#define atomic_dec_return(v)         atomic_sub_return(1, v)
#define atomic_dec_return_relaxed(v) atomic_sub_return_relaxed(1, v)
#define atomic_dec_return_acquire(v) atomic_sub_return_acquire(1, v)
#define atomic_dec_return_release(v) atomic_sub_return_release(1, v)

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

/*******************************************************************************
 **                               SPINLOCKS
 ******************************************************************************/

extern int __LKMM_SPIN_LOCK(int*);
extern int __LKMM_SPIN_UNLOCK(int*);

/* Spinlocks */
typedef struct spinlock {
    int unused;
} spinlock_t;

#define spin_lock(l)      __LKMM_SPIN_LOCK(l)
#define spin_unlock(l)    __LKMM_SPIN_UNLOCK(l)
