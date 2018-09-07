#include <pthread.h>
#include <assert.h>

int flag1 = 0, flag2 = 0;

void *thrd0(void *args) {
  while (1) {
    flag1 = 1;
    int f2 = flag2;
    while (f2 >= 3) {
      f2 = flag2;
    };
    flag1 = 3;
    f2 = flag2;
    if (f2 == 1) {
      flag1 = 2;
      f2 = flag2;
      while (f2 != 4) {
        f2 = flag2;
      }
    };
    flag1 = 4;
    f2 = flag2;
    while (f2 >= 2) {
      f2 = flag2;
    };
    f2 = flag2;
    while ((2 <= f2) && (f2 <= 3)) {
      f2 = flag2;
    }
  }
  return NULL;
}

void *thrd1(void *args) {
  while (1) {
    flag2 = 1;
    int f1 = flag1;
    while (f1 >= 3) {
      f1 = flag1;
    };
    flag2 = 3;
    f1 = flag1;
    if (f1 == 1) {
      flag2 = 2;
      f1 = flag1;
      while (f1 != 4) {
        f1 = flag1;
      }
    };
    flag2 = 4;
    f1 = flag1;
    while (f1 >= 2) {
      f1 = flag1;
    };
    f1 = flag1;
    while ((2 <= f1) && (f1 <= 3)) {
      f1 = flag1;
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

