#ifndef MAX_THREADS
#define MAX_THREADS 2
#endif

#define GP_PHASE 0x10000
#define CS_MASK 0x0ffff
static unsigned long rc[MAX_THREADS] = {0};
static unsigned long gc = 1;
static spinlock_t gp_lock;

__thread int tid;
#define get_my_tid() tid;

#ifdef RCUIMP
void rcu_read_lock(void) {
    unsigned int i = get_my_tid();
    unsigned long tmp = READ_ONCE(rc[i]);
    if (!(tmp & CS_MASK)) {
        WRITE_ONCE(rc[i], READ_ONCE(gc));
        smp_mb();
    } else {
        WRITE_ONCE(rc[i], tmp + 1);
    }
}

void rcu_read_unlock(void) { unsigned int i = get_my_tid();
    smp_mb();
    WRITE_ONCE(rc[i], READ_ONCE(rc[i]) - 1);
}

static int gp_ongoing(unsigned int i) {
    unsigned long val = READ_ONCE(rc[i]);
    return (val & CS_MASK) && ((val ^ READ_ONCE(gc)) & GP_PHASE);
}

static void update_counter_and_wait(void) {
    unsigned int i;
    WRITE_ONCE(gc, READ_ONCE(gc) ^ GP_PHASE);
    for (i = 0; i < MAX_THREADS; i++) {
        while (gp_ongoing(i)) {
            //            msleep(10);
        }
    }
}

void synchronize_rcu(void) {
    smp_mb();
    spin_lock(&gp_lock);
    update_counter_and_wait();
    update_counter_and_wait();
    spin_unlock(&gp_lock);
    smp_mb();
}
#else
#define rcu_read_lock() __LKMM_FENCE(RCU_LOCK)
#define rcu_read_unlock() __LKMM_FENCE(RCU_UNLOCK)
#define synchronize_rcu() __LKMM_FENCE(RCU_SYNC)
#endif
