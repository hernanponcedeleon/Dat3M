
extern void __VERIFIER_error() __attribute__ ((__noreturn__));

/* Testcase from Threader's distribution. For details see:
   http://www.model.in.tum.de/~popeea/research/threader
*/

#include <pthread.h>
#define assert(e) if (!(e)) __VERIFIER_error()

int main() {
  int x=0;
  while(x < 3) {
    x++;
  }
  assert(x != 3);
  return 0;
}
