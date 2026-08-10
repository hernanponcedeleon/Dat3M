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
    :   type SymRegister Equals location
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
    |   lui
    |   xor
    |   and
    |   or
    |   add
    |   xori
    |   andi
    |   ori
    |   addi
    |   addiw
    |   ld
    |   lw
    |   sw
    |   lr
    |   sc
    |   branchLabel
    |   branch
    |   branchCond
    |   fence
    |   amoor
    |   amoxor
    |   amoswap
    |   amoadd
    |   return
    |   sext
    |   zext
    ;

mv
    :   Mv register Comma register
    ;

li
    :   Li register Comma constant
    ;

lui
    :   Lui register Comma constant
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

sext
    :   Sext Period size register Comma register
    ;

zext
    :   Zext Period size register Comma register
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

addiw
    :   Addiw register Comma register Comma constant
    ;

branchLabel
    :   label Colon
    ;

branch
    :   Jmp label
    ;

branchCond
    :   cond register Comma register Comma label
    ;

fence
    :   Fence (Period)? fenceMode
    ;
    
fenceMode returns [String mode]
    :   I_I {$mode = "i.i";}
    |   I_O {$mode = "i.o";}
    |   I_R {$mode = "i.r";}
    |   I_W {$mode = "i.w";}
    |   I_IO {$mode = "i.io";}
    |   I_IR {$mode = "i.ir";}
    |   I_IW {$mode = "i.iw";}
    |   I_OR {$mode = "i.or";}
    |   I_OW {$mode = "i.ow";}
    |   I_RW {$mode = "i.rw";}
    |   I_IOR {$mode = "i.ior";}
    |   I_IOW {$mode = "i.iow";}
    |   I_IRW {$mode = "i.irw";}
    |   I_ORW {$mode = "i.orw";}
    |   I_IORW {$mode = "i.iorw";}
    |   O_I {$mode = "o.i";}
    |   O_O {$mode = "o.o";}
    |   O_R {$mode = "o.r";}
    |   O_W {$mode = "o.w";}
    |   O_IO {$mode = "o.io";}
    |   O_IR {$mode = "o.ir";}
    |   O_IW {$mode = "o.iw";}
    |   O_OR {$mode = "o.or";}
    |   O_OW {$mode = "o.ow";}
    |   O_RW {$mode = "o.rw";}
    |   O_IOR {$mode = "o.ior";}
    |   O_IOW {$mode = "o.iow";}
    |   O_IRW {$mode = "o.irw";}
    |   O_ORW {$mode = "o.orw";}
    |   O_IORW {$mode = "o.iorw";}
    |   R_I {$mode = "r.i";}
    |   R_O {$mode = "r.o";}
    |   R_R {$mode = "r.r";}
    |   R_W {$mode = "r.w";}
    |   R_IO {$mode = "r.io";}
    |   R_IR {$mode = "r.ir";}
    |   R_IW {$mode = "r.iw";}
    |   R_OR {$mode = "r.or";}
    |   R_OW {$mode = "r.ow";}
    |   R_RW {$mode = "r.rw";}
    |   R_IOR {$mode = "r.ior";}
    |   R_IOW {$mode = "r.iow";}
    |   R_IRW {$mode = "r.irw";}
    |   R_ORW {$mode = "r.orw";}
    |   R_IORW {$mode = "r.iorw";}
    |   W_I {$mode = "w.i";}
    |   W_O {$mode = "w.o";}
    |   W_R {$mode = "w.r";}
    |   W_W {$mode = "w.w";}
    |   W_IO {$mode = "w.io";}
    |   W_IR {$mode = "w.ir";}
    |   W_IW {$mode = "w.iw";}
    |   W_OR {$mode = "w.or";}
    |   W_OW {$mode = "w.ow";}
    |   W_RW {$mode = "w.rw";}
    |   W_IOR {$mode = "w.ior";}
    |   W_IOW {$mode = "w.iow";}
    |   W_IRW {$mode = "w.irw";}
    |   W_ORW {$mode = "w.orw";}
    |   W_IORW {$mode = "w.iorw";}
    |   IO_I {$mode = "io.i";}
    |   IO_O {$mode = "io.o";}
    |   IO_R {$mode = "io.r";}
    |   IO_W {$mode = "io.w";}
    |   IO_IO {$mode = "io.io";}
    |   IO_IR {$mode = "io.ir";}
    |   IO_IW {$mode = "io.iw";}
    |   IO_OR {$mode = "io.or";}
    |   IO_OW {$mode = "io.ow";}
    |   IO_RW {$mode = "io.rw";}
    |   IO_IOR {$mode = "io.ior";}
    |   IO_IOW {$mode = "io.iow";}
    |   IO_IRW {$mode = "io.irw";}
    |   IO_ORW {$mode = "io.orw";}
    |   IO_IORW {$mode = "io.iorw";}
    |   IR_I {$mode = "ir.i";}
    |   IR_O {$mode = "ir.o";}
    |   IR_R {$mode = "ir.r";}
    |   IR_W {$mode = "ir.w";}
    |   IR_IO {$mode = "ir.io";}
    |   IR_IR {$mode = "ir.ir";}
    |   IR_IW {$mode = "ir.iw";}
    |   IR_OR {$mode = "ir.or";}
    |   IR_OW {$mode = "ir.ow";}
    |   IR_RW {$mode = "ir.rw";}
    |   IR_IOR {$mode = "ir.ior";}
    |   IR_IOW {$mode = "ir.iow";}
    |   IR_IRW {$mode = "ir.irw";}
    |   IR_ORW {$mode = "ir.orw";}
    |   IR_IORW {$mode = "ir.iorw";}
    |   IW_I {$mode = "iw.i";}
    |   IW_O {$mode = "iw.o";}
    |   IW_R {$mode = "iw.r";}
    |   IW_W {$mode = "iw.w";}
    |   IW_IO {$mode = "iw.io";}
    |   IW_IR {$mode = "iw.ir";}
    |   IW_IW {$mode = "iw.iw";}
    |   IW_OR {$mode = "iw.or";}
    |   IW_OW {$mode = "iw.ow";}
    |   IW_RW {$mode = "iw.rw";}
    |   IW_IOR {$mode = "iw.ior";}
    |   IW_IOW {$mode = "iw.iow";}
    |   IW_IRW {$mode = "iw.irw";}
    |   IW_ORW {$mode = "iw.orw";}
    |   IW_IORW {$mode = "iw.iorw";}
    |   OR_I {$mode = "or.i";}
    |   OR_O {$mode = "or.o";}
    |   OR_R {$mode = "or.r";}
    |   OR_W {$mode = "or.w";}
    |   OR_IO {$mode = "or.io";}
    |   OR_IR {$mode = "or.ir";}
    |   OR_IW {$mode = "or.iw";}
    |   OR_OR {$mode = "or.or";}
    |   OR_OW {$mode = "or.ow";}
    |   OR_RW {$mode = "or.rw";}
    |   OR_IOR {$mode = "or.ior";}
    |   OR_IOW {$mode = "or.iow";}
    |   OR_IRW {$mode = "or.irw";}
    |   OR_ORW {$mode = "or.orw";}
    |   OR_IORW {$mode = "or.iorw";}
    |   OW_I {$mode = "ow.i";}
    |   OW_O {$mode = "ow.o";}
    |   OW_R {$mode = "ow.r";}
    |   OW_W {$mode = "ow.w";}
    |   OW_IO {$mode = "ow.io";}
    |   OW_IR {$mode = "ow.ir";}
    |   OW_IW {$mode = "ow.iw";}
    |   OW_OR {$mode = "ow.or";}
    |   OW_OW {$mode = "ow.ow";}
    |   OW_RW {$mode = "ow.rw";}
    |   OW_IOR {$mode = "ow.ior";}
    |   OW_IOW {$mode = "ow.iow";}
    |   OW_IRW {$mode = "ow.irw";}
    |   OW_ORW {$mode = "ow.orw";}
    |   OW_IORW {$mode = "ow.iorw";}
    |   RW_I {$mode = "rw.i";}
    |   RW_O {$mode = "rw.o";}
    |   RW_R {$mode = "rw.r";}
    |   RW_W {$mode = "rw.w";}
    |   RW_IO {$mode = "rw.io";}
    |   RW_IR {$mode = "rw.ir";}
    |   RW_IW {$mode = "rw.iw";}
    |   RW_OR {$mode = "rw.or";}
    |   RW_OW {$mode = "rw.ow";}
    |   RW_RW {$mode = "rw.rw";}
    |   RW_IOR {$mode = "rw.ior";}
    |   RW_IOW {$mode = "rw.iow";}
    |   RW_IRW {$mode = "rw.irw";}
    |   RW_ORW {$mode = "rw.orw";}
    |   RW_IORW {$mode = "rw.iorw";}
    |   IOR_I {$mode = "ior.i";}
    |   IOR_O {$mode = "ior.o";}
    |   IOR_R {$mode = "ior.r";}
    |   IOR_W {$mode = "ior.w";}
    |   IOR_IO {$mode = "ior.io";}
    |   IOR_IR {$mode = "ior.ir";}
    |   IOR_IW {$mode = "ior.iw";}
    |   IOR_OR {$mode = "ior.or";}
    |   IOR_OW {$mode = "ior.ow";}
    |   IOR_RW {$mode = "ior.rw";}
    |   IOR_IOR {$mode = "ior.ior";}
    |   IOR_IOW {$mode = "ior.iow";}
    |   IOR_IRW {$mode = "ior.irw";}
    |   IOR_ORW {$mode = "ior.orw";}
    |   IOR_IORW {$mode = "ior.iorw";}
    |   IOW_I {$mode = "iow.i";}
    |   IOW_O {$mode = "iow.o";}
    |   IOW_R {$mode = "iow.r";}
    |   IOW_W {$mode = "iow.w";}
    |   IOW_IO {$mode = "iow.io";}
    |   IOW_IR {$mode = "iow.ir";}
    |   IOW_IW {$mode = "iow.iw";}
    |   IOW_OR {$mode = "iow.or";}
    |   IOW_OW {$mode = "iow.ow";}
    |   IOW_RW {$mode = "iow.rw";}
    |   IOW_IOR {$mode = "iow.ior";}
    |   IOW_IOW {$mode = "iow.iow";}
    |   IOW_IRW {$mode = "iow.irw";}
    |   IOW_ORW {$mode = "iow.orw";}
    |   IOW_IORW {$mode = "iow.iorw";}
    |   IRW_I {$mode = "irw.i";}
    |   IRW_O {$mode = "irw.o";}
    |   IRW_R {$mode = "irw.r";}
    |   IRW_W {$mode = "irw.w";}
    |   IRW_IO {$mode = "irw.io";}
    |   IRW_IR {$mode = "irw.ir";}
    |   IRW_IW {$mode = "irw.iw";}
    |   IRW_OR {$mode = "irw.or";}
    |   IRW_OW {$mode = "irw.ow";}
    |   IRW_RW {$mode = "irw.rw";}
    |   IRW_IOR {$mode = "irw.ior";}
    |   IRW_IOW {$mode = "irw.iow";}
    |   IRW_IRW {$mode = "irw.irw";}
    |   IRW_ORW {$mode = "irw.orw";}
    |   IRW_IORW {$mode = "irw.iorw";}
    |   ORW_I {$mode = "orw.i";}
    |   ORW_O {$mode = "orw.o";}
    |   ORW_R {$mode = "orw.r";}
    |   ORW_W {$mode = "orw.w";}
    |   ORW_IO {$mode = "orw.io";}
    |   ORW_IR {$mode = "orw.ir";}
    |   ORW_IW {$mode = "orw.iw";}
    |   ORW_OR {$mode = "orw.or";}
    |   ORW_OW {$mode = "orw.ow";}
    |   ORW_RW {$mode = "orw.rw";}
    |   ORW_IOR {$mode = "orw.ior";}
    |   ORW_IOW {$mode = "orw.iow";}
    |   ORW_IRW {$mode = "orw.irw";}
    |   ORW_ORW {$mode = "orw.orw";}
    |   ORW_IORW {$mode = "orw.iorw";}
    |   IORW_I {$mode = "iorw.i";}
    |   IORW_O {$mode = "iorw.o";}
    |   IORW_R {$mode = "iorw.r";}
    |   IORW_W {$mode = "iorw.w";}
    |   IORW_IO {$mode = "iorw.io";}
    |   IORW_IR {$mode = "iorw.ir";}
    |   IORW_IW {$mode = "iorw.iw";}
    |   IORW_OR {$mode = "iorw.or";}
    |   IORW_OW {$mode = "iorw.ow";}
    |   IORW_RW {$mode = "iorw.rw";}
    |   IORW_IOR {$mode = "iorw.ior";}
    |   IORW_IOW {$mode = "iorw.iow";}
    |   IORW_IRW {$mode = "iorw.irw";}
    |   IORW_ORW {$mode = "iorw.orw";}
    |   IORW_IORW {$mode = "iorw.iorw";}
    |   Tso {$mode = "tso";}
    |   Synchronize {$mode = "i";}
    ;

