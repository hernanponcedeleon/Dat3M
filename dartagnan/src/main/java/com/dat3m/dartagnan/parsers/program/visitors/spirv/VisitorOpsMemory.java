package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags.MemoryOperandTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import org.antlr.v4.runtime.RuleContext;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.function.BiFunction;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isScalar;
import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.BUILT_IN;

public class VisitorOpsMemory extends SpirvBaseVisitor<Event> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final ProgramBuilder builder;
    private final BuiltIn builtIn;
    private int copyMemoryCount = 0;

    public VisitorOpsMemory(ProgramBuilder builder) {
        this.builder = builder;
        this.builtIn = (BuiltIn) builder.getDecorationsBuilder().getDecoration(BUILT_IN);
    }

    @Override
    public Event visitOpStore(SpirvParser.OpStoreContext ctx) {
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        String valueId = ctx.object().getText();
        Expression value = builder.getExpression(valueId);
        Type type = value.getType();
        List<Event> events = visitMemoryAccess(valueId, type, pointer, (i, exp) ->
            i == -1 ?
            EventFactory.newStore(exp, value) :
            EventFactory.newStore(exp, expressions.makeExtract(value, i)));
        MemoryOperandTags tags = ctx.memoryAccess() == null
                ? MemoryOperandTags.empty()
                : parseMemoryAccessTags(ctx.memoryAccess());
        validateMemoryAccessTags(tags, Tag.Spirv.MEM_VISIBLE, "OpStore");
        addMemoryEvents(events, tags.writeTags(), ctx.pointer().getText());
        return null;
    }

    @Override
    public Event visitOpLoad(SpirvParser.OpLoadContext ctx) {
        String resultId = ctx.idResult().getText();
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Type type = builder.getType(ctx.idResultType().getText());
        List<Event> events = visitMemoryAccess(resultId, type, pointer, (i, exp) -> {
            String regId = resultId;
            if (i != -1) {
                regId += "_" + i;
            }
            Register register = builder.addRegister(regId, getMemoryAccessType(type, i));
            return EventFactory.newLoad(register, exp);
            });
        List<Expression> registers = events.stream().map(Load.class::cast).map(Load::getResultRegister).collect(Collectors.toList());
        if (type instanceof AggregateType) {
            builder.addExpression(resultId, expressions.makeConstruct(type, registers));
        }
        if (type instanceof ArrayType arrayType) {
            builder.addExpression(resultId, expressions.makeArray(arrayType, registers));
        }
        MemoryOperandTags tags = ctx.memoryAccess() == null
                ? MemoryOperandTags.empty()
                : parseMemoryAccessTags(ctx.memoryAccess());
        validateMemoryAccessTags(tags, Tag.Spirv.MEM_AVAILABLE, "OpLoad");
        addMemoryEvents(events, tags.readTags(), ctx.pointer().getText());
        return null;
    }

    @Override
    public Event visitOpCopyMemory(SpirvParser.OpCopyMemoryContext ctx) {
        final String targetId = ctx.targetIdRef().getText();
        final String sourceId = ctx.sourceIdRef().getText();
        final Expression target = builder.getExpression(targetId);
        final Expression source = builder.getExpression(sourceId);
        if (!(target.getType() instanceof ScopedPointerType targetType)
                || !(source.getType() instanceof ScopedPointerType sourceType)
                || !targetType.getPointedType().equals(sourceType.getPointedType())) {
            throw new ParsingException("Mismatching pointer types in OpCopyMemory");
        }

        final Type type = targetType.getPointedType();
        final String registerId = "copy_memory_" + copyMemoryCount++;
        final List<Event> loads = visitMemoryAccess(registerId, type, source, (i, address) -> {
            final String id = i == -1 ? registerId : registerId + "_" + i;
            final Register register = builder.addRegister(id, getMemoryAccessType(type, i));
            return EventFactory.newLoad(register, address);
        });
        final List<Register> values = loads.stream()
                .map(Load.class::cast)
                .map(Load::getResultRegister)
                .toList();
        final List<Event> stores = visitMemoryAccess(registerId, type, target,
                (i, address) -> EventFactory.newStore(address, values.get(i == -1 ? 0 : i)));

        final List<SpirvParser.MemoryAccessContext> memoryAccesses = ctx.memoryAccess();
        final MemoryOperandTags targetTags = memoryAccesses.isEmpty()
                ? MemoryOperandTags.empty()
                : parseMemoryAccessTags(memoryAccesses.get(0));
        final MemoryOperandTags sourceTags = memoryAccesses.size() < 2
                ? targetTags
                : parseMemoryAccessTags(memoryAccesses.get(1));
        if (memoryAccesses.size() == 2) {
            validateMemoryAccessTags(targetTags, Tag.Spirv.MEM_VISIBLE, "OpCopyMemory");
            validateMemoryAccessTags(sourceTags, Tag.Spirv.MEM_AVAILABLE, "OpCopyMemory");
        }
        addMemoryEvents(loads, sourceTags.readTags(), sourceId);
        addMemoryEvents(stores, targetTags.writeTags(), targetId);
        return null;
    }

    private List<Event> visitMemoryAccess(String id, Type type, Expression pointer, BiFunction<Integer, Expression, Event> f) {
        List<Event> events = new ArrayList<>();
        if (type instanceof ArrayType arrayType) {
            Type elType = arrayType.getElementType();
            if(!isScalar(elType)) {
                throw new ParsingException("Unsupported type of memory access to '%s', " +
                        "expected an array of scalars but received %s", id, type);
            }
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                List<Expression> index = List.of(expressions.makeValue(i, types.getArchType()));
                Expression address = expressions.makeGetElementPointer(arrayType.getElementType(), pointer, index, arrayType.getStride());
                events.add(f.apply(i, address));
            }
        } else if (type instanceof AggregateType aggregateType) {
            if(aggregateType.getFields().stream().map(TypeOffset::type)
                    .anyMatch(t -> !isScalar(t))) {
                throw new ParsingException("Unsupported type of memory access to '%s', " +
                        "expected an struct of scalars but received %s", id, type);
            }
            for (int i = 0; i < aggregateType.getFields().size(); i++) {
                List<Expression> index = List.of(expressions.makeValue(i, types.getArchType()));
                Expression address = expressions.makeGetElementPointer(aggregateType.getFields().get(i).type(), pointer, index);
                events.add(f.apply(i, address));
            }
        } else {
            events.add(f.apply(-1, pointer));
        }
        return events;
    }

    private Type getMemoryAccessType(Type type, int index) {
        if (index == -1) {
            return type;
        }
        if (type instanceof AggregateType aggregateType) {
            return aggregateType.getFields().get(index).type();
        }
        if (type instanceof ArrayType arrayType) {
            return arrayType.getElementType();
        }
        throw new IllegalArgumentException("Cannot index memory access type %s".formatted(type));
    }

    private MemoryOperandTags parseMemoryAccessTags(SpirvParser.MemoryAccessContext ctx) {
        List<String> operands = ctx.memoryAccessTag().stream().map(RuleContext::getText).toList();
        Integer alignmentTag = ctx.literalInteger() != null ? Integer.parseInt(ctx.literalInteger().getText()) : null;
        List<String> paramIds = ctx.idRef().stream().map(RuleContext::getText).toList();
        List<Expression> paramsValues = ctx.idRef().stream().map(c -> builder.getExpression(c.getText())).toList();
        return HelperTags.parseMemoryOperandsTags(operands, alignmentTag, paramIds, paramsValues);
    }

    private void validateMemoryAccessTags(MemoryOperandTags tags, String invalidTag, String op) {
        if (tags.contains(invalidTag)) {
            throw new ParsingException("%s cannot contain tag '%s'", op, invalidTag);
        }
    }

    private void addMemoryEvents(List<Event> events, Set<String> tags, String pointerId) {
        final String storageClass = builder.getPointerStorageClass(pointerId);
        events.forEach(event -> {
            event.addTags(tags);
            event.addTags(storageClass);
            builder.addEvent(event);
        });
    }

    @Override
    public Event visitOpVariable(SpirvParser.OpVariableContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (type instanceof ScopedPointerType pType) {
            type = pType.getPointedType();
            Expression value = getOpVariableInitialValue(ctx, type);
            if (value != null) {
                if (!types.isStaticTypeOf(value.getType(), type)) {
                    throw new ParsingException("Mismatching value type for variable '%s', " +
                            "expected '%s' but received '%s'", id, type, value.getType());
                }
            } else if (!types.isStaticType(type)) {
                throw new ParsingException("Missing initial value for runtime variable '%s'", id);
            } else {
                value = builder.makeUndefinedValue(type);
            }
            ScopedPointerVariable pointer = builder.allocateMemory(id, pType, value);
            validateVariableStorageClass(pointer, ctx.storageClass().getText());
            builder.addExpression(id, pointer);
            return null;
        }
        throw new ParsingException("Type '%s' is not a pointer type", ctx.idResultType().getText());
    }

    private Expression getOpVariableInitialValue(SpirvParser.OpVariableContext ctx, Type type) {
        String id = ctx.idResult().getText();
        if (builder.hasInput(id)) {
            if (builtIn.hasDecoration(id) || ctx.initializer() != null) {
                throw new ParsingException("The original value of variable '%s' " +
                        "cannot be overwritten by an external input", id);
            }
            return HelperInputs.castInput(id, type, builder.getInput(id));
        }
        if (builtIn.hasDecoration(id)) {
            if (ctx.initializer() != null) {
                throw new ParsingException("The original value of variable '%s' " +
                        "cannot be overwritten by a decoration", id);
            }
            return builtIn.getDecoration(id, type);
        }
        if (ctx.initializer() != null) {
            return builder.getExpression(ctx.initializer().getText());
        }
        return null;
    }

    private void validateVariableStorageClass(ScopedPointerVariable pointer, String classToken) {
        String ptrStorageClass = pointer.getScopeId();
        String varStorageClass = HelperTags.parseStorageClass(classToken);
        if (!varStorageClass.equals(ptrStorageClass)) {
            throw new ParsingException("Storage class of variable '%s' " +
                    "does not match the pointer storage class", pointer.getId());
        }
        if (Tag.Spirv.SC_GENERIC.equals(ptrStorageClass)) {
            throw new ParsingException("Variable '%s' has illegal storage class '%s'",
                    pointer.getId(), classToken);
        }
    }

    @Override
    public Event visitOpAccessChain(SpirvParser.OpAccessChainContext ctx) {
        return visitOpAccessChain(ctx.idResult(), ctx.idResultType(), ctx.base(), null, ctx.indexesIdRef());
    }

    @Override
    public Event visitOpInBoundsAccessChain(SpirvParser.OpInBoundsAccessChainContext ctx) {
        return visitOpAccessChain(ctx.idResult(), ctx.idResultType(), ctx.base(), null, ctx.indexesIdRef());
    }

    @Override
    public Event visitOpPtrAccessChain(SpirvParser.OpPtrAccessChainContext ctx) {
        return visitOpAccessChain(ctx.idResult(), ctx.idResultType(), ctx.base(), ctx.element(), ctx.indexesIdRef());
    }

    @Override
    public Event visitOpInBoundsPtrAccessChain(SpirvParser.OpInBoundsPtrAccessChainContext ctx) {
        return visitOpAccessChain(ctx.idResult(), ctx.idResultType(), ctx.base(), ctx.element(), ctx.indexesIdRef());
    }

    private Event visitOpAccessChain(SpirvParser.IdResultContext idCtx, SpirvParser.IdResultTypeContext typeIdCtx,
                                     SpirvParser.BaseContext baseCtx, SpirvParser.ElementContext elCtx,
                                     List<SpirvParser.IndexesIdRefContext> idxCtx) {
        Expression base = builder.getExpression(baseCtx.getText());
        if (!(builder.getType(typeIdCtx.getText()) instanceof ScopedPointerType resultPointerType)) {
            throw new ParsingException("Invalid result type in access chain '%s', result must be a pointer", idCtx.getText());
        }
        if (!(base.getType() instanceof ScopedPointerType basePointerType)) {
            throw new ParsingException("Invalid base type in access chain '%s', base must be a pointer", idCtx.getText());
        }
        if (elCtx == null && idxCtx.isEmpty()) {
            throw new ParsingException("Empty element indexes in access chain '%s'", idCtx.getText());
        }
        Type baseType = basePointerType.getPointedType();
        Type resultType = resultPointerType.getPointedType();
        LinkedList<Expression> exprIndexes = new LinkedList<>();
        LinkedList<Integer> intIndexes = new LinkedList<>();
        idxCtx.forEach(ctx -> {
            Expression expression = builder.getExpression(ctx.getText());
            exprIndexes.add(expression);
            intIndexes.add(expression instanceof IntLiteral literal ? literal.getValueAsInt() : -1);
        });
        Type memberType = HelperTypes.getMemberType(baseCtx.getText(), baseType, intIndexes);
        if (!types.isStaticTypeOf(resultType, memberType)) {
            throw new ParsingException("Invalid result type in access chain '%s', " +
                    "expected '%s' but received '%s'", idCtx.getText(), resultType, memberType);
        }
        if (elCtx == null) {
            exprIndexes.addFirst(expressions.makeZero((IntegerType) exprIndexes.get(0).getType()));
        } else {
            exprIndexes.addFirst(builder.getExpression(elCtx.getText()));
        }
        Expression expression = expressions.makeGetElementPointer(baseType, base, exprIndexes, basePointerType.getStride());
        expression = new ScopedPointer(idCtx.getText(), resultPointerType, expression);
        builder.addExpression(idCtx.getText(), expression);
        return null;
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpVariable",
                "OpLoad",
                "OpStore",
                "OpCopyMemory",
                "OpAccessChain",
                "OpInBoundsAccessChain",
                "OpPtrAccessChain",
                "OpInBoundsPtrAccessChain"
        );
    }
}
