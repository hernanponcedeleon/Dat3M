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

#ifdef DV2WG
#define scope memory_scope_work_group
#else
#define scope memory_scope_device
#endif

static void lock(global atomic_uint* owner, global atomic_uint* next) {
    uint ticket = atomic_fetch_add_explicit(next, 1, memory_order_relaxed, scope);
    while (atomic_load_explicit(owner, mo_lock, scope) != ticket) {}
}

static void unlock(global atomic_uint* owner) {
    uint current = atomic_load_explicit(owner, memory_order_relaxed, scope);
    atomic_store_explicit(owner, current + 1, mo_unlock, scope);
}

__kernel void mutex_test(global atomic_uint* owner, global atomic_uint* next, global int* x, global int* A) {
    int a;
    lock(owner, next);
    a = *x;
    *x = a + 1;
    unlock(owner);
    A[get_global_id(0)] = a;
} 
