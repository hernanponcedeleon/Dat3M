grammar LitmusVulkan;

import LitmusAssertions;

@header{
import com.dat3m.dartagnan.expression.op.*;
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
    :   location Equals constant At storageClass
    ;

variableDeclaratorRegister
    :   threadId Colon register Equals constant
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register Equals Amp? location
    ;

variableDeclaratorLocationLocation
    :   location Equals Amp? location  At storageClass
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
    :   threadId At subgroupScope Comma workgroupScope Comma queuefamilyScope Comma deviceScope
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

deviceScope
    :   Device scopeID
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
    :   Store atomatic Period mo Period scope location Period storageClassSemantic Comma constant
    ;

storeRegister
    :   Store atomatic Period mo Period scope location Period storageClassSemantic Comma register
    ;

loadInstruction
    :   localConstant
    |   loadLocation
    ;

localConstant
    :   Load atomatic Period mo Period scope Period storageClassSemantic register Comma constant
    ;

loadLocation
    :   Load atomatic Period mo Period scope Period storageClassSemantic register Comma location
    ;

rmwInstruction
    :   rmwConstant
    ;

rmwConstant
    :   RMW atomatic Period mo Period scope Period storageClassSemantic Comma location register Comma constant
    ;

fenceInstruction
    :   memoryBarrier
    |   controlBarrier
    ;

memoryBarrier
    :   MemoryBarrier Period mo Period scope Period storageClassSemantic
    ;

controlBarrier
    :   ControlBarrier Period mo Period scope Period storageClassSemantic barID
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

atomatic returns [Boolean content]
    :   Period Atom {$content = true;}
    |   {$content = false;}
    ;

scope returns [String content]
    :   Subgroup {$content = "SG";}
    |   Workgroup {$content = "WG";}
    |   Queuefamily {$content = "QF";}
    |   Device {$content = "DV";}
    ;

scopeID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

mo returns [String content]
    :   Acquire {$content = "ACQ";}
    |   Release {$content = "REL";}
    |   Acq_rel {$content = "ACQ_REL";}
    |   Visible {$content = "VIS";}
    |   Available {$content = "AVA";}
    ;

storageClass returns [String content]
    :   Sc0 {$content = "sc0";}
    |   Sc1 {$content = "sc1";}
    ;

storageClassSemantic returns [String content]
    :   Semsc0 {$content = "semsc0";}
    |   Semsc1 {$content = "semsc1";}
    |   Semsc01 {$content = "semsc01";}
    ;

Locations
    :   'locations'
    ;

Register
    :   'r' DigitSequence
    ;

Load            :   'ld';
Store           :   'st';
RMW             :   'rmw';

MemoryBarrier   :   'membar';
ControlBarrier  :   'cbar';

Subgroup    :   'sg';
Workgroup   :   'wg';
Queuefamily :   'qf';
Device      :   'dev';

Atom        :   'atom';
Acquire     :   'acq';
Release     :   'rel';
Acq_rel     :   'acq_rel';

Visible     :   'vis';
Available   :   'av';

Sc0       :   'sc0';
Sc1       :   'sc1';

Semsc0          :   'semsc0';
Semsc1          :   'semsc1';
Semsc01         :   'semsc01';

LitmusLanguage
    :   'VULKAN'
    |   'vulkan'
    ;