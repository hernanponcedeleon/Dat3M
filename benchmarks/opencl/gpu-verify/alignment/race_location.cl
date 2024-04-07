//xfail:NOT_ALL_VERIFIED
//--local_size=64 --num_groups=64 --no-inline
//possible write-write race on n\[200\]

__kernel void foo(__global int3 *n)
{
  n[200] = get_global_id(0);
}
