package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.lang.spirv.*;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.Spirv.*;

public class VisitorOpsAtomic extends SpirvBaseVisitor<Event> {

    private static final TypeFactory TYPE_FACTORY = TypeFactory.getInstance();
    private final ProgramBuilderSpv builder;

    public VisitorOpsAtomic(ProgramBuilderSpv builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpAtomicLoad(SpirvParser.OpAtomicLoadContext ctx) {
        Register register = builder.addRegister(ctx.idResult().getText(), ctx.idResultType().getText());
        Expression ptr = getPointer(ctx.pointer().getText());
        String scope = builder.getScope(ctx.memory().getText());
        Set<String> tags = builder.getSemantics(ctx.semantics().getText());
        tags.add(builder.getExpressionStorageClass(ctx.pointer().getText()));
        SpirvLoad event = newSpirvLoad(register, ptr, scope, tags);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpAtomicStore(SpirvParser.OpAtomicStoreContext ctx) {
        Expression ptr = getPointer(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        String scope = builder.getScope(ctx.memory().getText());
        Set<String> tags = builder.getSemantics(ctx.semantics().getText());
        tags.add(builder.getExpressionStorageClass(ctx.pointer().getText()));
        SpirvStore event = newSpirvStore(ptr, value, scope, tags);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpAtomicExchange(SpirvParser.OpAtomicExchangeContext ctx) {
        Register register = builder.addRegister(ctx.idResult().getText(), ctx.idResultType().getText());
        Expression ptr = getPointer(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        String scope = builder.getScope(ctx.memory().getText());
        Set<String> tags = builder.getSemantics(ctx.semantics().getText());
        tags.add(builder.getExpressionStorageClass(ctx.pointer().getText()));
        SpirvXchg event = newSpirvXchg(register, ptr, value, scope, tags);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpAtomicCompareExchange(SpirvParser.OpAtomicCompareExchangeContext ctx) {
        return visitOpAtomicCompareExchange(ctx.idResult(), ctx.idResultType(),
                ctx.pointer(), ctx.memory(), ctx.equal(), ctx.unequal(), ctx.valueIdRef(), ctx.comparator());
    }

    @Override
    public Event visitOpAtomicCompareExchangeWeak(SpirvParser.OpAtomicCompareExchangeWeakContext ctx) {
        // OpAtomicCompareExchangeWeak is deprecated and has the same semantics as OpAtomicCompareExchange
        return visitOpAtomicCompareExchange(ctx.idResult(), ctx.idResultType(),
                ctx.pointer(), ctx.memory(), ctx.equal(), ctx.unequal(), ctx.valueIdRef(), ctx.comparator());
    }

    @Override
    public Event visitOpAtomicIIncrement(SpirvParser.OpAtomicIIncrementContext ctx) {
        return visitAtomicOpIncDec(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), IntBinaryOp.ADD);
    }

    @Override
    public Event visitOpAtomicIDecrement(SpirvParser.OpAtomicIDecrementContext ctx) {
        return visitAtomicOpIncDec(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), IntBinaryOp.SUB);
    }

    @Override
    public Event visitOpAtomicIAdd(SpirvParser.OpAtomicIAddContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.ADD);
    }

    @Override
    public Event visitOpAtomicISub(SpirvParser.OpAtomicISubContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.SUB);
    }

    @Override
    public Event visitOpAtomicAnd(SpirvParser.OpAtomicAndContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.AND);
    }

    @Override
    public Event visitOpAtomicOr(SpirvParser.OpAtomicOrContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.OR);
    }

