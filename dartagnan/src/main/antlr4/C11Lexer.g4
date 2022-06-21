lexer grammar C11Lexer;

C11AtomicLoad                 :   'atomic_load_explicit';
C11AtomicStore                :   'atomic_store_explicit';
C11AtomicSCAS                 :   'atomic_compare_exchange_strong_explicit';
C11AtomicWCAS                 :   'atomic_compare_exchange_weak_explicit';
C11AtomicFence                :   'atomic_thread_fence';
C11AtomicAdd                  :   'atomic_fetch_add_explicit';
C11AtomicSub                  :   'atomic_fetch_sub_explicit';
C11AtomicOr                   :   'atomic_fetch_or_explicit';
C11AtomicXor                  :   'atomic_fetch_xor_explicit';
C11AtomicAnd                  :   'atomic_fetch_and_explicit';
