package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;

public class DeleteEvent extends AbstractSqlEvent{

    public SqlApplication.DeletestmtContext sstm;

    public DeleteEvent(SqlApplication.DeletestmtContext sstm) {
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
