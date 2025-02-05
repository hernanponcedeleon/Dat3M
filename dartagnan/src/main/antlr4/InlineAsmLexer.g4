lexer grammar InlineAsmLexer;

import BaseLexer;


// instructions 
LabelDefinition             : NumbersInline Colon; // like '1:'
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

// metadata 
OutputOpAssign              : Equals Amp RLiteral | Equals RLiteral;
InputOpGeneralReg           : RLiteral;
IsMemoryAddress             : 'Q' | Ast 'Q';
OverlapInOutRegister        : NumbersInline; // defines which returnvalue should be used both for input and output
PointerToMemoryLocation     : Equals Ast 'm';

// clobbers
ClobberMemory               : 'memory';
ClobberModifyFlags          : 'cc';
ClobberDirectionFlag        : 'dirflag';
ClobberFloatPntStatusReg    : 'fpsr';
ClobberFlags                : 'flags';



// fences
DataMemoryBarrier           : 'dmb';
DataSynchronizationBarrier  : 'dsb';
FenceArmOpt                 : 'sy' | 'st' | 'ish' | 'ishld' | 'ishst';
X86Fence                    : 'mfence';
RISCVFence                  : 'fence';
FenceRISCVOpt               : 'i' | 'o' | 'io' | RLiteral | RLiteral'w' | 'w' | 'tso';
PPCFence                    : 'sync' | 'isync' | 'lwsync';

// Metavariables
StartSymbol                 : 'asm';
PrefetchStoreL1Once         : 'pstl1strm';
IfThenThenOptions           : 'eq';
NumbersInline               : [0-9]+;
RLiteral                    : 'r'; // needed because both 'r' and '=&r' use the general purpose
Register                    : '${' ( ~('}' | '$') )+ '}' | '$' NumbersInline | '[$' NumbersInline ']' | '#' NumbersInline; // should match any ${*}
LabelReference              : [a-zA-Z0-9_]+ ;
EndInstruction              :'\\0A';


WS
    :   [ \t\r\n]+
        -> skip
    ;
