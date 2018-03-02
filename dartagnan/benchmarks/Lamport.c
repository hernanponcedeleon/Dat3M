#include <pthread.h>
#include <assert.h>

int x = 0, y = 0, b1 = 0, b2 = 0, b3 = 0;

void *thrd0(void *args) {
  while (1) {
    int t = 1;
    int f = 0;
    b1 = t;
    int i = 1;
    x = i;
    int y1 = y;
    if (y1 != 0) {
      b1 = f;
    };
    y = i;
    int x1 = x;
    if (x1 != 1) {
      b1 = f;
    }
  }
  return NULL;
}

void *thrd1(void *args) {
  while (1) {
    int t = 1;
    int f = 0;
    b2 = t;
    int i = 2;
    x = i;
    int y1 = y;
    if (y1 != 0) {
      b2 = f;
    };
    y = i;
    int x1 = x;
    if (x1 != 2) {
      b2 = f;
    }
  }
  return NULL;
}

void *thrd2(void *args) {
  while (1) {
    int t = 1;
    int f = 0;
    b3 = t;
    int i = 3;
    x = i;
    int y1 = y;
    if (y1 != 0) {
      b3 = f;
    };
    y = i;
    int x1 = x;
    if (x1 != 3) {
      b3 = f;
    }
  }
  return NULL;
}

int main(int argc, char *argv[]){

  pthread_t t0;
  pthread_t t1;
  pthread_t t2;

  pthread_create(&t0,NULL,thrd0,NULL);
  pthread_create(&t1,NULL,thrd1,NULL);
  pthread_create(&t2,NULL,thrd2,NULL);

  int x = pthread_join(t0,NULL);
  int y = pthread_join(t1,NULL);
  int z = pthread_join(t2,NULL);

  assert(x==0 && y==0 && z==0);

  return 0;
}

