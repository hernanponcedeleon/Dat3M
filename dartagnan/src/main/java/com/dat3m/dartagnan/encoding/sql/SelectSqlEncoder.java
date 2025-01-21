package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;


import io.github.cvc5.Kind;
import io.github.cvc5.Solver;
import io.github.cvc5.Sort;
import io.github.cvc5.Term;
import org.antlr.v4.runtime.tree.RuleNode;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class SelectSqlEncoder extends SqlApplicationBaseVisitor<Term> implements Encoder {

    public record Table(String name, Sort sort) { }

    private final Solver slv;

    private final int event_id; //The id the event is assigned.
    private final Map<String, CreateSqlEncoder.Table> tables;

    private CreateSqlEncoder.Table currentTable;


    public SelectSqlEncoder(Solver slv,int event_id, Map<String, CreateSqlEncoder.Table> tables){
        this.slv = slv;
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
        if(ctx.getChildCount()>1){
            throw new UnsupportedOperationException("Select UNION/EXCEPT are not supported");
        }
        return ctx.simple_select_intersect(0).accept(this);
    }

    @Override
    public Term visitSimple_select_intersect(SqlApplication.Simple_select_intersectContext ctx) {
        if(ctx.getChildCount()>1){
            throw new UnsupportedOperationException("Select INTERSECT are not supported");
        }
        return ctx.simple_select_pramary(0).accept(this);
    }

    @Override
    public Term visitSimple_select_pramary(SqlApplication.Simple_select_pramaryContext ctx) {
        Term source_table = ctx.from_clause().accept(this);
        Term where_clause = ctx.where_clause().accept(this);

        Term filtered_bag = slv.mkTerm(Kind.BAG_FILTER,where_clause,source_table);

        return filtered_bag;
    }

    @Override
    public Term visitFrom_clause(SqlApplication.From_clauseContext ctx) {
        if(ctx.from_list().getChildCount()>1){
            throw new UnsupportedOperationException("Comma Seperated joins are not supported. Use CrossJoin Instead");
        }

        return ctx.from_list().table_ref(0).accept(this);
    }

    @Override
    public Term visitTable_ref(SqlApplication.Table_refContext ctx) {
        String table_name = ctx.relation_expr().getText();
        Sort table_sort = tables.get(table_name).table();
        this.currentTable= tables.get(table_name);

        return slv.mkConst(table_sort,table_name+"_"+event_id+"_"+"in");
    }

    //---------Encoding the where clause to a term -------------------------

    @Override
    public Term visitWhere_clause(SqlApplication.Where_clauseContext ctx) {

        Sort row_sort = currentTable.row();

        Term selected_row = slv.mkVar(row_sort,"row"+"_"+event_id);

        Term sel = row_sort.getDatatype().getSelector("0").getTerm();
        Term r = slv.mkTerm(Kind.APPLY_SELECTOR, sel, selected_row);



        Term condition = slv.mkTerm(Kind.GT, r, slv.mkInteger(1));

        // Create a lambda expression using the bound variable and the condition
        Term boundVars = slv.mkTerm(Kind.VARIABLE_LIST, selected_row);


        return slv.mkTerm(Kind.LAMBDA, boundVars, condition);
    }


}
