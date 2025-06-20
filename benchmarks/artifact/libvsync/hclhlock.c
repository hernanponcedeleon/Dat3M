/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define HCLH_MAX_CLUSTERS 2
#define REACQUIRE         1
#define WITH_INIT

#include <vsync/spinlock/hclhlock.h>
#include <test/boilerplate/lock.h>

hclh_lock_t lock;
hclh_tnode_t tnode[NTHREADS+1];
hclh_qnode_t qnode[NTHREADS+1];

void
init(void)
{
    hclhlock_init(&lock);
    for (vsize_t i = 0; i < NTHREADS+1; i++) {
        vuint32_t cluster = i % HCLH_MAX_CLUSTERS;
        hclhlock_init_tnode(&tnode[i], &qnode[i], cluster);
    }
}

void
acquire(vuint32_t tid)
{
    hclhlock_acquire(&lock, &tnode[tid]);
}

void
release(vuint32_t tid)
{
    hclhlock_release(&tnode[tid]);
}
