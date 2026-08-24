grammar AsmX86;

lines : LineEnd* line (LineEnd+ line)* EOF;
line : (label Colon)? directive?;
directive : mnemnonic=Name (operand (Comma operand)*)?;
operand
    : Type? LBracket base (opDisplacement=op displacement)? (opIndex=op index (Ast align)? )? RBracket #addressIntel
    | displacement? LPar base (Comma index (Comma align)?)? RPar #addressAtt
    | register #operandRegister
    | Immediate #operandImmediate
    | number #operandNumber
    | label #operandLabel
    ;
base : register | label;
displacement : number | Name op number | Name;
index : register;
align : Number;
number : Minus? Number;
register : Register;
label : Name par?;
op : Plus | Minus;
par : LPar (term (Comma term)*)? RPar;
term : par | ColonColon? Name par? term?;

Comma : ',';
LBracket : '[';
RBracket : ']';
LPar : '(';
RPar : ')';
ColonColon : '::';
Colon : ':';
Plus : '+';
Minus : '-';
Ast : '*';
AttRegister : '%' [A-Za-z]+;
Immediate : '$' Minus? Number;
Number : [0-9]+ | '0' [Xx] [0-9A-Fa-f]+;
LineEnd : (';' .*?)? '\n';
Type : ([Bb] [Yy] [Tt] [Ee] | [DQdq]? [Ww] [Oo] [Rr] [Dd]) [ ] [Pp] [Tt] [Rr];
Register
    : [ERer]? ([A-Da-d] [Xx] | [BSbs] [Pp] | [DSds] [Ii]) // 32-bit general purpose, prefix E -> 32 bits, R -> 64 bits.
    | [A-Da-d] [HLhl] // high and low byte-sized views.
    | [Rr] [0-9]+ [Dd]? // 64-bit general purpose registers, suffix D -> 32 bits.
    ;
Name : [._A-Za-z] [._0-9A-Za-z]*;
WS : [ \t\r]+ ->skip;
