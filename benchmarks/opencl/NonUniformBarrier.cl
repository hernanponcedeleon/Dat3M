__kernel void non_uniform_barrier() {

    // PASS liveness if each WG has a single tread
    // FAIL otherwise
    if(get_local_id(0) == 0) {
        barrier(CLK_GLOBAL_MEM_FENCE);
    }

}