amoor
    :   Amoor Period size (Period moRISCV)* register Comma register Comma LPar register RPar
    ;
    
amoxor
    :   Amoxor Period size (Period moRISCV)* register Comma register Comma LPar register RPar
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
    |   SymRegister
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

label
    :   Identifier
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

Addiw
    :   'addiw'
    ;

Amoor
    :   'amoor'
    ;

Amoxor
    :   'amoxor'
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

Jmp :   'j'
    ;

Li  :   'li'
    ;

Lui :   'lui'
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

Sext
    :   'sext'
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

Ret
    :   'ret'
    ;

Xor
    :   'xor'
    ;

Xori
    :   'xori'
    ;

Zext
    :   'zext'
    ;

I_I : 'i' Comma 'i';
I_O : 'i' Comma 'o';
I_R : 'i' Comma 'r';
I_W : 'i' Comma 'w';
I_IO : 'i' Comma 'io';
I_IR : 'i' Comma 'ir';
I_IW : 'i' Comma 'iw';
I_OR : 'i' Comma 'or';
I_OW : 'i' Comma 'ow';
I_RW : 'i' Comma 'rw';
I_IOR : 'i' Comma 'ior';
I_IOW : 'i' Comma 'iow';
I_IRW : 'i' Comma 'irw';
I_ORW : 'i' Comma 'orw';
I_IORW : 'i' Comma 'iorw';

