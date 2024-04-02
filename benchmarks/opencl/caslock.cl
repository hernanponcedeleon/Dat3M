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

static void lock(global atomic_uint* l) {
    uint e = 0;
    while (atomic_compare_exchange_strong_explicit(l, &e, 1, mo_lock, mo_lock) == 0) {
        e = 0;
    }
}

static void unlock(global atomic_uint* l) {
    atomic_store_explicit(l, 0, mo_unlock);
}

__kernel void mutex_test(global atomic_uint* l, global int* x, global int* A) {
    int a;
    lock(l);
    a = *x;
    *x = a + 1;
    unlock(l);
    A[get_local_id(0)] = a;
} 
