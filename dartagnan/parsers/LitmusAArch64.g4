grammar LitmusAArch64;

import LitmusBase;

@header{
package dartagnan.parsers;
import dartagnan.expression.op.*;
import dartagnan.program.utils.aarch64.Mo;
}

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
    :   location Equals value
    ;

variableDeclaratorRegister
    :   threadId Colon register64 Equals value
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register64 Equals location
    ;

variableDeclaratorLocationLocation
    :   location Equals location
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
    :   LDR     {$mo = Mo.RX;}
    |   LDAR    {$mo = Mo.ACQ;}
    ;

loadExclusiveInstruction locals [String mo]
    :   LDXR    {$mo = Mo.RX;}
    |   LDAXR   {$mo = Mo.ACQ;}
    ;

storeInstruction locals [String mo]
    :   STR     {$mo = Mo.RX;}
    |   STLR    {$mo = Mo.REL;}
    ;

storeExclusiveInstruction locals [String mo]
    :   STXR    {$mo = Mo.RX;}
    |   STLXR   {$mo = Mo.REL;}
    ;

arithmeticInstruction locals [AOpBin op]
    :   ADD     { $op = AOpBin.PLUS; }
//    |   ADDS    { throw new RuntimeException("Instruction ADDS is not implemented"); }
    |   SUB     { $op = AOpBin.MINUS; }
//    |   SUBS    { throw new RuntimeException("Instruction SUBS is not implemented"); }
//    |   ADC     { throw new RuntimeException("Instruction ADC is not implemented"); }
//    |   ADCS    { throw new RuntimeException("Instruction ADCS is not implemented"); }
//    |   SBC     { throw new RuntimeException("Instruction SBC is not implemented"); }
//    |   SBCS    { throw new RuntimeException("Instruction SBCS is not implemented"); }
    |   AND     { $op = AOpBin.AND; }
    |   ORR     { $op = AOpBin.OR; }
    |   EOR     { $op = AOpBin.XOR; }
//    |   BIC     { throw new RuntimeException("Instruction BIC is not implemented"); }
//    |   ORN     { throw new RuntimeException("Instruction ORN is not implemented"); }
//    |   EON     { throw new RuntimeException("Instruction EON is not implemented"); }
    ;

branchCondition returns [COpBin op]
    :   EQ {$op = COpBin.EQ;}
    |   NE {$op = COpBin.NEQ;}
    |   GE {$op = COpBin.GTE;}
    |   LE {$op = COpBin.LTE;}
    |   GT {$op = COpBin.GT;}
    |   LT {$op = COpBin.LT;}
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

branchRegInstruction returns [COpBin op]
    :   CBZ     {$op = COpBin.EQ;}
    |   CBNZ    {$op = COpBin.NEQ;}
    ;

shiftOperator returns [AOpBin op]
    :   LSL { $op = AOpBin.L_SHIFT; }
    |   LSR { $op = AOpBin.R_SHIFT; }
    |   ASR { $op = AOpBin.AR_SHIFT; }
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

assertionValue returns [IntExprInterface v]
    :   l = location    {$v = pb.getOrCreateLocation($l.text);}
    |   t = threadId Colon r = register64 {$v = pb.getOrCreateRegister($t.id, $r.id);}
    |   imm = value    { $v = new AConst(Integer.parseInt($imm.text)); }
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
    :   Num value
    ;

value
    :   Minus? DigitSequence
    ;

label
    :   Identifier
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
