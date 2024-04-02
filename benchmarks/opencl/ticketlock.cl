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

static void lock(global atomic_uint* owner, global atomic_uint* next) {
    uint ticket = atomic_fetch_add_explicit(next, 1, memory_order_relaxed);
    while (atomic_load_explicit(owner, mo_lock) != ticket) {}
}

static void unlock(global atomic_uint* owner) {
    uint current = atomic_load_explicit(owner, memory_order_relaxed); 
    atomic_store_explicit(owner, current + 1, mo_unlock);
}

__kernel void mutex_test(global atomic_uint* owner, global atomic_uint* next, global int* x, global int* A) {
    int a;
    lock(owner, next);
    a = *x;
    *x = a + 1;
    unlock(owner);
    A[get_local_id(0)] = a;
} 
