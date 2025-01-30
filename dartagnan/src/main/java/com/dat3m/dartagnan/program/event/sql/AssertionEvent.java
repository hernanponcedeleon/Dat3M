package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.encoding.sql.SelectSqlEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import io.github.cvc5.TermManager;

import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class AssertionEvent extends AbstractSqlEvent{

    public SqlApplication.SelectstmtContext sstm;
    SelectSqlEncoder enc;

    public AssertionEvent(SqlApplication.SelectstmtContext sstm) {
        this.sstm= sstm;
    }

    public String defaultString(){
        return sstm.getText();
    }

    @Override
    public Event getCopy() {
        return null;
    }

    @Override
    public Term encode(TermManager tm, Map<String, CreateSqlEncoder.Table> tables){
        this.enc = new SelectSqlEncoder(tm,getGlobalId(),tables);
        Term t = enc.visit(sstm);
        //Default is the assertion should be empty. So if sat with not empty there is a issue.
        return tm.mkTerm(
                Kind.NOT,
                tm.mkTerm(
                        Kind.EQUAL,
                        tm.mkEmptyBag(t.getSort()),
                        t)
        );
    }

    public Set<Table> getInputTables(){
        return enc.inputTables;
    };

    public Table getOutputTable(){
        return null;
    }



}
