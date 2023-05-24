grammar LitmusPTX;

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
    :   location At proxyType Aliases location
    ;

proxyType returns [String content]
    :   Generic {$content = "GEN";}
    |   Constant {$content = "CON";}
    |   Texture {$content = "TEX";}
    |   Surface {$content = "SUR";}
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
    :   store Period mo (Period scope)? location Comma constant
    ;

storeRegister
    :   store Period mo (Period scope)? location Comma register
    ;

loadInstruction
    :   localConstant
    |   loadLocation
    ;

localConstant
    :   load Period mo (Period scope)? register Comma constant
    ;

loadLocation
    :   load Period mo (Period scope)? register Comma location
    ;


fenceInstruction
    :   fencePhysic
    |   fenceProxy
    |   fenceAlias
    |   barrier
    ;

fencePhysic
    :   Fence Period mo Period scope
    ;

fenceProxy
    :   Fence Period Proxy Period proxyType
    ;

fenceAlias
    :   Fence Period Proxy Period Alias
    ;

barrier
    :   Barrier Period CTA Period Sync barID
    ;

atomInstruction
    :   atomConstant
    |   atomRegister
    ;

atomConstant
    :   atom Period mo Period scope Period operation register Comma location Comma constant
    ;

atomRegister
    :   atom Period mo Period scope Period operation register Comma location Comma register
    ;

redInstruction
    :   redConstant
    |   redRegister
    ;

redConstant
    :   red Period mo Period scope Period operation location Comma constant
    ;

redRegister
    :   red Period mo Period scope Period operation location Comma register
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
    :   Register
    ;

operation locals [IOpBin op]
    :   Add {$op = IOpBin.PLUS;}
    |   Sub {$op = IOpBin.MINUS;}
    |   Mult {$op = IOpBin.MULT;}
    |   Div {$op = IOpBin.DIV;}
    |   And {$op = IOpBin.AND;}
    |   Or {$op = IOpBin.OR;}
    |   Xor {$op = IOpBin.XOR;}
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

barID
    :   constant
    |   register
    ;

mo returns [String content]
    :   Weak {$content = "WEAK";}
    |   Relaxed {$content = "RLX";}
    |   Acquire {$content = "ACQ";}
    |   Release {$content = "REL";}
    |   Acq_rel {$content = "ACQ_REL";}
    |   Sc {$content = "SC";}
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

Locations
    :   'locations'
    ;

Register
    :   'r' DigitSequence
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
Barrier :   'bar';

Sync    :   'sync';

CTA     :   'cta';
GPU     :   'gpu';
SYS     :   'sys';

Weak    :   'weak';
Relaxed :   'relaxed';
Acquire :   'acquire';
Release :   'release';
Acq_rel :   'acq_rel';
Sc      :   'sc';

Add    :   'plus';
Sub    :   'minus';
Mult    :   'mult';
Div     :   'div';
And     :   'and';
Or      :   'or';
Xor     :   'xor';

Proxy       :   'proxy';
Generic     :   'generic';
Constant    :   'constant';
Surface     :   'surface';
Texture     :   'texture';
Aliases     :   'aliases';
Alias       :   'alias';

LitmusLanguage
    :   'PTX'
    |   'ptx'
    ;