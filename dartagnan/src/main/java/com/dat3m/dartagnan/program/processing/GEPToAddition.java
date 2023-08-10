package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.exception.MalformedProgramException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.GEPExpression;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.core.utils.RegReader;
import com.google.common.math.IntMath;

import java.math.BigInteger;
import java.math.RoundingMode;
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
            for (RegReader reader : function.getEvents(RegReader.class)) {
                reader.transformExpressions(transformer);
            }
        }
    }

    public static int getMemorySize(Type type) {
        final int sizeInBytes;
        if (type instanceof ArrayType arrayType) {
            sizeInBytes = arrayType.getNumElements() * getMemorySize(arrayType.getElementType());
        } else if (type instanceof AggregateType aggregateType) {
            sizeInBytes = aggregateType.getDirectFields().stream().mapToInt(GEPToAddition::getMemorySize).sum();
        } else if (type instanceof IntegerType integerType) {
            if (integerType.isMathematical()) {
                // FIXME: We cannot give proper sizes for mathematical integers.
                sizeInBytes = 8;
            } else {
                sizeInBytes = IntMath.divide(integerType.getBitWidth(), 8, RoundingMode.CEILING);
            }
        } else {
            throw new UnsupportedOperationException("Cannot compute the size of " + type);
        }
        return sizeInBytes;
    }

    private static final class GEPToAdditionTransformer extends ExprTransformer {

        private final ExpressionFactory expressions = ExpressionFactory.getInstance();
        private final IntegerType archType = TypeFactory.getInstance().getArchType();

        @Override
        public Expression visit(GEPExpression getElementPointer) {
            Type type = getElementPointer.getIndexingType();
            Expression result = getElementPointer.getBaseExpression().accept(this);
            final List<Expression> offsets = getElementPointer.getOffsetExpressions();
            assert offsets.size() > 0;
            result = expressions.makeADD(result,
                    expressions.makeMUL(
                            expressions.makeValue(BigInteger.valueOf(getMemorySize(type)), archType),
                            expressions.makeIntegerCast(offsets.get(0).accept(this), archType, true)));
            for (final Expression oldOffset : offsets.subList(1, offsets.size())) {
                final Expression offset = oldOffset.accept(this);
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
