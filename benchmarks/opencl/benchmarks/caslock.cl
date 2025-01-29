// clspv caslock.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv

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

static void lock(global atomic_uint* l) {
    uint e = 0;
    while (atomic_compare_exchange_strong_explicit(l, &e, 1, mo_lock, mo_lock, scope) == 0) {
        e = 0;
    }
}

static void unlock(global atomic_uint* l) {
    atomic_store_explicit(l, 0, mo_unlock, scope);
}

__kernel void mutex_test(global atomic_uint* l, global int* x, global int* A) {
    int a;
    lock(l);
    a = *x;
    *x = a + 1;
    unlock(l);
    A[get_global_id(0)] = a;
}
