__kernel void non_uniform_barrier() {

    if(get_global_id(0) == 0) {
        barrier(CLK_GLOBAL_MEM_FENCE);
    }

}
