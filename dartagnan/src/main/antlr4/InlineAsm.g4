grammar InlineAsm;

options {tokenVocab=InlineAsmLexer;}

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
compareBranchNonZero : CompareBranchNonZero register Comma NumbersInline LetterInline;
move : Move register Comma register;
branchEqual : BranchEqual NumbersInline LetterInline;
branchNotEqual : BranchNotEqual NumbersInline LetterInline;
setEventLocally : SetEventLocally;
waitForEvent : WaitForEvent;
labelDefinition : NumbersInline Colon;
alignInline : AlignInline;
prefetchMemory : PrefetchMemory PrefetchStoreL1Once Comma register;
yieldtask : YieldTask;

//fences
armFence : (DataMemoryBarrier | DataSynchronizationBarrier) FenceArmOpt;

constraint : outputOpAssign | memoryAddress | inputOpGeneralReg | overlapInOutRegister | pointerToMemoryLocation;

outputOpAssign              : Equals Amp? RLiteral;
memoryAddress               : Ast? QCapitalLiteral;
inputOpGeneralReg           : RLiteral;
overlapInOutRegister        : NumbersInline;
pointerToMemoryLocation     : Equals Ast MLiteral;

clobbers : clobber (Comma clobber)*;
clobber : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

expr : register | value;

register : Dollar NumbersInline | Dollar LBrace NumbersInline RegisterSizeHint RBrace | LBracket Dollar NumbersInline RBracket;
value : Num NumbersInline;
