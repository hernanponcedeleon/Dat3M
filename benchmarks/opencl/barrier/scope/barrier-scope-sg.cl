// clspv barrier-scope-sg.cl --cl-std=CL2.0 --inline-entry-points --spv-version=1.6
// spirv-opt --upgrade-memory-model -o a.opt.spv a.spv
// spirv-dis a.opt.spv > barrier-scope-sg.spvasm

// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c barrier-scope-sg.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > barrier-scope-sg.spvasm

__kernel void test(global uint* x, global uint* y) {
    uint tid = get_global_id(0);
    if (tid == 0) {
        *x = 1;
    }
    sub_group_barrier(CLK_GLOBAL_MEM_FENCE);
    if (tid == 1) {
        *y = *x;
    }
}
