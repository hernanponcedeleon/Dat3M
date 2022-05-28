#include <stdlib.h>
#include <pthread.h>
#include <assert.h>
#include <lkmm.h>
#include <rcu.h>

int x0, x1, x2, x3, x4, x5, x6;
int r1_1, r2_1, r1_2, r2_2, r1_3, r2_3, r1_4, r2_4, r1_5, r2_5, r1_6, r2_6, r1_7, r2_7;

void *thread_1(void *arg) {
	r1_1 = READ_ONCE(x0);
	synchronize_rcu();
	r2_1 = READ_ONCE(x1);
	return NULL;
}

void *thread_2(void *arg) {
	r1_2 = READ_ONCE(x1);
	synchronize_rcu();
	r2_2 = READ_ONCE(x2);
	return NULL;
}

void *thread_3(void *arg) {
	r1_3 = READ_ONCE(x2);
	synchronize_rcu();
	r2_3 = READ_ONCE(x3);
	return NULL;
}

void *thread_4(void *arg) {
	r1_4 = READ_ONCE(x3);
	synchronize_rcu();
	r2_4 = READ_ONCE(x4);
	return NULL;
}

void *thread_5(void *arg) {
	rcu_read_lock();
	r1_5 = READ_ONCE(x4);
	r2_5 = READ_ONCE(x5);
	rcu_read_unlock();
	return NULL;
}

void *thread_6(void *arg) {
	rcu_read_lock();
	r1_6 = READ_ONCE(x5);
	r2_6 = READ_ONCE(x6);
	rcu_read_unlock();
	return NULL;
}

void *thread_7(void *arg) {
	rcu_read_lock();
	r1_7 = READ_ONCE(x6);
	r2_7 = READ_ONCE(x0);
	rcu_read_unlock();
	return NULL;
}

void *thread_8(void *arg) {
	WRITE_ONCE(x0, 1);
	WRITE_ONCE(x1, 1);
	WRITE_ONCE(x2, 1);
	WRITE_ONCE(x3, 1);
	WRITE_ONCE(x4, 1);
	WRITE_ONCE(x5, 1);
	WRITE_ONCE(x6, 1);
	return NULL;
}

int main()
{

    init_rcu();
    
    pthread_t t1, t2, t3, t4, t5, t6, t7, t8;

	pthread_create(&t1, NULL, thread_1, NULL);
	pthread_create(&t2, NULL, thread_2, NULL);
	pthread_create(&t3, NULL, thread_3, NULL);
	pthread_create(&t4, NULL, thread_4, NULL);
	pthread_create(&t5, NULL, thread_5, NULL);
	pthread_create(&t6, NULL, thread_6, NULL);
	pthread_create(&t7, NULL, thread_7, NULL);
	pthread_create(&t8, NULL, thread_8, NULL);
	
	pthread_join(t1, NULL);
	pthread_join(t2, NULL);
	pthread_join(t3, NULL);
	pthread_join(t4, NULL);
	pthread_join(t5, NULL);
	pthread_join(t6, NULL);
	pthread_join(t7, NULL);
	pthread_join(t8, NULL);

	assert(!((r2_7 == 0 && r1_1 == 1 && r2_1 == 0 && r1_2 == 1 && r2_2 == 0 && r1_3 == 1 && r2_3 == 0 && r1_4 == 1 && r2_4 == 0 && r1_5 == 1 && r2_5 == 0 && r1_6 == 1 && r2_6 == 0 && r1_7 == 1)));

	return 0;
}
