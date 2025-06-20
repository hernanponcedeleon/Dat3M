/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define WITH_CS

#include <vsync/spinlock/seqcount.h>
// this impl works only with single writer
#define NWRITERS 1U
#include <test/boilerplate/reader_writer.h>

seqcount_t g_seq_cnt;
vuint32_t g_cs_x, g_cs_y;

void
writer_cs(vuint32_t tid)
{
    V_UNUSED(tid);
    seqvalue_t s = seqcount_wbegin(&g_seq_cnt);
    g_cs_x++;
    g_cs_y++;
    seqcount_wend(&g_seq_cnt, s);
}

void
reader_cs(vuint32_t tid)
{
    vuint32_t a  = 0;
    vuint32_t b  = 0;
    seqvalue_t s = 0;

    await_do {
        s = seqcount_rbegin(&g_seq_cnt);
        a = g_cs_x;
        b = g_cs_y;
    }
    while_await(!seqcount_rend(&g_seq_cnt, s));

    ASSERT(a == b);
    ASSERT((s >> 1) == a);

    V_UNUSED(a, b, tid);
}
