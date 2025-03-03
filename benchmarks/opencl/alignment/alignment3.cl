// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment3.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment3.spvasm

struct aligned_struct {
    unsigned int e0[3] __attribute__ ((aligned (16)));
    unsigned int e1[3] __attribute__ ((aligned (16)));
};

kernel void test(global int *x) {

    local struct aligned_struct aligned;
    local unsigned int unaligned[2][3];

    aligned.e0[0] = 0;
    aligned.e0[1] = 1;
    aligned.e0[2] = 2;
    aligned.e1[0] = 4;
    aligned.e1[1] = 5;
    aligned.e1[2] = 6;

    unaligned[0][0] = 10;
    unaligned[0][1] = 11;
    unaligned[0][2] = 12;
    unaligned[1][0] = 13;
    unaligned[1][1] = 14;
    unaligned[1][2] = 15;

    x[0] = aligned.e0[0];
    x[1] = aligned.e0[1];
    x[2] = aligned.e0[2];
    x[3] = aligned.e1[0];
    x[4] = aligned.e1[1];
    x[5] = aligned.e1[2];

    x[6] = unaligned[0][0];
    x[7] = unaligned[0][1];
    x[8] = unaligned[0][2];
    x[9] = unaligned[1][0];
    x[10] = unaligned[1][1];
    x[11] = unaligned[1][2];
}