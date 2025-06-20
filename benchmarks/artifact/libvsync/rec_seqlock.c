/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */


#ifdef VSYNC_VERIFICATION_QUICK
    #define NREADERS 2
    #define NWRITERS 2
#else
    #define NREADERS 1
    #define NWRITERS 3
#endif
#define REENTRY_COUNT        2
#define EXPECTED_FINAL_VALUE NWRITERS
#define WITH_CS
#define WITH_FINI
#define WITH_INIT

#include <vsync/spinlock/rec_seqlock.h>

/* This lock is both a reader-writer lock and recursive (reentrant),  it uses
 * the reader_writer boilerplate, but also makes sure to acquire the lock
 * multiple times */
#include <test/boilerplate/reader_writer.h>

rec_seqlock_t lock;

vuint32_t g_cs_x;
vuint32_t g_cs_y;

void
writer_cs(vuint32_t tid)
{
    vsize_t i = 0;

    for (i = 0; i < REENTRY_COUNT; i++) {
        rec_seqlock_acquire(&lock, tid);
    }
    g_cs_x++;
    g_cs_y++;

    for (i = 0; i < REENTRY_COUNT; i++) {
        rec_seqlock_release(&lock);
    }
    rec_seqlock_acquire(&lock, tid);
}

void
reader_cs(vuint32_t tid)
{
    vuint32_t a  = 0;
    vuint32_t b  = 0;
    seqvalue_t s = 0;

    await_do {
        s = rec_seqlock_rbegin(&lock);
        a = g_cs_x;
        b = g_cs_y;
    }
    while_await(!rec_seqlock_rend(&lock, s));

    ASSERT(a == b);
    ASSERT((s % 2) == 0);
    V_UNUSED(tid, a, b);
}

void
init(void)
{
    rec_seqlock_init(&lock);
}

void
fini(void)
{
    vuint32_t x = g_cs_x;
    vuint32_t y = g_cs_y;
    ASSERT(x == y);
    ASSERT(x == EXPECTED_FINAL_VALUE);
    V_UNUSED(x, y);
}
