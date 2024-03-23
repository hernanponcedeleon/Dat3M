//xfail:NOT_ALL_VERIFIED
//--local_size=1024 --global_size=1024 --only-divergence
//barrier may be reached by non-uniform control flow

kernel void foo (global int * restrict A, global int * restrict B) {
  int tmp = A[get_global_id(0)];
  if (tmp == 0) {
    barrier(CLK_GLOBAL_MEM_FENCE);
  }
  B[0] = tmp;
}
