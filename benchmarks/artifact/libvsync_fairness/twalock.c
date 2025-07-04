/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#include <vsync/spinlock/twalock.h>
#include "fairness_lock.h"

TWALOCK_ARRAY_DECL;
twalock_t lock = TWALOCK_INIT();

void
acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    twalock_acquire(&lock);
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    twalock_release(&lock);
}
