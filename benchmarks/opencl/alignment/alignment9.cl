// clang -x cl -cl-std=CL2.0 -target spir-unknown-unknown -cl-opt-disable -emit-llvm -c alignment9.cl -o a.bc
// llvm-spirv a.bc -o a.spv
// spirv-dis a.spv > alignment9.spvasm

struct aligned_struct {
    uint3 data[2];
};

global struct aligned_struct aligned;

__kernel void test(global uint *x, global struct aligned_struct *aligned)
{
    aligned->data[0].x = 0;
    aligned->data[0].y = 1;
    aligned->data[0].z = 2;

    aligned->data[1].x = 3;
    aligned->data[1].y = 4;
    aligned->data[1].z = 5;

    for (int i = 0; i < 8; i++)
    {
        x[i] = *(((uint*)aligned) + i);
    }
}