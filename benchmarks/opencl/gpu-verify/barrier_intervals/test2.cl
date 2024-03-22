//xfail:NOT_ALL_VERIFIED
//--local_size=16 --num_groups=16 --debug
//Found 2 barrier interval\(s\)
//barrier\(CLK_LOCAL_MEM_FENCE\)

#define tid get_local_id(0)

__kernel void simple_kernel(__local uint* p)
{
    p[tid] = tid;
    if(tid == 0) {
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    p[tid] = tid;
    barrier(CLK_LOCAL_MEM_FENCE);
    p[tid] = tid;
}
