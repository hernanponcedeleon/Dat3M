#include <stdatomic.h>

atomic_char x1, y1;
atomic_short x2, y2;
atomic_int x4, y4;
atomic_llong x8, y8;

int __attribute__((noinline)) check_atomic_8() {
  char a    = atomic_load(&x1);
  char b    = atomic_exchange_explicit(&y1, a, memory_order_acquire);
  _Bool res = atomic_compare_exchange_strong(&x1, &a, b);
  atomic_store_explicit(&x1, b, memory_order_relaxed);
  return res;
}

int __attribute__((noinline)) check_atomic_16() {
  short a   = atomic_load(&x2);
  short b   = atomic_exchange_explicit(&y2, a, memory_order_acquire);
  _Bool res = atomic_compare_exchange_strong(&x2, &a, b);
  atomic_store_explicit(&x2, b, memory_order_relaxed);
  return res;
}

int __attribute__((noinline)) check_atomic_32() {
  int a     = atomic_load(&x4);
  int b     = atomic_exchange_explicit(&y4, a, memory_order_acquire);
  _Bool res = atomic_compare_exchange_strong(&x4, &a, b);
  atomic_store_explicit(&x4, b, memory_order_relaxed);
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
  check_atomic_8();
  check_atomic_16();
  check_atomic_32();
  check_atomic_64();
  check_fence();
}
