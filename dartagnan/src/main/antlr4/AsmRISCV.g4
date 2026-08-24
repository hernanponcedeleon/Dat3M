grammar AsmRISCV;

lines : LineEnd* line (LineEnd+ line)* EOF;
line : label? directive?;
directive : mnemonic=Name (WS operand (Comma operand)*)?;
operand
    : Register #register
    | Constant #constant
    | Constant? LPar Register RPar #address
    | Name #operandLabel
    ;
label : Name par? Colon;
par : LPar (Comma | Name | par)* RPar;

Colon : ':';
LPar : '(';
RPar : ')';
Register : [ASTXastx] [0-9]+ | 'pc' | 'zero' | 'ra' | 'sp' | 'gp' | 'tp' | 'fp';
Constant : [0-9]+;
LineEnd : WS? (';' ~[\n]*)? '\n' WS?;
Comma : WS? ',' WS?;
Name : ('::'? [_.0-9A-Za-z]+)+;
WS : [ \t]+;

