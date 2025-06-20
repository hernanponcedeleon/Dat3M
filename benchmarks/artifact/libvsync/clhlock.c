/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REACQUIRE 1
#define WITH_INIT

#define NULL ((void *)(0))
#include <vsync/spinlock/clhlock.h>
#include <test/boilerplate/lock.h>

clhlock_t lock;
clh_qnode_t initial;
clh_node_t node[NTHREADS+1];

void
init(void)
{
    clhlock_init(&lock);

    for (int i = 0; i < NTHREADS+1; i++) {
        clhlock_node_init(&node[i]);
    }
}

void
acquire(vuint32_t tid)
{
    clhlock_acquire(&lock, &node[tid]);
}

void
release(vuint32_t tid)
{
    clhlock_release(&lock, &node[tid]);
}
