// clspv barrier-no-loop-4.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > barrier-no-loop-4.spv.dis

__kernel void test(global atomic_uint* x, global uint* r0) {
    uint tid = get_global_id(0);

    atomic_store_explicit(&(x[tid]), 1, memory_order_release);
    barrier(CLK_GLOBAL_MEM_FENCE);
    r0[tid] = atomic_load_explicit(&(x[1 - tid]), memory_order_acquire);

    atomic_store_explicit(&(x[tid + 2]), 1, memory_order_release);
    barrier(CLK_GLOBAL_MEM_FENCE);
    r0[2 + tid] = atomic_load_explicit(&(x[3 - tid]), memory_order_acquire);
}
