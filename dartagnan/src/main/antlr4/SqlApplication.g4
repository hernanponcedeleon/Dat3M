parser grammar SqlApplication;
options {
    superClass = PostgreSQLParserBase;
    tokenVocab = SqlApplicationLexer;
 }

import PostgreSQLParser;

application
    : identifiert //as application name
        table_definitions
        assertions
        programm
        EOF
    ;

identifiert: PROGRAM_NAME;

table_definitions: TABLE_DEFINITIONS 
                    (createstmt SEMI)+;

assertions: ASSERTIONS 
            (selectstmt SEMI)+;

programm: APPLICATION txn+;

txn: TXN_BEGIN (preparablestmt SEMI)+ TXN_END;