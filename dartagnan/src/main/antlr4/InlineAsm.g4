grammar InlineAsm;

options {tokenVocab=InlineAsmLexer;}

asm                                 
    :
    (Quot(asmInstrEntries)*Quot)Comma (Quot(asmMetadataEntries) Quot) EOF?
;

asmInstrEntries : EndInstruction?((armInstr | riscvInstr | ppcInstr | x86Instr )(EndInstruction | Semi)*);
asmMetadataEntries : (constraint Comma)* clobbers;


armInstr 
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
riscvInstr : riscvFence;
ppcInstr : ppcFence;
x86Instr : x86Fence;

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
riscvFence : RISCVFence fenceOptions;

fenceOptions returns [String mode]
    :   RLiteral Comma RLiteral {$mode = "r r";}
    |   RLiteral Comma WLiteral {$mode = "r w";}
    |   RLiteral Comma RWLiteral {$mode = "r rw";}
    |   WLiteral Comma RLiteral {$mode = "w r";}
    |   WLiteral Comma WLiteral {$mode = "w w";}
    |   WLiteral Comma RWLiteral {$mode = "w rw";}
    |   RWLiteral Comma RLiteral {$mode = "rw r";}
    |   RWLiteral Comma WLiteral {$mode = "rw w";}
    |   RWLiteral Comma RWLiteral {$mode = "rw rw";}
    |   TsoFence {$mode = "tso";}
    |   ILiteral {$mode = "i";}
    ;

x86Fence : X86Fence;
ppcFence : PPCFence;

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