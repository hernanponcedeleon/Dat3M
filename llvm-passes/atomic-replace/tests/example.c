#include <stdatomic.h>

atomic_int x, y;
atomic_llong x8, y8;

int __attribute__((noinline)) check_atomic_32() {
  int a     = atomic_load(&x);
  int b     = atomic_exchange_explicit(&y, a, memory_order_acquire);
  _Bool res = atomic_compare_exchange_strong(&x, &a, b);
  atomic_store_explicit(&x, b, memory_order_relaxed);
  return res;
}

int __attribute__((noinline)) check_atomic_64() {
  long long a = atomic_load(&x8);
  long long b = atomic_exchange_explicit(&y8, a, memory_order_acquire);
  _Bool res   = atomic_compare_exchange_strong(&x8, &a, b);
  atomic_store_explicit(&x8, b, memory_order_relaxed);
  return res;
}

void __attribute__((noinline)) check_fence() {
  atomic_thread_fence(memory_order_release);
}

int main() {
  check_atomic_32();
  check_atomic_64();
  check_fence();
}
