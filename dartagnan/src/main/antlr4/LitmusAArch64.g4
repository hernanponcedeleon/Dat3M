grammar LitmusAArch64;

import LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.integers.*;
}

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList program variableList? assertionFilter? assertionList? EOF
    ;

variableDeclaratorList
    :   LBrace variableDeclarator? (Semi variableDeclarator)* Semi? RBrace Semi?
    ;

variableDeclarator
    :   type location (Equals constant)? #typedVariableDeclarator
    |   type location LBracket constant RBracket #typedArrayDeclarator
    |   location Equals constant #variableDeclaratorLocation
    |   location Equals Amp? location #variableDeclaratorLocationLocation
    |   type threadId Colon register64 (Equals constant)? #typedRegisterDeclarator
    |   threadId Colon register64 Equals constant #variableDeclaratorRegister
    |   threadId Colon register64 Equals Amp? location #variableDeclaratorRegisterLocation
    ;

type
    :   Identifier
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
    |   loadPair
    |   loadExclusive
    |   store
    |   storePair
    |   storeExclusive
    // AMOs
    |   loadOp
    |   storeOp
    |   swap
    |   cas
    // -----
    |   cmp
    |   branch
    |   branchRegister
    |   branchLabel
    |   fence
    |   return
    |   nop
    ;

mov
    :   MovInstruction r32 = register32 Comma expr32
    |   MovInstruction r64 = register64 Comma expr64
    ;

cmp
    :   CmpInstruction r32 = register32 Comma expr32
    |   CmpInstruction r64 = register64 Comma expr64
    ;

arithmetic
    :   arithmeticInstruction rD32 = register32 Comma rV32 = register32 Comma expr32
    |   arithmeticInstruction rD64 = register64 Comma rV64 = register64 Comma expr64
    ;

load
    :   loadInstruction rD32 = register32 Comma LBracket address RBracket
    |   loadInstruction rD64 = register64 Comma LBracket address RBracket
    ;

loadPair
    :   LDP rD032 = register32 Comma rD132 = register32 Comma LBracket address RBracket
    |   LDP rD064 = register64 Comma rD164 = register64 Comma LBracket address RBracket
    ;

loadExclusive
    :   loadExclusiveInstruction rD32 = register32 Comma LBracket address RBracket
    |   loadExclusiveInstruction rD64 = register64 Comma LBracket address RBracket
    ;

store
    :   storeInstruction rV32 = register32 Comma LBracket address RBracket
    |   storeInstruction rV64 = register64 Comma LBracket address RBracket
    ;

storePair
    :   STP r032 = register32 Comma r132 = register32 Comma LBracket address RBracket
    |   STP r064 = register64 Comma r164 = register64 Comma LBracket address RBracket
    ;

storeExclusive
    :   storeExclusiveInstruction rS32 = register32 Comma rV32 = register32 Comma LBracket address RBracket
    |   storeExclusiveInstruction rS32 = register32 Comma rV64 = register64 Comma LBracket address RBracket
    ;

loadOp
    :   loadOpInstruction rS32 = register32 Comma rD32 = register32 Comma LBracket address RBracket
    |   loadOpInstruction rS64 = register64 Comma rD64 = register64 Comma LBracket address RBracket
    ;

storeOp
    :   storeOpInstruction rS32 = register32 Comma LBracket address RBracket
    |   storeOpInstruction rS64 = register64 Comma LBracket address RBracket
    ;

swap
    :   swapInstruction rS32 = register32 Comma rD32 = register32 Comma LBracket address RBracket
    |   swapInstruction rS64 = register64 Comma rD64 = register64 Comma LBracket address RBracket
    ;

cas
    :   casInstruction rS32 = register32 Comma rT32 = register32 Comma LBracket address RBracket
    |   casInstruction rS64 = register64 Comma rT64 = register64 Comma LBracket address RBracket
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

return
    :   Ret
    ;

nop
    :   Nop
    ;

loadInstruction locals [boolean acquire, boolean byteSize, boolean halfWordSize]
    :   LDR
    |   LDRB    {$byteSize = true;}
    |   LDRH    {$halfWordSize = true;}
    |   LDAR    {$acquire = true;}
    |   LDARB   {$acquire = true; $byteSize = true;}
    |   LDARH   {$acquire = true; $halfWordSize = true;}
    ;

