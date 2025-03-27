lexer grammar AsmX86Lexer;

import BaseLexer;

// instructions are empty as we don't have inline x86 assembly atm

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

// fences
X86Fence                    : 'mfence';

// misc
Literal                     : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
