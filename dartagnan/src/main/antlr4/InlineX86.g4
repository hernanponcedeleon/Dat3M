grammar InlineX86;

options {tokenVocab=InlineX86Lexer;}

asm                                 
    :
    (Quot(asmInstrEntries)*Quot)Comma (Quot(asmMetadataEntries) Quot) EOF?
;

asmInstrEntries : EndInstruction?(instr(EndInstruction | Semi)*);
asmMetadataEntries : (constraint Comma)* clobbers;


instr :
    x86Fence
;

x86Fence : X86Fence;

// these are defined but not used
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

register : Dollar NumbersInline;
value : ConstantValue;