O_I : 'o' Comma 'i';
O_O : 'o' Comma 'o';
O_R : 'o' Comma 'r';
O_W : 'o' Comma 'w';
O_IO : 'o' Comma 'io';
O_IR : 'o' Comma 'ir';
O_IW : 'o' Comma 'iw';
O_OR : 'o' Comma 'or';
O_OW : 'o' Comma 'ow';
O_RW : 'o' Comma 'rw';
O_IOR : 'o' Comma 'ior';
O_IOW : 'o' Comma 'iow';
O_IRW : 'o' Comma 'irw';
O_ORW : 'o' Comma 'orw';
O_IORW : 'o' Comma 'iorw';

R_I : 'r' Comma 'i';
R_O : 'r' Comma 'o';
R_R : 'r' Comma 'r';
R_W : 'r' Comma 'w';
R_IO : 'r' Comma 'io';
R_IR : 'r' Comma 'ir';
R_IW : 'r' Comma 'iw';
R_OR : 'r' Comma 'or';
R_OW : 'r' Comma 'ow';
R_RW : 'r' Comma 'rw';
R_IOR : 'r' Comma 'ior';
R_IOW : 'r' Comma 'iow';
R_IRW : 'r' Comma 'irw';
R_ORW : 'r' Comma 'orw';
R_IORW : 'r' Comma 'iorw';

