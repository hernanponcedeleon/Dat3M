//pass
//--local_size=1024 --num_groups=1024 --equality-abstraction --no-inline


__kernel void foo(__global int* p) {

  p[get_local_id(0)] = get_local_id(0);

}
