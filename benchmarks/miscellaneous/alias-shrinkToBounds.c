/*
  Exposes a bug in Dartagnan's Alias Analysis, where address sets were incorrectly shrunk based on array size.
  Expected verdict: FAIL.
*/
#include<pthread.h>
#include<assert.h>
#include<dat3m.h>

#define NUM_LOCKS 2

struct cache {
  // Unused storage to increase the static offset for the affected address sets.
  // For elements (given sizeof(int) == 4 and sizeof(pthread_mutex_t) == 8, the eager solver returned PASS.
  // The lazy solver non-deterministically returned FAIL or UNKNOWN(inconclusive).
  int garbage[17];
  pthread_mutex_t mutex[NUM_LOCKS];
} c;

volatile int x;

// Returns just `x`, but the Alias Analysis lost precision.
// Replacing at least one `id(x)` with `x` yielded FAIL again.
int id(int x) {
  int i = __VERIFIER_nondet_int();
  __VERIFIER_assume(i == x);
  return i;
}

// The address sets of these lock events were falsely estimated by the Alias Analysis.
void increment(int i) {
  pthread_mutex_lock(&c.mutex[i]);
  x++;
  pthread_mutex_unlock(&c.mutex[i]);
}

void *t_fun(void *arg) {
  increment(id(1));
  return NULL;
}

int main () {
  for (int i = 0; i < NUM_LOCKS; i++)
    pthread_mutex_init(&c.mutex[i], NULL);
  pthread_t t1;
  pthread_create(&t1, NULL, t_fun, NULL);
  increment(id(0));
  pthread_join(t1, NULL);
  assert(x == 2);
  return 0;
}
