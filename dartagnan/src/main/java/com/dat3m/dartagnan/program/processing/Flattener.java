package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.LeafExpression;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

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
        public Expression visitLeafExpression(LeafExpression expr) {
            return propagationMap.getOrDefault(expr, expr);
        }    
    }
}