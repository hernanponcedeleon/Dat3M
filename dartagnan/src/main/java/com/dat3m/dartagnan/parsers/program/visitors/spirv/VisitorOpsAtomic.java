package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

import java.util.Set;

import static com.dat3m.dartagnan.program.event.EventFactory.Spirv.*;

public class VisitorOpsAtomic extends SpirvBaseVisitor<Event> {

    private final ProgramBuilder builder;

    public VisitorOpsAtomic(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpAtomicLoad(SpirvParser.OpAtomicLoadContext ctx) {
        Register register = builder.addRegister(ctx.idResult().getText(), ctx.idResultType().getText());
        Expression ptr = builder.getExpression(ctx.pointer().getText());
        String scope = getScopeTag(ctx.memory().getText());
        Set<String> tags = getMemorySemanticsTags(ctx.semantics().getText());
        tags.add(builder.getPointerStorageClass(ctx.pointer().getText()));
        return builder.addEvent(newLoad(register, ptr, scope, tags));
    }

    @Override
    public Event visitOpAtomicStore(SpirvParser.OpAtomicStoreContext ctx) {
        Expression ptr = builder.getExpression(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        String scope = getScopeTag(ctx.memory().getText());
        Set<String> tags = getMemorySemanticsTags(ctx.semantics().getText());
        tags.add(builder.getPointerStorageClass(ctx.pointer().getText()));
        return builder.addEvent(newStore(ptr, value, scope, tags));
    }

    @Override
    public Event visitOpAtomicExchange(SpirvParser.OpAtomicExchangeContext ctx) {
        Register register = builder.addRegister(ctx.idResult().getText(), ctx.idResultType().getText());
        Expression ptr = builder.getExpression(ctx.pointer().getText());
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        String scope = getScopeTag(ctx.memory().getText());
        Set<String> tags = getMemorySemanticsTags(ctx.semantics().getText());
        tags.add(builder.getPointerStorageClass(ctx.pointer().getText()));
        return builder.addEvent(newXchg(register, ptr, value, scope, tags));
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
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.SMAX);
    }

    @Override
    public Event visitOpAtomicSMin(SpirvParser.OpAtomicSMinContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.SMIN);
    }

    @Override
    public Event visitOpAtomicUMax(SpirvParser.OpAtomicUMaxContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.UMAX);
    }

    @Override
    public Event visitOpAtomicUMin(SpirvParser.OpAtomicUMinContext ctx) {
        return visitAtomicOp(ctx.idResult(), ctx.idResultType(), ctx.pointer(),
                ctx.memory(), ctx.semantics(), ctx.valueIdRef(), IntBinaryOp.UMIN);
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
        Expression ptr = builder.getExpression(ptrCtx.getText());
        String scope = getScopeTag(scopeCtx.getText());
        Set<String> eqTags = getMemorySemanticsTags(eqCtx.getText());

        eqTags.add(builder.getPointerStorageClass(ptrCtx.getText()));

        Set<String> neqTags = getMemorySemanticsTags(neqCtx.getText());
        neqTags.add(builder.getPointerStorageClass(ptrCtx.getText()));
        Expression value = builder.getExpression(valCtx.getText());
        Expression cmp = builder.getExpression(cmpCtx.getText());
        return builder.addEvent(newCmpXchg(register, ptr, cmp, value, scope, eqTags, neqTags));
    }

    private Event visitAtomicOpIncDec(
            SpirvParser.IdResultContext idCtx,
            SpirvParser.IdResultTypeContext typeCtx,
            SpirvParser.PointerContext ptrCtx,
            SpirvParser.MemoryContext scopeCtx,
            SpirvParser.SemanticsContext tagsCtx,
            IntBinaryOp op
    ) {
        String typeId = typeCtx.getText();
        Type type = builder.getType(typeId);
        if (type instanceof IntegerType iType) {
            Expression value = ExpressionFactory.getInstance().makeOne(iType);
            return visitAtomicOp(idCtx, typeCtx, ptrCtx, scopeCtx, tagsCtx, value, op);
        }
        throw new ParsingException("Unexpected type at '%s', expected integer but received '%s'", typeId, type);
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
        Expression ptr = builder.getExpression(ptrCtx.getText());
        String scope = getScopeTag(scopeCtx.getText());
        Set<String> tags = getMemorySemanticsTags(tagsCtx.getText());
        tags.add(builder.getPointerStorageClass(ptrCtx.getText()));
        return builder.addEvent(newRmw(register, ptr, op, value, scope, tags));
    }

    private String getScopeTag(String scopeId) {
        return HelperTags.parseScope(scopeId, builder.getExpression(scopeId));
    }

    private Set<String> getMemorySemanticsTags(String semanticsId) {
        return HelperTags.parseMemorySemanticsTags(semanticsId, builder.getExpression(semanticsId));
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
