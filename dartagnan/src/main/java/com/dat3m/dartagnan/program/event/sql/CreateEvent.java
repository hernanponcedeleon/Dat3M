package com.dat3m.dartagnan.program.event.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import org.sosy_lab.java_smt.api.BooleanFormula;

import java.util.List;


public class CreateEvent extends AbstractSqlEvent {

    public SqlApplication.CreatestmtContext sqlExpression;

    public CreateEvent(SqlApplication.CreatestmtContext sql_expression) {
        super("CREATE", Tag.INIT,Tag.WRITE);
        sqlExpression = sql_expression;
        this.sqlExpression.accept(new CreateTableReferenceVisitor());
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        CreateSqlEncoder.Table t = sqlExpression.accept(new CreateSqlEncoder(ctx.solver));
        ctx.tables.put(t.name(), t);
        output_table = t.name();
        out_sort = t.table();

        return ctx.formula_creator.encapsulateBoolean(
                        ctx.solver.mkTerm(
                                Kind.EQUAL,
                                ctx.solver.mkEmptyBag(this.out_sort),
                                this.getOutputConst(ctx)
                        )
                );
    }

    public Term encodeEffect(Term bag, EncodingContext ctx){
        return this.getOutputConst(ctx);
    }


    @Override
    public String defaultString() {
        return sqlExpression.getText();
    }

    @Override
    public GenericVisibleEvent getCopy() {
        return new CreateEvent(sqlExpression);
    }

    public List<String> getInputTables() {
        return List.of();
    }

    public String getOutputTable() {
        return output_table;
    }

    protected class CreateTableReferenceVisitor extends SqlApplicationBaseVisitor<Void> {

        @Override
        public Void visitQualified_name(SqlApplication.Qualified_nameContext ctx){
            output_table = ctx.getText();
            return null;
        }

    }
}
