lexer grammar RISCVLexer;

import BaseLexer;


// instructions 
Load                        : 'ld' | 'lw' | 'lwu';
LoadImmediate               : 'li';
LoadExclusive               : 'lr.d' | 'lr.w';
LoadAcquireExclusive        : 'lr.d.aq';
LoadAcquireReleaseExclusive : 'lr.d.aqrl';
Add                         : 'add';
Sub                         : 'sub';
BranchNotEqual              : 'bne';
BranchNotEqualZero          : 'bnez';
Store                       : 'sd' | 'sw';
StoreConditional            : 'sc.d' | 'sc.w';
StoreConditionalRelease     : 'sc.d.rl';
Move                        : 'mv';
Negate                      : 'neg';

// at the moment these instructions are NOT supported by dat3m
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
Numbers                     : [0-9]+;
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

// misc
Literal                     : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
