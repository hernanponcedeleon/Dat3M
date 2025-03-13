lexer grammar InlinePPCLexer;

import BaseLexer;

// instructions are empty as we don't have inline PPC assembly atm
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
NumbersInline               : [0-9]+;
XLiteral                    : 'x';
RLiteral                    : 'r';
ILiteral                    : 'i';
OLiteral                    : 'o';
IOLiteral                   : 'io';
MLiteral                    : 'm';
QCapitalLiteral             : 'Q';
ConstantValue               : Num NumbersInline;


// fences
PPCFence                    : 'sync' | 'isync' | 'lwsync';


LetterInline                : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
