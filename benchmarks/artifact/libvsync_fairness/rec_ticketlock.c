/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REENTRANT 1

#include <vsync/spinlock/rec_ticketlock.h>
#include "fairness_lock.h"

rec_ticketlock_t lock = REC_TICKETLOCK_INIT();

void
acquire(vuint32_t tid)
{
    rec_ticketlock_acquire(&lock, tid);
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    rec_ticketlock_release(&lock);
}
