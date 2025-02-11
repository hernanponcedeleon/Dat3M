package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.program.event.sql.AbstractSqlEvent;
import io.github.cvc5.Kind;
import io.github.cvc5.Sort;
import io.github.cvc5.Term;
import io.github.cvc5.Solver;

import java.util.Map;

public class DeleteStmEncoder extends StmEncoder {

    public String table_name;

    public DeleteStmEncoder( EncodingContext ctx, int event_id) {
        super(ctx, ctx.tables, event_id);
    }

    @Override
    public Term visitDeletestmt(SqlApplication.DeletestmtContext ctx) {

        table_name = ctx.relation_expr_opt_alias().getText();

        currentTable = tables.get(table_name);
        Sort table_sort = currentTable.table();

        Term input_table = this.ctx.formula_creator.makeVariable(table_sort, table_name + "_" + event_id + "_" + "in");
        inputTables.add(new AbstractSqlEvent.Table(table_name,input_table));

        if (ctx.where_or_current_clause() == null) {
            return input_table;
        } else {
            return this.ctx.solver.mkTerm(Kind.BAG_FILTER, ctx.where_or_current_clause().accept(this), input_table);
        }
    }

    @Override
    public Term visitWhere_or_current_clause(SqlApplication.Where_or_current_clauseContext ctx) {
        this.context = LambdaContext.openLambdaContext(this.ctx, currentTable);

        Term row = context.makeRowVariable("delete" + "_" + event_id);
        Term boundVariables = this.ctx.solver.mkTerm(Kind.VARIABLE_LIST, row);
        return this.ctx.solver.mkTerm(Kind.LAMBDA, boundVariables, ctx.a_expr().accept(this));
    }
}
