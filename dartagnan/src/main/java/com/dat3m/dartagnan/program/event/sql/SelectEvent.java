package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.sql.SelectSqlEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.List;

public class SelectEvent extends AbstractSqlEvent {

    public SqlApplication.SelectstmtContext sstm;
    SelectSqlEncoder enc;

    public SelectEvent(SqlApplication.SelectstmtContext sstm, String ... tags) {
        super("SELECT",tags);
        this.sstm = sstm;
        this.sstm.accept(new StmtTableReferenceVisitor());

    }

    @Override
    public String defaultString() {
        return sstm.getText();
    }

    @Override
    public GenericVisibleEvent getCopy() {
        return null;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx)  {
        enc = new SelectSqlEncoder(ctx, getGlobalId());
        Term t = sstm.accept(enc);
        out_sort= t.getSort();

        Term output_const = getOutputConst(ctx);
        Term eq = ctx.solver.mkTerm(Kind.EQUAL, output_const, t);

        return ctx.formula_creator.encapsulateBoolean(eq);
    }

    public List<String> getInputTables(){return input_tables;}
    public String getOutputTable(){return "SELECT_"+getGlobalId();}

    public Term getOutputConst(EncodingContext ctx) {
        return ctx.formula_creator.makeVariable(
                out_sort,
                "E%s_out_%s".formatted(getGlobalId(),getOutputTable()));
    }

}
