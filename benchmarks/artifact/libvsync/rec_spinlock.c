/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REENTRANT 1

#include <vsync/spinlock/rec_spinlock.h>
#include <test/boilerplate/lock.h>

rec_spinlock_t lock = REC_SPINLOCK_INIT();

void
acquire(vuint32_t tid)
{
    if (tid == NTHREADS - 1) {
#if defined(VSYNC_VERIFICATION_DAT3M) || defined(VSYNC_VERIFICATION_GENERIC)
        vbool_t acquired = rec_spinlock_tryacquire(&lock, tid);
        verification_assume(acquired);
#else
        await_while (!rec_spinlock_tryacquire(&lock, tid)) {}
#endif
    } else {
        rec_spinlock_acquire(&lock, tid);
    }
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    rec_spinlock_release(&lock);
}
