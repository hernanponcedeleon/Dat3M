lexer grammar InlineRISCVLexer;

import BaseLexer;


// instructions 
Load                        : 'ld';
LoadExclusive               : 'lr.d';
LoadAcquireExclusive        : 'lr.d.aq' | 'lr.d.aqrl'; // the second one has both acquire and release!!!
Add                         : 'add';
Sub                         : 'sub';
BranchNotEqual              : 'bne';
BranchNotEqualZero          : 'bnez';
Store                       : 'sd';
StoreExclusive              : 'sc.d';
StoreReleaseExclusive       : 'sc.d.rl';
Move                        : 'mv';
Negate                      : 'neg';
AtomicAdd                   : 'amoadd.d';
AtomicAddRelease            : 'amoadd.d.rl' | 'amoadd.d.aqrl'; // also this second one has both acquire and relase

// clobbers
ClobberMemory               : 'memory';
ClobberModifyFlags          : 'cc';
ClobberDirectionFlag        : 'dirflag';
ClobberFloatPntStatusReg    : 'fpsr';
ClobberFlags                : 'flags';


// Metavariables
StartSymbol                 : 'asm';
// helpers for parser rules
NumbersInline               : [0-9]+;
RLiteral                    : 'r';
WLiteral                    : 'w';
RWLiteral                   : 'rw';
ILiteral                    : 'i';
OLiteral                    : 'o';
IOLiteral                   : 'io';
MLiteral                    : 'm';
ACapitalLiteral             : 'A';
ConstantValue               : Num NumbersInline;


// fences
RISCVFence                  : 'fence';
TsoFence                    : 'tso';


LetterInline                : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
