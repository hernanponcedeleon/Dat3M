// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment2.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment2.spvasm

struct aligned_struct {
    unsigned int e0 __attribute__ ((aligned (16)));
    unsigned int e1 __attribute__ ((aligned (16)));
};

kernel void test(global int *x) {

    local struct aligned_struct aligned;
    local unsigned int unaligned[2];

    *(&aligned.e0) = 1;
    *(&aligned.e0 + 4) = 2;
    *(unaligned) = 3;
    *(unaligned + 1) = 4;

    x[0] = aligned.e0;
    x[1] = aligned.e1;
    x[2] = unaligned[0];
    x[3] = unaligned[1];
}