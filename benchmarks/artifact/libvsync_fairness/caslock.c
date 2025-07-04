/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REACQUIRE 1

#include <vsync/spinlock/caslock.h>
#include "fairness_lock.h"

caslock_t lock = CASLOCK_INIT();

void
acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    caslock_acquire(&lock);
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    caslock_release(&lock);
}
