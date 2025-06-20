/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define NREADERS             2
#define NWRITERS             2
#define EXPECTED_FINAL_VALUE NWRITERS
#define WITH_CS
#define WITH_FINI

#include <vsync/spinlock/seqlock.h>
#include <test/boilerplate/reader_writer.h>
#include <vsync/utils/math.h>

seqlock_t lock = SEQ_LOCK_INIT();

vuint32_t g_cs_x;
vuint32_t g_cs_y;

void
writer_cs(vuint32_t tid)
{
    seqlock_acquire(&lock);
    g_cs_x++;
    g_cs_y++;
    seqlock_release(&lock);
    V_UNUSED(tid);
}

void
reader_cs(vuint32_t tid)
{
    vuint32_t a  = 0;
    vuint32_t b  = 0;
    seqvalue_t s = 0;

    await_do {
        s = seqlock_rbegin(&lock);
        a = g_cs_x;
        b = g_cs_y;
    }
    while_await(!seqlock_rend(&lock, s));

    ASSERT(a == b);
    ASSERT(VIS_EVEN(s));
    V_UNUSED(tid, a, b);
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
