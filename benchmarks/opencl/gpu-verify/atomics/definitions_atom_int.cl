//pass
//--local_size=1024 --num_groups=1 --no-inline

kernel void definitions (local int* A, local unsigned int* B, global int* C, global unsigned int* D)
{
  atom_add(A,10);
  atom_sub(A,10);
  atom_xchg(A,10);
  atom_min(A,10);
  atom_max(A,10);
  atom_and(A,10);
  atom_or(A,10);
  atom_xor(A,10);
  atom_inc(A);
  atom_dec(A);
  atom_cmpxchg(A,10,10);

  atom_add(B,10);
  atom_sub(B,10);
  atom_xchg(B,10);
  atom_min(B,10);
  atom_max(B,10);
  atom_and(B,10);
  atom_or(B,10);
  atom_xor(B,10);
  atom_inc(B);
  atom_dec(B);
  atom_cmpxchg(B,10,10);

  atom_add(C,10);
  atom_sub(C,10);
  atom_xchg(C,10);
  atom_min(C,10);
  atom_max(C,10);
  atom_and(C,10);
  atom_or(C,10);
  atom_xor(C,10);
  atom_inc(C);
  atom_dec(C);
  atom_cmpxchg(C,10,10);

  atom_add(D,10);
  atom_sub(D,10);
  atom_xchg(D,10);
  atom_min(D,10);
  atom_max(D,10);
  atom_and(D,10);
  atom_or(D,10);
  atom_xor(D,10);
  atom_inc(D);
  atom_dec(D);
  atom_cmpxchg(D,10,10);
}
