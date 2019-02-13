#include <pthread.h>
#include <assert.h>

int flag0 = 0, flag1 = 0, turn = 0;

void *thrd0(void *args) {
  while (1) {
    flag0 = 1;
    int f1 = flag1;
    while (f1 == 1) {
      int t1 = turn;
      if (t1 != 0) {
        flag0 = 0;
        t1 = turn;
        while (t1 != 0) {
          t1 = turn;
        };
        flag0 = 1;
      }
    }
  }
  return NULL;
}

void *thrd1(void *args) {
  while (1) {
    flag1 = 1;
    int f2 = flag0;
    while (f2 == 1) {
      int t2 = turn;
      if (t2 != 1) {
        flag1 = 0;
        t2 = turn;
        while (t2 != 1) {
          t2 = turn;
        };
        flag1 = 1;
      }
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

