#include <pthread.h>
#include <assert.h>

int flag0 = 0, flag1 = 0, turn = 0;

void *thrd0(void *args) {
  int a = 1;
  flag0 = a;
  turn = a;
  int f1 = flag1;
  int t0 = turn;
  while ((f1 == 1) && (t0 == 1)) {
    f1 = flag1;
    t0 = turn;
  }
  return NULL;
}

void *thrd1(void *args) {
  int b = 1;
  int c = 0;
  flag1 = b;
  turn = c;
  int f0 = flag0;
  int t1 = turn;
  while ((f0 == 1) && (t1 == 0)) {
    f0 = flag0;
    t1 = turn;
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

