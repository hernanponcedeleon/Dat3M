/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define WITH_INIT

#define REACQUIRE 1

#include <vsync/spinlock/arraylock.h>
#include <test/boilerplate/lock.h>

#ifndef ARRAY_LOCK_LEN
    #define ARRAY_LOCK_LEN (NTHREADS + 1U)
#endif
arraylock_flag_t flags[ARRAY_LOCK_LEN];
arraylock_t lock;
static __thread vuint32_t slot;

V_STATIC_ASSERT(NTHREADS <= ARRAY_LOCK_LEN,
                "ARRAY_LOCK_LEN must be a power of two greater than NTHREADS. "
                "You can overwrite it with `-DARRAY_LOCK_LEN=N`");

// Static initialisation causes problems to Dartagnan for this benchmark
void
init(void)
{
    arraylock_init(&lock, flags, ARRAY_LOCK_LEN);
}

void
acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    arraylock_acquire(&lock, &slot);
}

void
release(vuint32_t tid)
{
    V_UNUSED(tid);
    arraylock_release(&lock, slot);
}
