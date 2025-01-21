package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.parsers.PostgreSQLParser;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.parsers.PostgreSQLParser;


public class CreateEvent extends AbstractSqlEvent{

    public SqlApplication.CreatestmtContext sqlExpression;

    public CreateEvent(SqlApplication.CreatestmtContext sql_expression){
        sqlExpression = sql_expression;
    }

    @Override
    protected String defaultString() {
        return sqlExpression.getText();
    }

    @Override
    public Event getCopy() {
        return new CreateEvent(sqlExpression);
    }
}
