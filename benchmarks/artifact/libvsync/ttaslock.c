/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#include <vsync/spinlock/ttaslock.h>
#include <test/boilerplate/lock.h>

ttaslock_t lock = TTASLOCK_INIT();

void
acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    ttaslock_acquire(&lock);
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);

    ttaslock_release(&lock);
}
