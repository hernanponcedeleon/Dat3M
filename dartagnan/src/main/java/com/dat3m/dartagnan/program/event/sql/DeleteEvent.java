package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.sql.DeleteStmEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.*;

public class DeleteEvent extends AbstractSqlEvent {


    DeleteStmEncoder enc;
    public SqlApplication.DeletestmtContext sstm;

    public DeleteEvent(SqlApplication.DeletestmtContext sstm) {
        super("DELETE", Tag.WRITE);
        this.sstm= sstm;
        this.sstm.accept(new DeleteTableReferenceVisitor());
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
    public BooleanFormula encodeExec(EncodingContext ctx) {
        enc = new DeleteStmEncoder(ctx,getGlobalId());
        Term delEnc= sstm.accept(enc);
        Term output_const= getOutputConst(ctx);
        Term t = ctx.solver.mkTerm(Kind.EQUAL, output_const,delEnc);

        logger.info(t);
        return ctx.formula_creator.encapsulateBoolean(t);
    }

    public List<String> getInputTables(){return input_tables;}
    public String getOutputTable(){return output_table;}

    public Term encodeEffect(Term bag, EncodingContext ctx){
        return ctx.solver.mkTerm(
                Kind.BAG_DIFFERENCE_SUBTRACT,
                bag, getOutputConst(ctx)
        );
    }

    protected class DeleteTableReferenceVisitor extends StmtTableReferenceVisitor {

        @Override
        public Void visitRelation_expr_opt_alias(SqlApplication.Relation_expr_opt_aliasContext ctx){
            output_table =ctx.getText();
            return null;
        }

    }

}
