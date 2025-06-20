/*
 * Copyright (C) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * SPDX-License-Identifier: MIT
 */

#define REACQUIRE 1
#define WITH_INIT

#include <vsync/spinlock/hmcslock.h>
#include <test/boilerplate/lock.h>

#define MAX_THREADS (NTHREADS + 1U)

#if NTHREADS > MAX_THREADS
    #error NTHREADS > MAX_THREADS
#endif

#define NUM_LEVELS 3
#define LEVEL_1    1
#define LEVEL_2    2
#define LEVEL_3    2

#define LEVEL_1_THRESHOLD 1
#define LEVEL_2_THRESHOLD 1
#define LEVEL_3_THRESHOLD 1

#define NUM_LOCKS                                                              \
    ((LEVEL_3 * LEVEL_2 * LEVEL_1) + (LEVEL_1 * LEVEL_2) + (LEVEL_1))

typedef struct {
    hmcslock_t hmcs_locks[NUM_LOCKS]; // array of hmcs locks
    hmcslock_t *leaf_locks[MAX_THREADS];
} lock_t;

typedef struct {
    hmcs_node_t qnode;
} ctx_t;

lock_t lock;
ctx_t ctx[NTHREADS+1];

void
init(void)
{
    hmcslock_level_spec_t level_specs[NUM_LEVELS] = {
        {LEVEL_1, LEVEL_1_THRESHOLD},
        {LEVEL_2, LEVEL_2_THRESHOLD},
        {LEVEL_3, LEVEL_3_THRESHOLD},
    };

    hmcslock_init(lock.hmcs_locks, NUM_LOCKS, level_specs, NUM_LEVELS);

    for (vuint32_t i = 0; i < MAX_THREADS; i++) {
        lock.leaf_locks[i] = hmcslock_which_lock(
            lock.hmcs_locks, NUM_LOCKS, level_specs, NUM_LEVELS, LEVEL_3, i);
    }
}

void
acquire(vuint32_t tid)
{
    const vuint32_t coreid = tid;
    hmcslock_acquire(lock.leaf_locks[coreid], &(ctx[tid].qnode), NUM_LEVELS);
}

void
release(vuint32_t tid)
{
    const vuint32_t coreid = tid;
    hmcslock_release(lock.leaf_locks[coreid], &(ctx[tid].qnode), NUM_LEVELS);
}
