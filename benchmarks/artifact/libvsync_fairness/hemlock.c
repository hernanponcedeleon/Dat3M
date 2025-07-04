/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#ifdef VSYNC_VERIFICATION_QUICK
    #define REACQUIRE 1
    #define NTHREADS  3
#else
    #define REACQUIRE 1
    #define NTHREADS  4
#endif

#include <vsync/spinlock/hemlock.h>
#include "fairness_lock.h"

hemlock_t lock = HEMLOCK_INIT();
struct hem_node_s nodes[NTHREADS+1];

void
acquire(vuint32_t tid)
{
    hemlock_acquire(&lock, &nodes[tid]);
}

void
release(vuint32_t tid)
{
    hemlock_release(&lock, &nodes[tid]);
}
