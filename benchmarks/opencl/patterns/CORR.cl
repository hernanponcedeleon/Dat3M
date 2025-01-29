// clspv CORR.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv

__kernel void test(global atomic_uint* x, global uint* r0, global uint* r1, global uint* r2, global uint* r3) {
    if (get_group_id(0) == 0) {
        *r0 = atomic_load_explicit(x, memory_order_relaxed);
        *r1 = atomic_load_explicit(x, memory_order_relaxed);
    }
    if(get_group_id(0) == 1) {
        *r2 = atomic_load_explicit(x, memory_order_relaxed);
        *r3 = atomic_load_explicit(x, memory_order_relaxed);
    }
    if(get_group_id(0) == 2) {
        atomic_store_explicit(x, 2, memory_order_relaxed);
    }
    if(get_group_id(0) == 3) {
        atomic_store_explicit(x, 1, memory_order_relaxed);
    }
} 
