package com.dat3m.dartagnan.encoding.sql;

import com.dat3m.dartagnan.encoding.Encoder;
import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.parsers.SqlApplication;
import com.dat3m.dartagnan.parsers.SqlApplicationBaseVisitor;
import com.dat3m.dartagnan.parsers.SqlApplicationLexer;
import com.dat3m.dartagnan.program.event.sql.AbstractSqlEvent;
import io.github.cvc5.CVC5ApiException;
import io.github.cvc5.Kind;
import io.github.cvc5.Term;
import io.github.cvc5.Solver;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.*;

public abstract class StmEncoder extends SqlApplicationBaseVisitor<Term> implements Encoder {

    protected final EncodingContext ctx;
    protected final Map<String, CreateSqlEncoder.Table> tables;
    protected final int event_id;
    /**
     * Keeps track of which new introduced constants map to which tables
     */
    public Set<AbstractSqlEvent.Table> inputTables= new HashSet<>();

    protected AGG aggregateResult = AGG.UNKNOWN;

    public CreateSqlEncoder.Table currentTable;

    protected LambdaContext context;

    protected StmEncoder(EncodingContext ctx, Map<String, CreateSqlEncoder.Table> tables,int event_id) {
        this.tables=tables;
        this.event_id = event_id;
        this.ctx=ctx;
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
            return this.ctx.solver.mkTerm(Kind.OR, children);
        } else if (children.length == 1) {
            return children[0];
        }
        throw new RuntimeException("There need to be at least one clause in the where clause");
    }

    @Override
    public Term visitA_expr_and(SqlApplication.A_expr_andContext ctx) {

        Term[] children = ctx.a_expr_between().stream().map(ctx_ -> ctx_.accept(this)).toList().toArray(new Term[0]);
        if (children.length > 1) {
            return this.ctx.solver.mkTerm(Kind.AND, children);
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
            return this.ctx.solver.mkTerm(Kind.NOT, ctx.a_expr_isnull().accept(this));
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

            return this.ctx.solver.mkTerm(k, ctx.a_expr_like(0).accept(this), ctx.a_expr_like(1).accept(this));
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
                this.aggregateResult = SelectSqlEncoder.AGG.IS_AGG;

                assert ctx.func_arg_list().getChildCount() == 1;

                this.context = this.context.deriveContext();
                Term initial_var = this.context.makeInitialVariable("summant", this.ctx.solver.getIntegerSort(), this.ctx.solver.mkInteger(0));
                Term row_var = this.context.makeRowVariable("summxx");

                Term boundVars = this.ctx.solver.mkTerm(Kind.VARIABLE_LIST, new Term[]{row_var, initial_var});

                return this.ctx.solver.mkTerm(Kind.LAMBDA,
                        boundVars,
                        this.ctx.solver.mkTerm(
                                Kind.ADD,
                                ctx.func_arg_list().func_arg_expr(0).accept(this),
                                initial_var));
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
        return this.context.getColumnFromRowVariable(column_name);
    }

    @Override
    public Term visitAexprconst(SqlApplication.AexprconstContext ctx) {

        return ctx.getChild(0).accept(this);
    }

    @Override
    public Term visitIconst(SqlApplication.IconstContext ctx) {

        try {
            return this.ctx.solver.mkInteger(ctx.getText());
        } catch (CVC5ApiException e) {
            throw new RuntimeException(e);
        }
    }

    protected enum AGG {
        IS_AGG,
        NOT_AGG,
        UNKNOWN

    }
}
