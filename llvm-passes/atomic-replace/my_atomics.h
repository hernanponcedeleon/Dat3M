/*
 * Copyright (C) 2022-2023. Huawei Technologies Co., Ltd.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the MIT License.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the MIT License for more details.
 */

#ifndef MY_ATOMICS_H
#define MY_ATOMICS_H

#include <assert.h>
#include <stdatomic.h>

#include "AtomicReplaceInterface.h"

#define MY_ATOMICS_NAME(op, n) __llvm_atomic##n##_##op

#define MY_RET_NAME(n) my_ret##n

#define MY_ATOMICS_DECLARE_FUNCTIONS(n, ty, atomic_ptr_ty)                     \
                                                                               \
  typedef struct {                                                             \
    ty loaded;                                                                 \
    _Bool succ;                                                                \
  } MY_RET_NAME(n);                                                            \
                                                                               \
  ty MY_ATOMICS_NAME(load, n)(atomic_ptr_ty x, int mode);                      \
                                                                               \
  void MY_ATOMICS_NAME(store, n)(atomic_ptr_ty x, ty y, int mode);             \
                                                                               \
  MY_RET_NAME(n) MY_ATOMICS_NAME(cmpxchg, n)(atomic_ptr_ty x,                  \
      ty expected, ty desired, int mode_succ, int mode_fail);                  \
                                                                               \
  ty MY_ATOMICS_NAME(rmw, n)(atomic_ptr_ty x, ty y, int mode, int op);

MY_ATOMICS_DECLARE_FUNCTIONS(8, char, atomic_char *)
MY_ATOMICS_DECLARE_FUNCTIONS(16, short, atomic_short *)
MY_ATOMICS_DECLARE_FUNCTIONS(32, int, atomic_int *)
MY_ATOMICS_DECLARE_FUNCTIONS(64, long long, atomic_llong *)

void MY_ATOMICS_NAME(fence, )(int mode);

#endif /* MY_ATOMICS_H */