W_I : 'w' Comma 'i';
W_O : 'w' Comma 'o';
W_R : 'w' Comma 'r';
W_W : 'w' Comma 'w';
W_IO : 'w' Comma 'io';
W_IR : 'w' Comma 'ir';
W_IW : 'w' Comma 'iw';
W_OR : 'w' Comma 'or';
W_OW : 'w' Comma 'ow';
W_RW : 'w' Comma 'rw';
W_IOR : 'w' Comma 'ior';
W_IOW : 'w' Comma 'iow';
W_IRW : 'w' Comma 'irw';
W_ORW : 'w' Comma 'orw';
W_IORW : 'w' Comma 'iorw';

IO_I : 'io' Comma 'i';
IO_O : 'io' Comma 'o';
IO_R : 'io' Comma 'r';
IO_W : 'io' Comma 'w';
IO_IO : 'io' Comma 'io';
IO_IR : 'io' Comma 'ir';
IO_IW : 'io' Comma 'iw';
IO_OR : 'io' Comma 'or';
IO_OW : 'io' Comma 'ow';
IO_RW : 'io' Comma 'rw';
IO_IOR : 'io' Comma 'ior';
IO_IOW : 'io' Comma 'iow';
IO_IRW : 'io' Comma 'irw';
IO_ORW : 'io' Comma 'orw';
IO_IORW : 'io' Comma 'iorw';