loadExclusiveInstruction locals [boolean acquire, boolean byteSize, boolean halfWordSize]
    :   LDXR
    |   LDXRB    {$byteSize = true;}
    |   LDXRH    {$halfWordSize = true;}
    |   LDAXR    {$acquire = true;}
    |   LDAXRB   {$acquire = true; $byteSize = true;}
    |   LDAXRH   {$acquire = true; $halfWordSize = true;}
    ;

loadOpInstruction
    // ADD
    :   LDADD  | LDADDA  | LDADDL  | LDADDAL
    |   LDADDH | LDADDAH | LDADDLH | LDADDALH
    |   LDADDB | LDADDAB | LDADDLB | LDADDALB
    // EOR
    |   LDEOR  | LDEORA  | LDEORL  | LDEORAL
    |   LDEORH | LDEORAH | LDEORLH | LDEORALH
    |   LDEORB | LDEORAB | LDEORLB | LDEORALB
    // SET
    |   LDSET  | LDSETA  | LDSETL  | LDSETAL
    |   LDSETH | LDSETAH | LDSETLH | LDSETALH
    |   LDSETB | LDSETAB | LDSETLB | LDSETALB
    // CLR
    |   LDCLR  | LDCLRA  | LDCLRL  | LDCLRAL
    |   LDCLRH | LDCLRAH | LDCLRLH | LDCLRALH
    |   LDCLRB | LDCLRAB | LDCLRLB | LDCLRALB
    // SMIN
    |   LDSMIN  | LDSMINA  | LDSMINL  | LDSMINAL
    |   LDSMINH | LDSMINAH | LDSMINLH | LDSMINALH
    |   LDSMINB | LDSMINAB | LDSMINLB | LDSMINALB
    // UMIN
    |   LDUMIN  | LDUMINA  | LDUMINL  | LDUMINAL
    |   LDUMINH | LDUMINAH | LDUMINLH | LDUMINALH
    |   LDUMINB | LDUMINAB | LDUMINLB | LDUMINALB
    // SMAX
    |   LDSMAX  | LDSMAXA  | LDSMAXL  | LDSMAXAL
    |   LDSMAXH | LDSMAXAH | LDSMAXLH | LDSMAXALH
    |   LDSMAXB | LDSMAXAB | LDSMAXLB | LDSMAXALB
    // UMAX
    |   LDUMAX  | LDUMAXA  | LDUMAXL  | LDUMAXAL
    |   LDUMAXH | LDUMAXAH | LDUMAXLH | LDUMAXALH
    |   LDUMAXB | LDUMAXAB | LDUMAXLB | LDUMAXALB
    ;

storeOpInstruction
    // ADD
    :   STADD  | STADDL
    |   STADDH | STADDLH
    |   STADDB | STADDLB
    // EOR
    |   STEOR  | STEORL
    |   STEORH | STEORLH
    |   STEORB | STEORLB
    // SET
    |   STSET  | STSETL
    |   STSETH | STSETLH
    |   STSETB | STSETLB
    // CLR
    |   STCLR  | STCLRL
    |   STCLRH | STCLRLH
    |   STCLRB | STCLRLB
    // SMIN
    |   STSMIN  | STSMINL
    |   STSMINH | STSMINLH
    |   STSMINB | STSMINLB
    // UMIN
    |   STUMIN  | STUMINL
    |   STUMINH | STUMINLH
    |   STUMINB | STUMINLB
    // SMAX
    |   STSMAX  | STSMAXL
    |   STSMAXH | STSMAXLH
    |   STSMAXB | STSMAXLB
    // UMAX
    |   STUMAX  | STUMAXL
    |   STUMAXH | STUMAXLH
    |   STUMAXB | STUMAXLB
    ;

storeInstruction locals [boolean release, boolean byteSize, boolean halfWordSize]
    :   STR
    |   STRB    {$byteSize = true;}
    |   STRH    {$halfWordSize = true;}
    |   STLR    {$release = true;}
    |   STLRB   {$release = true; $byteSize = true;}
    |   STLRH   {$release = true; $halfWordSize = true;}
    ;

storeExclusiveInstruction locals [boolean release, boolean byteSize, boolean halfWordSize]
    :   STXR
    |   STXRB    {$byteSize = true;}
    |   STXRH    {$halfWordSize = true;}
    |   STLXR    {$release = true;}
    |   STLXRB   {$release = true; $byteSize = true;}
    |   STLXRH   {$release = true; $halfWordSize = true;}
    ;

