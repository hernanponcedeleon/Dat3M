package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTypes;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import org.antlr.v4.runtime.RuleContext;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import static com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType.BUILT_IN;

public class VisitorOpsMemory extends SpirvBaseVisitor<Event> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final ProgramBuilder builder;
    private final BuiltIn builtIn;

    public VisitorOpsMemory(ProgramBuilder builder) {
        this.builder = builder;
        this.builtIn = (BuiltIn) builder.getDecorationsBuilder().getDecoration(BUILT_IN);
    }

    @Override
    public Event visitOpStore(SpirvParser.OpStoreContext ctx) {
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.object().getText());
        Event event = EventFactory.newStore(pointer, value);
        Set<String> tags = parseMemoryAccessTags(ctx.memoryAccess());
        if (!tags.contains(Tag.Spirv.MEM_VISIBLE)) {
            String storageClass = builder.getPointerStorageClass(ctx.pointer().getText());
            event.addTags(tags);
            event.addTags(storageClass);
            return builder.addEvent(event);
        }
        throw new ParsingException("OpStore cannot contain tag '%s'", Tag.Spirv.MEM_VISIBLE);
    }

    @Override
    public Event visitOpLoad(SpirvParser.OpLoadContext ctx) {
        String resultId = ctx.idResult().getText();
        String pointerId = ctx.pointer().getText();
        String resultType = ctx.idResultType().getText();
        Expression pointer = builder.getExpression(pointerId);
        List<Event> events = new ArrayList<>();
        if (builder.getType(resultType) instanceof ArrayType arrayType) {
            List<Expression> registers = new ArrayList<>();
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                String elementId = resultId + "_" + i;
                Register register = builder.addRegister(elementId, resultType);
                registers.add(register);
                List<Expression> index = List.of(expressions.makeValue(new BigInteger(Long.toString(i)), types.getArchType()));
                Expression elementPointer = HelperTypes.getMemberAddress(pointerId, pointer, arrayType, index);
                Event load = EventFactory.newLoad(register, elementPointer);
                events.add(load);
            }
            Expression arrayRegister = expressions.makeArray(arrayType.getElementType(), registers, true);
            builder.addExpression(resultId, arrayRegister);
        } else {
            Register register = builder.addRegister(resultId, resultType);
            events.add(EventFactory.newLoad(register, pointer));
        }
        Set<String> tags = parseMemoryAccessTags(ctx.memoryAccess());
        if (!tags.contains(Tag.Spirv.MEM_AVAILABLE)) {
            String storageClass = builder.getPointerStorageClass(ctx.pointer().getText());
            events.forEach(e -> {
                e.addTags(tags);
                e.addTags(storageClass);
                builder.addEvent(e);
            });
            return null;
        }
        throw new ParsingException("OpLoad cannot contain tag '%s'", Tag.Spirv.MEM_AVAILABLE);
    }

    @Override
    public Event visitOpVariable(SpirvParser.OpVariableContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        if (builder.getType(typeId) instanceof ScopedPointerType pointerType) {
            Type type = pointerType.getPointedType();
            Expression value = getOpVariableInitialValue(ctx, type);
            if (value != null) {
                if (!TypeFactory.isStaticTypeOf(value.getType(), type)) {
                    throw new ParsingException("Mismatching value type for variable '%s', " +
                            "expected '%s' but received '%s'", id, type, value.getType());
                }
                type = value.getType();
            } else if (!TypeFactory.isStaticType(type)) {
                throw new ParsingException("Missing initial value for runtime variable '%s'", id);
            } else {
                value = builder.makeUndefinedValue(type);
            }
            ScopedPointerVariable pointer = builder.allocateScopedPointerVariable(id, value, pointerType.getScopeId(), type);
            validateVariableStorageClass(pointer, ctx.storageClass().getText());
            builder.addExpression(id, pointer);
            return null;
        }
        throw new ParsingException("Type '%s' is not a pointer type", typeId);
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

    @Override
    public Event visitOpPtrAccessChain(SpirvParser.OpPtrAccessChainContext ctx) {
        visitOpPtrAccessChain(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.element().getText(), ctx.indexesIdRef());
        return null;
    }

    @Override
    public Event visitOpInBoundsPtrAccessChain(SpirvParser.OpInBoundsPtrAccessChainContext ctx) {
        visitOpPtrAccessChain(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.element().getText(), ctx.indexesIdRef());
        return null;
    }

    private void visitOpPtrAccessChain(String id, String typeId, String baseId, String elementId,
                                       List<SpirvParser.IndexesIdRefContext> idxContexts) {
        if (builder.getType(typeId) instanceof ScopedPointerType pointerType) {
            Expression basePointer = builder.getExpression(baseId);
            Type basePointedType;
            if (basePointer.getType() instanceof ScopedPointerType basePointerType) {
                basePointedType = basePointerType.getPointedType();
            } else if (basePointer instanceof ScopedPointer scopedPointer) {
                basePointedType = scopedPointer.getInnerType();
            } else {
                throw new ParsingException("Invalid base pointer type '%s' in access chain '%s'", basePointer.getType(), id);
            }
            Expression element = builder.getExpression(elementId);
            Expression address = HelperTypes.getPointerOffset(basePointer, basePointedType, element);
            String baseWithOffsetId = baseId + "_" + elementId;
            ScopedPointer baseWithOffset = expressions.makeScopedPointer(baseWithOffsetId, pointerType.getScopeId(), basePointedType, address);
            visitAccessChain(id, pointerType, baseWithOffsetId, baseWithOffset, idxContexts);
        } else {
            throw new ParsingException("Type '%s' is not a pointer type", typeId);
        }
    }

    private void visitOpAccessChain(String id, String typeId, String baseId,
                                    List<SpirvParser.IndexesIdRefContext> idxContexts) {
        if (builder.getType(typeId) instanceof ScopedPointerType pointerType) {
            ScopedPointer base = (ScopedPointer) builder.getExpression(baseId);
            visitAccessChain(id, pointerType, baseId, base, idxContexts);
            return;
        }
        throw new ParsingException("Type '%s' is not a pointer type", typeId);
    }

    private void visitAccessChain(String id, ScopedPointerType pointerType, String baseId, ScopedPointer base,
                                    List<SpirvParser.IndexesIdRefContext> idxContexts) {
        Type baseType = base.getMemoryType();
        Type resultType = pointerType.getPointedType();
        List<Integer> intIndexes = new ArrayList<>();
        List<Expression> exprIndexes = new ArrayList<>();
        idxContexts.forEach(c -> {
            Expression expression = builder.getExpression(c.getText());
            exprIndexes.add(expression);
            intIndexes.add(expression instanceof IntLiteral intLiteral ? intLiteral.getValueAsInt() : -1);
        });
        Type runtimeResultType = HelperTypes.getMemberType(baseId, baseType, intIndexes);
        if (!TypeFactory.isStaticTypeOf(runtimeResultType, resultType)) {
            throw new ParsingException("Invalid result type in access chain '%s', " +
                    "expected '%s' but received '%s'", id, resultType, runtimeResultType);
        }
        Expression expression = HelperTypes.getMemberAddress(baseId, base, baseType, exprIndexes);
        ScopedPointer pointer = expressions.makeScopedPointer(id, pointerType.getScopeId(), runtimeResultType, expression);
        builder.addExpression(id, pointer);
    }

    private Set<String> parseMemoryAccessTags(SpirvParser.MemoryAccessContext ctx) {
        if (ctx != null) {
            List<String> operands = ctx.memoryAccessTag().stream().map(RuleContext::getText).toList();
            Integer alignment = ctx.literalInteger() != null ? Integer.parseInt(ctx.literalInteger().getText()) : null;
            List<String> paramIds = ctx.idRef().stream().map(RuleContext::getText).toList();
            List<Expression> paramsValues = ctx.idRef().stream().map(c -> builder.getExpression(c.getText())).toList();
            return HelperTags.parseMemoryOperandsTags(operands, alignment, paramIds, paramsValues);
        }
        return Set.of();
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpVariable",
                "OpLoad",
                "OpStore",
                "OpAccessChain",
                "OpInBoundsAccessChain",
                "OpPtrAccessChain",
                "OpInBoundsPtrAccessChain"
        );
    }
}
