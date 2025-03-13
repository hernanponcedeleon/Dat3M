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
    | compare
    | branchNotEqual
    | store
    | storeConditional
    | or
    | add
    | addImmediateCarry
    | subtractFrom
    | labelDefinition
    | ppcFence
;

load : Load register Comma register;
loadReserve : LoadReserve register Comma NumbersInline Comma register;
compare : Compare NumbersInline Comma register Comma register;
branchNotEqual : BranchNotEqual NumbersInline LetterInline;
store : Store register Comma register;
storeConditional : StoreConditional register Comma NumbersInline Comma register; 
or : Or NumbersInline Comma NumbersInline Comma NumbersInline;
add : Add register Comma register Comma register;
addImmediateCarry : AddImmediateCarry register Comma register Comma NumbersInline;
subtractFrom : SubtractFrom register Comma register Comma register;
labelDefinition : NumbersInline Colon;
ppcFence : PPCFence;

// these are defined but not used
constraint : outputOpAssign | memoryAddress | inputOpGeneralReg | overlapInOutRegister | pointerToMemoryLocation;

outputOpAssign              : Equals Amp? RLiteral;
memoryAddress               : Ast? QCapitalLiteral;
inputOpGeneralReg           : RLiteral;
overlapInOutRegister        : NumbersInline;
pointerToMemoryLocation     : Equals? Ast MLiteral;

clobbers : clobber (Comma clobber)*;
clobber : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

expr : register | value;

register : Dollar NumbersInline;
value : ConstantValue;