swapInstruction locals [boolean acquire, boolean release, boolean byteSize, boolean halfWordSize]
    : SWP
    | SWPB {$byteSize = true;}
    | SWPH {$halfWordSize = true;}
    | SWPA {$acquire = true;}
    | SWPAB {$acquire = true; $byteSize = true;}
    | SWPAH {$acquire = true; $halfWordSize = true;}
    | SWPL {$release = true;}
    | SWPLB {$release = true; $byteSize = true;}
    | SWPLH {$release = true; $halfWordSize = true;}
    | SWPAL {$acquire = true; $release = true;}
    | SWPALB {$acquire = true; $release = true; $byteSize = true;}
    | SWPALH {$acquire = true; $release = true; $halfWordSize = true;}
    ;

casInstruction locals [boolean acquire, boolean release, boolean byteSize, boolean halfWordSize]
    : CAS
    | CASB {$byteSize = true;}
    | CASH {$halfWordSize = true;}
    | CASA {$acquire = true;}
    | CASAB {$acquire = true; $byteSize = true;}
    | CASAH {$acquire = true; $halfWordSize = true;}
    | CASL {$release = true;}
    | CASLB {$release = true; $byteSize = true;}
    | CASLH {$release = true; $halfWordSize = true;}
    | CASAL {$acquire = true; $release = true;}
    | CASALB {$acquire = true; $release = true; $byteSize = true;}
    | CASALH {$acquire = true; $release = true; $halfWordSize = true;}
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

address
    :   register64 (Comma offset)?
    ;

offset
    :   immediate
    |   register64
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

expressionConversion returns[boolean signed]
    :   register32 Comma UXTW {$signed = false;}
    |   register32 Comma SXTW {$signed = true;}
    ;

register64 returns[String id]
    :   r = Register64 {$id = $r.text;}
    ;

register32 returns[String id]
    :   r = Register32 {$id = $r.text.replace("W","X");}
    ;

location
    :   Identifier
    |   LBracket Identifier RBracket
    ;

immediate
    :   Num Hexa? constant
    ;

label
    :   Identifier
    ;

assertionValue
    :   location
    |   threadId Colon register64
    |   constant
    ;

Hexa
    :   '0x'
    ;

Ret
    :   'ret'
    ;

Nop
    :   'nop'
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
LDRB   :   'LDRB'   ;
LDRH   :   'LDRH'   ;
LDAR   :   'LDAR'   ;
LDARB  :   'LDARB'  ;
LDARH  :   'LDARH'  ;
LDP    :   'LDP'    ;
LDXR   :   'LDXR'   ;
LDXRB  :   'LDXRB'  ;
LDXRH  :   'LDXRH'  ;
LDAXR  :   'LDAXR'  ;
LDAXRB :   'LDAXRB' ;
LDAXRH :   'LDAXRH' ;

// Store instructions

STR    :   'STR'    ;
STRB   :   'STRB'   ;
STRH   :   'STRH'   ;
STLR   :   'STLR'   ;
STLRB  :   'STLRB'  ;
STLRH  :   'STLRH'  ;
STP    :   'STP'    ;
STXR   :   'STXR'   ;
STXRB  :   'STXRB'  ;
STXRH  :   'STXRH'  ;
STLXR  :   'STLXR'  ;
STLXRB :   'STLXRB' ;
STLXRH :   'STLXRH' ;

