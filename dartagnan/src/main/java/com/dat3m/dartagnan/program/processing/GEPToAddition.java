package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.GEPExpression;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.ArrayType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;

import java.math.BigInteger;
import java.util.List;

public class GEPToAddition implements ProgramProcessor {

    private GEPToAddition() {}

    public static GEPToAddition newInstance() {
        return new GEPToAddition();
    }

    @Override
    public void run(Program program) {
        final var transformer = new GEPToAdditionTransformer();
        for (Function function : program.getFunctions()) {
            for (Event event : function.getEvents()) {
                if (event instanceof RegReader reader) {
                    reader.transformExpressions(transformer);
                }
            }
        }
    }

    // TODO this method does not properly reflect type sizes, i.e. i16 gets size 1
    public static int getMemorySize(Type type) {
        if (type instanceof ArrayType arrayType) {
            return arrayType.getNumElements() * getMemorySize(arrayType.getElementType());
        }
        if (type instanceof AggregateType aggregateType) {
            int size = 0;
            for (final Type elementType : aggregateType.getDirectFields()) {
                size += getMemorySize(elementType);
            }
            return size;
        }
        return 1;
    }

    private static final class GEPToAdditionTransformer extends ExprTransformer {

        private final ExpressionFactory expressions = ExpressionFactory.getInstance();
        private final IntegerType archType = TypeFactory.getInstance().getArchType();

        @Override
        public Expression visit(GEPExpression getElementPointer) {
            Type type = getElementPointer.getIndexingType();
            Expression result = getElementPointer.getBaseExpression();
            final List<Expression> offsets = getElementPointer.getOffsetExpressions();
            assert offsets.size() > 0;
            result = expressions.makeADD(result,
                    expressions.makeMUL(
                            expressions.makeValue(BigInteger.valueOf(getMemorySize(type)), archType),
                            expressions.makeIntegerCast(offsets.get(0), archType, true)));
            for (final Expression offset : offsets.subList(1, offsets.size())) {
                if (type instanceof ArrayType arrayType) {
                    type = arrayType.getElementType();
                    result = expressions.makeADD(result,
                            expressions.makeMUL(
                                    expressions.makeValue(BigInteger.valueOf(getMemorySize(arrayType.getElementType())), archType),
                                    expressions.makeIntegerCast(offset, archType, true)));
                    continue;
                }
                if (!(type instanceof AggregateType aggregateType)) {
                    throw new MalformedProgramException(String.format("GEP from non-compound type %s.", type));
                }
                if (!(offset instanceof IConst constant)) {
                    throw new MalformedProgramException(
                            String.format("Non-constant field index %s for aggregate of type %s.", offset, type));
                }
                final int value = constant.getValueAsInt();
                type = aggregateType.getDirectFields().get(value);
                int o = 0;
                for (final Type elementType : aggregateType.getDirectFields().subList(0, value)) {
                    o += getMemorySize(elementType);
                }
                result = expressions.makeADD(result, expressions.makeValue(BigInteger.valueOf(o), archType));
            }
            return result;
        }
    }
}
