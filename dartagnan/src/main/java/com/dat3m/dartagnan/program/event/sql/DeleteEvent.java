package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.encoding.sql.DeleteStmEncoder;
import com.dat3m.dartagnan.encoding.sql.SelectSqlEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Event;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import io.github.cvc5.TermManager;

import java.util.*;

public class DeleteEvent extends AbstractSqlEvent{
    DeleteStmEncoder enc;
    public SqlApplication.DeletestmtContext sstm;

    Term output_const;

    public DeleteEvent(SqlApplication.DeletestmtContext sstm) {
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
    public Term encode(TermManager tm, Map<String, CreateSqlEncoder.Table> tables){
        enc = new DeleteStmEncoder(tm,tables,getGlobalId());
        Term delEnc= sstm.accept(enc);
        output_const= tm.mkConst(delEnc.getSort(),"delete_out"+"_"+getGlobalId());
        Term t = tm.mkTerm(Kind.EQUAL, output_const,delEnc);

        logger.info(t);
        return t;
    }

    public Set<Table> getInputTables(){return enc.inputTables;}
    public Table getOutputTable(){return new Table(enc.table_name,output_const);}
}
