//pass
//--local_size=16 --num_groups=16 --debug
//Found 3 barrier interval\(s\)

#define tid get_local_id(0)

__kernel void simple_kernel(__local uint* p)
{
    p[tid] = tid;
    barrier(CLK_LOCAL_MEM_FENCE);
    p[tid] = tid;
    barrier(CLK_LOCAL_MEM_FENCE);
    p[tid] = tid;
}
