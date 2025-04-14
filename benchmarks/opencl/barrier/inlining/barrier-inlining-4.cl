// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c barrier-inlining-4.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > barrier-inlining-4.spv.dis

void synchronized_increment(__global uint* shared_value, uint local_id) {
    for (int i = 0; i < 2; i++) {
        barrier(CLK_GLOBAL_MEM_FENCE);
        if (local_id == 0) {
            (*shared_value)++;
        }
        barrier(CLK_GLOBAL_MEM_FENCE);
    }
}

__kernel void test(__global uint* x) {
    uint tid = get_group_id(0);
    synchronized_increment(&x[tid], get_local_id(0));
}
