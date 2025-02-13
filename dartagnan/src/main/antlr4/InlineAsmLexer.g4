lexer grammar InlineAsmLexer;

import BaseLexer;


// instructions 
AlignInline                 : Period 'align 'NumbersInline;
Load                        : 'ldr';
LoadAcquire                 : 'ldar';
LoadExclusive               : 'ldxr' | 'ldrex';
LoadAcquireExclusive        : 'ldaxr';
Add                         : 'add';
Sub                         : 'sub';
Or                          : 'orr';
And                         : 'and';
Compare                     : 'cmp';
CompareBranchNonZero        : 'cbnz';
BranchEqual                 : 'b.eq' | 'beq';
BranchNotEqual              : 'b.ne' | 'bne';
SetEventLocally             : 'sevl';
WaitForEvent                : 'wfe';
Store                       : 'str';
StoreExclusive              : 'stxr' | 'strex';
StoreReleaseExclusive       : 'stlxr';
StoreRelease                : 'stlr';
Move                        : 'mov';
PrefetchMemory              : 'prfm';
YieldTask                   : 'yield';
<<<<<<< HEAD
=======

// metadata 
OutputOpAssign              : Equals Amp? RLiteral;
InputOpGeneralReg           : RLiteral;
MemoryAddress               : Ast? 'Q';
OverlapInOutRegister        : NumbersInline; // defines which returnvalue should be used both for input and output
PointerToMemoryLocation     : Equals Ast 'm';
>>>>>>> 2d85efd32 (first cleaning pass, public and private, removed getEvents in InlineParser, removed unsupported operators and more consistent names in .g4)

// clobbers
ClobberMemory               : 'memory';
ClobberModifyFlags          : 'cc';
ClobberDirectionFlag        : 'dirflag';
ClobberFloatPntStatusReg    : 'fpsr';
ClobberFlags                : 'flags';


// Metavariables
StartSymbol                 : 'asm';
PrefetchStoreL1Once         : 'pstl1strm';
// helpers for parser rules
NumbersInline               : [0-9]+;
XLiteral                    : 'x';
RLiteral                    : 'r';
WLiteral                    : 'w';
RWLiteral                   : 'rw';
ILiteral                    : 'i';
OLiteral                    : 'o';
IOLiteral                   : 'io';
MLiteral                    : 'm';
QCapitalLiteral             : 'Q';
RegisterSizeHint            : Colon (XLiteral | 'w');


// fences
DataMemoryBarrier           : 'dmb';
DataSynchronizationBarrier  : 'dsb';
FenceArmOpt                 : 'sy' | 'st' | 'ish' | 'ishld' | 'ishst';
X86Fence                    : 'mfence';
RISCVFence                  : 'fence';
TsoFence                    : 'tso';
PPCFence                    : 'sync' | 'isync' | 'lwsync';

<<<<<<< HEAD

LetterInline                : [a-z]+;
=======
// Metavariables
StartSymbol                 : 'asm';
PrefetchStoreL1Once         : 'pstl1strm';
IfThenThenOptions           : 'eq';
NumbersInline               : [0-9]+;
RLiteral                    : 'r'; // needed because both 'r' and '=&r' use the general purpose
Register                    : '${' ( ~('}' | '$') )+ '}' | '$' NumbersInline | '[$' NumbersInline ']'; // should match any ${*}
ConstantValue               : Num NumbersInline;
LabelReference              : [a-zA-Z0-9_]+ ;
>>>>>>> 2d85efd32 (first cleaning pass, public and private, removed getEvents in InlineParser, removed unsupported operators and more consistent names in .g4)
EndInstruction              :'\\0A';
WS
    :   [ \t\r\n]+
        -> skip
    ;
