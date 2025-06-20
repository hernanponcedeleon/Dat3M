/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REACQUIRE 1

#include <vsync/spinlock/caslock.h>
#include <test/boilerplate/lock.h>

caslock_t lock = CASLOCK_INIT();

void
acquire(vuint32_t tid)
{
    if (tid == NTHREADS - 1) {
#if defined(VSYNC_VERIFICATION_DAT3M) || defined(VSYNC_VERIFICATION_GENERIC)
        vbool_t acquired = caslock_tryacquire(&lock);
        verification_assume(acquired);
#else
        await_while (!caslock_tryacquire(&lock)) {}
#endif
    } else {
        caslock_acquire(&lock);
    }
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    caslock_release(&lock);
}
