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
    :   location At proxyType virtuality Aliases location
    ;

proxyType returns [String content]
    :   Generic {$content = "GEN";}
    |   Constant {$content = "CON";}
    |   Texture {$content = "TEX";}
    |   Surface {$content = "SURF";}
    ;

virtuality
    :   Physically
    |   Virtually
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
    |   storeInstruction
    |   loadInstruction
    |   fenceInstruction
    |   atomInstruction
    |   redInstruction
    ;

storeInstruction
    :   storeConstant
    |   storeRegister
    ;

storeConstant
    :   store Period sem (Period scope)? location Comma constant
    ;

storeRegister
    :   store Period sem (Period scope)? location Comma register
    ;

loadInstruction
    :   loadConstant
    |   loadLocation
    ;

loadConstant
    :   load Period sem (Period scope)? register Comma constant
    ;

loadLocation
    :   load Period sem (Period scope)? register Comma location
    ;


fenceInstruction
    :   fencePhysic
    |   fenceProxy
    |   fenceAlias
    ;

fencePhysic
    :   Fence Period sem Period scope
    ;

fenceProxy
    :   Fence Period Proxy Period proxyType
    ;

fenceAlias
    :   Fence Period Proxy Period Alias
    ;

atomInstruction
    :   atomConstant
    |   atomRegister
    ;

atomConstant
    :   atom Period sem Period scope Period operation register Comma location Comma constant
    ;

atomRegister
    :   atom Period sem Period scope Period operation register Comma location Comma register
    ;

redInstruction
    :   redConstant
    |   redRegister
    ;

redConstant
    :   red Period sem Period scope Period operation location Comma constant
    ;

redRegister
    :   red Period sem Period scope Period operation location Comma register
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

sem returns [String content]
    :   Weak {$content = "WEAK";}
    |   Relaxed {$content = "RLX";}
    |   Acquire {$content = "ACQ";}
    |   Release {$content = "REL";}
    |   ACQ_REL {$content = "ACQ_REL";}
    |   SC {$content = "SC";}
    ;

load returns [String loadProxy]
    :   Load {$loadProxy = "GEN";}
    |   TextureLoad {$loadProxy = "TEX";}
    |   SurfaceLoad {$loadProxy = "SUR";}
    |   ConstantLoad {$loadProxy = "CON";}
    ;

store returns [String storeProxy]
    :   Store {$storeProxy = "GEN";}
    |   Sustore {$storeProxy = "SUR";}
    ;

atom returns [String atomProxy]
    :   Atom {$atomProxy = "GEN";}
    |   SurfaceAtom {$atomProxy = "SUR";}
    ;

red returns [String redProxy]
    :   Red {$redProxy = "GEN";}
    |   SurfaceRed {$redProxy = "SUR";}
    ;

Load            :   'ld';
TextureLoad     :   'tld';
SurfaceLoad     :   'suld';
ConstantLoad    :   'cold';

Store           :   'st';
Sustore         :   'sust';

Atom            :   'atom';
SurfaceAtom     :   'suatom';

Red             :   'red';
SurfaceRed      :   'sured';

Fence   :   'fence';

CTA     :   'cta';
GPU     :   'gpu';
SYS     :   'sys';

Weak    :   'weak';
Relaxed :   'relaxed';
Acquire :   'acquire';
Release :   'release';
ACQ_REL :   'acq_rel';
SC      :   'sc';

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

Proxy       :   'proxy';
Generic     :   'generic';
Constant    :   'constant';
Surface     :   'surface';
Texture     :   'texture';
Physically  :   'physically';
Virtually   :   'virtually';
Aliases     :   'aliases';
Alias       :   'alias';

LitmusLanguage
    :   'PTX'
    |   'ptx'
    ;