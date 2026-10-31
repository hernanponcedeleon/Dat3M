package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.BlockingEvent;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Assert;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.MemoryCoreEvent;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.smt.ModelExt;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.utils.graph.EventGraph;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.Evaluator;

import java.math.BigInteger;

import static com.dat3m.dartagnan.configuration.Property.CAT_SPEC;
import static java.lang.Boolean.FALSE;
import static java.lang.Boolean.TRUE;

public class IREvaluator implements AutoCloseable {

    private final EncodingContext ctx;
    private final ExpressionEncoder exprEnc;
    private final ModelExt smtModel;

    IREvaluator(EncodingContext ctx, Evaluator smtModel) {
        this.ctx = ctx;
        this.exprEnc = ctx.getExpressionEncoder();
        this.smtModel = new ModelExt(smtModel);
    }

    public EncodingContext getEncodingContext() { return ctx; }

    public ModelExt getSMTModel() { return smtModel; }

    // ====================================================================================
    // General

    // NOTE: Values left unconstrained by the model are reported as zero.
    public Expression evaluate(TypedFormula<?, ?> typedFormula) {
        final Object smtValue = smtModel.evaluate(typedFormula.formula());
        return smtValue == null
                ? ExpressionFactory.getInstance().makeGeneralZero(typedFormula.getType())
                : ExpressionDecoder.decode(typedFormula.getType(), smtValue);
    }

    public boolean evaluateBooleanAt(Expression expression, Event at) {
        Preconditions.checkArgument(expression.getType() instanceof BooleanType);
        return ((BoolLiteral) evaluateAt(expression, at)).getValue();
    }

    public Expression evaluateAt(Expression expression, Event at) {
        return evaluate(exprEnc.encodeAt(expression, at));
    }

    public Expression evaluateFinal(Expression expression) {
        return evaluate(exprEnc.encodeFinal(expression));
    }

    // ====================================================================================
    // Program

    public boolean threadHasStarted(Thread thread) {
        return isExecuted(thread.getEntry());
    }

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

    public Expression value(MemoryCoreEvent e) {
        return evaluateAt(ctx.value(e), e);
    }

    public Expression address(MemoryCoreEvent e) {
        return evaluateAt(ctx.address(e), e);
    }

    public Expression address(MemoryObject e) {
        return evaluate(ctx.address(e));
    }

    public Expression result(RegWriter writer) {
        return evaluate(ctx.result(writer));
    }

    public IntLiteral size(MemoryObject memoryObject) {
        return ((IntLiteral) evaluate(ctx.size(memoryObject)));
    }

    public boolean isLeaked(MemoryObject object) {
        return object.isHeapAllocated() && TRUE.equals(smtModel.evaluate(ctx.leakVariable(object)));
    }

    public boolean isTrackable(MemoryObject object) {
        return object.isHeapAllocated() && TRUE.equals(smtModel.evaluate(ctx.trackVariable(object)));
    }

    // ====================================================================================
    // Memory Model

    public boolean hasElement(Relation rel, Event a) {
        Preconditions.checkArgument(rel.isSet(), "Non-unary relation %s", rel);
        return TRUE.equals(smtModel.evaluate(ctx.edge(rel, a, a)));
    }

    public boolean hasElement(EncodingContext.EdgeEncoder edgeEncoder, Event a) {
        return TRUE.equals(smtModel.evaluate(edgeEncoder.encode(a, a)));
    }

    public boolean hasEdge(Relation rel, Event a, Event b) {
        Preconditions.checkArgument(rel.isRelation(), "Non-binary relation %s", rel);
        return TRUE.equals(smtModel.evaluate(ctx.edge(rel, a, b)));
    }

    public boolean hasEdge(EncodingContext.EdgeEncoder edgeEncoder, Event a, Event b) {
        return TRUE.equals(smtModel.evaluate(edgeEncoder.encode(a, b)));
    }

    public BigInteger clock(String name, Event e) {
        return smtModel.evaluate(ctx.clockVariable(name, e));
    }

    public EventGraph eventGraph(Relation relation) {
        final EventGraph may = ctx.getAnalysisContext().get(RelationAnalysis.class).getKnowledge(relation).getMaySet();
        final EncodingContext.EdgeEncoder encoder = ctx.edge(relation);
        return may.filter((x, y) -> hasEdge(encoder, x, y));
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
        return isExecuted(event) && !evaluateBooleanAt(event.getExpression(), event);
    }

    // ====================================================================================
    // Overrides

    @Override
    public void close() {
        smtModel.close();
    }
}
