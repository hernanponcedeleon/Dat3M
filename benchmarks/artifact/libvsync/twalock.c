/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#include <vsync/spinlock/twalock.h>
#include <test/boilerplate/lock.h>

TWALOCK_ARRAY_DECL;
twalock_t lock = TWALOCK_INIT();

void
acquire(vuint32_t tid)
{
    if (tid == NTHREADS - 1) {
#if defined(VSYNC_VERIFICATION_DAT3M) || defined(VSYNC_VERIFICATION_GENERIC)
        vbool_t acquired = twalock_tryacquire(&lock);
        verification_assume(acquired);
#else
        await_while (!twalock_tryacquire(&lock)) {}
#endif
    } else {
        twalock_acquire(&lock);
    }
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    twalock_release(&lock);
}
