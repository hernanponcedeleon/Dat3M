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
#include <test/boilerplate/lock.h>

hemlock_t lock = HEMLOCK_INIT();
struct hem_node_s nodes[NTHREADS+1];

void
acquire(vuint32_t tid)
{
    if (tid == NTHREADS - 1) {
#if defined(VSYNC_VERIFICATION_DAT3M) || defined(VSYNC_VERIFICATION_GENERIC)
        vbool_t acquired = hemlock_tryacquire(&lock, &nodes[tid]);
        verification_assume(acquired);
#else
        await_while (!hemlock_tryacquire(&lock, &nodes[tid])) {}
#endif
    } else {
        hemlock_acquire(&lock, &nodes[tid]);
    }
}

void
release(vuint32_t tid)
{
    hemlock_release(&lock, &nodes[tid]);
}