IR_I : 'ir' Comma 'i';
IR_O : 'ir' Comma 'o';
IR_R : 'ir' Comma 'r';
IR_W : 'ir' Comma 'w';
IR_IO : 'ir' Comma 'io';
IR_IR : 'ir' Comma 'ir';
IR_IW : 'ir' Comma 'iw';
IR_OR : 'ir' Comma 'or';
IR_OW : 'ir' Comma 'ow';
IR_RW : 'ir' Comma 'rw';
IR_IOR : 'ir' Comma 'ior';
IR_IOW : 'ir' Comma 'iow';
IR_IRW : 'ir' Comma 'irw';
IR_ORW : 'ir' Comma 'orw';
IR_IORW : 'ir' Comma 'iorw';

IW_I : 'iw' Comma 'i';
IW_O : 'iw' Comma 'o';
IW_R : 'iw' Comma 'r';
IW_W : 'iw' Comma 'w';
IW_IO : 'iw' Comma 'io';
IW_IR : 'iw' Comma 'ir';
IW_IW : 'iw' Comma 'iw';
IW_OR : 'iw' Comma 'or';
IW_OW : 'iw' Comma 'ow';
IW_RW : 'iw' Comma 'rw';
IW_IOR : 'iw' Comma 'ior';
IW_IOW : 'iw' Comma 'iow';
IW_IRW : 'iw' Comma 'irw';
IW_ORW : 'iw' Comma 'orw';
IW_IORW : 'iw' Comma 'iorw';

OR_I : 'or' Comma 'i';
OR_O : 'or' Comma 'o';
OR_R : 'or' Comma 'r';
OR_W : 'or' Comma 'w';
OR_IO : 'or' Comma 'io';
OR_IR : 'or' Comma 'ir';
OR_IW : 'or' Comma 'iw';
OR_OR : 'or' Comma 'or';
OR_OW : 'or' Comma 'ow';
OR_RW : 'or' Comma 'rw';
OR_IOR : 'or' Comma 'ior';
OR_IOW : 'or' Comma 'iow';
OR_IRW : 'or' Comma 'irw';
OR_ORW : 'or' Comma 'orw';
OR_IORW : 'or' Comma 'iorw';

OW_I : 'ow' Comma 'i';
OW_O : 'ow' Comma 'o';
OW_R : 'ow' Comma 'r';
OW_W : 'ow' Comma 'w';
OW_IO : 'ow' Comma 'io';
OW_IR : 'ow' Comma 'ir';
OW_IW : 'ow' Comma 'iw';
OW_OR : 'ow' Comma 'or';
OW_OW : 'ow' Comma 'ow';
OW_RW : 'ow' Comma 'rw';
OW_IOR : 'ow' Comma 'ior';
OW_IOW : 'ow' Comma 'iow';
OW_IRW : 'ow' Comma 'irw';
OW_ORW : 'ow' Comma 'orw';
OW_IORW : 'ow' Comma 'iorw';

RW_I : 'rw' Comma 'i';
RW_O : 'rw' Comma 'o';
RW_R : 'rw' Comma 'r';
RW_W : 'rw' Comma 'w';
RW_IO : 'rw' Comma 'io';
RW_IR : 'rw' Comma 'ir';
RW_IW : 'rw' Comma 'iw';
RW_OR : 'rw' Comma 'or';
RW_OW : 'rw' Comma 'ow';
RW_RW : 'rw' Comma 'rw';
RW_IOR : 'rw' Comma 'ior';
RW_IOW : 'rw' Comma 'iow';
RW_IRW : 'rw' Comma 'irw';
RW_ORW : 'rw' Comma 'orw';
RW_IORW : 'rw' Comma 'iorw';

