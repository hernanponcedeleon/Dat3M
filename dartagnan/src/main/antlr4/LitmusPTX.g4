grammar LitmusPTX;

import LitmusAssertions;

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
    :   threadId Colon register Equals constant
    ;

variableDeclaratorRegisterLocation
    :   threadId Colon register Equals Amp? location
    ;

variableDeclaratorLocationLocation
    :   location Equals Amp? location
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
    :   threadId At scopeID
    ;

scopeID
    :   CTA ctaID Comma GPU gpuID
    ;

instructionList
    :   (instructionRow) +
    ;

instructionRow
    :   instruction (Bar instruction)* Semi
    ;
instruction
    :
    |   storeRelaxed
    |   storeRelease
    |   storeWeak
    |   loadRelaxed
    |   loadAcquire
    |   loadWeak
    |   fencePhysic
    ;

storeWeak
    :   storeWeakConstant
    |   storeWeakRegister
    ;

storeWeakConstant
    :   Store Period Weak location Comma constant
    ;

storeWeakRegister
    :   Store Period Weak location Comma register
    ;

storeRelaxed
    :   storeRelaxedConstant
    |   storeRelaxedRegister
    ;

storeRelaxedConstant
    :   Store Period Relaxed Period scope location Comma constant
    ;

storeRelaxedRegister
    :   Store Period Relaxed Period scope location Comma register
    ;

storeRelease
    :   storeReleaseConstant
    |   storeReleaseRegister
    ;

storeReleaseConstant
    :   Store Period Release Period scope location Comma constant
    ;

storeReleaseRegister
    :   Store Period Release Period scope location Comma register
    ;


loadWeak
    :   loadWeakConstant
    |   loadWeakLocation
    ;

loadWeakConstant
    :   Load Period Weak register Comma constant
    ;

loadWeakLocation
    :   Load Period Weak register Comma location
    ;

loadRelaxed
    :   loadRelaxedConstant
    |   loadRelaxedLocation
    ;

loadRelaxedConstant
    :   Load Period Relaxed Period scope register Comma constant
    ;

loadRelaxedLocation
    :   Load Period Relaxed Period scope register Comma location
    ;

loadAcquire
    :   loadAcquireConstant
    |   loadAcquireLocation
    ;

loadAcquireConstant
    :   Load Period Acquire Period scope register Comma constant
    ;

loadAcquireLocation
    :   Load Period Acquire Period scope register Comma location
    ;

fencePhysic
    :   fenceSC
    |   fenceBar
    ;

fenceSC
    :   Fence Period ACQ_REL Period scope
    ;

fenceBar
    :   Fence Period BAR_SYNC Period scope
    ;

scope returns [String content]
    :   CTA {$content = "cta";}
    |   GPU {$content = "gpu";}
    |   SYS {$content = "sys";}
    ;

location
    :   Identifier
    ;

register
    :   Percent Identifier
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

ctaID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

gpuID returns [int id]
    :   t = DigitSequence {$id = Integer.parseInt($t.text);}
    ;

Load    :   'ld';
Store   :   'st';

Weak    :   'weak';
Relaxed :   'relaxed';
Acquire :   'acquire';
Release :   'release';

CTA :   'cta';
GPU :   'gpu';
SYS :   'sys';

Fence   :   'fence';

ACQ_REL :   'acq_rel';
BAR_SYNC:   'bar_sync';

LitmusLanguage
    :   'PTX'
    |   'ptx'
    ;