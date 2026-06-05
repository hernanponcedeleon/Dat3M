grammar LitmusRISCV;

import LitmusAssertions;

@header{
import static com.dat3m.dartagnan.program.event.Tag.*;
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
    |   variableDeclaratorPointerLocation
    |   variableDeclaratorSymbolic
    |   variableDeclaratorArray
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

variableDeclaratorPointerLocation
    :   Ast Identifier Equals location
    ;

variableDeclaratorSymbolic
    :   type symRegister Equals location
    ;

variableDeclaratorArray
    :   type? location LBracket constant RBracket (Equals initArray)?
    ;

initArray
    :   LBrace arrayElement* (Comma arrayElement)* RBrace
    ;

arrayElement
    :   constant
    |   Ast? (Amp? location | LPar Amp? location RPar)
    ;

type
    :   Identifier
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
    |   mv
    |   li
    |   xor
    |   and
    |   or
    |   add
    |   xori
    |   andi
    |   ori
    |   addi
    |   ld
    |   lw
    |   sw
    |   lr
    |   sc
    |   label
    |   branchCond
    |   fence
    |   amoor
    |   amoswap
    |   amoadd
    |   return
    ;

mv
    :   Mv register Comma register
    ;

li
    :   Li register Comma constant
    ;

ld
    :   Ld (Period moRISCV)* register Comma offset LPar register RPar
    ;

lw
    :   Lw (Period moRISCV)* register Comma offset LPar register RPar
    ;

sw
    :   Sw (Period moRISCV)* register Comma offset LPar register RPar
    ;

lr
    :   Lr Period size (Period moRISCV)* register Comma offset LPar register RPar
    ;

sc
    :   Sc Period size (Period moRISCV)* register Comma register Comma offset LPar register RPar
    ;

size
    :   Word
    |   Double
    ;

xor
    :   Xor register Comma register Comma register
    ;

and
    :   And register Comma register Comma register
    ;

or
    :   Or register Comma register Comma register
    ;

add
    :   Add register Comma register Comma register
    ;

xori
    :   Xori register Comma register Comma constant
    ;

andi
    :   Andi register Comma register Comma constant
    ;

ori
    :   Ori register Comma register Comma constant
    ;

addi
    :   Addi register Comma register Comma constant
    ;

branchCond
    :   cond register Comma register Comma Label
    ;

label
    :   Label Colon
    ;

fence
    :   Fence (Period)? fenceMode
    ;
    
fenceMode returns [String mode]
    :   ReadRead {$mode = "r.r";}
    |   ReadWrite {$mode = "r.w";}
    |   ReadReadWrite {$mode = "r.rw";}
    |   WriteRead {$mode = "w.r";}
    |   WriteWrite {$mode = "w.w";}
    |   WriteReadWrite {$mode = "w.rw";}
    |   ReadWriteRead {$mode = "rw.r";}
    |   ReadWriteWrite {$mode = "rw.w";}
    |   ReadWriteReadWrite {$mode = "rw.rw";}
    |   Tso {$mode = "tso";}
    |   Synchronize {$mode = "i";}
    ;
    
amoor
    :   Amoor Period size (Period moRISCV)* register Comma register Comma LPar register RPar
    ;
    
amoswap
    :   Amoswap Period size (Period moRISCV)* register Comma register Comma LPar register RPar
    ;
    
amoadd
    :   Amoadd Period size (Period moRISCV)* register Comma register Comma LPar register RPar
    ;
    
return
    :   Ret
    ;

location
    :   Period? Identifier
    |   LBracket Identifier RBracket
    ;

register
    :   Register
    |   symRegister
    ;

offset
    :   DigitSequence
    ;

cond returns [IntCmpOp op]
    :   Beq {$op = IntCmpOp.EQ;}
    |   Bne {$op = IntCmpOp.NEQ;}
    |   Bge {$op = IntCmpOp.GTE;}
    |   Ble {$op = IntCmpOp.LTE;}
    |   Bgt {$op = IntCmpOp.GT;}
    |   Blt {$op = IntCmpOp.LT;}
    ;

assertionValue
    :   location
    |   threadId Colon register
    |   constant
    ;

moRISCV returns [String mo]
    :   Acq   {$mo = RISCV.MO_ACQ;}
    |   Rel   {$mo = RISCV.MO_REL;}
    ;

Locations
    :   'locations'
    ;

Add
    :   'add'
    ;

Addi
    :   'addi'
    ;

Amoor
    :   'amoor'
    ;

Amoswap
    :   'amoswap'
    ;

Amoadd
    :   'amoadd'
    ;

Andi
    :   'andi'
    ;

And
    :   'and'
    ;

Beq
    :   'beq'
    ;

Bne
    :   'bne'
    ;

Blt
    :   'blt'
    ;

Bgt
    :   'bgt'
    ;

Ble
    :   'ble'
    ;

Bge
    :   'bge'
    ;

Li  :   'li'
    ;

Lr
    :   'lr'
    ;

Ld
    :   'ld'
    ;

Lw
    :   'lw'
    ;

Mv
    :   'mv'
    ;

Sc
    :   'sc'
    ;

Sw
    :   'sw'
    ;

Fence
    :   'fence'
    ;

Or
    :   'or'
    ;

Ori
    :   'ori'
    ;

Xor
    :   'xor'
    ;

Xori
    :   'xori'
    ;

Ret
    :   'ret'
    ;

ReadRead
    :   'r' Comma 'r'
    ;

ReadWrite
    :   'r' Comma 'w'
    ;

ReadReadWrite
    :   'r' Comma 'rw'
    ;

WriteRead
    :   'w' Comma 'r'
    ;

WriteWrite
    :   'w' Comma 'w'
    ;

WriteReadWrite
    :   'w' Comma 'rw'
    ;

ReadWriteRead
    :   'rw' Comma 'r'
    ;

ReadWriteWrite
    :   'rw' Comma 'w'
    ;

ReadWriteReadWrite
    :   'rw' Comma 'rw'
    ;

Tso
    :   'tso'
    ;

Synchronize
    :   'i'
    ;

Acq
    :   'aq'
    ;

Rel
    :   'rl'
    ;

Word
    :   'w'
    ;

Double
    :   'd'
    ;

Register
    :   'a' DigitSequence
    |   's' DigitSequence
    |   't' DigitSequence
    |   'x' DigitSequence
    ;

symRegister
    :   Percent Identifier
    ;

Label
    :   'LC' DigitSequence
    ;

LitmusLanguage
    :   'RISCV'
    |   'riscv'
    ;
