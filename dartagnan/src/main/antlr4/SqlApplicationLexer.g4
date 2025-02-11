lexer grammar SqlApplicationLexer;
options {
    superClass = PostgreSQLLexerBase;
    caseInsensitive = true;
}

import PostgreSQLLexer;

PROGRAM_NAME: 'program_' [a-zA-Z]+;

TABLE_DEFINITIONS: 'table_definition:';
ASSERTIONS: 'assertions:';
APPLICATION: 'application:';

TXN_BEGIN: 'BEGIN TRANSACTION' '\n';
TXN_END: '\n' 'END TRANSACTION';

SEMI: ';';

WS: [ \t\n\r\f]+ -> skip ;