lexer grammar InlineX86Lexer;

import BaseLexer;

// instructions are empty as we don't have inline PPC assembly atm

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
X86Fence                    : 'mfence';


LetterInline                : [a-z]+;
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
