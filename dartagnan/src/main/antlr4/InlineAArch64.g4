grammar InlineAArch64;

options {tokenVocab=InlineAArch64Lexer;}
/* each rule has the form asm sideeffect? "(instruction)*", "(metadata)*,~{clobber}*" */
asm                                 // vvv this one is because the staddl starts with \0A for some reason
    :
    (Quot(asmInstrEntries)*Quot)Comma (Quot(asmMetadataEntries)+ Quot)+ EOF?
;

asmInstrEntries : EndInstruction?((instr)EndInstruction?);
asmMetadataEntries : metaInstr(Comma metaInstr)*;


instr 
    : loadReg
    | loadAcquireReg
    | loadExclusiveReg
    | loadAcquireExclusiveReg
    | add
    | storeReg
    | storeExclusiveRegister
    | storeReleaseExclusiveReg
    | storeReleaseReg
    | atomicAddDoubleWordRelease
//    | dataMemoryBarrier captured by llvm + not needed if target is ARMv8
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
;

// rules divised like this in order to generate single visitors
loadReg : (LoadReg VariableInline)Comma ConstantInline;
loadAcquireReg : (LoadAcquireReg VariableInline)Comma ConstantInline;
loadExclusiveReg : (LoadExclusiveReg VariableInline)Comma ConstantInline;
loadAcquireExclusiveReg : (LoadAcquireExclusiveReg VariableInline)Comma ConstantInline;
add : ((Add VariableInline)Comma VariableInline)Comma VariableInline;
storeReg : (StoreReg VariableInline)Comma ConstantInline;
storeReleaseReg : (StoreReleaseReg VariableInline)Comma ConstantInline;
storeExclusiveRegister : ((StoreExclusiveRegister VariableInline)Comma VariableInline)Comma ConstantInline ;
storeReleaseExclusiveReg : ((StoreReleaseExclusiveReg VariableInline)Comma VariableInline)Comma ConstantInline;
atomicAddDoubleWordRelease : (AtomicAddDoubleWordRelease VariableInline)Comma ConstantInline;
dataMemoryBarrier : DataMemoryBarrier DataMemoryBarrierOpt; //atm it is catched by the visitorLlvm so it should not be mandatory
swapWordAcquire : ((SwapWordAcquire VariableInline)Comma VariableInline)Comma ConstantInline;
compare : (Compare VariableInline)Comma VariableInline;
compareBranchNonZero : (CompareBranchNonZero VariableInline)Comma LabelReference;
compareAndSwap : ((CompareAndSwap VariableInline)Comma VariableInline)Comma ConstantInline;
compareAndSwapAcquire :((CompareAndSwapAcquire VariableInline)Comma VariableInline)Comma ConstantInline;
move : (Move VariableInline)Comma VariableInline;
branchEqual : BranchEqual LabelReference;
branchNotEqual : BranchNotEqual LabelReference;
setEventLocally : SetEventLocally;
waitForEvent : WaitForEvent;
labelDefinition : LabelDefinition;
alignInline : AlignInline;
prefetchMemory : (PrefetchMemory PrefetchStoreL1Once)Comma ConstantInline;
yieldtask : YieldTask;






// Note that since there is an isA between metaINstr and its children, in the AST you get two nodes and I think it is ok, it might be useful for analysis purposes
metaInstr : metadataInline | clobber;
metadataInline : OutputOpAssign | IsMemoryAddress | InputOpGeneralReg | MetadataExtraVariables;

clobber : Tilde LBrace (ClobberMemory | ClobberModifyFlags) RBrace;