    @Override
    public Event visitOpAtomicXor(SpirvParser.OpAtomicXorContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.XOR);
    }

    @Override
    public Event visitOpAtomicSMax(SpirvParser.OpAtomicSMaxContext ctx) {
        return visitOpAtomicExtremum(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntCmpOp.GT);
    }

    @Override
    public Event visitOpAtomicSMin(SpirvParser.OpAtomicSMinContext ctx) {
        return visitOpAtomicExtremum(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntCmpOp.LT);
    }

    private Event visitOpAtomicExtremum(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.PointerContext ptrCtx,
            SpirvParser.MemoryContext scopeCtx,
            SpirvParser.SemanticsContext tagsCtx,
            SpirvParser.ValueIdRefContext valCtx,
            IntCmpOp kind
    ) {
        Register register = builder.addRegister(idCtx.getText(), typeCtx.getText());
        Expression ptr = getPointer(ptrCtx.getText());
        Expression value = builder.getExpression(valCtx.getText());
        String scope = builder.getScope(scopeCtx.getText());
        Set<String> tags = builder.getSemantics(tagsCtx.getText());
        tags.add(builder.getExpressionStorageClass(ptrCtx.getText()));
        if (!(ptr.getType() instanceof IntegerType) || !(value.getType() instanceof IntegerType)) {
            throw new ParsingException("Unexpected type at '%s' or '%s', expected integer but received '%s' and '%s'",
                    ptrCtx.getText(), valCtx.getText(), ptr.getType(), value.getType());
        }
        SpirvRmwExtremum event = newSpirvRmwExtremum(register, ptr, kind, value, scope, tags);
        return builder.addEvent(event);
    }

    private Event visitOpAtomicCompareExchange(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.PointerContext ptrCtx,
            SpirvParser.MemoryContext scopeCtx,
            SpirvParser.EqualContext eqCtx,
            SpirvParser.UnequalContext neqCtx,
            SpirvParser.ValueIdRefContext valCtx,
            SpirvParser.ComparatorContext cmpCtx
    ) {
        Register register = builder.addRegister(idCtx.getText(), typeCtx.getText());
        Expression ptr = getPointer(ptrCtx.getText());
        String scope = builder.getScope(scopeCtx.getText());
        Set<String> eqTags = builder.getSemantics(eqCtx.getText());

        eqTags.add(builder.getExpressionStorageClass(ptrCtx.getText()));

        Set<String> neqTags = builder.getSemantics(neqCtx.getText());
        neqTags.add(builder.getExpressionStorageClass(ptrCtx.getText()));
        Expression value = builder.getExpression(valCtx.getText());
        Expression cmp = builder.getExpression(cmpCtx.getText());
        SpirvCmpXchg event = newSpirvCmpXchg(register, ptr, cmp, value, scope, eqTags, neqTags);
        return builder.addEvent(event);
    }

    private Event visitAtomicOpIncDec(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.PointerContext ptrCtx,
            SpirvParser.MemoryContext scopeCtx,
            SpirvParser.SemanticsContext tagsCtx,
            IntBinaryOp op
    ) {
        IntegerType type = getIntegerType(typeCtx.getText());
        Expression value = ExpressionFactory.getInstance().makeOne(type);
        return visitAtomicOp(idCtx, typeCtx, ptrCtx, scopeCtx, tagsCtx, value, op);
    }

    private Event visitAtomicOp(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.PointerContext ptrCtx,
            SpirvParser.MemoryContext scopeCtx,
            SpirvParser.SemanticsContext tagsCtx,
            SpirvParser.ValueIdRefContext valCtx,
            IntBinaryOp op
    ) {
        Expression value = builder.getExpression(valCtx.getText());
        return visitAtomicOp(idCtx, typeCtx, ptrCtx, scopeCtx, tagsCtx, value, op);
    }

    private Event visitAtomicOp(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.PointerContext ptrCtx,
            SpirvParser.MemoryContext scopeCtx,
            SpirvParser.SemanticsContext tagsCtx,
            Expression value,
            IntBinaryOp op
    ) {
        Register register = builder.addRegister(idCtx.getText(), typeCtx.getText());
        Expression ptr = getPointer(ptrCtx.getText());
        String scope = builder.getScope(scopeCtx.getText());
        Set<String> tags = builder.getSemantics(tagsCtx.getText());
        tags.add(builder.getExpressionStorageClass(ptrCtx.getText()));
        SpirvRmw event = newSpirvRmw(register, ptr, op, value, scope, tags);
        return builder.addEvent(event);
    }

    private IntegerType getIntegerType(String typeId) {
        Type type = builder.getType(typeId);
        if (type instanceof IntegerType iType) {
            return iType;
        }
        throw new ParsingException("Unexpected type at '%s', expected integer but received '%s'", typeId, type);
    }

    private Expression getPointer(String ptrId) {
        Expression expression = builder.getExpression(ptrId);
        Type type = expression.getType();
        if (TYPE_FACTORY.isPointerType(type)) {
            return expression;
        }
        throw new ParsingException("Unexpected type at '%s', expected pointer but received '%s'", ptrId, type);
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpAtomicLoad",
                "OpAtomicStore",
                "OpAtomicExchange",
                "OpAtomicCompareExchange",
                "OpAtomicCompareExchangeWeak",
                "OpAtomicIAdd",
                "OpAtomicISub",
                "OpAtomicIIncrement",
                "OpAtomicIDecrement",
                "OpAtomicAnd",
                "OpAtomicOr",
                "OpAtomicXor",
                "OpAtomicSMax",
                "OpAtomicSMin"
        );
    }
}
