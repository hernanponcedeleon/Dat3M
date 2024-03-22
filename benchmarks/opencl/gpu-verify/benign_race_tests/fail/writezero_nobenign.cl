//xfail:NOT_ALL_VERIFIED
//--local_size=64 --num_groups=1 --no-benign-tolerance --no-inline
//kernel.cl: error: possible write-write race on


__kernel void foo(__local int* A) {
  A[0] = 0;
}
