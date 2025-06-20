/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REENTRANT 1

#include <vsync/spinlock/rec_mcslock.h>
#include <test/boilerplate/lock.h>

rec_mcslock_t lock = REC_MCSLOCK_INIT();
struct mcs_node_s nodes[NTHREADS+1];

void
acquire(vuint32_t tid)
{
    rec_mcslock_acquire(&lock, tid, &nodes[tid]);
}

void
release(vuint32_t tid)
{
    rec_mcslock_release(&lock, &nodes[tid]);
}
