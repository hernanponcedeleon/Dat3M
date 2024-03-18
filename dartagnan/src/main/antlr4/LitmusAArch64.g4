grammar LitmusAArch64;

import LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.integers.*;
import static com.dat3m.dartagnan.program.event.Tag.ARMv8.*;
}

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? EOF
    ;

variableDeclaratorList
    :   LBrace variableDeclarator? (Semi variableDeclarator)* Semi? RBrace Semi?
    ;

variableDeclarator
    :   variableDeclaratorLocation
    |   variableDeclaratorRegister
    |   variableDeclaratorRegisterLocation
    |   variableDeclaratorLocationLocation
    ;

variableDeclaratorLocation
    :   location Equals constant
    ;

variableDeclaratorRegister
    :   threadId Colon register64 Equals constant
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register64 Equals Amp? location
    ;

variableDeclaratorLocationLocation
    :   location Equals Amp? location
    ;

variableList
    :   Locations LBracket variable (Semi variable)* Semi? RBracket
    ;

variable
    :   location
    |   threadId Colon register64
    ;

program
    :   threadDeclaratorList instructionList
    ;

threadDeclaratorList
    :   threadId (Bar threadId)* Semi
    ;

instructionList
    :   (instructionRow)+
    ;

instructionRow
    :   instruction (Bar instruction)* Semi
    ;

instruction
    :
    |   mov
    |   arithmetic
    |   load
    |   loadExclusive
    |   store
    |   storeExclusive
    |   cmp
    |   branch
    |   branchRegister
    |   branchLabel
    |   fence
    ;

mov locals [String rD, int size]
    :   MovInstruction r32 = register32 Comma expr32 {$rD = $r32.id; $size = 32;}
    |   MovInstruction r64 = register64 Comma expr64 {$rD = $r64.id; $size = 64;}
    ;

cmp locals [String rD, int size]
    :   CmpInstruction r32 = register32 Comma expr32 {$rD = $r32.id; $size = 32;}
    |   CmpInstruction r64 = register64 Comma expr64 {$rD = $r64.id; $size = 64;}
    ;

arithmetic locals [String rD, String rV, int size]
    :   arithmeticInstruction rD32 = register32 Comma rV32 = register32 Comma expr32 {$rD = $rD32.id; $rV = $rV32.id; $size = 32;}
    |   arithmeticInstruction rD64 = register64 Comma rV64 = register64 Comma expr64 {$rD = $rD64.id; $rV = $rV64.id; $size = 64;}
    ;

load  locals [String rD, int size]
    :   loadInstruction rD32 = register32 Comma LBracket address (Comma offset)? RBracket {$rD = $rD32.id; $size = 32;}
    |   loadInstruction rD64 = register64 Comma LBracket address (Comma offset)? RBracket {$rD = $rD64.id; $size = 64;}
    ;

loadExclusive  locals [String rD, int size]
    :   loadExclusiveInstruction rD32 = register32 Comma LBracket address (Comma offset)? RBracket {$rD = $rD32.id; $size = 32;}
    |   loadExclusiveInstruction rD64 = register64 Comma LBracket address (Comma offset)? RBracket {$rD = $rD64.id; $size = 64;}
    ;

store  locals [String rV, int size]
    :   storeInstruction rV32 = register32 Comma LBracket address (Comma offset)? RBracket {$rV = $rV32.id; $size = 32;}
    |   storeInstruction rV64 = register64 Comma LBracket address (Comma offset)? RBracket {$rV = $rV64.id; $size = 64;}
    ;

storeExclusive  locals [String rS, String rV, int size]
    :   storeExclusiveInstruction rS32 = register32 Comma rV32 = register32 Comma LBracket address (Comma offset)? RBracket {$rS = $rS32.id; $rV = $rV32.id; $size = 32;}
    |   storeExclusiveInstruction rS32 = register32 Comma rV64 = register64 Comma LBracket address (Comma offset)? RBracket {$rS = $rS32.id; $rV = $rV64.id; $size = 64;}
    ;

fence locals [String opt]
    :   Fence {$opt = "SY";}
    |   Fence FenceOpt {$opt = $FenceOpt.text;}
    ;

