grammar LitmusVulkan;

import LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.op.*;
}

main
    :    LitmusLanguage ~(LBrace)* variableDeclaratorList sswDeclaratorList? program variableList? assertionFilter? assertionList? EOF
    ;

variableDeclaratorList
    :   LBrace variableDeclarator? (Semi variableDeclarator)* Semi? RBrace Semi?
    ;

variableDeclarator
    :   variableDeclaratorLocation
    |   variableDeclaratorRegister
    |   variableDeclaratorRegisterLocation
    |   variableDeclaratorLocationLocation
    |   variableDeclaratorProxy
    ;

variableDeclaratorLocation
    :   location Equals constant
    ;

variableDeclaratorRegister
    :   threadId Colon register Equals constant
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register Equals Amp? location
    ;

variableDeclaratorLocationLocation
    :   location Equals Amp? location
    ;

variableDeclaratorProxy
    :   location Aliases location
    ;

sswDeclaratorList
    :   LBrace sswDeclarator? (Semi sswDeclarator)* Semi? RBrace Semi?
    ;

sswDeclarator
    :   Ssw threadId threadId
    ;

variableList
    :   Locations LBracket variable (Semi variable)* Semi? RBracket
    ;

variable
    :   location
    |   threadId Colon register
    ;

program
    :   threadDeclaratorList instructionList
    ;

threadDeclaratorList
    :   threadScope (Bar threadScope)* Semi
    ;

threadScope
    :   threadId At subgroupScope Comma workgroupScope Comma queuefamilyScope
    ;

subgroupScope
    :   Subgroup scopeID
    ;

workgroupScope
    :   Workgroup scopeID
    ;

queuefamilyScope
    :   Queuefamily scopeID
    ;

instructionList
    :   (instructionRow) +
    ;

instructionRow
    :   instruction (Bar instruction)* Semi
    ;

instruction
    :
    |   storeInstruction
    |   loadInstruction
    |   rmwInstruction
    |   fenceInstruction
    |   deviceOperation
    |   label
    |   branchCond
    |   jump
    ;

storeInstruction
    :   Store atomic mo? avvis? scope? storageClass storageClassSemanticList avvisSemanticList location Comma value
    ;

loadInstruction
    :   localValue
    |   localAdd
    |   localSub
    |   localMul
    |   localDiv
    |   loadLocation
    ;

localValue
    :   Load atomic mo? avvis? scope? storageClass storageClassSemanticList avvisSemanticList register Comma value
    ;

localAdd
    :   Add register Comma value Comma value
    ;

localSub
    :   Sub register Comma value Comma value
    ;

localMul
    :   Mul register Comma value Comma value
    ;

localDiv
    :   Div register Comma value Comma value
    ;

loadLocation
    :   Load atomic mo? avvis? scope? storageClass storageClassSemanticList avvisSemanticList register Comma location
    ;

rmwInstruction
    :   rmwValue
    |   rmwOp
    ;

rmwValue
    :   RMW atomic mo? avvis? scope? storageClass storageClassSemanticList avvisSemanticList register Comma location Comma value
    ;

rmwOp
    :   RMW atomic mo? avvis? scope? storageClass storageClassSemanticList avvisSemanticList operation register Comma location Comma value
    ;

fenceInstruction
    :   memoryBarrier
    |   controlBarrier
    ;

memoryBarrier
    :   MemoryBarrier mo? avvis? scope? storageClassSemanticList avvisSemanticList
    ;

controlBarrier
    :   ControlBarrier mo? avvis? scope? storageClassSemanticList avvisSemanticList value
    ;

deviceOperation
    :   AVDEVICE
    |   VISDEVICE
    ;

label
    :   Label Colon
    ;

branchCond
    :   cond value Comma value Comma Label
    ;

jump
    :   Goto Label
    ;

value
    :   constant
    |   register
    ;

location
    :   Identifier
    ;

register
    :   Register
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

atomic returns [Boolean isAtomic]
    :   Period Atom {$isAtomic = true;}
    |   {$isAtomic = false;}
    ;

scope returns [String content]
    :   Period Subgroup {$content = "SG";}
    |   Period Workgroup {$content = "WG";}
    |   Period Queuefamily {$content = "QF";}
    |   Period Device {$content = "DV";}
    |   Period Nonprivate {$content = "NONPRIV";}
    ;

scopeID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

mo returns [String content]
    :   Period Acquire {$content = "ACQ";}
    |   Period Release {$content = "REL";}
    |   Period Acq_rel {$content = "ACQ_REL";}
    ;

avvis returns [String content]
    :   Period Visible {$content = "VIS";}
    |   Period Available {$content = "AV";}
    ;

storageClass returns [String content]
    :   Period Sc0 {$content = "SC0";}
    |   Period Sc1 {$content = "SC1";}
    ;

storageClassSemantic returns [String content]
    :   Period Semsc0 {$content = "SEMSC0";}
    |   Period Semsc1 {$content = "SEMSC1";}
    ;

storageClassSemanticList
    :   (storageClassSemantic)*
    ;

avvisSemantic returns [String content]
    :   Period SemVis {$content = "SEMVIS";}
    |   Period SemAv {$content = "SEMAV";}
    ;

avvisSemanticList
    :   (avvisSemantic)*
    ;

operation locals [IntBinaryOp op]
    :   Period Add {$op = IntBinaryOp.ADD;}
    |   Period Sub {$op = IntBinaryOp.SUB;}
    |   Period Mul {$op = IntBinaryOp.MUL;}
    |   Period Div {$op = IntBinaryOp.DIV;}
    |   Period And {$op = IntBinaryOp.AND;}
    |   Period Or {$op = IntBinaryOp.OR;}
    |   Period Xor {$op = IntBinaryOp.XOR;}
    ;

cond returns [CmpOp op]
    :   Beq {$op = CmpOp.EQ;}
    |   Bne {$op = CmpOp.NEQ;}
    |   Bge {$op = CmpOp.GTE;}
    |   Ble {$op = CmpOp.LTE;}
    |   Bgt {$op = CmpOp.GT;}
    |   Blt {$op = CmpOp.LT;}
    ;

Locations
    :   'locations'
    ;

Register
    :   'r' DigitSequence
    ;

Label
    :   'LC' DigitSequence
    ;


AVDEVICE        :   'avdevice';
VISDEVICE       :   'visdevice';

Aliases         :   'aliases';
Ssw             :   'ssw';

Load            :   'ld';
Store           :   'st';
RMW             :   'rmw';

MemoryBarrier   :   'membar';
ControlBarrier  :   'cbar';

Subgroup        :   'sg';
Workgroup       :   'wg';
Queuefamily     :   'qf';
Device          :   'dv';

Nonprivate      :   'nonpriv';

Atom            :   'atom';
Acquire         :   'acq';
Release         :   'rel';
Acq_rel         :   'acq_rel';

Visible         :   'vis';
Available       :   'av';

SemVis          :   'semvis';
SemAv           :   'semav';

Sc0             :   'sc0';
Sc1             :   'sc1';

Semsc0          :   'semsc0';
Semsc1          :   'semsc1';

Beq             :   'beq';
Bne             :   'bne';
Blt             :   'blt';
Bgt             :   'bgt';
Ble             :   'ble';
Bge             :   'bge';

Add             :   'add';
Sub             :   'sub';
Mul             :   'mul';
Div             :   'div';
And             :   'and';
Or              :   'or';
Xor             :   'xor';

Goto            :   'goto';

LitmusLanguage
    :   'VULKAN'
    |   'Vulkan'
    |   'vulkan'
    ;