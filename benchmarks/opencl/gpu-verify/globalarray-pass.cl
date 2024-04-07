//pass
//--local_size=8 --num_groups=8 --no-inline


__constant int A[64] = { };

__kernel void globalarray(__global int* p) {
  int i = get_global_id(0);
  int a = A[i];

  if(a != 0) {
    p[0] = get_global_id(0);
  }
}
