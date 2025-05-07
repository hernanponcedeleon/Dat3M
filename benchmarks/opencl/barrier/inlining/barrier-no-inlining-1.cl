// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c barrier-no-inlining-1.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > barrier-no-inlining-1.spvasm

__kernel void test(global uint* x) {
    uint tid = get_group_id(0);
    barrier(CLK_GLOBAL_MEM_FENCE);
    if (get_local_id(0) == 0) {
        x[tid] += 1;
    }
    barrier(CLK_GLOBAL_MEM_FENCE);
    if (get_local_id(0) == 0) {
        x[tid] += 1;
    }
    barrier(CLK_GLOBAL_MEM_FENCE);
}

