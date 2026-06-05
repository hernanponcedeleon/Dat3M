package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.TypeOffset;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Local;
import com.google.common.base.Preconditions;

import java.util.*;
import java.util.stream.Collectors;

// Scalar Replacement of Aggregates
public class SROA implements FunctionProcessor {

    private SROA() {}

    public static SROA newInstance() {
        return new SROA();
    }

    @Override
    public void run(Function function) {
        // Compute decomposable aggregate registers
        final Set<Register> decomposableAggRegs = function.getRegisters().stream()
                .filter(r -> r.getType() instanceof AggregateType)
                .collect(Collectors.toSet());
        for (RegWriter writer : function.getEvents(RegWriter.class)) {
            if (decomposableAggRegs.contains(writer.getResultRegister()) && !(writer instanceof Local)) {
                decomposableAggRegs.remove(writer.getResultRegister());
            }
        }

        // Compute decomposition of aggregate registers
        final Map<Register, AggregateReg> agg2Scalars = new HashMap<>();
        for (Register reg : decomposableAggRegs) {
            agg2Scalars.put(reg, (AggregateReg) decomposeType(function, reg.getType(), reg.getName()));
        }

        // Transform program
        final ExprTransformer exprTransformer = new ExprTransformer() {
            @Override
            public Expression visitRegister(Register reg) {
                return agg2Scalars.containsKey(reg) ? toExpression(agg2Scalars.get(reg)) : reg;
            }
        };

        for (Event e : function.getEvents()) {
            if (e instanceof RegReader reader) {
                reader.transformExpressions(exprTransformer);
            }

            if (e instanceof Local writer && agg2Scalars.containsKey(writer.getResultRegister())) {
                decomposeLocal(writer, agg2Scalars.get(writer.getResultRegister()), writer.getExpr());
                writer.tryDelete();
            }
        }

    }

    private void decomposeLocal(Local orig, AnnotatedRegister reg, Expression expr) {
        Preconditions.checkArgument(reg.getType().equals(expr.getType()));

        if (reg instanceof SimpleReg simpleReg) {
            final Local local = EventFactory.newLocal(simpleReg.reg, expr);
            local.copyAllMetadataFrom(orig);
            orig.insertAfter(local);
        } else if (reg instanceof AggregateReg aggReg) {
            assert expr instanceof ConstructExpr;
            for (int i = aggReg.regs.size() - 1; i >= 0; i--) {
                decomposeLocal(orig, aggReg.regs.get(i), expr.getOperands().get(i));
            }
        }
    }


    private Expression toExpression(AnnotatedRegister annotatedRegister) {
        if (annotatedRegister instanceof SimpleReg reg) {
            return reg.reg;
        } else if (annotatedRegister instanceof AggregateReg aggReg) {
            final List<Expression> exprs = aggReg.regs.stream().map(this::toExpression).collect(Collectors.toList());
            return ExpressionFactory.getInstance().makeConstruct(aggReg.getType(), exprs);
        }
        return null;
    }

    private AnnotatedRegister decomposeType(Function func, Type type, String regName) {
        if (!(type instanceof AggregateType aggType)) {
            return new SimpleReg(func.newRegister(regName + "__sroa", type));
        }

        final List<TypeOffset> fields = aggType.getFields();
        List<AnnotatedRegister> regs = new ArrayList<>(fields.size());
        for (int i = 0; i < fields.size(); i++) {
            regs.add(decomposeType(func, fields.get(i).type(), regName + "@" + i));
        }
        return new AggregateReg(type, regs);
    }

    // --------------------------------------------------------------------------------------------
    // Helper classes

    sealed interface AnnotatedRegister {
        Type getType();
    }

    record SimpleReg(Register reg) implements AnnotatedRegister {
        @Override
        public Type getType() { return reg.getType(); }
    }

    record AggregateReg(Type type, List<AnnotatedRegister> regs) implements AnnotatedRegister {
        @Override
        public Type getType() { return type; }
    }


}
