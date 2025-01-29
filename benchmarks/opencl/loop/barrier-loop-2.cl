// clspv barrier-loop-2.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-dis a.spv > barrier-loop-2.spv.dis

__kernel void test(global uint* x) {
    uint tid = get_global_id(0);
    uint gid = get_group_id(0);
    for (uint i = 0; i < 2; i++) {
        if (i % 2 == gid) {
            barrier(CLK_GLOBAL_MEM_FENCE);
            x[tid] = tid + i;
        }
    }
}
