package com.dat3m.dartagnan.program.event.core.tangles;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.encoding.ExpressionEncoder;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.ThreadGrid;
import com.dat3m.dartagnan.program.Entrypoint.Grid;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.EventVisitor;
import org.sosy_lab.java_smt.api.BitvectorFormula;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

import java.util.List;
import java.util.ArrayList;
import java.util.Set;

import static com.dat3m.dartagnan.expression.tangles.TangleType.BALLOT;

public class NonUniformOpBallot extends NonUniformOpBase {

    public NonUniformOpBallot(String instanceId, String execScope, Register register, Expression expr) {
        super(instanceId, execScope, BALLOT, register, expr);
    }

    private NonUniformOpBallot(NonUniformOpBallot other) {
        super(other);
    }

    @Override
    public NonUniformOpBallot getCopy() {
        return new NonUniformOpBallot(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        return visitor.visitNonUniformOpBallot(this);
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        BooleanFormula enc = super.encodeExec(ctx);
        for (int i = 0; i < 4; i++) {
            enc = bmgr.and(enc, encode32Threads(ctx, i));
        }
        return enc;
    }

    private BooleanFormula encode32Threads(EncodingContext ctx, int i) {
        ScopeHierarchy hierarchy = getThread().getScopeHierarchy();
        ThreadGrid grid = ((Grid) getThread().getProgram().getEntrypoint()).threadGrid();
        BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        ExpressionEncoder encoder = ctx.getExpressionEncoder();
        ExpressionFactory expressions = ExpressionFactory.getInstance();
        Expression iExpr = expressions.makeExtract(ctx.result(this), i);
        Expression bv1_1 = expressions.makeOne(TypeFactory.getInstance().getIntegerType(1));
        Expression bv1_0 = expressions.makeZero(TypeFactory.getInstance().getIntegerType(1));
        List<BooleanFormula> existingThreadsBits = getThread().getProgram().getThreadEvents(NonUniformOpBallot.class).stream()
                .filter(e -> getInstanceId().equals(e.getInstanceId()))
                .filter(e -> hierarchy.canSyncAtScope(e.getThread().getScopeHierarchy(), execScope))
                // TODO is grid.thId the one we need to use?
                .filter(e -> grid.thId(e.getThread().getId()) >= (32 * i) && grid.thId(e.getThread().getId()) < (32 * (i + 1)))
                .map(e -> encoder.equal(
                    expressions.makeIntExtract(iExpr, grid.thId(e.getThread().getId() % 32), grid.thId(e.getThread().getId() % 32)),
                    expressions.makeITE(expressions.makeAnd(encoder.encodeAt(e.expr, e), encoder.wrap(ctx.execution(e))), bv1_1, bv1_0)))
                .toList();
        List<BooleanFormula> nonExistingThreadsBits = new ArrayList();
        int start = grid.sgSize() > (32 * (i + 1)) ? 32 : (grid.sgSize() < (32 * i) ? 0 : grid.sgSize() % 32);
        for(int j = start; j < 32; j++) {
            nonExistingThreadsBits.add(encoder.equal(expressions.makeIntExtract(iExpr, j, j), bv1_0));
        }
        return bmgr.and(bmgr.and(existingThreadsBits), bmgr.and(nonExistingThreadsBits));
    }

}
