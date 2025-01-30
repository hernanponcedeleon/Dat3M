package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;
import io.github.cvc5.Term;
import io.github.cvc5.TermManager;

import java.util.Map;
import java.util.Set;

public class SelectEvent extends AbstractSqlEvent {

    public SqlApplication.SelectstmtContext sstm;

    public SelectEvent(SqlApplication.SelectstmtContext sstm) {
        this.sstm = sstm;
    }

    @Override
    protected String defaultString() {
        return sstm.getText();
    }

    @Override
    public Event getCopy() {
        return null;
    }

    @Override
    public Term encode(TermManager tm, Map<String, CreateSqlEncoder.Table> tables) {
        return tm.mkTrue();
    }

    public Set<Table> getInputTables() {
        return Set.of();
    }

    public Table getOutputTable(){
        return null;
    }
}
