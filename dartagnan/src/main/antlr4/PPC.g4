grammar PPC;

options {tokenVocab=PPCLexer;}

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
branchNotEqual : BranchNotEqual Numbers Literal;
store : Store register Comma register;
storeConditional : StoreConditional register Comma value Comma register; 
or : Or value Comma value Comma value;
add : Add register Comma register Comma register;
addImmediateCarry : AddImmediateCarry register Comma register Comma value;
subtractFrom : SubtractFrom register Comma register Comma register;
labelDefinition : Numbers Colon;
ppcFence : PPCFence;

// these are defined but not used
constraint : outputOpAssign | inputOpGeneralReg | overlapInOutRegister;

outputOpAssign              : Equals Amp? RLiteral;
inputOpGeneralReg           : RLiteral | Equals? Ast MLiteral;
overlapInOutRegister        : Numbers;

clobbers : clobber (Comma clobber)*;
clobber : Tilde LBrace clobberType RBrace;

clobberType : ClobberMemory | ClobberModifyFlags | ClobberDirectionFlag | ClobberFlags | ClobberFloatPntStatusReg;

register : Dollar Numbers;
value : Numbers;