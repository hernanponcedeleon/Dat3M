package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationLexer;
import com.dat3m.dartagnan.program.event.sql.AbstractSqlEvent;
import io.github.cvc5.*;
import org.antlr.v4.runtime.tree.RuleNode;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class SelectSqlEncoder extends StmEncoder {
    //The id the event is assigned.
    private Term currentinitialValue;


    public SelectSqlEncoder(int event_id, EncodingContext ctx) {
        super(ctx, ctx.tables, event_id);
    }

    public SelectSqlEncoder(EncodingContext ctx,int event_id ) {
        super(ctx, ctx.tables, event_id);
    }

    @Override
    public Term visitChildren(RuleNode node) {
        throw new UnsupportedOperationException(
                "This expection originates from encoding a SQL Statement with constructs that are not yet supported"
        );
    }

    @Override
    public Term visitSelectstmt(SqlApplication.SelectstmtContext ctx) {
        return ctx.select_no_parens().accept(this);
    }

    @Override
    public Term visitSelect_with_parens(SqlApplication.Select_with_parensContext ctx) {
        return ctx.select_no_parens().accept(this);
    }

    @Override
    public Term visitSelect_no_parens(SqlApplication.Select_no_parensContext ctx) {
        return ctx.select_clause().accept(this);
    }


    @Override
    public Term visitSelect_clause(SqlApplication.Select_clauseContext ctx) {

        Term r = ctx.simple_select_intersect(0).accept(this);

        for (int i = 1; i < ctx.simple_select_intersect().size(); i++) {
            r = switch (ctx.j.getType()) {
                case SqlApplicationLexer.UNION ->
                        this.ctx.solver.mkTerm(Kind.BAG_UNION_MAX, r, ctx.simple_select_intersect(i).accept(this));
                case SqlApplicationLexer.EXCEPT ->
                        this.ctx.solver.mkTerm(Kind.BAG_DIFFERENCE_REMOVE, r, ctx.simple_select_intersect(i).accept(this));
                default -> throw new UnsupportedOperationException("Select " + ctx.j + " is not supported");
            };
        }
        return r;
    }

    @Override
    public Term visitSimple_select_intersect(SqlApplication.Simple_select_intersectContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("Select INTERSECT are not supported");
        }
        return ctx.simple_select_pramary(0).accept(this);
    }

    @Override
    public Term visitSimple_select_pramary(SqlApplication.Simple_select_pramaryContext ctx) {
        if (ctx.values_clause() != null) {
            return ctx.values_clause().accept(this);
        } else {

            //from Clause
            Term return_table = ctx.from_clause().accept(this);

            //Where clause
            if (ctx.where_clause() !=null) {
                Term where_clause = ctx.where_clause().accept(this);
                return_table = this.ctx.solver.mkTerm(Kind.BAG_FILTER, where_clause, return_table);
            }

            //Select Clause
            if (ctx.target_list_().start.getType() == SqlApplicationLexer.STAR) {
                return return_table;
            }

            Term selectTerm = visit(ctx.target_list_().target_list());

            if (this.aggregateResult == AGG.IS_AGG) {
                //Having clause
                Term agg = this.ctx.solver.mkTerm(Kind.BAG_FOLD, selectTerm, this.currentinitialValue, return_table);
                Term agg_bag = this.ctx.solver.mkTerm(Kind.BAG_MAKE, agg, this.ctx.solver.mkInteger(1));

                List<String> aggColumns = new ArrayList<>();
                aggColumns.add("agg1");

                this.currentTable = new CreateSqlEncoder.Table("", null, agg.getSort(), aggColumns);
                this.context = LambdaContext.openLambdaContext(this.ctx, currentTable);

                return_table = this.ctx.solver.mkTerm(Kind.BAG_FILTER, ctx.having_clause().accept(this), agg_bag);
            } else {
                return_table = this.ctx.solver.mkTerm(Kind.BAG_MAP, selectTerm, return_table);
            }

            return return_table;
        }
    }

    @Override
    public Term visitValues_clause(SqlApplication.Values_clauseContext ctx) {
        List<SqlApplication.Expr_listContext> exprList = ctx.expr_list();
        Term bag = null;
        List<Term> bags = new ArrayList<>();
        for (SqlApplication.Expr_listContext expr_list : exprList) {
            List<Term> terms = new ArrayList<>();
            for (SqlApplication.A_exprContext a_expr : expr_list.a_expr()) {
                terms.add(visit(a_expr));
            }
            if (bag == null) {
                bag = this.ctx.solver.mkEmptyBag(this.ctx.solver.mkBagSort(this.ctx.solver.mkTuple(terms.stream().map(Term::getSort).toArray(Sort[]::new),terms.toArray(new Term[0])).getSort()));
            }
            bag = this.ctx.solver.mkTerm(Kind.BAG_UNION_MAX, bag, this.ctx.solver.mkTerm(Kind.BAG_MAKE, this.ctx.solver.mkTuple( terms.stream().map(Term::getSort).toArray(Sort[]::new),terms.toArray(new Term[0])), this.ctx.solver.mkInteger(1)));
        }

        return bag;
    }

    //---------Encoding the FROM Clause -------------------------
    @Override
    public Term visitFrom_clause(SqlApplication.From_clauseContext ctx) {
        if (ctx.from_list().getChildCount() > 1) {
            throw new UnsupportedOperationException("Comma Seperated joins are not supported. Use CrossJoin Instead");
        }

        return ctx.from_list().table_ref(0).accept(this);
    }

    @Override
    public Term visitTable_ref(SqlApplication.Table_refContext ctx) {
        String table_name = ctx.relation_expr().getText();

        Optional<AbstractSqlEvent.Table> table = inputTables.stream().filter(t -> t.table_name() == table_name).findFirst();
        if (table.isPresent()) {
            return table.get().constant();
        } else {

            Sort table_sort = tables.get(table_name).table();
            currentTable = tables.get(table_name);
            Term input_table = this.ctx.formula_creator.makeVariable(table_sort, "E%s_in_%s".formatted(event_id,table_name));
            inputTables.add(new AbstractSqlEvent.Table(table_name, input_table));
            return input_table;
        }
    }

    //---------Encoding the Where clause -------------------------
    @Override
    public Term visitWhere_clause(SqlApplication.Where_clauseContext ctx) {

        this.context = LambdaContext.openLambdaContext(this.ctx, currentTable);

        Term currentRow = context.makeRowVariable("row_where" + "_" + event_id);

        Term boundVars = this.ctx.solver.mkTerm(Kind.VARIABLE_LIST, currentRow);

        Term condition = ctx.a_expr().a_expr_qual().accept(this);

        return this.ctx.solver.mkTerm(Kind.LAMBDA, boundVars, condition);
    }

    //----- Encoding Select Clause

    /**
     * This either returns a fold function with two arguments or a projection function with one argument
     * Depending on what is return the flag is aggregateResult is set
     *
     * @param ctx the parse tree
     * @return
     */
    @Override
    public Term visitTarget_list(SqlApplication.Target_listContext ctx) {


        this.context = LambdaContext.openLambdaContext(this.ctx, currentTable);
        Term currentRow = context.makeRowVariable("row_select" + "_" + event_id);
        Term boundVars;
        Term function;


        List<Term> terms = new ArrayList<>();
        List<Sort> initialsSort = new ArrayList<>();
        List<Term> initial_value = new ArrayList<>();
        for (SqlApplication.Target_elContext target_elContext : ctx.target_el()) {
            //open lambda contex
            Term elm = target_elContext.accept(this);
            terms.add(elm);

            initialsSort.add(this.context.getCurrentinitialVariableSort());
            initial_value.add(this.context.getCurrentinitialValue());
            this.context = this.context.close();
        }

        if (this.aggregateResult == AGG.IS_AGG) {

            Term intialVariabl = this.ctx.solver.mkVar(this.ctx.solver.mkTupleSort(initialsSort.toArray(new Sort[0])), "inital_fold_var");

            DatatypeConstructor g = intialVariabl.getSort().getDatatype().getConstructor(0);
            currentinitialValue = this.ctx.solver.mkTuple(initial_value.stream().map(Term::getSort).toArray(Sort[]::new),initial_value.toArray(new Term[0]));
            boundVars = this.ctx.solver.mkTerm(Kind.VARIABLE_LIST, currentRow, intialVariabl);
            List<Term> appliedTerms = new ArrayList<>();
            for (int i = 0; i < terms.size(); i++) {
                Term term = terms.get(i);
                appliedTerms.add(
                        this.ctx.solver.mkTerm(Kind.APPLY_UF,
                                term, currentRow, this.ctx.solver.mkTerm(Kind.APPLY_SELECTOR, g.getSelector(i).getTerm(), intialVariabl)));
            }
            function = this.ctx.solver.mkTuple(appliedTerms.stream().map(Term::getSort).toArray(Sort[]::new),appliedTerms.toArray(new Term[0]));
        } else {
            function = this.ctx.solver.mkTuple(terms.stream().map(Term::getSort).toArray(Sort[]::new),terms.toArray(new Term[0]));
            boundVars = this.ctx.solver.mkTerm(Kind.VARIABLE_LIST, currentRow);
        }
        return this.ctx.solver.mkTerm(Kind.LAMBDA, boundVars, function);
    }

    @Override
    public Term visitTarget_label(SqlApplication.Target_labelContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("AS in Select is not supported. See grammer");
        }
        return ctx.a_expr().accept(this);
    }


    @Override
    public Term visitHaving_clause(SqlApplication.Having_clauseContext ctx) {


        Term currentRow = context.makeRowVariable("aggregated_row");
        Term boundVars = this.ctx.solver.mkTerm(Kind.VARIABLE_LIST, currentRow);

        return this.ctx.solver.mkTerm(Kind.LAMBDA, boundVars, ctx.a_expr().accept(this));
    }


}
