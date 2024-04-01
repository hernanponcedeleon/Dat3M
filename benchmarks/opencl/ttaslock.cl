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
    while(1) {
        while (atomic_load_explicit(l, memory_order_relaxed) != 0) {}
        if(!atomic_exchange_explicit(l, 1, mo_lock)) {
            return;
        }
    }
}

static void unlock(global atomic_uint* l) {
    atomic_store_explicit(l, 0, mo_unlock);
}

__kernel void mutex_test(global atomic_uint* l, global uint* x, global atomic_uint* d) {
    lock(l);
    *x = *x + 1;
    unlock(l);
    atomic_fetch_add_explicit(d, 1, memory_order_relaxed);
} 
