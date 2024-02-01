package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.misc.ExtractExpr;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.program.event.EventFactory.newLocal;
import static com.google.common.base.Preconditions.checkNotNull;

public class RegisterDecomposition implements ProgramProcessor {

    private RegisterDecomposition() {}

    public static RegisterDecomposition newInstance() {
        return new RegisterDecomposition();
    }

    @Override
    public void run(Program program) {
        final var transformer = new ExtractSubstitutor();
        for (Function function : program.getFunctions()) {
            //TODO assume that no constructor occurs anywhere other than as the root operation of a local
            for (RegWriter writer : function.getEvents(RegWriter.class)) {
                if (!(writer instanceof LlvmCmpXchg) &&
                        writer.getResultRegister().getType() instanceof AggregateType) {
                    if (!(writer instanceof Local local) ||
                            !(local.getExpr() instanceof ConstructExpr construct)) {
                        throw new UnsupportedOperationException("No support for indirect aggregate construct");
                    }
                    final List<Expression> arguments = construct.getOperands();
                    final var componentAssignments = new ArrayList<Event>();
                    for (int i = 0; i < arguments.size(); i++) {
                        final Expression argument = arguments.get(i);
                        final Register register = function.newRegister(argument.getType());
                        final var index = new RegisterIndex(local.getResultRegister(), i);
                        transformer.map.put(index, register);
                        componentAssignments.add(newLocal(register, argument));
                        //TODO recur if no leaf type
                    }
                    local.replaceBy(componentAssignments);
                }
            }
            for (RegReader reader : function.getEvents(RegReader.class)) {
                reader.transformExpressions(transformer);
            }
        }
    }

    private record RegisterIndex(Register origin, int index) {}

    private static final class ExtractSubstitutor extends ExprTransformer {

        private final Map<RegisterIndex, Register> map = new HashMap<>();

        @Override
        public Expression visitExtractExpression(ExtractExpr expr) {
            if (!(expr.getOperand() instanceof Register reg)) {
                throw new UnsupportedOperationException("No support for indirect expr");
            }
            final var index = new RegisterIndex(reg, expr.getFieldIndex());
            return checkNotNull(map.get(index));
        }
    }
}
