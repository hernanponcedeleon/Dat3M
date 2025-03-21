grammar Arm;

options {tokenVocab=ArmLexer;}

asm                                 
    :
    (Quot(asmInstrEntries)*Quot)Comma (Quot(asmMetadataEntries) Quot) EOF?
;

asmInstrEntries : EndInstruction?( instr (EndInstruction | Semi)*);
asmMetadataEntries : (constraint Comma)* clobbers;


instr 
    : load
    | loadAcquire
    | loadExclusive
    | loadAcquireExclusive
    | add
    | sub
    | or 
    | and
    | store
    | storeExclusive
    | storeReleaseExclusive
    | storeRelease
    | compare
    | compareBranchNonZero
    | move
    | branchEqual
    | branchNotEqual
    | setEventLocally
    | waitForEvent
    | labelDefinition
    | alignInline
    | prefetchMemory
    | yieldtask
    | armFence
;

// rules divised like this in order to generate single visitors
load : Load register Comma register;
loadAcquire : LoadAcquire register Comma register;
loadExclusive : LoadExclusive register Comma register;
loadAcquireExclusive : LoadAcquireExclusive register Comma register;
add : Add register Comma register Comma expr;
sub : Sub register Comma register Comma expr;
or : Or register Comma register Comma register;
and : And register Comma register Comma register;
store : Store register Comma register;
storeRelease : StoreRelease register Comma register;
storeExclusive : StoreExclusive register Comma register Comma register ;
storeReleaseExclusive : StoreReleaseExclusive register Comma register Comma register;
compare : Compare register Comma expr;
compareBranchNonZero : CompareBranchNonZero register Comma Numbers Literal;
move : Move register Comma register;
branchEqual : BranchEqual Numbers Literal;
branchNotEqual : BranchNotEqual Numbers Literal;
setEventLocally : SetEventLocally;
waitForEvent : WaitForEvent;
labelDefinition : Numbers Colon;
alignInline : AlignInline;
prefetchMemory : PrefetchMemory PrefetchStoreL1Once Comma register;
yieldtask : YieldTask;

//fences
armFence : (DataMemoryBarrier | DataSynchronizationBarrier) FenceArmOpt;

constraint : outputOpAssign | memoryAddress | inputOpGeneralReg | overlapInOutRegister | pointerToMemoryLocation;

outputOpAssign              : Equals Amp? RLiteral;
memoryAddress               : Ast? QCapitalLiteral;
inputOpGeneralReg           : RLiteral;
overlapInOutRegister        : Numbers;
pointerToMemoryLocation     : Equals Ast MLiteral;

clobbers : clobber (Comma clobber)*;
clobber : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

expr : register | value;

register : Dollar Numbers | Dollar LBrace Numbers RegisterSizeHint RBrace | LBracket Dollar Numbers RBracket;
value : Num Numbers;
