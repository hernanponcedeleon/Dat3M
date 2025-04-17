// clspv barrier-no-loop-3.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > barrier-no-loop-3.spv.dis

__kernel void test(global uint* x) {
    uint tid = get_global_id(0);
    x[tid] += tid;
    barrier(CLK_GLOBAL_MEM_FENCE);
    x[tid] += 1;
    barrier(CLK_GLOBAL_MEM_FENCE);
    x[tid] *= 2;
    barrier(CLK_GLOBAL_MEM_FENCE);
    x[tid] *= 3;
    barrier(CLK_GLOBAL_MEM_FENCE);
    x[tid] += 2;
    barrier(CLK_GLOBAL_MEM_FENCE);
    x[tid] *= 2;
    barrier(CLK_GLOBAL_MEM_FENCE);
    x[tid] *= 3;
}
