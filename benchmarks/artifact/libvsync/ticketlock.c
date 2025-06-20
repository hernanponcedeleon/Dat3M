/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#include <vsync/spinlock/ticketlock.h>
#include <test/boilerplate/lock.h>

ticketlock_t lock = TICKETLOCK_INIT();

void
acquire(vuint32_t tid)
{
    if (tid == NTHREADS - 1) {
        await_while (!ticketlock_tryacquire(&lock)) {}
    } else {
        ticketlock_acquire(&lock);
    }
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    ticketlock_release(&lock);
}
