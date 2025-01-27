grammar InlineAArch64;

options {tokenVocab=InlineAArch64Lexer;}
/* each rule has the form asm sideeffect? "(instruction)*", "(metadata)*,~{clobber}*" */
asm                                 // vvv this one is because the staddl starts with \0A for some reason
    :
    (Quot(asmInstrEntries)*Quot)Comma (Quot(asmMetadataEntries)+ Quot)+ EOF?
;

asmInstrEntries : EndInstruction?((armInstr | riscvInstr | ppcInstr | x86Instr )EndInstruction*);
asmMetadataEntries : metaInstr(Comma metaInstr)*;


armInstr 
    : loadReg
    | loadAcquireReg
    | loadExclusiveReg
    | loadAcquireExclusiveReg
    | add
    | sub
    | or 
    | and
    | storeReg
    | storeExclusiveRegister
    | storeReleaseExclusiveReg
    | storeReleaseReg
    | atomicAddDoubleWordRelease
    | swapWordAcquire
    | compare
    | compareBranchNonZero
    | compareAndSwap
    | compareAndSwapAcquire
    | move
    | branchEqual
    | branchNotEqual
    | setEventLocally
    | waitForEvent
    | labelDefinition
    | alignInline
    | prefetchMemory
    | yieldtask
    | asmFence
    | riscvFence
    | x86Fence
    | ppcFence
;
riscvInstr : riscvFence;
ppcInstr : ppcFence;
x86Instr : x86Fence;

// rules divised like this in order to generate single visitors
loadReg : (LoadReg register)Comma register;
loadAcquireReg : (LoadAcquireReg register)Comma register;
loadExclusiveReg : (LoadExclusiveReg register)Comma register;
loadAcquireExclusiveReg : (LoadAcquireExclusiveReg register)Comma register;
add : ((Add register)Comma register)Comma register;
sub : ((Sub register)Comma register)Comma register;
or : ((Or register)Comma register)Comma register;
and : ((And register)Comma register)Comma register;
storeReg : (StoreReg register)Comma register;
storeReleaseReg : (StoreReleaseReg register)Comma register;
storeExclusiveRegister : ((StoreExclusiveRegister register)Comma register)Comma register ;
storeReleaseExclusiveReg : ((StoreReleaseExclusiveReg register)Comma register)Comma register;
atomicAddDoubleWordRelease : (AtomicAddDoubleWordRelease register)Comma register;
swapWordAcquire : ((SwapWordAcquire register)Comma register)Comma register;
compare : (Compare register)Comma register;
compareBranchNonZero : (CompareBranchNonZero register)Comma LabelReference;
compareAndSwap : ((CompareAndSwap register)Comma register)Comma register;
compareAndSwapAcquire :((CompareAndSwapAcquire register)Comma register)Comma register;
move : (Move register)Comma register;
branchEqual : BranchEqual LabelReference;
branchNotEqual : BranchNotEqual LabelReference;
setEventLocally : SetEventLocally;
waitForEvent : WaitForEvent;
labelDefinition : LabelDefinition;
alignInline : AlignInline;
prefetchMemory : (PrefetchMemory PrefetchStoreL1Once)Comma register;
yieldtask : YieldTask;

//fences
// fence : DataMemoryBarrier FenceArmOpt | DataSynchronizationBarrier FenceArmOpt | RISCVFence FenceRISCVOpt | RISCVFence FenceRISCVOpt Comma FenceRISCVOpt | X86Fence | PPCFence;
asmFence : DataMemoryBarrier FenceArmOpt | DataSynchronizationBarrier FenceArmOpt;
riscvFence : RISCVFence FenceRISCVOpt | RISCVFence FenceRISCVOpt Comma FenceRISCVOpt;
x86Fence : X86Fence;
ppcFence : PPCFence;

// Note that since there is an isA between metaINstr and its children, in the AST you get two nodes and I think it is ok, it might be useful for analysis purposes
metaInstr : clobber | flag;
clobber : OutputOpAssign | IsMemoryAddress | InputOpGeneralReg | OverlapInOutRegister | PointerToMemoryLocation;

flag : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

register : Register;