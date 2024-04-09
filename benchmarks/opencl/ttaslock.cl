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
    while(1) {
        while (atomic_load_explicit(l, memory_order_relaxed, scope) != 0) {}
        if(!atomic_exchange_explicit(l, 1, mo_lock, scope)) {
            return;
        }
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
