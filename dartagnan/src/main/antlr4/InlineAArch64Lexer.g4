lexer grammar InlineAArch64Lexer;

import BaseLexer;


// instructions 
LabelDefinition             : NumbersInline Colon; // like '1:'
AlignInline                 : Period 'align 'NumbersInline;
LoadReg                     : 'ldr';
LoadAcquireReg              : 'ldar';
LoadExclusiveReg            : 'ldxr' | 'ldrex';
LoadAcquireExclusiveReg     : 'ldaxr';
Add                         : 'add';
Sub                         : 'sub';
Or                          : 'orr';
And                         : 'and';
Compare                     : 'cmp';
CompareBranchNonZero        : 'cbnz';
BranchEqual                 : 'b.eq';
BranchNotEqual              : 'b.ne' | 'bne';
SetEventLocally             : 'sevl';
WaitForEvent                : 'wfe';
StoreReg                    : 'str';
StoreExclusiveRegister      : 'stxr' | 'strex';
StoreReleaseExclusiveReg    : 'stlxr';
StoreReleaseReg             : 'stlr';
AtomicAddDoubleWordRelease  : 'staddl';
SwapWordAcquire             : 'swpa';
CompareAndSwap              : 'cas';
CompareAndSwapAcquire       : 'casa';
Move                        : 'mov';
PrefetchMemory              : 'prfm';
YieldTask                   : 'yield'; // used to tell Hw that we're in a spinlock. If not implemented it just NOPs


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
NumbersInline               : [0-9]+;
RLiteral                    : 'r'; // needed because both 'r' and '=&r' use the general purpose
Register                    : '${' ( ~('}' | '$') )+ '}' | '$' NumbersInline | '[$' NumbersInline ']' | '#' NumbersInline; // should match any ${*}
// ConstantInline              : '$' NumbersInline;   //if you see any $Number you state it is a constant
LabelReference              : [a-zA-Z0-9_]+ ;
EndInstruction              :'\\0A';


WS
    :   [ \t\r\n]+
        -> skip
    ;
