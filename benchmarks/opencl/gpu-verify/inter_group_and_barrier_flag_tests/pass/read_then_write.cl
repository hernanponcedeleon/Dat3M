//pass
//--local_size=1024 --num_groups=1024 --no-inline


__kernel void foo(__local int* p) {

  volatile int x, y;

  x = get_local_id(0) == 0 ? CLK_LOCAL_MEM_FENCE : 0;

  if(get_local_id(0) == 0) {
    y = p[0];
  }

  barrier(x);  

  if(get_local_id(0) == 1) {
    p[0] = 0;
  }

}
