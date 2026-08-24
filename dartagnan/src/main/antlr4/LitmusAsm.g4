parser grammar LitmusAsm;

options {tokenVocab=LitmusAsmLexer;}

main: declarators threads instructions locations? filter? assertion? EOF;
declarators: Lbrace declarator? (Semi declarator)* Semi? Rbrace;
declarator
    :   type=Identifier object Lbracket size=Digits Rbracket #declaratorArray
    |   type=Identifier? object (Equals constant)? #declaratorObject
    |   type=Identifier? register (Equals constant)? #declaratorRegister
    ;
locations: Locations Lbracket location (Semi location)* Semi? Rbracket;
location: object | register;
threads: thread=Thread (ThreadDelim thread=Thread)* ThreadEnd;
instructions: instructionRow+;
instructionRow: instruction (InstructionRowDelim instruction)* InstructionRowEnd;
instruction: Instruction?;
filter: Filter condition Semi?;
assertion: (Exists | Notexists | Forall | Final) condition Semi? | Final condition Semi With expectation+;
expectation: test=Identifier Colon (Exists | Notexists) Semi;
condition
    :   Lpar condition Rpar #conditionPar
    |   Not condition #conditionNot
    |   condition And condition #conditionAnd
    |   condition Or condition #conditionOr
    |   lvalue Equals Equals? rvalue #conditionEq
    |   lvalue Greater rvalue #conditionGt
    |   lvalue Lower rvalue #conditionLt
    |   lvalue Greater Equals rvalue #conditionGe
    |   lvalue Lower Equals rvalue #conditionLe
    |   lvalue Excl Equals rvalue #conditionNe
    ;
lvalue: register | object (Lbracket Digits Rbracket)? | Lbracket object Rbracket;
rvalue: lvalue | literal;
register: (threadId=Digits | threadName=Identifier) Colon name=Identifier;
constant: literal | location;
literal: Minus? Digits | Hexdigits;
object: name=Identifier;
