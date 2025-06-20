/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#ifdef VSYNC_VERIFICATION_QUICK
    #define NTHREADS 4
#else
    #define NTHREADS 5
#endif

#define WITH_POST

#include <vsync/spinlock/cnalock.h>
#include <test/boilerplate/lock.h>

cnalock_t lock = CNALOCK_INIT();
struct cna_node_s nodes[NTHREADS+1];

void
post(void)
{
#ifdef VSYNC_VERIFICATION
    vatomic32_write_rlx(&rand, 1);
#endif
}

#define NUMA(_tid_) ((_tid_) < NTHREADS / 2)

void
acquire(vuint32_t tid)
{
    cnalock_acquire(&lock, &nodes[tid], NUMA(tid));
}

void
release(vuint32_t tid)
{
    cnalock_release(&lock, &nodes[tid], NUMA(tid));
}
