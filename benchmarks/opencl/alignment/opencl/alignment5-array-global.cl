// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -fno-discard-value-names -cl-opt-disable -emit-llvm -c alignment5-array-global.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment5-array-global.spvasm

typedef int aligned_sub_t __attribute__((vector_size(3 * sizeof(int))));
typedef aligned_sub_t aligned_t[3] __attribute__((aligned(64)));

typedef int unaligned_sub_t[3];
typedef unaligned_sub_t unaligned_t[3];

//global aligned_t aligned[3];
//global unaligned_t unaligned[3];

__kernel void test(global int *r_aligned, global int* r_unaligned, global aligned_t* aligned, global unaligned_t* unaligned) {
    aligned[0][0][0] = 0;
    aligned[0][0][1] = 1;
    aligned[0][0][2] = 2;
    aligned[0][1][0] = 3;
    aligned[0][1][1] = 4;
    aligned[0][1][2] = 5;
    aligned[0][2][0] = 6;
    aligned[0][2][1] = 7;
    aligned[0][2][2] = 8;

    aligned[1][0][0] = 9;
    aligned[1][0][1] = 10;
    aligned[1][0][2] = 11;
    aligned[1][1][0] = 12;
    aligned[1][1][1] = 13;
    aligned[1][1][2] = 14;
    aligned[1][2][0] = 15;
    aligned[1][2][1] = 16;
    aligned[1][2][2] = 17;

    unaligned[0][0][0] = 18;
    unaligned[0][0][1] = 19;
    unaligned[0][0][2] = 20;
    unaligned[0][1][0] = 21;
    unaligned[0][1][1] = 22;
    unaligned[0][1][2] = 23;
    unaligned[0][2][0] = 24;
    unaligned[0][2][1] = 25;
    unaligned[0][2][2] = 26;

    unaligned[1][0][0] = 27;
    unaligned[1][0][1] = 28;
    unaligned[1][0][2] = 29;
    unaligned[1][1][0] = 30;
    unaligned[1][1][1] = 31;
    unaligned[1][1][2] = 32;
    unaligned[1][2][0] = 33;
    unaligned[1][2][1] = 34;
    unaligned[1][2][2] = 35;

    for (int i = 0; i < 64; i++) {
        r_aligned[i] = *(((global int*) aligned) + i);
        r_unaligned[i] = *(((global int*) unaligned) + i);
    }
}
