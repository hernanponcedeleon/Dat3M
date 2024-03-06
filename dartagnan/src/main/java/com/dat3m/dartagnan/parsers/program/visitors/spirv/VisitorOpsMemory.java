package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.List;
import java.util.Set;

public class VisitorOpsMemory extends SpirvBaseVisitor<Expression> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private static final ExpressionFactory EXPR_FACTORY = ExpressionFactory.getInstance();

    private final ProgramBuilderSpv builder;

    public VisitorOpsMemory(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Expression visitOpStore(SpirvParser.OpStoreContext ctx) {
        // TODO: Handle memoryAccess
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Expression object = builder.getExpression(ctx.object().getText());
        Store store = new Store(pointer, object);
        builder.addEvent(store);
        return null;
    }

    @Override
    public Expression visitOpLoad(SpirvParser.OpLoadContext ctx) {
        // TODO: Handle memoryAccess
        String id = ctx.idResult().getText();
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        Expression pointer = builder.getExpression(ctx.pointer().getText());
        Load load = new Load(register, pointer);
        builder.addEvent(load);
        return null;
    }

    @Override
    public Expression visitOpVariable(SpirvParser.OpVariableContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getPointedType(ctx.idResultType().getText());
        int bytes = TYPE_FACTORY.getMemorySizeInBytes(type);
        MemoryObject memObj = builder.allocateMemory(bytes);
        memObj.setCVar(id);
        builder.addExpression(id, memObj);

        // TODO: Proper storage class enum and handling
        //  Function should be copied for each function
        //  handle scopes
        if (ctx.storageClass().Input() != null
                || ctx.storageClass().Private() != null
                || ctx.storageClass().Function() != null) {
            memObj.setIsThreadLocal(true);
        }

        if (ctx.initializer() != null) {
            Expression constant = builder.getExpression(ctx.initializer().getText());
            setInitialValue(memObj, 0, constant);
        }
        //builder.addVariable(id, memObj);
        return null;
    }

    @Override
    public Expression visitOpAccessChain(SpirvParser.OpAccessChainContext ctx) {
        return visitOpAccessChain(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.indexesIdRef());
    }

    @Override
    public Expression visitOpInBoundsAccessChain(SpirvParser.OpInBoundsAccessChainContext ctx) {
        return visitOpAccessChain(ctx.idResult().getText(), ctx.idResultType().getText(),
                ctx.base().getText(), ctx.indexesIdRef());
    }

    private Expression visitOpAccessChain(String id, String typeId, String baseId,
                                          List<SpirvParser.IndexesIdRefContext> idxContexts) {
        Type type = builder.getPointedType(typeId);
        Expression base = builder.getExpression(baseId);
        List<Expression> indexes = idxContexts.stream()
                .map(c -> builder.getExpression(c.getText()))
                .toList();
        IExprBin expression = EXPR_FACTORY.makeBinary(base, IOpBin.ADD, getMemberPtr(type, indexes));
        builder.addExpression(id, expression);
        return expression;
    }

    private IExprBin getMemberPtr(Type type, List<Expression> indexes) {
        if (type instanceof ArrayType arrayType) {
            Type elemType = arrayType.getElementType();
            int size = TYPE_FACTORY.getMemorySizeInBytes(elemType);
            IValue sizeExpr = EXPR_FACTORY.makeValue(size, TYPE_FACTORY.getArchType());
            IExprBin offsetExpr = EXPR_FACTORY.makeBinary(sizeExpr, IOpBin.MUL, indexes.get(0));
            if (indexes.size() > 1) {
                IExprBin remOffsetExpr = getMemberPtr(elemType, indexes.subList(1, indexes.size()));
                return EXPR_FACTORY.makeBinary(offsetExpr, IOpBin.ADD, remOffsetExpr);
            }
            return offsetExpr;
        } else if (type instanceof AggregateType) {
            throw new UnsupportedOperationException("Not implemented");
        } else {
            // TODO: ParsingException
            throw new UnsupportedOperationException("Referring to a member of a primitive type");
        }
    }

    private void setInitialValue(MemoryObject memObj, int offset, Expression constant) {
        if (constant.getType() instanceof ArrayType arrayType) {
            assert constant instanceof Construction;
            final Construction constArray = (Construction) constant;
            final List<Expression> arrayElements = constArray.getArguments();
            final int stepSize = TYPE_FACTORY.getMemorySizeInBytes(arrayType.getElementType());
            for (int i = 0; i < arrayElements.size(); i++) {
                setInitialValue(memObj, offset + i * stepSize, arrayElements.get(i));
            }
        } else if (constant.getType() instanceof AggregateType) {
            assert constant instanceof Construction;
            final Construction constStruct = (Construction) constant;
            final List<Expression> structElements = constStruct.getArguments();
            int currentOffset = offset;
            for (Expression structElement : structElements) {
                setInitialValue(memObj, currentOffset, structElement);
                currentOffset += TYPE_FACTORY.getMemorySizeInBytes(structElement.getType());
            }
        } else if (constant.getType() instanceof IntegerType) {
            memObj.setInitialValue(offset, constant);
        } else {
            // TODO: ParsingException
            throw new UnsupportedOperationException("Unrecognized constant value: " + constant);
        }
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
