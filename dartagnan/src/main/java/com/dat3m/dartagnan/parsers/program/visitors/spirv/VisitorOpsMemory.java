package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInputs;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import org.antlr.v4.runtime.RuleContext;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

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
            event.addTags(tags);
            event.addTags(getStorageClassTag(ctx.pointer().getText()));
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
            Type elType = arrayType.getElementType();
            List<Expression> registers = new ArrayList<>();
            for (int i = 0; i < arrayType.getNumElements(); i++) {
                String elementId = resultId + "_" + i;
                Register register = builder.addRegister(elementId, elType);
                registers.add(register);
                List<Expression> indexes = List.of(expressions.makeValue(i, types.getArchType()));
                Expression elPointer;
                try {
                    elPointer = expressions.makeGetElementPointer(elType, pointer, indexes);
                } catch (Exception e) {
                    throw new ParsingException("%s in assignment to '%s'", e.getMessage(), resultId);
                }
                Event load = EventFactory.newLoad(register, elPointer);
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
            String storageClass = getStorageClassTag(ctx.pointer().getText());
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
                    throw new ParsingException("Mismatching value type for '%s', " +
                            "expected '%s' but received '%s'", id, type, value.getType());
                }
                type = value.getType();
                pointerType = types.getScopedPointerType(pointerType.getScopeId(), type);
            } else if (!TypeFactory.isStaticType(type)) {
                throw new ParsingException("Missing initial value for runtime variable '%s'", id);
            } else {
                value = builder.makeUndefinedValue(type);
            }
            validateVariableStorageClass(id, pointerType.getScopeId(), ctx.storageClass().getText());
            value = expressions.makeConstruct(types.getArrayType(pointerType.getPointedType(), 1), List.of(value));
            Expression pointer = builder.allocateMemory(id, pointerType, value);
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
            // TODO: Where used?
            return builtIn.getDecoration(id, type);
        }
        if (ctx.initializer() != null) {
            return builder.getExpression(ctx.initializer().getText());
        }
        return null;
    }

    private void validateVariableStorageClass(String id, String expected, String classToken) {
        String varStorageClass = HelperTags.parseStorageClass(classToken);
        if (!varStorageClass.equals(expected)) {
            throw new ParsingException("Storage class of variable '%s' " +
                    "does not match the pointer storage class", id);
        }
        if (Tag.Spirv.SC_GENERIC.equals(expected)) {
            throw new ParsingException("Variable '%s' has illegal storage class '%s'", id, classToken);
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
            throw new ParsingException("Invalid result type in access chain '%s', result and base must be pointers", idCtx.getText());
        }
        if (!(base.getType() instanceof ScopedPointerType pType)) {
            throw new ParsingException("Invalid base type in access chain '%s', result and base must be pointers", idCtx.getText());
        }
        if (elCtx == null && idxCtx.isEmpty()) {
            throw new ParsingException("Empty element indexes in access chain '%s'", idCtx.getText());
        }
        LinkedList<Expression> exprIndexes = idxCtx.stream()
                .map(ctx -> builder.getExpression(ctx.getText()))
                .collect(Collectors.toCollection(LinkedList::new));
        if (elCtx == null) {
            exprIndexes.addFirst(expressions.makeZero((IntegerType) exprIndexes.get(0).getType()));
        } else {
            exprIndexes.addFirst(builder.getExpression(elCtx.getText()));
        }
        Expression expression;
        try {
            expression = expressions.makeGetElementPointer(pType.getPointedType(), base, exprIndexes);
        } catch (Exception e) {
            throw new ParsingException("%s in assignment to '%s'", e.getMessage(), idCtx.getText());
        }
            Type memberType = expression.getType();
            if (!TypeFactory.isStaticTypeOf(resultPointerType, memberType)) {
                throw new ParsingException("Invalid result type in access chain '%s', " +
                        "expected '%s' but received '%s'", idCtx.getText(), resultPointerType, memberType);
            }
            builder.addExpression(idCtx.getText(), expression);
            return null;
    }

    private String getStorageClassTag(String id) {
        if (builder.getExpression(id).getType() instanceof ScopedPointerType pType) {
            return pType.getScopeId();
        }
        throw new ParsingException("Expression '%s' is not a pointer", id);
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
