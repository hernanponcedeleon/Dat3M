var b : int;
procedure main() {
  var a,c : int;
  call pthread_create($p3, $0.ref, thrd0, $0.ref);
  c := b;
  a := c + c;
  assert(a != 1);
}

procedure thrd0() {
  b := 1;
}