branch
    :   BranchInstruction (Period branchCondition)? label
    ;

branchRegister locals [String rV, int size]
    :   branchRegInstruction rV32 = register32 Comma label {$rV = $rV32.id; $size = 32;}
    |   branchRegInstruction rV64 = register64 Comma label {$rV = $rV64.id; $size = 64;}
    ;

branchLabel
    :   label Colon
    ;

loadInstruction locals [String mo]
    :   LDR     {$mo = MO_RX;}
    |   LDAR    {$mo = MO_ACQ;}
    ;

loadExclusiveInstruction locals [String mo]
    :   LDXR    {$mo = MO_RX;}
    |   LDAXR   {$mo = MO_ACQ;}
    ;

storeInstruction locals [String mo]
    :   STR     {$mo = MO_RX;}
    |   STLR    {$mo = MO_REL;}
    ;

storeExclusiveInstruction locals [String mo]
    :   STXR    {$mo = MO_RX;}
    |   STLXR   {$mo = MO_REL;}
    ;

arithmeticInstruction locals [IntBinaryOp op]
    :   ADD     { $op = IntBinaryOp.ADD; }
//    |   ADDS    { throw new RuntimeException("Instruction ADDS is not implemented"); }
    |   SUB     { $op = IntBinaryOp.SUB; }
//    |   SUBS    { throw new RuntimeException("Instruction SUBS is not implemented"); }
//    |   ADC     { throw new RuntimeException("Instruction ADC is not implemented"); }
//    |   ADCS    { throw new RuntimeException("Instruction ADCS is not implemented"); }
//    |   SBC     { throw new RuntimeException("Instruction SBC is not implemented"); }
//    |   SBCS    { throw new RuntimeException("Instruction SBCS is not implemented"); }
    |   AND     { $op = IntBinaryOp.AND; }
    |   ORR     { $op = IntBinaryOp.OR; }
    |   EOR     { $op = IntBinaryOp.XOR; }
//    |   BIC     { throw new RuntimeException("Instruction BIC is not implemented"); }
//    |   ORN     { throw new RuntimeException("Instruction ORN is not implemented"); }
//    |   EON     { throw new RuntimeException("Instruction EON is not implemented"); }
    ;

branchCondition returns [IntCmpOp op]
    :   EQ {$op = IntCmpOp.EQ;}
    |   NE {$op = IntCmpOp.NEQ;}
    |   GE {$op = IntCmpOp.GTE;}
    |   LE {$op = IntCmpOp.LTE;}
    |   GT {$op = IntCmpOp.GT;}
    |   LT {$op = IntCmpOp.LT;}
//    |   CS
//    |   HS
//    |   CC
//    |   LO
//    |   MI
//    |   PL
//    |   VS
//    |   VC
//    |   HI
//    |   LS
//    |   AL
    ;

branchRegInstruction returns [IntCmpOp op]
    :   CBZ     {$op = IntCmpOp.EQ;}
    |   CBNZ    {$op = IntCmpOp.NEQ;}
    ;

shiftOperator returns [IntBinaryOp op]
    :   LSL { $op = IntBinaryOp.LSHIFT; }
    |   LSR { $op = IntBinaryOp.RSHIFT; }
    |   ASR { $op = IntBinaryOp.ARSHIFT; }
    ;

expr64
    :   expressionRegister64
    |   expressionImmediate
    |   expressionConversion
    ;

expr32
    :   expressionRegister32
    |   expressionImmediate
    ;

offset
    :   immediate
    |   expressionConversion
    ;

shift
    :   Comma shiftOperator immediate
    ;

expressionRegister64
    :   register64 shift?
    ;

expressionRegister32
    :   register32 shift?
    ;

expressionImmediate
    :   immediate shift?
    ;

expressionConversion
    :   register32 Comma BitfieldOperator
    ;

address returns[String id]
    :   r = register64 {$id = $r.id;}
    ;

register64 returns[String id]
    :   r = Register64 {$id = $r.text;}
    ;

register32 returns[String id]
    :   r = Register32 {$id = $r.text.replace("W","X");}
    ;

