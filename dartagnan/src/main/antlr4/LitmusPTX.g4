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
    |   atomRelaxed
    |   atomAcqRel
    |   redRelaxed
    |   redAcqRel
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
    :   fenceAcqRel
    |   fenceSC
    ;

fenceAcqRel
    :   Fence Period ACQ_REL Period scope
    ;

fenceSC
    :   Fence Period SC Period scope
    ;

atomRelaxed
    :   atomRelaxedConstant
    |   atomRelaxedRegister
    ;

atomRelaxedConstant
    :   Atom Period Relaxed Period scope Period operation register Comma location Comma constant
    ;

atomRelaxedRegister
    :   Atom Period Relaxed Period scope Period operation register Comma location Comma register
    ;

atomAcqRel
    :   atomAcqRelConstant
    |   atomAcqRelRegister
    ;

atomAcqRelConstant
    :   Atom Period ACQ_REL Period scope Period operation register Comma location Comma constant
    ;

atomAcqRelRegister
    :   Atom Period ACQ_REL Period scope Period operation register Comma location Comma register
    ;

redRelaxed
    :   redRelaxedConstant
    |   redRelaxedRegister
    ;

redRelaxedConstant
    :   Red Period Relaxed Period scope Period operation location Comma constant
    ;

redRelaxedRegister
    :   Red Period Relaxed Period scope Period operation location Comma register
    ;

redAcqRel
    :   redAcqRelConstant
    |   redAcqRelRegister
    ;

redAcqRelConstant
    :   Red Period ACQ_REL Period scope Period operation location Comma constant
    ;

redAcqRelRegister
    :   Red Period ACQ_REL Period scope Period operation location Comma register
    ;

scope returns [String content]
    :   CTA {$content = "CTA";}
    |   GPU {$content = "GPU";}
    |   SYS {$content = "SYS";}
    ;

location
    :   Identifier
    ;

register
    :   Percent Identifier
    ;

operation returns [String content]
    :   Plus {$content = "PLUS";}
    |   Minus {$content = "MINUS";}
    |   Mult {$content = "MULT";}
    |   Div {$content = "DIV";}
    |   Udiv {$content = "UDIV";}
    |   Mod {$content = "MOD";}
    |   SRem {$content = "SREM";}
    |   URem {$content = "UREM";}
    |   And {$content = "AND";}
    |   Or {$content = "OR";}
    |   Xor {$content = "XOR";}
    |   L_Shift {$content = "L_SHIFT";}
    |   R_Shift {$content = "R_SHIFT";}
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
SC:   'sc';

Atom    :   'atom';
Red     :   'red';

Plus    :   'plus';
Minus   :   'minus';
Mult    :   'mult';
Div     :   'div';
Udiv    :   'udiv';
Mod     :   'mod';
SRem    :   's_rem';
URem    :   'u_rem';
And     :   'and';
Or      :   'or';
Xor     :   'xor';
L_Shift :   'l_shift';
R_Shift :   'r_shift';

LitmusLanguage
    :   'PTX'
    |   'ptx'
    ;