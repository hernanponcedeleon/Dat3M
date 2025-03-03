// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment4.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment4.spvasm

struct aligned_struct {
    unsigned int e0[3] __attribute__ ((aligned (16)));
    unsigned int e1[3] __attribute__ ((aligned (16)));
};

struct nested_aligned_struct {
    struct aligned_struct as0[3] __attribute__ ((aligned (64)));
    struct aligned_struct as1[3] __attribute__ ((aligned (64)));
};

kernel void test(global int *x) {
    local struct nested_aligned_struct nested_aligned;
    local unsigned int unaligned[2][2][3];

    nested_aligned.as0[0].e0[0] = 0;
    nested_aligned.as0[0].e0[1] = 1;
    nested_aligned.as0[0].e0[2] = 2;
    nested_aligned.as0[0].e1[0] = 3;
    nested_aligned.as0[0].e1[1] = 4;
    nested_aligned.as0[0].e1[2] = 5;
    nested_aligned.as0[1].e0[0] = 6;
    nested_aligned.as0[1].e0[1] = 7;
    nested_aligned.as0[1].e0[2] = 8;
    nested_aligned.as0[1].e1[0] = 9;
    nested_aligned.as0[1].e1[1] = 10;
    nested_aligned.as0[1].e1[2] = 11;
    nested_aligned.as0[2].e0[0] = 12;
    nested_aligned.as0[2].e0[1] = 13;
    nested_aligned.as0[2].e0[2] = 14;
    nested_aligned.as0[2].e1[0] = 15;
    nested_aligned.as0[2].e1[1] = 16;
    nested_aligned.as0[2].e1[2] = 17;
    nested_aligned.as1[0].e0[0] = 18;
    nested_aligned.as1[0].e0[1] = 19;
    nested_aligned.as1[0].e0[2] = 20;
    nested_aligned.as1[0].e1[0] = 21;
    nested_aligned.as1[0].e1[1] = 22;
    nested_aligned.as1[0].e1[2] = 23;
    nested_aligned.as1[1].e0[0] = 24;
    nested_aligned.as1[1].e0[1] = 25;
    nested_aligned.as1[1].e0[2] = 26;
    nested_aligned.as1[1].e1[0] = 27;
    nested_aligned.as1[1].e1[1] = 28;
    nested_aligned.as1[1].e1[2] = 29;
    nested_aligned.as1[2].e0[0] = 30;
    nested_aligned.as1[2].e0[1] = 31;
    nested_aligned.as1[2].e0[2] = 32;
    nested_aligned.as1[2].e1[0] = 33;
    nested_aligned.as1[2].e1[1] = 34;
    nested_aligned.as1[2].e1[2] = 35;
    unaligned[0][0][0] = 36;
    unaligned[0][0][1] = 37;
    unaligned[0][0][2] = 38;
    unaligned[0][1][0] = 39;
    unaligned[0][1][1] = 40;
    unaligned[0][1][2] = 41;
    unaligned[1][0][0] = 42;
    unaligned[1][0][1] = 43;
    unaligned[1][0][2] = 44;
    unaligned[1][1][0] = 45;
    unaligned[1][1][1] = 46;
    unaligned[1][1][2] = 47;

    x[0] = nested_aligned.as0[0].e0[0];
    x[1] = nested_aligned.as0[0].e0[1];
    x[2] = nested_aligned.as0[0].e0[2];
    x[3] = nested_aligned.as0[0].e1[0];
    x[4] = nested_aligned.as0[0].e1[1];
    x[5] = nested_aligned.as0[0].e1[2];
    x[6] = nested_aligned.as0[1].e0[0];
    x[7] = nested_aligned.as0[1].e0[1];
    x[8] = nested_aligned.as0[1].e0[2];
    x[9] = nested_aligned.as0[1].e1[0];
    x[10] = nested_aligned.as0[1].e1[1];
    x[11] = nested_aligned.as0[1].e1[2];
    x[12] = nested_aligned.as0[2].e0[0];
    x[13] = nested_aligned.as0[2].e0[1];
    x[14] = nested_aligned.as0[2].e0[2];
    x[15] = nested_aligned.as0[2].e1[0];
    x[16] = nested_aligned.as0[2].e1[1];
    x[17] = nested_aligned.as0[2].e1[2];
    x[18] = nested_aligned.as1[0].e0[0];
    x[19] = nested_aligned.as1[0].e0[1];
    x[20] = nested_aligned.as1[0].e0[2];
    x[21] = nested_aligned.as1[0].e1[0];
    x[22] = nested_aligned.as1[0].e1[1];
    x[23] = nested_aligned.as1[0].e1[2];
    x[24] = nested_aligned.as1[1].e0[0];
    x[25] = nested_aligned.as1[1].e0[1];
    x[26] = nested_aligned.as1[1].e0[2];
    x[27] = nested_aligned.as1[1].e1[0];
    x[28] = nested_aligned.as1[1].e1[1];
    x[29] = nested_aligned.as1[1].e1[2];
    x[30] = nested_aligned.as1[2].e0[0];
    x[31] = nested_aligned.as1[2].e0[1];
    x[32] = nested_aligned.as1[2].e0[2];
    x[33] = nested_aligned.as1[2].e1[0];
    x[34] = nested_aligned.as1[2].e1[1];
    x[35] = nested_aligned.as1[2].e1[2];
    x[36] = unaligned[0][0][0];
    x[37] = unaligned[0][0][1];
    x[38] = unaligned[0][0][2];
    x[39] = unaligned[0][1][0];
    x[40] = unaligned[0][1][1];
    x[41] = unaligned[0][1][2];
    x[42] = unaligned[1][0][0];
    x[43] = unaligned[1][0][1];
    x[44] = unaligned[1][0][2];
    x[45] = unaligned[1][1][0];
    x[46] = unaligned[1][1][1];
    x[47] = unaligned[1][1][2];
}