package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;

public class InsertEvent extends AbstractSqlEvent{


    public String affected_table;
    public SqlApplication.InsertstmtContext sstm;

    public InsertEvent(SqlApplication.InsertstmtContext sstm) {
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
