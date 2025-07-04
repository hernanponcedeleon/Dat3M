/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REENTRANT 1

#include <vsync/spinlock/rec_spinlock.h>
#include "fairness_lock.h"

rec_spinlock_t lock = REC_SPINLOCK_INIT();

void
acquire(vuint32_t tid)
{
    rec_spinlock_acquire(&lock, tid);
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    rec_spinlock_release(&lock);
}
