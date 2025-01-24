package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.parsers.SqlApplicationLexer;
import io.github.cvc5.*;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.RuleNode;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class SelectSqlEncoder extends SqlApplicationBaseVisitor<Term> implements Encoder {

    private final TermManager tm;
    private final int event_id; //The id the event is assigned.
    private final Map<String, CreateSqlEncoder.Table> tables;
    public CreateSqlEncoder.Table currentTable;
    public List<Term> inputVariables = new ArrayList<>();

    private DatatypeConstructor row_constructor;
    private Term currentRow;
    private Sort currentinitialVariableSort;
    private Term currentinitialValue;
    private AGG aggregateResult = AGG.UNKNOWN;
    private Term initial_tupel;

    public SelectSqlEncoder(TermManager tm, int event_id, Map<String, CreateSqlEncoder.Table> tables) {
        this.tm = tm;
        this.event_id = event_id;
        this.tables = tables;
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
    public Term visitSelect_no_parens(SqlApplication.Select_no_parensContext ctx) {

        return ctx.select_clause().accept(this);

    }

    @Override
    public Term visitSelect_clause(SqlApplication.Select_clauseContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("Select UNION/EXCEPT are not supported");
        }
        return ctx.simple_select_intersect(0).accept(this);
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

        Term source_table = ctx.from_clause().accept(this);
        Term where_clause = ctx.where_clause().accept(this);

        Term filtered_bag = tm.mkTerm(Kind.BAG_FILTER, where_clause, source_table);

        if (ctx.target_list_().start.getType() == SqlApplicationLexer.STAR) {
            return tm.mkTerm(
                    Kind.NOT,
                    tm.mkTerm(
                            Kind.EQUAL,
                            tm.mkEmptyBag(filtered_bag.getSort()),
                            filtered_bag)
            );
        }

        Term selectTerm = visit(ctx.target_list_().target_list());

        if (this.aggregateResult == AGG.IS_AGG) {
            Term agg = tm.mkTerm(Kind.BAG_FOLD, selectTerm, this.currentinitialValue, filtered_bag);

            List<String> aggColumns = new ArrayList<>();
            aggColumns.add("agg1");
            this.currentTable = new CreateSqlEncoder.Table("", null, null, aggColumns);
            this.currentRow = tm.mkVar(agg.getSort(), "aggregated_row");
            this.row_constructor  =  this.currentRow.getSort().getDatatype().getConstructor(0);

            return tm.mkTerm(Kind.APPLY_UF, ctx.having_clause().accept(this), agg);
        } else {
            Term projected = tm.mkTerm(Kind.BAG_MAP, selectTerm, filtered_bag);
            return tm.mkTerm(
                    Kind.NOT,
                    tm.mkTerm(
                            Kind.EQUAL,
                            tm.mkEmptyBag(projected.getSort()),
                            projected)
            );
        }
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
        Sort table_sort = tables.get(table_name).table();
        this.currentTable = tables.get(table_name);
        Term input_table = tm.mkConst(table_sort, table_name + "_" + event_id + "_" + "in");
        inputVariables.add(input_table);
        return input_table;
    }

    //---------Encoding the Where clause -------------------------
    @Override
    public Term visitWhere_clause(SqlApplication.Where_clauseContext ctx) {

        Sort row_sort = currentTable.row();
        this.row_constructor = row_sort.getDatatype().getConstructor(0);

        this.currentRow = tm.mkVar(row_sort, "row_where" + "_" + event_id);
        Term boundVars = tm.mkTerm(Kind.VARIABLE_LIST, this.currentRow);

        Term condition = ctx.a_expr().a_expr_qual().accept(this);

        // Create a lambda expression using the bound variable and the condition


        return tm.mkTerm(Kind.LAMBDA, boundVars, condition);
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
        Sort row_sort = currentTable.row();
        this.row_constructor = row_sort.getDatatype().getConstructor(0);
        this.currentRow = tm.mkVar(row_sort, "row_select" + "_" + event_id);

        Term boundVars;
        Term function;


        List<Term> terms = new ArrayList<>();
        List<Sort> initialsSort = new ArrayList<>();
        List<Term> initial_value = new ArrayList<>();
        for (SqlApplication.Target_elContext target_elContext : ctx.target_el()) {
            //open lambda contex
            Term elm = target_elContext.accept(this);
            terms.add(elm);
            initialsSort.add(currentinitialVariableSort);
            initial_value.add(currentinitialValue);
            //close lambda context
        }

        if (this.aggregateResult == AGG.IS_AGG) {

            Term intialVariabl = tm.mkVar(tm.mkTupleSort(initialsSort.toArray(new Sort[0])),"inital_fold_var");

            DatatypeConstructor g = intialVariabl.getSort().getDatatype().getConstructor(0);
            currentinitialValue = tm.mkTuple(initial_value.toArray(new Term[0]));
            boundVars = tm.mkTerm(Kind.VARIABLE_LIST, this.currentRow, intialVariabl);
            List<Term> appliedTerms = new ArrayList<>();
            for (int i = 0; i < terms.size(); i++) {
                Term term = terms.get(i);
                appliedTerms.add(
                        tm.mkTerm(Kind.APPLY_UF,
                                term, this.currentRow, tm.mkTerm(Kind.APPLY_SELECTOR, g.getSelector(i).getTerm(), intialVariabl)));
            }
            function = tm.mkTuple(appliedTerms.toArray(new Term[0]));
        } else {
            function = tm.mkTuple(terms.toArray(new Term[0]));
            boundVars = tm.mkTerm(Kind.VARIABLE_LIST, this.currentRow);
        }
        return tm.mkTerm(Kind.LAMBDA, boundVars, function);
    }

    @Override
    public Term visitTarget_label(SqlApplication.Target_labelContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("AS in Select is not supported. See grammer");
        }
        return ctx.a_expr().accept(this);
    }


    @Override
    public Term visitHaving_clause(SqlApplication.Having_clauseContext ctx){
        Term boundVars = tm.mkTerm(Kind.VARIABLE_LIST, this.currentRow);

        return tm.mkTerm(Kind.LAMBDA,boundVars,ctx.a_expr().accept(this));
    }
    //---------Encoding the A Expr -------------------------
    @Override
    public Term visitA_expr(SqlApplication.A_exprContext ctx) {
        return ctx.a_expr_qual().accept(this);
    }

    @Override
    public Term visitA_expr_qual(SqlApplication.A_expr_qualContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("qual_op is not supported. See grammer");
        }

        return ctx.a_expr_lessless().accept(this);
    }

    @Override
    public Term visitA_expr_lessless(SqlApplication.A_expr_lesslessContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("qual_op is not supported. See grammer");
        }

        return ctx.a_expr_or(0).accept(this);
    }

    @Override
    public Term visitA_expr_or(SqlApplication.A_expr_orContext ctx) {
        Term[] children = ctx.a_expr_and().stream().map(ctx_ -> ctx_.accept(this)).toList().toArray(new Term[0]);
        if (children.length > 1) {
            return tm.mkTerm(Kind.OR, children);
        } else if (children.length == 1) {
            return children[0];
        }
        throw new RuntimeException("There need to be at least one clause in the where clause");
    }

    @Override
    public Term visitA_expr_and(SqlApplication.A_expr_andContext ctx) {

        Term[] children = ctx.a_expr_between().stream().map(ctx_ -> ctx_.accept(this)).toList().toArray(new Term[0]);
        if (children.length > 1) {
            return tm.mkTerm(Kind.AND, children);
        } else if (children.length == 1) {
            return children[0];
        }
        throw new RuntimeException("There need to be at least one clause in the where clause");
    }

    @Override
    public Term visitA_expr_between(SqlApplication.A_expr_betweenContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("BETWEEN is not supported. See grammer");
        }
        return ctx.a_expr_in(0).accept(this);
    }

    @Override
    public Term visitA_expr_in(SqlApplication.A_expr_inContext ctx) {
        if (ctx.getChildCount() > 1) {
            //TODO: Probably possible via subbag
            throw new UnsupportedOperationException("IN is not supported. See grammer");
        }
        return ctx.a_expr_unary_not().accept(this);
    }

    @Override
    public Term visitA_expr_unary_not(SqlApplication.A_expr_unary_notContext ctx) {
        if (ctx.getChildCount() == 2) {
            return tm.mkTerm(Kind.NOT, ctx.a_expr_isnull().accept(this));
        } else if (ctx.getChildCount() == 1) {
            return ctx.a_expr_isnull().accept(this);
        }
        throw new UnsupportedOperationException("Unsupported Number of Children in a_expr_unary_not");
    }

    @Override
    public Term visitA_expr_isnull(SqlApplication.A_expr_isnullContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("Unsupported Number of Children in a_expr_unary_not");
        }
        return ctx.a_expr_is_not().accept(this);
    }

    @Override
    public Term visitA_expr_is_not(SqlApplication.A_expr_is_notContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("Unsupported Number of Children in a_expr_unary_not");
        }
        return ctx.a_expr_compare().accept(this);
    }

    @Override
    public Term visitA_expr_compare(SqlApplication.A_expr_compareContext ctx) {

        if (ctx.getChildCount() > 1) {
            Kind k = switch (ctx.cmp_token.getType()) {
                case SqlApplicationLexer.LT -> Kind.LT;
                case SqlApplicationLexer.GT -> Kind.GT;
                case SqlApplicationLexer.EQUAL -> Kind.EQUAL;
                case SqlApplicationLexer.LESS_EQUALS -> Kind.LEQ;
                case SqlApplicationLexer.GREATER_EQUALS -> Kind.GEQ;
                case SqlApplicationLexer.NOT_EQUALS -> Kind.NEG;
                default -> throw new UnsupportedOperationException("Unknown Compare operator");
            };

            return tm.mkTerm(k, ctx.a_expr_like(0).accept(this), ctx.a_expr_like(1).accept(this));
        }
        return ctx.a_expr_like(0).accept(this);
    }

    @Override
    public Term visitA_expr_like(SqlApplication.A_expr_likeContext ctx) {
        if (ctx.getChildCount() > 1) {
            throw new UnsupportedOperationException("Unsupported Number of Children in a_expr_unary_not");
        }
        return ctx.a_expr_qual_op(0).a_expr_unary_qualop(0).a_expr_add().a_expr_mul(0).a_expr_caret(0).a_expr_unary_sign(0).a_expr_at_time_zone().a_expr_collate().a_expr_typecast().c_expr().accept(this);
    }

    @Override
    public Term visitC_expr_expr(SqlApplication.C_expr_exprContext ctx) {
        ParseTree child = ctx.getChild(0);
        return child.accept(this);
    }

    @Override
    public Term visitFunc_expr(SqlApplication.Func_exprContext ctx) {
        return ctx.func_application().accept(this);
    }

    @Override
    public Term visitFunc_application(SqlApplication.Func_applicationContext ctx) {
        switch (ctx.func_name().getText()) {
            case "SUM":
                this.aggregateResult = AGG.IS_AGG;

                assert ctx.func_arg_list().getChildCount() == 1;

                this.currentinitialVariableSort = tm.getIntegerSort();
                Term initialVariable = tm.mkVar(currentinitialVariableSort,"summant");
                this.currentinitialValue = tm.mkInteger(0);
                Term boundVars = tm.mkTerm(Kind.VARIABLE_LIST, new Term[]{this.currentRow, initialVariable});
                return tm.mkTerm(Kind.LAMBDA,
                        boundVars,
                        tm.mkTerm(
                                Kind.ADD,
                                ctx.func_arg_list().func_arg_expr(0).accept(this),
                                initialVariable));
            default:
                throw new UnsupportedOperationException("This function is not supported");
        }
    }

    @Override
    public Term visitFunc_arg_expr(SqlApplication.Func_arg_exprContext ctx) {
        return ctx.a_expr().accept(this);
    }

    @Override
    public Term visitColumnref(SqlApplication.ColumnrefContext ctx) {
        String s = ctx.getText();
        String column_name = ctx.colid().identifier().getText();
        int idx = currentTable.col_names().indexOf(column_name);
        Term sel = this.row_constructor.getSelector(idx).getTerm();
        return tm.mkTerm(Kind.APPLY_SELECTOR, sel, this.currentRow);
    }

    @Override
    public Term visitAexprconst(SqlApplication.AexprconstContext ctx) {

        return ctx.getChild(0).accept(this);
    }

    @Override
    public Term visitIconst(SqlApplication.IconstContext ctx) {

        try {
            return tm.mkInteger(ctx.getText());
        } catch (CVC5ApiException e) {
            throw new RuntimeException(e);
        }
    }

    private enum AGG {
        IS_AGG,
        NOT_AGG,
        UNKNOWN

    }


}
