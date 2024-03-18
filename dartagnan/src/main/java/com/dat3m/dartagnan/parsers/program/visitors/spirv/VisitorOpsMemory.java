package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.ADD;
import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.MUL;

public class VisitorOpsMemory extends SpirvBaseVisitor<Event> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsMemory(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpStore(SpirvParser.OpStoreContext ctx) {
        // TODO: Handle memoryAccess
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.object().getText());
        return builder.addEvent(new Store(pointer, value));
    }

    @Override
    public Event visitOpLoad(SpirvParser.OpLoadContext ctx) {
        // TODO: Handle memoryAccess
        Register register = builder.addRegister(ctx.idResult().getText(), ctx.idResultType().getText());
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        return builder.addEvent(new Load(register, pointer));
    }

    @Override
    public Event visitOpVariable(SpirvParser.OpVariableContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getPointedType(ctx.idResultType().getText());
        Expression value = getOpVariableInitialValue(ctx, type);
        if (value != null) {
            type = validateVariableType(id, value, type, value.getType());
        } else if (type instanceof ArrayType aType && aType.getNumElements() == -1) {
            throw new ParsingException("Missing initial value for runtime variable '%s'", id);
        }

        int size = TYPE_FACTORY.getMemorySizeInBytes(type);
        MemoryObject memObj = builder.allocateMemory(size);
        memObj.setCVar(id);
        if (isThreadLocal(ctx.storageClass())) {
            memObj.setIsThreadLocal(true);
        }
        if (value != null) {
            setInitialValue(memObj, 0, value);
        }

        builder.addExpression(id, memObj);
        builder.addVariableType(id, type);
        return null;
    }

    private Expression getOpVariableInitialValue(SpirvParser.OpVariableContext ctx, Type type) {
        String id = ctx.idResult().getText();
        if (builder.hasInput(id)) {
            if (ctx.initializer() == null) {
                return castInput(id, type, builder.getInput(id));
            }
            throw new ParsingException("Variable '%s' has a constant initializer " +
                    "and cannot accept an external input", id);
        }
        if (ctx.initializer() != null) {
            return builder.getExpression(ctx.initializer().getText());
        }
        return null;
    }

    private Expression castInput(String id, Type type, Expression value) {
        if (type instanceof ArrayType aType) {
            return castInputArray(id, aType, value);
        }
        if (type instanceof AggregateType aType) {
            return castInputAggregate(id, aType, value);
        }
        return castInputScalar(id, type, value);
    }

    private Expression castInputArray(String id, ArrayType type, Expression value) {
        if (value instanceof ConstructExpr cValue) {
            // TODO: Handle empty arrays
            int size = type.getNumElements();
            if (size != -1 && size != cValue.getOperands().size()) {
                // TODO: Add a unit test for this
                throw new ParsingException("Unexpected number of elements in variable '%s', " +
                        "expected '%d' elements but received '%d' elements", id, size, cValue.getOperands().size());
            }
            Type eType = type.getElementType();
            List<Expression> elements = cValue.getOperands().stream().map(a -> castInput(id, eType, a)).toList();
            return EXPR_FACTORY.makeArray(elements.get(0).getType(), elements, true);
        }
        throw new ParsingException("Mismatching value type for variable '%s', " +
                "expected '%s' but received '%s'", id, type, value.getType());
    }

    private Expression castInputAggregate(String id, AggregateType type, Expression value) {
        if (value instanceof ConstructExpr cValue) {
            // TODO: Test empty structures
            int size = type.getDirectFields().size();
            if (size != cValue.getOperands().size()) {
                // TODO: Add a unit test for this
                throw new ParsingException("Unexpected number of elements in variable '%s', " +
                        "expected '%d' elements but received '%d' elements", id, size, cValue.getOperands().size());
            }
            List<Expression> elements = new ArrayList<>();
            for (int i = 0; i < size; i++) {
                elements.add(castInput(id, type.getDirectFields().get(i), cValue.getOperands().get(i)));
            }
            return EXPR_FACTORY.makeConstruct(elements);
        }
        throw new ParsingException("Mismatching value type for variable '%s', " +
                "expected '%s' but received '%s'", id, type, value.getType());
    }

    private Expression castInputScalar(String id, Type type, Expression value) {
        if (!value.getType().equals(TYPE_FACTORY.getArchType())) {
            throw new ParsingException("Mismatching value type for variable '%s', " +
                    "expected '%s' but received '%s'", id, type, value.getType());
        }
        if (value instanceof IntLiteral iConst) {
            int iValue = iConst.getValueAsInt();
            if (type instanceof BooleanType) {
                if (iValue == 0) {
                    return EXPR_FACTORY.makeFalse();
                }
                return EXPR_FACTORY.makeTrue();
            }
            if (type instanceof IntegerType iType) {
                return EXPR_FACTORY.makeValue(iValue, iType);
            }
            throw new ParsingException("Unexpected element type '%s' for variable '%s'",
                    type, id);
        }
        throw new ParsingException("Illegal input for variable '%s', " +
                "the value is not constant", id);
    }

    private Type validateVariableType(String id, Expression value, Type varType, Type valType) {
        if (varType.equals(valType)) {
            return valType;
        }
        if (varType instanceof AggregateType t1 && valType instanceof AggregateType t2) {
            int size = t1.getDirectFields().size();
            if (size == t2.getDirectFields().size()) {
                for (int i = 0; i < size; i++) {
                    validateVariableType(id, value, t1.getDirectFields().get(i), t2.getDirectFields().get(i));
                }
                return valType;
            }
        }
        if (varType instanceof ArrayType t1 && valType instanceof ArrayType t2) {
            if (t1.getNumElements() == -1) {
                if (t2.getNumElements() > 0) {
                    return valType;
                }
            } else if (t1.getNumElements() == t2.getNumElements()) {
                validateVariableType(id, value, t1.getElementType(), t2.getElementType());
                return valType;
            }
        }
        throw new ParsingException("Mismatching value type for variable '%s', " +
                "expected '%s' but received '%s'", id, varType, valType);
    }

    private boolean isThreadLocal(SpirvParser.StorageClassContext ctx) {
        // TODO: More fine-grained handling
        // TODO: Input has to be thread-local only if set from BuiltIn
        return ctx.Input() != null || ctx.Private() != null || ctx.Function() != null;
    }

    private void setInitialValue(MemoryObject memObj, int offset, Expression value) {
        if (value.getType() instanceof ArrayType aType) {
            ConstructExpr cValue = (ConstructExpr) value;
            List<Expression> elements = cValue.getOperands();
            int step = TYPE_FACTORY.getMemorySizeInBytes(aType.getElementType());
            for (int i = 0; i < elements.size(); i++) {
                setInitialValue(memObj, offset + i * step, elements.get(i));
            }
        } else if (value.getType() instanceof AggregateType) {
            ConstructExpr cValue = (ConstructExpr) value;
            final List<Expression> elements = cValue.getOperands();
            int currentOffset = offset;
            for (Expression element : elements) {
                setInitialValue(memObj, currentOffset, element);
                currentOffset += TYPE_FACTORY.getMemorySizeInBytes(element.getType());
            }
        } else if (value.getType() instanceof IntegerType) {
            memObj.setInitialValue(offset, value);
        } else if (value.getType() instanceof BooleanType) {
            memObj.setInitialValue(offset, value);
        } else {
            throw new ParsingException("Illegal variable value type '%s'", value.getType());
        }
    }

    @Override
    public Event visitOpAccessChain(SpirvParser.OpAccessChainContext ctx) {
        visitOpAccessChain(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.indexesIdRef());
        return null;
    }

    @Override
    public Event visitOpInBoundsAccessChain(SpirvParser.OpInBoundsAccessChainContext ctx) {
        visitOpAccessChain(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.indexesIdRef());
        return null;
    }

    private void visitOpAccessChain(String id, String typeId, String baseId,
                                    List<SpirvParser.IndexesIdRefContext> idxContexts) {
        Type resultType = builder.getPointedType(typeId);
        Type baseType = builder.getVariableType(baseId);
        Expression base = builder.getExpression(baseId);
        List<Expression> indexes = idxContexts.stream()
                .map(c -> builder.getExpression(c.getText()))
                .toList();
        // TODO: Merge with GEPExpression?
        Expression expression = EXPR_FACTORY.makeBinary(base, ADD, getMemberPtr(id, resultType, baseType, indexes));
        builder.addExpression(id, expression);
    }

    private Expression getMemberPtr(String id, Type resultType, Type type, List<Expression> indexes) {
        if (type instanceof ArrayType arrayType) {
            return getArrayMemberPtr(id, resultType, arrayType, indexes);
        } else if (type instanceof AggregateType agType) {
            return getStructMemberPtr(id, resultType, agType, indexes);
        } else {
            throw new ParsingException("Referring to a scalar type in access chain '%s'", id);
        }
    }

    private Expression getArrayMemberPtr(String id, Type resultType, ArrayType type, List<Expression> indexes) {
        // TODO: Simplify if all indexes are constants
        Type elementType = type.getElementType();
        int size = TYPE_FACTORY.getMemorySizeInBytes(elementType);
        IntLiteral sizeExpr = EXPR_FACTORY.makeValue(size, TYPE_FACTORY.getArchType());
        Expression indexExpr = EXPR_FACTORY.makeIntegerCast(indexes.get(0), sizeExpr.getType(), false);
        Expression offsetExpr = EXPR_FACTORY.makeBinary(sizeExpr, MUL, indexExpr);
        if (indexes.size() > 1) {
            Expression remainingOffsetExpr = getMemberPtr(id, resultType, elementType, indexes.subList(1, indexes.size()));
            return EXPR_FACTORY.makeBinary(offsetExpr, ADD, remainingOffsetExpr);
        }
        if (!resultType.equals(elementType)) {
            throw new ParsingException("Invalid value type in access chain '%s', " +
                    "expected '%s' but received '%s'", id, resultType, elementType);
        }
        return offsetExpr;
    }

    private Expression getStructMemberPtr(String id, Type resultType, AggregateType type, List<Expression> indexes) {
        // TODO: Support for non-constants, simplify if all indexes are constants
        Expression indexExpr = indexes.get(0);
        if (indexExpr instanceof IntLiteral iValue) {
            int value = iValue.getValueAsInt();
            int offset = 0;
            for (int i = 0; i < value; i++) {
                offset += TYPE_FACTORY.getMemorySizeInBytes(type.getDirectFields().get(i));
            }
            IntLiteral offsetExpr = EXPR_FACTORY.makeValue(offset, TYPE_FACTORY.getArchType());
            if (indexes.size() > 1) {
                Expression remainingOffsetExpr = getMemberPtr(id, resultType, type.getDirectFields().get(value), indexes.subList(1, indexes.size()));
                return EXPR_FACTORY.makeBinary(offsetExpr, ADD, remainingOffsetExpr);
            }
            Type elemType = type.getDirectFields().get(value);
            if (!resultType.equals(elemType)) {
                throw new ParsingException("Invalid value type in access chain '%s', " +
                        "expected '%s' but received '%s'", id, resultType, elemType);
            }
            return offsetExpr;
        }
        throw new ParsingException("Unsupported non-constant offset in access chain '%s'", id);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpVariable",
                "OpLoad",
                "OpStore",
                "OpAccessChain",
                "OpInBoundsAccessChain"
        );
    }
}
