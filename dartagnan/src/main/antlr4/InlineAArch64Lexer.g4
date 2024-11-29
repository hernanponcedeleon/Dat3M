lexer grammar InlineAArch64Lexer;

import BaseLexer;


// instructions 
LabelDefinition             : NumbersInline':'; // like '1:'
AlignInline                 : '.align 'NumbersInline;
LoadReg                     : 'ldr';
LoadAcquireReg              : 'ldar';
LoadExclusiveReg            : 'ldxr';
LoadAcquireExclusiveReg     : 'ldaxr';
Add                         : 'add';
Sub                         : 'sub';
Or                          : 'orr';
And                         : 'and';
Compare                     : 'cmp';
CompareBranchNonZero        : 'cbnz';
BranchEqual                 : 'b.eq';
BranchNotEqual              : 'b.ne';
SetEventLocally             : 'sevl';
WaitForEvent                : 'wfe';
StoreReg                    : 'str';
StoreExclusiveRegister      : 'stxr';
StoreReleaseExclusiveReg    : 'stlxr';
StoreReleaseReg             : 'stlr';
AtomicAddDoubleWordRelease  : 'staddl';
DataMemoryBarrier           : 'dmb'; 
SwapWordAcquire             : 'swpa';
CompareAndSwap              : 'cas';
CompareAndSwapAcquire       : 'casa';
Move                        : 'mov';
PrefetchMemory              : 'prfm';
YieldTask                   : 'yield'; // used to tell Hw that we're in a spinlock. If not implemented it just NOPs


// metadata 
OutputOpAssign              : Equals Amp GeneralPurposeReg;
InputOpGeneralReg           : GeneralPurposeReg;
IsMemoryAddress             : 'Q' | '*Q';
MetadataExtraVariables      : '0' | '3'; // M3 mac produced inline with '0' in the metadata part of inline asm

// clobbers
ClobberMemory               : 'memory';
ClobberModifyFlags          : 'cc';
ClobberDirectionFlag        : 'dirflag';
ClobberFloatPntStatusReg    : 'fpsr';
ClobberFlags                : 'flags';


WS
    :   [ \t\r\n]+
        -> skip
    ;

// Metavariables
StartSymbol                 : 'asm';
PrefetchStoreL1Once         : 'pstl1strm';
NumbersInline               : [0-9]+;
GeneralPurposeReg           : 'r'; // needed because both 'r' and '=&r' use the general purpose
VariableInline              : '${' ( ~('}' | '$') )+ '}' ; // should match any ${*}
ConstantInline              : '$' NumbersInline;   //if you see any $Number you state it is a constant
DataMemoryBarrierOpt        : 'ish' | 'ishld'; //Inner Shareable symbols
LabelReference              : [a-zA-Z0-9_]+ ; //not sure if a label in arm can be like DD4 with capital letters, keeping them but might have to change it
EndInstruction              :'\\0A';
