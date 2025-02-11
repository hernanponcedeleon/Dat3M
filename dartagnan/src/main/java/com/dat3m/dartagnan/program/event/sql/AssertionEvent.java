package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.sql.SelectSqlEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import org.sosy_lab.java_smt.api.BooleanFormula;

public class AssertionEvent extends SelectEvent {

    public AssertionEvent(SqlApplication.SelectstmtContext sstm) {
        super(sstm,"ASSERTION","ASSERT_EMPTY");
    }

    public String getOutputTable() {
        return "ASSERTION_" + getGlobalId();
    }

}
