//xfail:NOT_ALL_VERIFIED
//--local_size=8 --num_groups=8 --no-inline
//kernel.cl:[\s]+error:[\s]+possible[\s]+write-write[\s]+race on p\[0]
//Write by work item[\s]+[\d]+[\s]+with local id[\s]+[\d]+[\s]+in work group[\s]+[\d], .+kernel.cl:21:[\d]+:[\s]+p\[0\] = get_global_id\(0\) \+ c;



__constant int A[64] = { };

__kernel void globalarray(__global int* p) {
  int i = get_global_id(0) + 1;
  int a = A[i];

  char c;

  __constant char* cp = (__constant char*) A;

  c = cp[0];

  if(a == 0) {
    p[0] = get_global_id(0) + c;
  }
}
