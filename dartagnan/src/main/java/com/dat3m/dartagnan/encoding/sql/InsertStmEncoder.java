package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.parsers.SqlApplication;
import io.github.cvc5.Term;
import io.github.cvc5.TermManager;

import java.util.Map;

public class InsertStmEncoder extends StmEncoder {


    public String into_name;

    public InsertStmEncoder(TermManager tm, Map<String, CreateSqlEncoder.Table> tables, int event_id) {
        super(tm, tables, event_id);
    }

    @Override
    public Term visitInsertstmt(SqlApplication.InsertstmtContext ctx) {

        into_name = ctx.insert_target().getText();

        return ctx.insert_rest().accept(this);
    }

    @Override
    public Term visitInsert_rest(SqlApplication.Insert_restContext ctx) {
        SelectSqlEncoder selEnc = new SelectSqlEncoder(tm, event_id, tables);
        Term t = ctx.selectstmt().accept(selEnc);
        inputTables = selEnc.inputTables;
        return t;
    }


}
