//pass
//--local_size=8 --num_groups=1 --no-inline

/*
 * The values of the constant array [A] should be preserved as requires clauses.
 */

__constant int A[8] = {0,1,2,3,4,5,6,7};

__kernel void globalarray(__global int* p) {
  int i = get_global_id(0);
  int a = A[i];

  if(a != get_global_id(0)) {
    p[0] = get_global_id(0);
    __assert(false); //< unreachable
  }
}
