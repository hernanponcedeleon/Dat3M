package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.parsers.PostgreSQLParser;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.parsers.PostgreSQLParser;
import io.github.cvc5.Term;
import io.github.cvc5.TermManager;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Set;


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


    @Override
    public Term encode(TermManager tm, Map<String, CreateSqlEncoder.Table> tables) {
        return tm.mkTrue();
    }

    public Set<Table> getInputTables(){return Set.of();}
    public Table getOutputTable(){return null;}
}
