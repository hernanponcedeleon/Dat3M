grammar LitmusVulkan;

import LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.integers.*;
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

scopeID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

instructionList
    :   instructionRow+
    ;

instructionRow
    :   instruction (Bar instruction)* Semi
    ;

instruction
    :
    |   storeInstruction
    |   loadInstruction
    |   atomicStoreInstruction
    |   atomicLoadInstruction
    |   atomicRmwInstruction
    |   memoryBarrierInstruction
    |   controlBarrierInstruction
    |   localInstruction
    |   labelInstruction
    |   jumpInstruction
    |   condJumpInstruction
    |   deviceOperation
    ;

storeInstruction
    :   Store (nonpriv | (av scope))? sc location Comma value
    ;

loadInstruction
    :   Load (nonpriv | (vis scope))? sc register Comma location
    ;

atomicStoreInstruction
    :   Store Period Atom (scope sc | moRel scope sc semSc+ semAv?) location Comma value
    ;

atomicLoadInstruction
    :   Load Period Atom (scope sc | moAcq scope sc semSc+ semVis?) register Comma location
    ;

atomicRmwInstruction
    :   RMW Period Atom (scope sc | moAcq scope sc semSc+ semVis? | moRel scope sc semSc+ semAv? | moAcqRel scope sc semSc+ semAv? semVis?) (Period operation)? register Comma location Comma value
    ;

memoryBarrierInstruction
    :   MemoryBarrier (moAcq scope semSc+ semVis? | moRel scope semSc+ semAv? | moAcqRel scope semSc+ semAv? semVis?)
    ;

controlBarrierInstruction
    :   ControlBarrier (scope | moAcq scope semSc+ semVis? | moRel scope semSc+ semAv? | moAcqRel scope semSc+ semAv? semVis?) constant (Comma barrierId (Comma barrierQuorum)?)?
    ;

localInstruction
    :   operation register Comma value Comma value
    ;

labelInstruction
    :   Label Colon
    ;

jumpInstruction
    :   Goto Label
    ;

condJumpInstruction
    :   cond value Comma value Comma Label
    ;

deviceOperation
    :   AVDEVICE
    |   VISDEVICE
    ;

barrierId
    : value
    ;

barrierQuorum
    : value
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

moAcq
    :   Period Acquire
    ;

moRel
    :   Period Release
    ;

moAcqRel
    :   Period Acq_rel
    ;

nonpriv
    :   Period Nonprivate
    ;

av
    :   Period Available
    ;

vis
    :   Period Visible
    ;

semAv
    :   Period SemAv
    ;

semVis
    :   Period SemVis
    ;

scope returns [String content]
    :   Period Subgroup {$content = "SG";}
    |   Period Workgroup {$content = "WG";}
    |   Period Queuefamily {$content = "QF";}
    |   Period Device {$content = "DV";}
    ;

sc returns [String content]
    :   Period Sc0 {$content = "SC0";}
    |   Period Sc1 {$content = "SC1";}
    ;

semSc returns [String content]
    :   Period Semsc0 {$content = "SEMSC0";}
    |   Period Semsc1 {$content = "SEMSC1";}
    ;

operation locals [IntBinaryOp op]
    :   Add {$op = IntBinaryOp.ADD;}
    |   Sub {$op = IntBinaryOp.SUB;}
    |   Mul {$op = IntBinaryOp.MUL;}
    |   Div {$op = IntBinaryOp.DIV;}
    |   And {$op = IntBinaryOp.AND;}
    |   Or {$op = IntBinaryOp.OR;}
    |   Xor {$op = IntBinaryOp.XOR;}
    ;

cond returns [IntCmpOp op]
    :   Beq {$op = IntCmpOp.EQ;}
    |   Bne {$op = IntCmpOp.NEQ;}
    |   Bge {$op = IntCmpOp.GTE;}
    |   Ble {$op = IntCmpOp.LTE;}
    |   Bgt {$op = IntCmpOp.GT;}
    |   Blt {$op = IntCmpOp.LT;}
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