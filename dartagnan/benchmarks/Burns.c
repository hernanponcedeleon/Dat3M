#include <pthread.h>
#include <assert.h>

int x = 0, y = 0;

void *thrd0(void *args) {
  while (1) {
    int a = 1;
    x = a;
    int chk = y;
    while (chk != 0) {
      chk = y;
    }
  }
  return NULL;
}

void *thrd1(void *args) {
  while (1) {
    int chk = x;
    while (chk != 0) {
      chk = x;
    };
    int b = 1;
    y = b;
    chk = x;
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

