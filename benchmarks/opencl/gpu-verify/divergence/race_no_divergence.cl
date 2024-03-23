//pass
//--local_size=1024 --global_size=1024 --only-divergence

kernel void foo (global int * restrict A, global int * restrict B) {
  int tmp = A[get_global_id(0)];
  barrier(CLK_GLOBAL_MEM_FENCE);
  B[0] = tmp;
}
