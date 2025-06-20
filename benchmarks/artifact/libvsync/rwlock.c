/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#ifdef VSYNC_VERIFICATION_QUICK
    #define NREADERS 1
    #define NWRITERS 2
#else
    #define NREADERS 2
    #define NWRITERS 2
#endif

#include <vsync/spinlock/rwlock.h>
#include <test/boilerplate/reader_writer.h>

rwlock_t lock = RWLOCK_INIT();

void
writer_acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    rwlock_write_acquire(&lock);
}
void
writer_release(vuint32_t tid)
{
    V_UNUSED(tid);
    rwlock_write_release(&lock);
}
void
reader_acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    rwlock_read_acquire(&lock);
}
void
reader_release(vuint32_t tid)
{
    V_UNUSED(tid);
    rwlock_read_release(&lock);
}
