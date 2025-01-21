package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;

public class SelectEvent extends AbstractSqlEvent{

    public SqlApplication.SelectstmtContext sstm;

    public SelectEvent(SqlApplication.SelectstmtContext sstm) {
        this.sstm= sstm;
    }

    @Override
    protected String defaultString() {
        return "";
    }

    @Override
    public Event getCopy() {
        return null;
    }
}
