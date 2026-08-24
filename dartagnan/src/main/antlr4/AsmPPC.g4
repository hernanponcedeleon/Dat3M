grammar AsmPPC;

lines : LineEnd* line (LineEnd+ line)* EOF;
line : label? directive?;
directive : mnemnonic=Name (operand (Comma operand)*)?;
operand
    : Register #operandRegister
    | Immediate #operandImmediate
    | Immediate LPar Register RPar #operandAddress
    | Name par? #operandLabel
    ;
label : Name par? Colon;
par : LPar (term (Comma term)*)? RPar;
term : par | ColonColon? Name par? term?;

LPar : '(';
RPar : ')';
LineEnd : '\n';
Comma : ',';
Colon : ':';
ColonColon : '::';
Register : 'r' [0-9]+;
Immediate : '-'? [0-9]+;
Name : [_.A-Za-z] [_.0-9A-Za-z]*;
WS : [ \t\r]+->skip;
