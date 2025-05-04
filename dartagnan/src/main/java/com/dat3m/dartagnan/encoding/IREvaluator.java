package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.smt.ModelExt;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.Formula;

import java.math.BigInteger;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static java.lang.Boolean.FALSE;
import static java.lang.Boolean.TRUE;

public class IREvaluator {

    private final EncodingContext ctx;
    private final ExpressionEncoder exprEnc;
    private final ModelExt smtModel;

    public IREvaluator(EncodingContext ctx, ModelExt smtModel) {
        this.ctx = ctx;
        this.exprEnc = ctx.getExpressionEncoder();
        this.smtModel = smtModel;
    }

    public ModelExt getSMTModel() { return smtModel; }

    // ====================================================================================
    // General

    public <TType extends Type, TFormula extends Formula> TypedValue<TType, ?> evaluate(TypedFormula<TType, TFormula> typedFormula) {
        return new TypedValue<>(typedFormula.getType(), smtModel.evaluate(typedFormula.formula()));
    }

    @SuppressWarnings("unchecked")
    public TypedValue<BooleanType, Boolean> evaluateBooleanAt(Expression expression, Event at) {
        Preconditions.checkArgument(expression.getType() instanceof BooleanType);
        return (TypedValue<BooleanType, Boolean>) evaluateAt(expression, at);
    }

    public TypedValue<?, ?> evaluateAt(Expression expression, Event at) {
        return evaluate(exprEnc.encodeAt(expression, at));
    }

    // ====================================================================================
    // Program

    public boolean isExecuted(Event e) {
        return TRUE.equals(smtModel.evaluate(ctx.execution(e)));
    }

    public boolean jumpTaken(CondJump jump) {
        return TRUE.equals(smtModel.evaluate(ctx.jumpTaken(jump)));
    }

    public boolean isBlocked(BlockingEvent barrier) {
        return TRUE.equals(smtModel.evaluate(ctx.blocked(barrier)));
    }

    public boolean isAllocated(MemoryObject memObj) {
        return memObj.isStaticallyAllocated() || isExecuted(memObj.getAllocationSite());
    }

    public TypedValue<?, ?> value(MemoryCoreEvent e) {
        return evaluateAt(ctx.value(e), e);
    }

    public TypedValue<?, ?> address(MemoryCoreEvent e) {
        return evaluateAt(ctx.address(e), e);
    }

    public TypedValue<?, ?> address(MemoryObject e) {
        return evaluate(ctx.address(e));
    }

    public TypedValue<?, ?> result(RegWriter writer) {
        return evaluate(ctx.result(writer));
    }

    @SuppressWarnings("unchecked")
    public TypedValue<IntegerType, BigInteger> size(MemoryObject memoryObject) {
        return (TypedValue<IntegerType, BigInteger>) evaluate(ctx.size(memoryObject));
    }

    // ====================================================================================
    // Memory Model

    public boolean hasEdge(Relation rel, Event a, Event b) {
        return TRUE.equals(smtModel.evaluate(ctx.edge(rel, a, b)));
    }

    public boolean hasEdge(EncodingContext.EdgeEncoder edgeEncoder, Event a, Event b) {
        return TRUE.equals(smtModel.evaluate(edgeEncoder.encode(a, b)));
    }

    public BigInteger memoryOrderClock(Event write) {
        return smtModel.evaluate(ctx.memoryOrderClock(write));
    }

    // ====================================================================================
    // Properties

    public boolean propertyViolated(Property property) {
        return FALSE.equals(smtModel.evaluate(property.getSMTVariable(ctx)));
    }

    public boolean propertySatisfied(Property property) {
        return TRUE.equals(smtModel.evaluate(property.getSMTVariable(ctx)));
    }

    public boolean isFlaggedAxiomViolated(Axiom axiom) {
        Preconditions.checkArgument(axiom.isFlagged());
        return FALSE.equals(smtModel.evaluate(CAT_SPEC.getSMTVariable(axiom, ctx)));
    }

    public boolean assertionViolated(Assert event) {
        return isExecuted(event) && FALSE.equals(evaluateBooleanAt(event.getExpression(), event).value());
    }

}
