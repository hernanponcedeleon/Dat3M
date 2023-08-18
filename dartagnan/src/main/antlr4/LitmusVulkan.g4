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
    ;

storeInstruction
    :   storeConstant
    |   storeRegister
    ;

storeConstant
    :   Store atomatic mo scope storageClass storageClassSemantic avvisSemantic location Comma constant
    ;

storeRegister
    :   Store atomatic mo scope storageClass storageClassSemantic avvisSemantic location Comma register
    ;

loadInstruction
    :   localConstant
    |   loadLocation
    ;

localConstant
    :   Load atomatic mo scope storageClass storageClassSemantic avvisSemantic register Comma constant
    ;

loadLocation
    :   Load atomatic mo scope storageClass storageClassSemantic avvisSemantic register Comma location
    ;

rmwInstruction
    :   rmwConstant
    ;

rmwConstant
    :   RMW atomatic mo scope storageClass storageClassSemantic avvisSemantic Comma location register Comma constant
    ;

fenceInstruction
    :   memoryBarrier
    |   controlBarrier
    ;

memoryBarrier
    :   MemoryBarrier mo scope storageClassSemantic avvisSemantic
    ;

controlBarrier
    :   ControlBarrier scope barID
    ;

barID
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

atomatic returns [Boolean isAtomic]
    :   Period Atom {$isAtomic = true;}
    |   {$isAtomic = false;}
    ;

scope returns [String content]
    :   Period Subgroup {$content = "SG";}
    |   Period Workgroup {$content = "WG";}
    |   Period Queuefamily {$content = "QF";}
    |   Period Device {$content = "DV";}
    |   Period Private {$content = "PRIV";}
    |   Period Nonprivate {$content = "NONPRIV";}
    ;

scopeID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

mo returns [String content]
    :   Period Acquire {$content = "ACQ";}
    |   Period Release {$content = "REL";}
    |   Period Acq_rel {$content = "ACQ_REL";}
    |   Period Visible {$content = "VIS";}
    |   Period Available {$content = "AV";}
    |   {$content = "";}
    ;

storageClass returns [String content]
    :   Period Sc0 {$content = "SC0";}
    |   Period Sc1 {$content = "SC1";}
    ;

storageClassSemantic returns [String content]
    :   Period Semsc0 {$content = "SEMSC0";}
    |   Period Semsc1 {$content = "SEMSC1";}
    |   Period Semsc01 {$content = "SEMSC01";}
    |   {$content = "";}
    ;

avvisSemantic returns [String content]
    :   Period SemVis {$content = "SEMVIS";}
    |   Period SemAv {$content = "SEMAV";}
    |   {$content = "";}
    ;

Locations
    :   'locations'
    ;

Register
    :   'r' DigitSequence
    ;

Aliases     :   'aliases';
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

Atom            :   'atom';
Acquire         :   'acq';
Release         :   'rel';
Acq_rel         :   'acq_rel';
Relaxed         :   'rlx';

Visible         :   'vis';
Available       :   'av';

Private         :   'priv';
Nonprivate      :   'nonpriv';

SemVis          :   'semvis';
SemAv           :   'semav';

Sc0             :   'sc0';
Sc1             :   'sc1';

Semsc0          :   'semsc0';
Semsc1          :   'semsc1';
Semsc01         :   'semsc01';

LitmusLanguage
    :   'VULKAN'
    |   'Vulkan'
    |   'vulkan'
    ;