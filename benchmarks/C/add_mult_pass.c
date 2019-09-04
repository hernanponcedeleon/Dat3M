extern void __VERIFIER_error() __attribute__ ((__noreturn__));

int add(int x, int y) {
  return x+y;
}

int mult(int x, int y) {
  return x*y;
}

int main(void) {
  int a = add(1,2);
  if (a != 3) {
     __VERIFIER_error();
  }
  
  int m = mult(a,3);
  if (m != 9) {
    __VERIFIER_error();
  }
  return 0;
}
