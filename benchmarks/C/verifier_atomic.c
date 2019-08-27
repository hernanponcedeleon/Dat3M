extern void __VERIFIER_error() __attribute__ ((__noreturn__));

extern void __VERIFIER_atomic_begin();
extern void __VERIFIER_atomic_end();

#include <pthread.h>

int i=0;

#define NUM 5
#define NULL 0

void *
t1(void* arg)
{
  __VERIFIER_atomic_begin();
  i+=1;
  i+=1;
  __VERIFIER_atomic_end();
  pthread_exit(NULL);
}

void *
t2(void* arg)
{
  if (i == 1) {
    ERROR: __VERIFIER_error();
  }
  pthread_exit(NULL);
}

int
main(int argc, char **argv)
{
  pthread_t id1, id2;
  pthread_create(&id1, NULL, t1, NULL);
  pthread_create(&id2, NULL, t2, NULL);
  return 0;
}
