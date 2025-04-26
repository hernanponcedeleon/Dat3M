// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c barrier-inlining-3.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > barrier-inlining-3.spv.dis

void synchronized_increment(__global uint* shared_value, uint local_id) {
    barrier(CLK_GLOBAL_MEM_FENCE);
    if (local_id == 0) {
        (*shared_value)++;
    }
    barrier(CLK_GLOBAL_MEM_FENCE);
}

void agent_function1(__global uint* shared_value, uint local_id) {
    synchronized_increment(shared_value, local_id);
}

void agent_function2(__global uint* shared_value, uint local_id) {
    agent_function1(shared_value, local_id);
}

__kernel void test(__global uint* x) {
    uint tid = get_group_id(0);
    agent_function2(&x[tid], get_local_id(0));
    agent_function2(&x[tid], get_local_id(0));
}
