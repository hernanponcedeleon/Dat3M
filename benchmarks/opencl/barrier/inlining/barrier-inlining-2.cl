// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c barrier-inlining-2.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > barrier-inlining-2.spvasm

static void synchronized_increment(__global uint* shared_value, uint local_id) {
    barrier(CLK_GLOBAL_MEM_FENCE);
    if (local_id == 0) {
        (*shared_value)++;
    }
    barrier(CLK_GLOBAL_MEM_FENCE);
}

static void agent_function1(__global uint* shared_value, uint local_id) {
    synchronized_increment(shared_value, local_id);
}

static void agent_function2(__global uint* shared_value, uint local_id) {
    synchronized_increment(shared_value, local_id);
}

__kernel void test(__global uint* x) {
    uint tid = get_group_id(0);
    agent_function1(&x[tid], get_local_id(0));
    agent_function2(&x[tid], get_local_id(0));
}