location
    :   Identifier
    ;

immediate
    :   Num constant
    ;

label
    :   Identifier
    ;

assertionValue
    :   location
    |   threadId Colon register64
    |   constant
    ;

Locations
    :   'locations'
    ;

// Arthmetic instructions

ADD     :   'ADD'   ;   // Add
ADDS    :   'ADDS'  ;   // Add and set flag
SUB     :   'SUB'   ;   // Sub
SUBS    :   'SUBS'  ;   // Sub and set flag
ADC     :   'ADC'   ;   // Add and use carry flag
ADCS    :   'ADCS'  ;   // Add and use carry flag and set carry flag
SBC     :   'SBC'   ;   // Sub and use carry flag
SBCS    :   'SBCS'  ;   // Sub and use carry flag and set carry flag
AND     :   'AND'   ;   // Logical AND
ORR     :   'ORR'   ;   // Logical OR
EOR     :   'EOR'   ;   // Logical XOR
BIC     :   'BIC'   ;   // Invert and AND (Bitwise Bit Clear)
ORN     :   'ORN'   ;   // Invert and OR
EON     :   'EON'   ;   // Invert and XOR

// Load instructions

LDR    :   'LDR'    ;
LDAR   :   'LDAR'   ;
LDXR   :   'LDXR'   ;
LDAXR  :   'LDAXR'  ;

// Store instructions

STR    :   'STR'    ;
STLR   :   'STLR'   ;
STXR   :   'STXR'   ;
STLXR  :   'STLXR'   ;

MovInstruction
    :   'MOV'
    ;

CmpInstruction
    :   'CMP'
    ;

BranchInstruction
    :   'B'
    ;

Fence
    :   'DMB'
    |   'DSB'
    |   'ISB'
    ;

FenceOpt
    :   'SY'    |   'sy'        // Full barrier (default)
    |   'LD'    |   'ld'        // Loads only
    |   'ST'    |   'st'        // Stores only
    |   'ISHLD' |   'ishld'     // Loads only and inner sharable domain only
    |   'NSHLD' |   'nshld'     // Loads only and out to the point of unification only
    |   'OSHLD' |   'oshld'     // Loads only and outer sharable domain only
    |   'ISHST' |   'ishsd'     // Stores only and inner sharable domain only
    |   'NSHST' |   'nshst'     // Stores only and out to the point of unification only
    |   'OSHST' |   'oshst'     // Stores only and outer sharable domain only
    |   'ISH'   |   'ish'       // Inner sharable domain only
    |   'NSH'   |   'nsh'       // Out to the point of unification only
    |   'OSH'   |   'osh'       // Outer sharable domain only
    ;

// Bracnch conditions

EQ  :   'EQ';    // Equal
NE  :   'NE';    // Not equal
CS  :   'CS';    // Carry set
HS  :   'HS';    // Identical to CS
CC  :   'CC';    // Carry clear
LO  :   'LO';    // Identical to CC
MI  :   'MI';	 // Minus or negative result
PL  :   'PL';    // Positive or zero result
VS  :   'VS';    // Overflow
VC  :   'VC';    // No overflow
HI  :   'HI';    // Unsigned higher
LS  :   'LS';    // Unsigned lower or same
GE  :   'GE';    // Signed greater than or equal
LT  :   'LT';    // Signed less than
GT  :   'GT';    // Signed greater than
LE  :   'LE';    // Signed less than or equal
AL  :   'AL';    // Always (this is the default)

// Branch conditions shortcut instructions

CBZ     :   'CBZ';      // Branch if zero
CBNZ    :   'CBNZ';     // Branch if not zero

// Shift operators

LSL :   'LSL';   // Logical shift left
LSR :   'LSR';   // Logical shift right
ASR :   'ASR';   // Arithmetic shift right (preserves sign bit)

BitfieldOperator
    :   'UXTW' // Zero extends a 32-bit word (unsigned)
    |   'SXTW' // Zero extends a 32-bit word (signed)
    ;

Register64
    :   'X' DigitSequence
    ;

Register32
    :   'W' DigitSequence
    ;

LitmusLanguage
    :   'AArch64'
    ;