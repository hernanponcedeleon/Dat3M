/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2023-2025. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#ifndef VSYNC_BOILERPLATE_LOCK_H
#define VSYNC_BOILERPLATE_LOCK_H
/*******************************************************************************
 * Boilerplate for testing spinlocks and mutexes
 *
 * Constants:
 *
 * - NTHREADS  : total number of threads
 * - REACQUIRE : first threads enters the critical section twice.
 * - REENTRANT : first threads acquire (and release) lock twice.
 * - WITH_INIT : define init()
 * - WITH_FINI : define fini()
 * - WITH_POST : define post()
 ******************************************************************************/
#include <vsync/atomic.h>
#include <vsync/common/verify.h>

void acquire(vuint32_t tid);
void release(vuint32_t tid);

#ifndef NTHREADS
    #define NTHREADS 2
#endif

/*******************************************************************************
 * client code
 ******************************************************************************/
#include <stdio.h>
#include <vsync/vtypes.h>
#include <pthread.h>
#include <vsync/common/assert.h>

#ifdef WITH_INIT
void init(void);
#else
void
init(void)
{
}
#endif

static vuint32_t g_cs_x = 0;

static void *
thread_1(void *arg)
{
    vuint32_t tid = (vuintptr_t)arg;
    while (g_cs_x == 0) {
        acquire(tid);
        release(tid);
    }
    return NULL;
}

static void *
thread_2(void *arg)
{
    vuint32_t tid = (vuintptr_t)arg;
    acquire(tid);
    g_cs_x = 1;
    release(tid);
    return NULL;
}

int
main(void)
{
    pthread_t t[2];
    init();

    (void)pthread_create(&t[0], 0, thread_1, (void *)0);
    (void)pthread_create(&t[1], 0, thread_2, (void *)1);

    (void)pthread_join(t[0], NULL);
    (void)pthread_join(t[1], NULL);

    return 0;
}
#endif
