//xfail:NOT_ALL_VERIFIED
//--local_size=65 --num_groups=1 --no-inline
//kernel.cl: error: possible write-write race on

__kernel void foo(__local int* A, int i) {
  A[i] = get_local_id(0) / 64;
}