// Load Op instructions
// Add
LDADD        :   'LDADD'      ;
LDADDA       :   'LDADDA'     ;
LDADDL       :   'LDADDL'     ;
LDADDAL      :   'LDADDAL'    ;
LDADDH       :   'LDADDH'     ;
LDADDAH      :   'LDADDAH'    ;
LDADDLH      :   'LDADDLH'    ;
LDADDALH     :   'LDADDALH'   ;
LDADDB       :   'LDADDB'     ;
LDADDAB      :   'LDADDAB'    ;
LDADDLB      :   'LDADDLB'    ;
LDADDALB     :   'LDADDALB'   ;
// EOR (XOR)
LDEOR        :   'LDEOR'      ;
LDEORA       :   'LDEORA'     ;
LDEORL       :   'LDEORL'     ;
LDEORAL      :   'LDEORAL'    ;
LDEORH       :   'LDEORH'     ;
LDEORAH      :   'LDEORAH'    ;
LDEORLH      :   'LDEORLH'    ;
LDEORALH     :   'LDEORALH'   ;
LDEORB       :   'LDEORB'     ;
LDEORAB      :   'LDEORAB'    ;
LDEORLB      :   'LDEORLB'    ;
LDEORALB     :   'LDEORALB'   ;
// SET (OR)
LDSET        :   'LDSET'      ;
LDSETA       :   'LDSETA'     ;
LDSETL       :   'LDSETL'     ;
LDSETAL      :   'LDSETAL'    ;
LDSETH       :   'LDSETH'     ;
LDSETAH      :   'LDSETAH'    ;
LDSETLH      :   'LDSETLH'    ;
LDSETALH     :   'LDSETALH'   ;
LDSETB       :   'LDSETB'     ;
LDSETAB      :   'LDSETAB'    ;
LDSETLB      :   'LDSETLB'    ;
LDSETALB     :   'LDSETALB'   ;
// CLR (AND with complement)
LDCLR        :   'LDCLR'      ;
LDCLRA       :   'LDCLRA'     ;
LDCLRL       :   'LDCLRL'     ;
LDCLRAL      :   'LDCLRAL'    ;
LDCLRH       :   'LDCLRH'     ;
LDCLRAH      :   'LDCLRAH'    ;
LDCLRLH      :   'LDCLRLH'    ;
LDCLRALH     :   'LDCLRALH'   ;
LDCLRB       :   'LDCLRB'     ;
LDCLRAB      :   'LDCLRAB'    ;
LDCLRLB      :   'LDCLRLB'    ;
LDCLRALB     :   'LDCLRALB'   ;
// SMIN
LDSMIN        :   'LDSMIN'      ;
LDSMINA       :   'LDSMINA'     ;
LDSMINL       :   'LDSMINL'     ;
LDSMINAL      :   'LDSMINAL'    ;
LDSMINH       :   'LDSMINH'     ;
LDSMINAH      :   'LDSMINAH'    ;
LDSMINLH      :   'LDSMINLH'    ;
LDSMINALH     :   'LDSMINALH'   ;
LDSMINB       :   'LDSMINB'     ;
LDSMINAB      :   'LDSMINAB'    ;
LDSMINLB      :   'LDSMINLB'    ;
LDSMINALB     :   'LDSMINALB'   ;
// UMIN
LDUMIN        :   'LDUMIN'      ;
LDUMINA       :   'LDUMINA'     ;
LDUMINL       :   'LDUMINL'     ;
LDUMINAL      :   'LDUMINAL'    ;
LDUMINH       :   'LDUMINH'     ;
LDUMINAH      :   'LDUMINAH'    ;
LDUMINLH      :   'LDUMINLH'    ;
LDUMINALH     :   'LDUMINALH'   ;
LDUMINB       :   'LDUMINB'     ;
LDUMINAB      :   'LDUMINAB'    ;
LDUMINLB      :   'LDUMINLB'    ;
LDUMINALB     :   'LDUMINALB'   ;
// SMAX
LDSMAX        :   'LDSMAX'      ;
LDSMAXA       :   'LDSMAXA'     ;
LDSMAXL       :   'LDSMAXL'     ;
LDSMAXAL      :   'LDSMAXAL'    ;
LDSMAXH       :   'LDSMAXH'     ;
LDSMAXAH      :   'LDSMAXAH'    ;
LDSMAXLH      :   'LDSMAXLH'    ;
LDSMAXALH     :   'LDSMAXALH'   ;
LDSMAXB       :   'LDSMAXB'     ;
LDSMAXAB      :   'LDSMAXAB'    ;
LDSMAXLB      :   'LDSMAXLB'    ;
LDSMAXALB     :   'LDSMAXALB'   ;
// UMAX
LDUMAX        :   'LDUMAX'      ;
LDUMAXA       :   'LDUMAXA'     ;
LDUMAXL       :   'LDUMAXL'     ;
LDUMAXAL      :   'LDUMAXAL'    ;
LDUMAXH       :   'LDUMAXH'     ;
LDUMAXAH      :   'LDUMAXAH'    ;
LDUMAXLH      :   'LDUMAXLH'    ;
LDUMAXALH     :   'LDUMAXALH'   ;
LDUMAXB       :   'LDUMAXB'     ;
LDUMAXAB      :   'LDUMAXAB'    ;
LDUMAXLB      :   'LDUMAXLB'    ;
LDUMAXALB     :   'LDUMAXALB'   ;

