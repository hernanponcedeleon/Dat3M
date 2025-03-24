lexer grammar PPCLexer;

import BaseLexer;

// instructions 
Load                        : 'lwz' | 'ld';
LoadReserve                 : 'lwarx' | 'ldarx';
Compare                     : 'cmpw' | 'cmpd';
BranchNotEqual              : 'bne-';
Store                       : 'stw' | 'std';
StoreConditional            : 'stwcx.' | 'stdcx.';
Or                          : 'or'; 
Add                         : 'add';
AddImmediateCarry           : 'addic';
SubtractFrom                : 'subf';

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
XLiteral                    : 'x';
RLiteral                    : 'r';
ILiteral                    : 'i';
OLiteral                    : 'o';
IOLiteral                   : 'io';
MLiteral                    : 'm';
QCapitalLiteral             : 'Q';
ConstantValue               : Num Numbers;

// fences
PPCFence                    : 'sync' | 'isync' | 'lwsync';

// misc
Literal                     : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
