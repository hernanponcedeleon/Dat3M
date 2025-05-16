// TODO: Crashes llvm-spirv

// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment2-array-local.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment2-array-local.spvasm

typedef int aligned_t __attribute__((vector_size(5 * sizeof(int))));
typedef int unaligned_t[5];

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    local aligned_t aligned[3];
    local unaligned_t unaligned[3];

    aligned[0][0] = 0;
    aligned[0][1] = 1;
    aligned[0][2] = 2;
    aligned[0][3] = 3;
    aligned[0][4] = 4;

    aligned[1][0] = 5;
    aligned[1][1] = 6;
    aligned[1][2] = 7;
    aligned[1][3] = 8;
    aligned[1][4] = 9;

    unaligned[0][0] = 10;
    unaligned[0][1] = 11;
    unaligned[0][2] = 12;
    unaligned[0][3] = 13;
    unaligned[0][4] = 14;

    unaligned[1][0] = 15;
    unaligned[1][1] = 16;
    unaligned[1][2] = 17;
    unaligned[1][3] = 18;
    unaligned[1][4] = 19;

    for (int i = 0; i < 16; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
