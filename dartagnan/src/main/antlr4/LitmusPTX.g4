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
    |   branchCond
    |   jump
    |   label
    ;

storeInstruction
    :   store Period mo (Period scope)? location Comma value
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
    :   load register Comma value
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
    :   Barrier Period CTA Period barrierMode value
    ;

barrierMode
    :   Sync
    |   Arrive
    ;

atomInstruction
    :   atomOp
    |   atomCAS
    |   atomExchange
    ;

atomOp
    :   atom Period mo Period scope Period operation register Comma location Comma value
    ;

atomCAS
    :   atom Period mo Period scope Period Cas register Comma location Comma value Comma value
    ;

atomExchange
    :   atom Period mo Period scope Period Exch register Comma location Comma value
    ;

redInstruction
    :   red Period mo Period scope Period operation location Comma value
    ;

branchCond
    :   cond value Comma value Comma Label
    ;

jump
    :   Goto Label
    ;

label
    :   Label Colon
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

operation locals [IntBinaryOp op]
    :   Add {$op = IntBinaryOp.ADD;}
    |   Sub {$op = IntBinaryOp.SUB;}
    |   Mul {$op = IntBinaryOp.MUL;}
    |   Div {$op = IntBinaryOp.DIV;}
    |   And {$op = IntBinaryOp.AND;}
    |   Or {$op = IntBinaryOp.OR;}
    |   Xor {$op = IntBinaryOp.XOR;}
    ;

cond returns [CmpOp op]
    :   Beq {$op = CmpOp.EQ;}
    |   Bne {$op = CmpOp.NEQ;}
    |   Bge {$op = CmpOp.GTE;}
    |   Ble {$op = CmpOp.LTE;}
    |   Bgt {$op = CmpOp.GT;}
    |   Blt {$op = CmpOp.LT;}
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

value
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

Label
    :   'LC' DigitSequence
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
Arrive  :   'arrive';

CTA     :   'cta';
GPU     :   'gpu';
SYS     :   'sys';

Weak    :   'weak';
Relaxed :   'relaxed';
Acquire :   'acquire';
Release :   'release';
Acq_rel :   'acq_rel';
Sc      :   'sc';

Add     :   'add';
Sub     :   'sub';
Mul     :   'mul';
Div     :   'div';
And     :   'and';
Or      :   'or';
Xor     :   'xor';

Cas     :   'cas';
Exch    :   'exch';

Proxy       :   'proxy';
Generic     :   'generic';
Constant    :   'constant';
Surface     :   'surface';
Texture     :   'texture';
Aliases     :   'aliases';
Alias       :   'alias';

Beq    :   'beq';
Bne    :   'bne';
Blt    :   'blt';
Bgt    :   'bgt';
Ble    :   'ble';
Bge    :   'bge';

Goto   :   'goto';

LitmusLanguage
    :   'PTX'
    |   'ptx'
    ;