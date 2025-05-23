// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment2-struct-global.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment2-struct-global.spvasm

typedef struct __attribute__ ((aligned (32))) {
    int a;
    int b;
    int c;
    int d;
    int e;
} aligned_t;

typedef struct {
    int a;
    int b;
    int c;
    int d;
    int e;
} unaligned_t;

global static aligned_t aligned[3];
global static unaligned_t unaligned[3];

__kernel void test(global int *r_aligned, global int* r_unaligned) {
    aligned[0].a = 0;
    aligned[0].b = 1;
    aligned[0].c = 2;
    aligned[0].d = 3;
    aligned[0].e = 4;

    aligned[1].a = 5;
    aligned[1].b = 6;
    aligned[1].c = 7;
    aligned[1].d = 8;
    aligned[1].e = 9;

    unaligned[0].a = 10;
    unaligned[0].b = 11;
    unaligned[0].c = 12;
    unaligned[0].d = 13;
    unaligned[0].e = 14;

    unaligned[1].a = 15;
    unaligned[1].b = 16;
    unaligned[1].c = 17;
    unaligned[1].d = 18;
    unaligned[1].e = 19;

    for (int i = 0; i < 16; i++) {
        r_aligned[i] = *(((int*) aligned) + i);
        r_unaligned[i] = *(((int*) unaligned) + i);
    }
}
