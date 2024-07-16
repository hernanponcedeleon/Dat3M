package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.misc.ConstructExpr;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.BuiltIn;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.decorations.DecorationType;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperCompositeTypes;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperInput;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.memory.ScopedPointer;
import com.dat3m.dartagnan.program.memory.ScopedPointerVariable;
import com.dat3m.dartagnan.expression.type.ScopedPointerType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class VisitorOpsMemory extends SpirvBaseVisitor<Event> {

    private static final TypeFactory types = TypeFactory.getInstance();
    private final ProgramBuilder builder;
    private final BuiltIn builtInDecorator;

    public VisitorOpsMemory(ProgramBuilder builder) {
        this.builder = builder;
        this.builtInDecorator = (BuiltIn) builder.getDecoration(DecorationType.BUILT_IN);
    }

    @Override
    public Event visitOpStore(SpirvParser.OpStoreContext ctx) {
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.object().getText());
        Event event = EventFactory.newStore(pointer, value);
        Set<String> tags = parseMemoryAccessTags(ctx.memoryAccess());
        if (!tags.contains(Tag.Spirv.MEM_VISIBLE)) {
            String storageClass = builder.getExpressionStorageClass(ctx.pointer().getText());
            String scope = getScope(storageClass);
            event.addTags(tags);
            event.addTags(storageClass);
            if (scope != null) {
                event.addTags(Tag.Spirv.MEM_NON_PRIVATE);
                event.addTags(scope);
            }
            return builder.addEvent(event);
        }
        throw new ParsingException("OpStore cannot contain tag '%s'", Tag.Spirv.MEM_VISIBLE);
    }

    @Override
    public Event visitOpLoad(SpirvParser.OpLoadContext ctx) {
        Register register = builder.addRegister(ctx.idResult().getText(), ctx.idResultType().getText());
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Event event = EventFactory.newLoad(register, pointer);
        Set<String> tags = parseMemoryAccessTags(ctx.memoryAccess());
        if (!tags.contains(Tag.Spirv.MEM_AVAILABLE)) {
            String storageClass = builder.getExpressionStorageClass(ctx.pointer().getText());
            String scope = getScope(storageClass);
            event.addTags(tags);
            event.addTags(storageClass);
            if (scope != null) {
                event.addTags(Tag.Spirv.MEM_NON_PRIVATE);
                event.addTags(scope);
            }
            return builder.addEvent(event);
        }
        throw new ParsingException("OpLoad cannot contain tag '%s'", Tag.Spirv.MEM_AVAILABLE);
    }

    @Override
    public Event visitOpVariable(SpirvParser.OpVariableContext ctx) {
        String id = ctx.idResult().getText();
        String typeId = ctx.idResultType().getText();
        if (builder.getType(typeId) instanceof ScopedPointerType pType) {
            Type type = pType.getPointedType();
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
                value = builder.newUndefinedValue(type);
            }
            int size = types.getMemorySizeInBytes(type);
            ScopedPointerVariable pointer = builder.allocateMemoryVirtual(id, typeId, type, size);
            setInitialValue(pointer, 0, value);
            validateVariableStorageClass(pointer, ctx.storageClass().getText());
            builder.addExpression(id, pointer);
            return null;
        }
        throw new ParsingException("Type '%s' is not a pointer type", typeId);
    }

    private Expression getOpVariableInitialValue(SpirvParser.OpVariableContext ctx, Type type) {
        String id = ctx.idResult().getText();
        if (builder.hasInput(id)) {
            if (builtInDecorator.hasDecoration(id) || ctx.initializer() != null) {
                throw new ParsingException("The original value of variable '%s' " +
                        "cannot be overwritten by an external input", id);
            }
            return HelperInput.castInput(id, type, builder.getInput(id));
        }
        if (builtInDecorator.hasDecoration(id)) {
            if (ctx.initializer() != null) {
                throw new ParsingException("The original value of variable '%s' " +
                        "cannot be overwritten by a decoration", id);
            }
            return builtInDecorator.getDecoration(id, type);
        }
        if (ctx.initializer() != null) {
            return builder.getExpression(ctx.initializer().getText());
        }
        return null;
    }

    private void setInitialValue(ScopedPointerVariable pointer, int offset, Expression value) {
        if (value.getType() instanceof ArrayType aType) {
            ConstructExpr cValue = (ConstructExpr) value;
            List<Expression> elements = cValue.getOperands();
            int step = types.getMemorySizeInBytes(aType.getElementType());
            for (int i = 0; i < elements.size(); i++) {
                setInitialValue(pointer, offset + i * step, elements.get(i));
            }
        } else if (value.getType() instanceof AggregateType) {
            ConstructExpr cValue = (ConstructExpr) value;
            final List<Expression> elements = cValue.getOperands();
            int currentOffset = offset;
            for (Expression element : elements) {
                setInitialValue(pointer, currentOffset, element);
                currentOffset += types.getMemorySizeInBytes(element.getType());
            }
        } else if (value.getType() instanceof IntegerType) {
            pointer.setInitialValue(offset, value);
        } else if (value.getType() instanceof BooleanType) {
            pointer.setInitialValue(offset, value);
        } else {
            throw new ParsingException("Illegal variable value type '%s'", value.getType());
        }
    }

    private void validateVariableStorageClass(ScopedPointerVariable pointer, String classToken) {
        String ptrStorageClass = pointer.getScopeId();
        String varStorageClass = builder.getStorageClass(classToken);
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

    private void visitOpAccessChain(String id, String typeId, String baseId,
                                    List<SpirvParser.IndexesIdRefContext> idxContexts) {
        if (builder.getType(typeId) instanceof ScopedPointerType pointerType) {
            ScopedPointer base = (ScopedPointer) builder.getExpression(baseId);
            Type baseType = base.getInnerType();
            Type resultType = pointerType.getPointedType();
            List<Integer> intIndexes = new ArrayList<>();
            List<Expression> exprIndexes = new ArrayList<>();
            idxContexts.forEach(c -> {
                Expression expression = builder.getExpression(c.getText());
                exprIndexes.add(expression);
                intIndexes.add(expression instanceof IntLiteral intLiteral ? intLiteral.getValueAsInt() : -1);
            });
            Type exactResultType = HelperCompositeTypes.getMemberType(baseId, baseType, intIndexes);
            if (!TypeFactory.isStaticTypeOf(exactResultType, resultType)) {
                throw new ParsingException("Invalid result type in access chain '%s', " +
                        "expected '%s' but received '%s'", id, resultType, exactResultType);
            }
            Expression expression = HelperCompositeTypes.getMemberAddress(baseId, base, baseType, exprIndexes);
            ScopedPointer pointer = new ScopedPointer(id, pointerType.getScopeId(), exactResultType, expression);
            builder.addExpression(id, pointer);
            return;
        }
        throw new ParsingException("Type '%s' is not a pointer type", typeId);
    }

    private Set<String> parseMemoryAccessTags(SpirvParser.MemoryAccessContext ctx) {
        if (ctx == null || ctx.None() != null) {
            return Set.of();
        }
        if (ctx.Volatile() != null) {
            return Set.of(Tag.Spirv.MEM_VOLATILE);
        }
        if (ctx.Nontemporal() != null) {
            return Set.of(Tag.Spirv.MEM_NON_TEMPORAL);
        }
        if (ctx.NonPrivatePointer() != null || ctx.NonPrivatePointerKHR() != null) {
            return Set.of(Tag.Spirv.MEM_NON_PRIVATE);
        }
        if (ctx.idScope() != null) {
            Set<String> tags = new HashSet<>();
            tags.add(builder.getScope(ctx.idScope().getText()));
            tags.add(Tag.Spirv.MEM_NON_PRIVATE);
            if (ctx.MakePointerAvailable() != null || ctx.MakePointerAvailableKHR() != null) {
                tags.add(Tag.Spirv.MEM_AVAILABLE);
            }
            if (ctx.MakePointerVisible() != null || ctx.MakePointerVisibleKHR() != null) {
                tags.add(Tag.Spirv.MEM_VISIBLE);
            }
            return tags;
        }
        throw new ParsingException("Unsupported memory access tag '%s'",
                String.join(" ", ctx.children.stream().map(ParseTree::getText).toList()));
    }

    private String getScope(String storageClass) {
        return switch (storageClass) {
            case Tag.Spirv.SC_UNIFORM_CONSTANT,
                    Tag.Spirv.SC_UNIFORM,
                    Tag.Spirv.SC_OUTPUT,
                    Tag.Spirv.SC_PUSH_CONSTANT,
                    Tag.Spirv.SC_STORAGE_BUFFER,
                    Tag.Spirv.SC_PHYS_STORAGE_BUFFER -> Tag.Spirv.DEVICE;
            case Tag.Spirv.SC_PRIVATE,
                    Tag.Spirv.SC_FUNCTION,
                    Tag.Spirv.SC_INPUT -> null;
            case Tag.Spirv.SC_WORKGROUP -> Tag.Spirv.WORKGROUP;
            case Tag.Spirv.SC_CROSS_WORKGROUP -> Tag.Spirv.QUEUE_FAMILY;
            default -> throw new UnsupportedOperationException(
                    "Unsupported storage class " + storageClass);
        };
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
