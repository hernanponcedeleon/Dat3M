grammar InlinePPC;

options {tokenVocab=InlinePPCLexer;}

asm                                 
    :
    (Quot(asmInstrEntries)*Quot)Comma (Quot(asmMetadataEntries) Quot) EOF?
;

asmInstrEntries : EndInstruction?(instr(EndInstruction | Semi)*);
asmMetadataEntries : (constraint Comma)* clobbers;


instr 
    : load 
    | loadReserve
    | store
    | storeConditional
    | compare
    | branchNotEqual
    | or
    | add
    | addImmediateCarry
    | subtractFrom
    | labelDefinition
    | ppcFence
;

load : Load register Comma register;
loadReserve : LoadReserve register Comma value Comma register;
compare : Compare value Comma register Comma register;
branchNotEqual : BranchNotEqual NumbersInline LetterInline;
store : Store register Comma register;
storeConditional : StoreConditional register Comma value Comma register; 
or : Or value Comma value Comma value;
add : Add register Comma register Comma register;
addImmediateCarry : AddImmediateCarry register Comma register Comma value;
subtractFrom : SubtractFrom register Comma register Comma register;
labelDefinition : NumbersInline Colon;
ppcFence : PPCFence;

// these are defined but not used
constraint : outputOpAssign | memoryAddress | inputOpGeneralReg | overlapInOutRegister | pointerToMemoryLocation;

outputOpAssign              : Equals Amp? RLiteral;
memoryAddress               : Ast? QCapitalLiteral | Equals Ast MLiteral;
inputOpGeneralReg           : RLiteral;
overlapInOutRegister        : NumbersInline;
pointerToMemoryLocation     : Ast MLiteral;

clobbers : clobber (Comma clobber)*;
clobber : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

expr : register | value;

register : Dollar NumbersInline;
value : NumbersInline;