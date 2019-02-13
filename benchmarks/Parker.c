#include <assert.h>
#include <pthread.h>

int cond = 0, parkCounter = 0;

void *thrd0(void *args) {
  int c = cond;
  while (c == 0) {
    int counter = parkCounter;
    parkCounter = 0;
    c = cond;
  }
  return NULL;
}

void *thrd1(void *args) {
  cond = 1;
  parkCounter = 1;
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