IOR_I : 'ior' Comma 'i';
IOR_O : 'ior' Comma 'o';
IOR_R : 'ior' Comma 'r';
IOR_W : 'ior' Comma 'w';
IOR_IO : 'ior' Comma 'io';
IOR_IR : 'ior' Comma 'ir';
IOR_IW : 'ior' Comma 'iw';
IOR_OR : 'ior' Comma 'or';
IOR_OW : 'ior' Comma 'ow';
IOR_RW : 'ior' Comma 'rw';
IOR_IOR : 'ior' Comma 'ior';
IOR_IOW : 'ior' Comma 'iow';
IOR_IRW : 'ior' Comma 'irw';
IOR_ORW : 'ior' Comma 'orw';
IOR_IORW : 'ior' Comma 'iorw';

IOW_I : 'iow' Comma 'i';
IOW_O : 'iow' Comma 'o';
IOW_R : 'iow' Comma 'r';
IOW_W : 'iow' Comma 'w';
IOW_IO : 'iow' Comma 'io';
IOW_IR : 'iow' Comma 'ir';
IOW_IW : 'iow' Comma 'iw';
IOW_OR : 'iow' Comma 'or';
IOW_OW : 'iow' Comma 'ow';
IOW_RW : 'iow' Comma 'rw';
IOW_IOR : 'iow' Comma 'ior';
IOW_IOW : 'iow' Comma 'iow';
IOW_IRW : 'iow' Comma 'irw';
IOW_ORW : 'iow' Comma 'orw';
IOW_IORW : 'iow' Comma 'iorw';

IRW_I : 'irw' Comma 'i';
IRW_O : 'irw' Comma 'o';
IRW_R : 'irw' Comma 'r';
IRW_W : 'irw' Comma 'w';
IRW_IO : 'irw' Comma 'io';
IRW_IR : 'irw' Comma 'ir';
IRW_IW : 'irw' Comma 'iw';
IRW_OR : 'irw' Comma 'or';
IRW_OW : 'irw' Comma 'ow';
IRW_RW : 'irw' Comma 'rw';
IRW_IOR : 'irw' Comma 'ior';
IRW_IOW : 'irw' Comma 'iow';
IRW_IRW : 'irw' Comma 'irw';
IRW_ORW : 'irw' Comma 'orw';
IRW_IORW : 'irw' Comma 'iorw';

ORW_I : 'orw' Comma 'i';
ORW_O : 'orw' Comma 'o';
ORW_R : 'orw' Comma 'r';
ORW_W : 'orw' Comma 'w';
ORW_IO : 'orw' Comma 'io';
ORW_IR : 'orw' Comma 'ir';
ORW_IW : 'orw' Comma 'iw';
ORW_OR : 'orw' Comma 'or';
ORW_OW : 'orw' Comma 'ow';
ORW_RW : 'orw' Comma 'rw';
ORW_IOR : 'orw' Comma 'ior';
ORW_IOW : 'orw' Comma 'iow';
ORW_IRW : 'orw' Comma 'irw';
ORW_ORW : 'orw' Comma 'orw';
ORW_IORW : 'orw' Comma 'iorw';

IORW_I : 'iorw' Comma 'i';
IORW_O : 'iorw' Comma 'o';
IORW_R : 'iorw' Comma 'r';
IORW_W : 'iorw' Comma 'w';
IORW_IO : 'iorw' Comma 'io';
IORW_IR : 'iorw' Comma 'ir';
IORW_IW : 'iorw' Comma 'iw';
IORW_OR : 'iorw' Comma 'or';
IORW_OW : 'iorw' Comma 'ow';
IORW_RW : 'iorw' Comma 'rw';
IORW_IOR : 'iorw' Comma 'ior';
IORW_IOW : 'iorw' Comma 'iow';
IORW_IRW : 'iorw' Comma 'irw';
IORW_ORW : 'iorw' Comma 'orw';
IORW_IORW : 'iorw' Comma 'iorw';

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

SymRegister
    :   Percent Identifier
    ;

LitmusLanguage
    :   'RISCV'
    |   'riscv'
    ;
