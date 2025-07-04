/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REACQUIRE 1

#include <vsync/spinlock/mcslock.h>
#include "fairness_lock.h"

mcslock_t lock = MCSLOCK_INIT();
struct mcs_node_s nodes[NTHREADS+1];

void
acquire(vuint32_t tid)
{
    mcslock_acquire(&lock, &nodes[tid]);
}

void
release(vuint32_t tid)
{
    mcslock_release(&lock, &nodes[tid]);
}
