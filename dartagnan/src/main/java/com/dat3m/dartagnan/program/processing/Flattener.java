package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ITEExpr;
import com.dat3m.dartagnan.expression.IntBinaryExpr;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.google.common.base.Verify;

import java.util.HashMap;

public class Flattener implements FunctionProcessor {

    private static HashMap<Register, Expression> propagationMap = new HashMap<>();

    private Flattener() { }

    public static Flattener newInstance() {
        return new Flattener();
    }

    @Override
    public void run(Function function) {
        final ExpressionPropagator propagator = new ExpressionPropagator();
        for (Event cur : function.getEvents()) {
            if(cur instanceof Label) {
                propagationMap = new HashMap<>();
            }
            if (cur instanceof RegReader regReader) {
                regReader.transformExpressions(propagator);
            }
            if(cur instanceof Local loc && !loc.getExpr().getRegs().contains(loc.getResultRegister())) {
                propagationMap.put(loc.getResultRegister(), loc.getExpr());
            }
        }
    }

    private static class ExpressionPropagator extends ExprTransformer {

        @Override
        public Expression visit(Register reg) {
            return propagationMap.getOrDefault(reg, reg);
        }

        @Override
        public Expression visit(Atom atom) {
            Expression lhs = transform(atom.getLHS());
            Expression rhs = transform(atom.getRHS());
            return expressions.makeBinary(lhs, atom.getOp(), rhs);
        }

        @Override
        public Expression visit(BoolBinaryExpr bBin) {
            Expression lhs = transform(bBin.getLHS());
            Expression rhs = transform(bBin.getRHS());
            return expressions.makeBinary(lhs, bBin.getOp(), rhs);
        }

        @Override
        public Expression visit(BoolUnaryExpr bUn) {
            Expression inner = transform(bUn.getInner());
            return expressions.makeUnary(bUn.getOp(), inner);
        }

        @Override
        public Expression visit(IntBinaryExpr iBin) {
            Expression lhs = transform(iBin.getLHS());
            Expression rhs = transform(iBin.getRHS());
            return expressions.makeBinary(lhs, iBin.getOp(), rhs);
        }

        @Override
        public Expression visit(ITEExpr iteExpr) {
            Expression guard = transform(iteExpr.getGuard());
            Expression trueBranch = transform(iteExpr.getTrueBranch());
            Expression falseBranch = transform(iteExpr.getFalseBranch());
            return expressions.makeITE(guard, trueBranch, falseBranch);
        }
        
        private Expression transform(Expression expression) {
            Expression result = expression.accept(this);
            Verify.verify(result.getType().equals(expression.getType()), "Type mismatch in constant propagation.");
            return result;
        }

    }
}