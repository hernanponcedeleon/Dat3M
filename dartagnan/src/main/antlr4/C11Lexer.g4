lexer grammar C11Lexer;

C11AtomicLoad                 :   'atomic_load_explicit';
C11AtomicStore                :   'atomic_store_explicit';
C11AtomicSCAS                 :   'atomic_compare_exchange_strong_explicit';
C11AtomicWCAS                 :   'atomic_compare_exchange_weak_explicit';
C11AtomicFence                :   'atomic_thread_fence';
