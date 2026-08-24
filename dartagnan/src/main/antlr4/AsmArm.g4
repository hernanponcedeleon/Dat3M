grammar AsmArm;

lines : LineEnd* line (LineEnd+ line)* EOF;
line : Label? directive?;
directive : mnemonic=Name (operand (Comma operand)*)?;
operand
    : Immediate shift? #immediate
    | Register64 shift? #register64
    | Register32 shift? #register32
    | Register32 Comma (Sxtw | Uxtw) #conversion
    | LBracket Register64 (Comma offset)? RBracket #address
    | Equals? Name #label
    | String #string
    | Number #number
    ;
offset
    : Immediate #offsetImmediate
    | Register64 #offsetRegister
    | Register32 Comma (Sxtw | Uxtw) #offsetConversion
    ;
shift : Comma (Lsl | Lsr | Asr) Immediate;

Comma: ',';
LBracket: '[';
RBracket: ']';
Equals : '=';
Lsl : [Ll] [Ss] [Ll];
Lsr : [Ll] [Ss] [Rr];
Asr : [Aa] [Ss] [Rr];
Sxtw : [Sx] [Xx] [Tt] [Ww];
Uxtw : [Uu] [Xx] [Tt] [Ww];
Register64 : [Xx] [0-9]+ | [Xx] [Zz] [Rr];
Register32 : [Ww] [0-9]+ | [Wx] [Zz] [Rr];
LineEnd : ((';' | '//') .*?)? '\n';
Label : Name ':';
Immediate : '#' Number;
String : '"' ('\\"' | .)*? '"';
Number : [0-9]+ | '0x' [0-9A-Fa-f]+;
Name : ([_.0-9A-Za-z] | '::')+ ('(' ([_,.0-9A-Za-z] | '::')* ')')?;
WS : [ \t\r]+->skip;
