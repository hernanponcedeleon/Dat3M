// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment1-struct-global.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment1-struct-global.spvasm

typedef struct __attribute__ ((aligned (16))) {
    int x;
    int y;
    int z;
} aligned_t;

typedef struct {
    int x;
    int y;
    int z;
} unaligned_t;

global static aligned_t aligned[3];
global static unaligned_t unaligned[3];

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    aligned[0].x = 0;
    aligned[0].y = 1;
    aligned[0].z = 2;

    aligned[1].x = 3;
    aligned[1].y = 4;
    aligned[1].z = 5;

    unaligned[0].x = 6;
    unaligned[0].y = 7;
    unaligned[0].z = 8;

    unaligned[1].x = 9;
    unaligned[1].y = 10;
    unaligned[1].z = 11;

    for (int i = 0; i < 8; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
