/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define WITH_INIT

#ifdef VSYNC_VERIFICATION_QUICK
    #define NREADERS 1
    #define NWRITERS 2
#else
    #define NREADERS 2
    #define NWRITERS 2
#endif

#include <vsync/spinlock/semaphore.h>
#include <test/boilerplate/reader_writer.h>

#define M NTHREADS
semaphore_t g_semaphore;

// Static initialisation causes problems to Dartagnan for this benchmark
void
init(void)
{
    semaphore_init(&g_semaphore, M);
}

void
writer_acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    semaphore_acquire(&g_semaphore, M);
}

void
writer_release(vuint32_t tid)
{
    V_UNUSED(tid);
    semaphore_release(&g_semaphore, M);
}
void
reader_acquire(vuint32_t tid)
{
    V_UNUSED(tid);
    semaphore_acquire(&g_semaphore, 1);
}

void
reader_release(vuint32_t tid)
{
    V_UNUSED(tid);
    semaphore_release(&g_semaphore, 1);
}