// Store Op instructions
// Add
STADD        :   'STADD'      ;
STADDL       :   'STADDL'     ;
STADDH       :   'STADDH'     ;
STADDLH      :   'STADDLH'    ;
STADDB       :   'STADDB'     ;
STADDLB      :   'STADDLB'    ;
// EOR (XOR)
STEOR        :   'STEOR'      ;
STEORL       :   'STEORL'     ;
STEORH       :   'STEORH'     ;
STEORLH      :   'STEORLH'    ;
STEORB       :   'STEORB'     ;
STEORLB      :   'STEORLB'    ;
// SET (OR)
STSET        :   'STSET'      ;
STSETL       :   'STSETL'     ;
STSETH       :   'STSETH'     ;
STSETLH      :   'STSETLH'    ;
STSETB       :   'STSETB'     ;
STSETLB      :   'STSETLB'    ;
// CLR (AND with complement)
STCLR        :   'STCLR'      ;
STCLRL       :   'STCLRL'     ;
STCLRH       :   'STCLRH'     ;
STCLRLH      :   'STCLRLH'    ;
STCLRB       :   'STCLRB'     ;
STCLRLB      :   'STCLRLB'    ;
// SMIN
STSMIN        :   'STSMIN'      ;
STSMINL       :   'STSMINL'     ;
STSMINH       :   'STSMINH'     ;
STSMINLH      :   'STSMINLH'    ;
STSMINB       :   'STSMINB'     ;
STSMINLB      :   'STSMINLB'    ;
// UMIN
STUMIN        :   'STUMIN'      ;
STUMINL       :   'STUMINL'     ;
STUMINH       :   'STUMINH'     ;
STUMINLH      :   'STUMINLH'    ;
STUMINB       :   'STUMINB'     ;
STUMINLB      :   'STUMINLB'    ;
// SMAX
STSMAX        :   'STSMAX'      ;
STSMAXL       :   'STSMAXL'     ;
STSMAXH       :   'STSMAXH'     ;
STSMAXLH      :   'STSMAXLH'    ;
STSMAXB       :   'STSMAXB'     ;
STSMAXLB      :   'STSMAXLB'    ;
// UMAX
STUMAX        :   'STUMAX'      ;
STUMAXL       :   'STUMAXL'     ;
STUMAXH       :   'STUMAXH'     ;
STUMAXLH      :   'STUMAXLH'    ;
STUMAXB       :   'STUMAXB'     ;
STUMAXLB      :   'STUMAXLB'    ;


// Swap word instructions (~ Exchange)

SWP    :   'SWP'    ;
SWPB   :   'SWPB'   ;
SWPH   :   'SWPH'   ;
SWPA   :   'SWPA'   ;
SWPAB  :   'SWPAB'  ;
SWPAH  :   'SWPAH'  ;
SWPL   :   'SWPL'   ;
SWPLB  :   'SWPLB'  ;
SWPLH  :   'SWPLH'  ;
SWPAL  :   'SWPAL'  ;
SWPALB :   'SWPALB' ;
SWPALH :   'SWPALH' ;

// CAS instructions

CAS    :   'CAS'    ;
CASB   :   'CASB'   ;
CASH   :   'CASH'   ;
CASA   :   'CASA'   ;
CASAB  :   'CASAB'  ;
CASAH  :   'CASAH'  ;
CASL   :   'CASL'   ;
CASLB  :   'CASLB'  ;
CASLH  :   'CASLH'  ;
CASAL  :   'CASAL'  ;
CASALB :   'CASALB' ;
CASALH :   'CASALH' ;

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

// Branch conditions

EQ  :   'EQ';    // Equal
NE  :   'NE';    // Not equal
CS  :   'CS';    // Carry set
HS  :   'HS';    // Identical to CS
CC  :   'CC';    // Carry clear
LO  :   'LO';    // Identical to CC
MI  :   'MI';    // Minus or negative result
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

UXTW :  'UXTW' ; // Zero extends a 32-bit word (unsigned)
SXTW :  'SXTW' ; // Zero extends a 32-bit word (signed)

Register64
    :   'X' DigitSequence
    |   'XZR' // zero register
    ;

Register32
    :   'W' DigitSequence
    |   'WZR' // zero register
    ;

LitmusLanguage
    :   'AArch64'
    ;