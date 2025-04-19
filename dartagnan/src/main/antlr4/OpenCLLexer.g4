lexer grammar OpenCLLexer;

OpenCLGlobalSpace             :   'global';
OpenCLLocalSpace              :   'local';

OpenCLWG                      :   'wg';
OpenCLDEV                     :   'dev';

OpenCLAtomicFenceWI           :   'atomic_work_item_fence';
OpenCLBarrier                 :   'barrier';

OpenCLMemoryScopeWI           :   'memory_scope_work_item';
OpenCLMemoryScopeSG           :   'memory_scope_sub_group';
OpenCLMemoryScopeWG           :   'memory_scope_work_group';
OpenCLMemoryScopeDEV          :   'memory_scope_device';
OpenCLMemoryScopeALL          :   'memory_scope_all_svm_devices';

OpenCLFenceFlagGL             :   'CLK_GLOBAL_MEM_FENCE';
OpenCLFenceFlagLC             :   'CLK_LOCAL_MEM_FENCE';
