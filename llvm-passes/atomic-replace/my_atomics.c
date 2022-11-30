/*
 * Copyright (C) 2022. Huawei Technologies Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the MIT License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the MIT License for more details.
 */

#include "my_atomics.h"

#define MY_ATOMICS_DEFINE_FUNCTIONS(n, ty, atomic_ptr_ty)                      \
                                                                               \
  ty MY_ATOMICS_NAME(load, n)(atomic_ptr_ty x, int mode) {                     \
    return atomic_load_explicit(x, mode);                                      \
  }                                                                            \
                                                                               \
  void MY_ATOMICS_NAME(store, n)(atomic_ptr_ty x, ty y, int mode) {            \
    atomic_store_explicit(x, y, mode);                                         \
  }                                                                            \
                                                                               \
  MY_RET_NAME(n) MY_ATOMICS_NAME(cmpxchg, n)(atomic_ptr_ty x,                  \
      ty expected, ty desired, int mode_succ, int mode_fail) {                 \
    MY_RET_NAME(n) r;                                                          \
    r.loaded = expected;                                                       \
    r.succ = atomic_compare_exchange_strong_explicit(x,                        \
        &r.loaded, desired, mode_succ, mode_fail);                             \
    return r;                                                                  \
  }                                                                            \
                                                                               \
  ty MY_ATOMICS_NAME(rmw, n)(atomic_ptr_ty x, ty y, int mode, int op) {        \
    switch (op) {                                                              \
      case op_xchg:                                                            \
        return atomic_exchange_explicit(x, y, mode);                           \
      case op_add:                                                             \
        return atomic_fetch_add_explicit(x, y, mode);                          \
      case op_sub:                                                             \
        return atomic_fetch_sub_explicit(x, y, mode);                          \
      case op_and:                                                             \
        return atomic_fetch_and_explicit(x, y, mode);                          \
      case op_or:                                                              \
        return atomic_fetch_or_explicit(x, y, mode);                           \
      case op_xor:                                                             \
        return atomic_fetch_xor_explicit(x, y, mode);                          \
      default:                                                                 \
        assert(0 && "unknown atomic");                                         \
    }                                                                          \
  }

MY_ATOMICS_DEFINE_FUNCTIONS(32, int, atomic_int *)
MY_ATOMICS_DEFINE_FUNCTIONS(64, long long, atomic_llong *)

void MY_ATOMICS_NAME(fence, )(int mode) {
  return atomic_thread_fence(mode);
}
