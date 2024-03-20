//pass
//--local_size=16 --num_groups=16 --debug
//Found 2 barrier interval\(s\)

#define tid get_local_id(0)

static void barrier_wrapper() {
    barrier(CLK_LOCAL_MEM_FENCE | CLK_GLOBAL_MEM_FENCE);
}

__kernel void simple_kernel(__local uint* p)
{
    for(int i = 0; i < 100; i++) {
        barrier_wrapper();
        p[tid] = tid;
        barrier_wrapper();
    }

    if(p[0] == 22) {

        for(int i = 0; i < 100; i++) {
            barrier_wrapper();
            p[tid] = tid;
            barrier_wrapper();
        }
        
    }

}
