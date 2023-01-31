package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.BExpr;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.visitors.EventVisitor;
import com.google.common.base.Preconditions;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

public class NewConstantPropagation implements ProgramProcessor {

    private static final ExprInterface TOP = new IConst() {
        @Override
        public BigInteger getValue() { return null; }

        @Override
        public <T> T visit(ExpressionVisitor<T> visitor) { return null; }
    };

    @Override
    public void run(Program program) {
        Preconditions.checkArgument(program.isUnrolled());
    }

    private void run(Thread thread) {
        Map<Register, ExprInterface> propagationMap = new HashMap<>();
        Map<Label, Map<Register, ExprInterface>> inflowMap = new HashMap<>();

        for (Event e : thread.getEvents()) {


        }
    }





    private static class ConstantPropagator extends ExprTransformer {

        Map<Register, ExprInterface> propagationMap = new HashMap<>();
        @Override
        public ExprInterface visit(Register reg) {
            return propagationMap.compute(reg, (k, v) -> v == null || v == TOP ? reg : v );
        }
    }


    private class Simplifier implements EventVisitor<Void> {

        ConstantPropagator propagator = new ConstantPropagator();

        @Override
        public Void visitEvent(Event e) {
            return null;
        }

        @Override
        public Void visitCondJump(CondJump e) {
            e.setGuard((BExpr) e.getGuard().visit(propagator));
            return null;
        }

        @Override
        public Void visitLocal(Local e) {
            e.setExpr(e.getExpr().visit(propagator));
            return null;
        }

        @Override
        public Void visitMemEvent(MemEvent e) {
            e.setAddress((IExpr)e.getAddress().visit(propagator));
            return null;
        }

        @Override
        public Void visitStore(Store e) {
            e.setMemValue(e.getAddress().visit(propagator));
            return visitMemEvent(e);
        }
    }

}
