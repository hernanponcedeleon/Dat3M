grammar AsmRISCV;

options {tokenVocab=AsmRISCVLexer;}

asm                                 
    :
    (Quot(riscvInstrEntries)*Quot)Comma (Quot(asmMetadataEntries) Quot) EOF?
;

riscvInstrEntries : EndInstruction?(instr(EndInstruction | Semi)*);
asmMetadataEntries : (constraint Comma)* clobbers;


instr
    : load
    | loadImmediate
    | loadExclusive
    | loadAcquireExclusive
    | add
    | sub
    | store
    | storeConditional
    | storeConditionalRelease
    | move
    | branchNotEqual
    | branchNotEqualZero
    | labelDefinition
    | riscvFence
    | negate
    | atomicAdd
    | atomicAddRelease
    | atomicAddAcquireRelease
;

// rules divised like this in order to generate single visitors
load : Load register Comma value LPar register RPar;
loadImmediate : LoadImmediate register Comma value;
loadExclusive : LoadExclusive register Comma register;
loadAcquireExclusive : LoadAcquireExclusive register Comma register;
add : Add register Comma register Comma register;
sub : Sub register Comma register Comma register;
store : Store register Comma value LPar register RPar;
storeConditional : StoreConditional register Comma register Comma register ;
storeConditionalRelease : StoreConditionalRelease register Comma register Comma register;
move : Move register Comma register;
branchNotEqual : BranchNotEqual register Comma register Comma Numbers Literal;
branchNotEqualZero : BranchNotEqualZero register Comma Numbers Literal;
labelDefinition : Numbers Colon;
negate : Negate register Comma register;
atomicAdd : AtomicAdd register Comma register Comma register;
atomicAddRelease : AtomicAddRelease register Comma register Comma register;
atomicAddAcquireRelease : AtomicAddAcquireRelease register Comma register Comma register;
value : Numbers;


//fences
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

constraint : outputOpAssign | inputOpGeneralReg | overlapInOutRegister;

outputOpAssign              : Equals (Amp? RLiteral | ACapitalLiteral);
inputOpGeneralReg           : RLiteral | ACapitalLiteral | Equals Ast MLiteral;
overlapInOutRegister        : Numbers;

clobbers : clobber (Comma clobber)*;
clobber : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

register : Dollar Numbers;
