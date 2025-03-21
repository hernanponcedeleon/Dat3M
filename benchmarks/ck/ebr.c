#include <inttypes.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <strings.h>
#include <unistd.h>
#include <sys/time.h>

#include "ck_cc.h"
#include "ck_pr.h"
#include "stdbool.h"
#include "stddef.h"
#include "ck_epoch.c"
#include "ck_stack.h"
#include <assert.h>

#ifndef NTHREADS
#define NTHREADS 4
#endif

static ck_stack_t stack = {NULL, NULL};
static ck_epoch_t stack_epoch;

static void *thread(void *arg)
{
	ck_epoch_record_t *record = (ck_epoch_record_t *)arg;

	// We do the registration in main to speed up verification (this removes a level of nondeterminism)

	ck_epoch_begin(record, NULL);
	int global_epoch = ck_pr_load_uint(&stack_epoch.epoch);
	int local_epoch = ck_pr_load_uint(&record->epoch);
	ck_epoch_end(record, NULL);

	// Check that local epoch is not too far behind global epoch (difference <= 2);
	assert(!(local_epoch == 1 && global_epoch == 3));

	ck_epoch_poll(record); // Try to increment global epoch

	return (NULL);
}

ck_epoch_record_t records[NTHREADS];

int main(int argc, char *argv[])
{
	pthread_t threads[NTHREADS];

	ck_epoch_init(&stack_epoch);

	for (int i = 0; i < NTHREADS; i++)
	{
		ck_epoch_register(&stack_epoch, &records[i], NULL);
		pthread_create(&threads[i], NULL, thread, &records[i]);
	}

	for (int i = 0; i < NTHREADS; i++)
		pthread_join(threads[i], NULL);

	return (0);
}
