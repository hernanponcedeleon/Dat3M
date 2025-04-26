// clspv barrier-loop-1.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > barrier-loop-1.spv.dis

__kernel void test(global uint* x) {
    uint tid = get_global_id(0);
    x[tid] = tid;
    for (uint i = 1; i <= 3; i++) {
        barrier(CLK_GLOBAL_MEM_FENCE);
        x[tid] += i;
    }
}
