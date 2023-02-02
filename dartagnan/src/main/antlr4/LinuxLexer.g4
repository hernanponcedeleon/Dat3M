lexer grammar LinuxLexer;

AtomicAddReturnRelaxed     :   'atomic_add_return_relaxed';
AtomicAddReturnAcquire     :   'atomic_add_return_acquire';
AtomicAddReturnRelease     :   'atomic_add_return_release';
AtomicAddReturn            :   'atomic_add_return';

AtomicSubReturnRelaxed     :   'atomic_sub_return_relaxed';
AtomicSubReturnAcquire     :   'atomic_sub_return_acquire';
AtomicSubReturnRelease     :   'atomic_sub_return_release';
AtomicSubReturn            :   'atomic_sub_return';

AtomicIncReturnRelaxed     :   'atomic_inc_return_relaxed';
AtomicIncReturnAcquire     :   'atomic_inc_return_acquire';
AtomicIncReturnRelease     :   'atomic_inc_return_release';
AtomicIncReturn            :   'atomic_inc_return';

AtomicDecReturnRelaxed     :   'atomic_dec_return_relaxed';
AtomicDecReturnAcquire     :   'atomic_dec_return_acquire';
AtomicDecReturnRelease     :   'atomic_dec_return_release';
AtomicDecReturn            :   'atomic_dec_return';

AtomicFetchAddRelaxed      :   'atomic_fetch_add_relaxed';
AtomicFetchAddAcquire      :   'atomic_fetch_add_acquire';
AtomicFetchAddRelease      :   'atomic_fetch_add_release';
AtomicFetchAdd             :   'atomic_fetch_add';

AtomicFetchSubRelaxed      :   'atomic_fetch_sub_relaxed';
AtomicFetchSubAcquire      :   'atomic_fetch_sub_acquire';
AtomicFetchSubRelease      :   'atomic_fetch_sub_release';
AtomicFetchSub             :   'atomic_fetch_sub';

AtomicAdd                  :   'atomic_add';
AtomicSub                  :   'atomic_sub';
AtomicInc                  :   'atomic_inc';
AtomicDec                  :   'atomic_dec';

AtomicFetchInc             :   'atomic_fetch_inc';
AtomicFetchIncRelaxed      :   'atomic_fetch_inc_relaxed';
AtomicFetchIncAcquire      :   'atomic_fetch_inc_acquire';
AtomicFetchIncRelease      :   'atomic_fetch_inc_release';

AtomicFetchDecRelaxed      :   'atomic_fetch_dec_relaxed';
AtomicFetchDecAcquire      :   'atomic_fetch_dec_acquire';
AtomicFetchDecRelease      :   'atomic_fetch_dec_release';
AtomicFetchDec             :   'atomic_fetch_dec';

AtomicSubAndTest           :   'atomic_sub_and_test';
AtomicIncAndTest           :   'atomic_inc_and_test';
AtomicDecAndTest           :   'atomic_dec_and_test';

AtomicAddUnless            :   'atomic_add_unless';

AtomicCmpXchgRelaxed       :   'atomic_cmpxchg_relaxed';
AtomicCmpXchgAcquire       :   'atomic_cmpxchg_acquire';
AtomicCmpXchgRelease       :   'atomic_cmpxchg_release';
AtomicCmpXchg              :   'atomic_cmpxchg';

CmpXchgRelaxed             :   'cmpxchg_relaxed';
CmpXchgAcquire             :   'cmpxchg_acquire';
CmpXchgRelease             :   'cmpxchg_release';
CmpXchg                    :   'cmpxchg';

AtomicXchgRelaxed          :   'atomic_xchg_relaxed';
AtomicXchgAcquire          :   'atomic_xchg_acquire';
AtomicXchgRelease          :   'atomic_xchg_release';
AtomicXchg                 :   'atomic_xchg';

XchgRelaxed                :   'xchg_relaxed';
XchgAcquire                :   'xchg_acquire';
XchgRelease                :   'xchg_release';
Xchg                       :   'xchg';

AtomicReadAcquire          :   'atomic_read_acquire';
AtomicRead                 :   'atomic_read';

SmpLoadAcquire             :   'smp_load_acquire';
SmpStoreRelease            :   'smp_store_release';
SmpStoreMb                 :   'smp_store_mb';

AtomicSetRelease           :   'atomic_set_release';
AtomicSet                  :   'atomic_set';

AtomicInit                 :   'ATOMIC_INIT';
ReadOnce                   :   'READ_ONCE';
WriteOnce                  :   'WRITE_ONCE';

RcuReadLock                :   'rcu_read_lock';
RcuReadUnlock              :   'rcu_read_unlock';
RcuSyncExpedited           :   'synchronize_rcu_expedited';
RcuSync                    :   'synchronize_rcu';
RcuDereference             :   'rcu_dereference';
RcuAssignPointer           :   'rcu_assign_pointer';

SrcuReadLock                :   'srcu_read_lock';
SrcuReadUnlock              :   'srcu_read_unlock';
SrcuSync                    :   'synchronize_srcu';

SpinTrylock                :   'spin_trylock';
SpiIsLocked                :   'spin_is_locked';
SpinUnlockWait             :   'spin_unlock_wait';
SpinUnlock                 :   'spin_unlock';
SpinLock                   :   'spin_lock';

FenceSmpMbBeforeAtomic     :   'smp_mb__before_atomic';
FenceSmpMbAfterAtomic      :   'smp_mb__after_atomic';
FenceSmpMbAfterSpinLock    :   'smp_mb__after_spinlock';
FenceSmpMbAfterUnlockLock  :   'smp_mb__after_unlock_lock';
FenceSmpMb                 :   'smp_mb';
FenceSmpWMb                :   'smp_wmb';
FenceSmpRMb                :   'smp_rmb';
