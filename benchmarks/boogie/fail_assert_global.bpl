var b : int;
procedure main() {
  var a : int;
  call pthread_create($p3, $0.ref, thrd0, $0.ref);
  a := b + b;
  assert(a != 1);
}

procedure thrd0() {
  b := 1;
}
