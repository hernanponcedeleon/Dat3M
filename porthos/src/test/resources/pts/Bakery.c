#include <pthread.h>
#include <assert.h>

int c0 = 0, c1 = 0, n0 = 0, n1 = 0;

void *thrd0(void *args) {
  while (1) {
    int a0 = 1;
    c0 = a0;
    int r0 = n1;
    int r1 = r0 + 1;
    n0 = r1;
    int a1 = 0;
    c0 = a1;
    int chk = c1;
    while (chk != 0) {
      chk = c1;
    };
    r0 = n1;
    while ((r0 != 0) && (r0 < r1)) {
      r0 = n1;
    }
  }
  return NULL;
}

void *thrd1(void *args) {
  while (1) {
    int b0 = 1;
    c1 = b0;
    int q0 = n0;
    int q1 = q0 + 1;
    n1 = q1;
    int b1 = 0;
    c1 = b1;
    int chk = c0;
    while (chk != 0) {
      chk = c0;
    };
    q0 = n0;
    while ((q0 != 0) && (q0 < q1)) {
      q0 = n0;
    }
  }
  return NULL;
}

int main(int argc, char *argv[]){

  pthread_t t0;
  pthread_t t1;

  pthread_create(&t0,NULL,thrd0,NULL);
  pthread_create(&t1,NULL,thrd1,NULL);

  int x = pthread_join(t0,NULL);
  int y = pthread_join(t1,NULL);

  assert(x==0 && y==0);

  return 0;
}

