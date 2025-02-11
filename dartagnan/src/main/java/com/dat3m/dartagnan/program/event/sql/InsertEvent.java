package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.sql.InsertStmEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;

import java.util.List;

public class InsertEvent extends AbstractSqlEvent {

    public SqlApplication.InsertstmtContext sstm;
    InsertStmEncoder enc;

    /*
    This flag indicates if the insert statement has the attribute ifnotexits
     */
    boolean flag_ifnotexists;

    public InsertEvent(SqlApplication.InsertstmtContext sstm) {
        super("INSERT", Tag.WRITE);
        this.sstm = sstm;
        this.sstm.accept(new InsertTableReferenceVisitor());
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
        enc = new InsertStmEncoder(ctx, getGlobalId());
        Term t = sstm.accept(enc);

        Term output_const = getOutputConst(ctx);
        Term eq = ctx.solver.mkTerm(Kind.EQUAL, output_const, t);

        return ctx.formula_creator.encapsulateBoolean(eq);
    }

    public List<String> getInputTables(){return input_tables;}
    public String getOutputTable(){return output_table;}

    public Term encodeEffect(Term bag, EncodingContext ctx){
        return ctx.solver.mkTerm(
                flag_ifnotexists? Kind.BAG_UNION_MAX : Kind.BAG_UNION_DISJOINT,
                bag, getOutputConst(ctx)
        );
    }

    protected class InsertTableReferenceVisitor extends StmtTableReferenceVisitor {

        @Override
        public Void visitInsert_target(SqlApplication.Insert_targetContext ctx){
            output_table = ctx.getText();
            return null;
        }

    }
}
