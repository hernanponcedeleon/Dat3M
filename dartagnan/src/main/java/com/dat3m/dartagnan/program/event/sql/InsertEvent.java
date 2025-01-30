package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.encoding.sql.InsertStmEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import io.github.cvc5.TermManager;

import java.util.*;

public class InsertEvent extends AbstractSqlEvent{


    public String affected_table;
    public SqlApplication.InsertstmtContext sstm;

    InsertStmEncoder enc;

    Term output_const;

    public InsertEvent(SqlApplication.InsertstmtContext sstm) {
        this.sstm= sstm;
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
        enc = new InsertStmEncoder(tm,tables,getLocalId());
        Term t = sstm.accept(enc);

        output_const = tm.mkConst(t.getSort(),"insert_"+enc.into_name+"_"+getGlobalId());
        Term eq = tm.mkTerm(Kind.EQUAL,output_const,t);

        return eq;
    }

    public  Set<Table> getInputTables(){ return enc.inputTables;}
    public  Table getOutputTable(){return new Table(enc.into_name,output_const);}
}
