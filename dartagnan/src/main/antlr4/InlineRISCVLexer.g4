lexer grammar InlineRISCVLexer;

import BaseLexer;


// instructions 
Load                        : 'ld' | 'lw'; // since it is using 64 bit, we can evaluate store word as normal one as it picks up 32
LoadImmediate               : 'li';
LoadExclusive               : 'lr.d';
LoadAcquireExclusive        : 'lr.d.aq';
LoadAcquireReleaseExclusive : 'lr.d.aqrl';
Add                         : 'add';
Sub                         : 'sub';
BranchNotEqual              : 'bne';
BranchNotEqualZero          : 'bnez';
Store                       : 'sd' | 'sw'; // since it is using 64 bit, we can evaluate store word as normal one as it picks up 32
StoreConditional            : 'sc.d';
StoreConditionalRelease     : 'sc.d.rl';
Move                        : 'mv';
Negate                      : 'neg';
AtomicAdd                   : 'amoadd.d';
AtomicAddRelease            : 'amoadd.d.rl';
AtomicAddAcquireRelease     : 'amoadd.d.aqrl';

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


// fences
RISCVFence                  : 'fence';
TsoFence                    : 'tso';


LetterInline                : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
