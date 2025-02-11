package com.dat3m.dartagnan.program.event.sql;


import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.program.event.core.GenericVisibleEvent;
import com.google.common.base.Preconditions;
import io.github.cvc5.Kind;
import io.github.cvc5.Sort;
import io.github.cvc5.Term;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.Formula;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractSqlEvent extends GenericVisibleEvent {

    protected static final Logger logger = LogManager.getLogger(AbstractSqlEvent.class);

    String output_table;
    List<String> input_tables = new ArrayList<>();

    Sort out_sort;

    public AbstractSqlEvent(String name, String... tags) {
        super(name, tags);
    }

    public abstract List<String> getInputTables();

    public abstract String getOutputTable();

    public Term encodeEffect(Term bag,EncodingContext ctx){
        return bag;
    }

    public Term getInputConst(String table_name, EncodingContext ctx) {
        Preconditions.checkArgument(getInputTables().contains(table_name), "This event have this table not as input");
        return ctx.formula_creator.makeVariable(ctx.tables.get(table_name).table(),
                "E%s_in_%s".formatted(getGlobalId(),table_name));
    }

    public Term getOutputConst(EncodingContext ctx) {
        return ctx.formula_creator.makeVariable(
                ctx.tables.get(getOutputTable()).table(),
                "E%s_out_%s".formatted(getGlobalId(),getOutputTable()));
    }

    public BooleanFormula encode_empty(EncodingContext ctx) {
        return ctx.formula_creator
                .encapsulateBoolean(
                        ctx.solver.mkTerm(
                                Kind.EQUAL,
                                ctx.solver.mkEmptyBag(this.out_sort),
                                this.getOutputConst(ctx))
                );
    }

    public record Table(String table_name, Term constant) {
    }

    protected class StmtTableReferenceVisitor extends SqlApplicationBaseVisitor<Void> {

        @Override
        public Void visitTable_ref(SqlApplication.Table_refContext ctx) {
            input_tables.add(ctx.relation_expr().getText());
            return null;
        }
    }
}
