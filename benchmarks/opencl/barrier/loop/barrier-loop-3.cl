// clspv barrier-loop-3.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > barrier-loop-3.spv.dis

__kernel void test(global uint* x) {
    uint tid = get_global_id(0);
    x[tid] = tid;
    for (uint i = 1; i <= 2; i++) {
        barrier(CLK_GLOBAL_MEM_FENCE);
        x[tid] += i;
        for (uint j = 2; j <= 3; j++) {
            barrier(CLK_GLOBAL_MEM_FENCE);
            x[tid] *= j;
        }
    }
}
