package com.dat3m.dartagnan.parsers.program.visitors.spirv;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.SpirvBaseVisitor;
import com.dat3m.dartagnan.parsers.SpirvParser;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.helpers.HelperTags;
import com.dat3m.dartagnan.parsers.program.visitors.spirv.builders.ProgramBuilder;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.tangles.TangleType;
import com.dat3m.dartagnan.expression.tangles.GroupOp;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.Register;
import java.util.Set;
import java.util.Arrays;

import static com.dat3m.dartagnan.expression.utils.ExpressionHelper.isScalar;

public class VisitorOpsNonUniform extends SpirvBaseVisitor<Event> {

    private final ProgramBuilder builder;
    private int nextOpId = 0;

    public VisitorOpsNonUniform(ProgramBuilder builder) {
        this.builder = builder;
    }

    @Override
    public Event visitOpGroupNonUniformAll(SpirvParser.OpGroupNonUniformAllContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof BooleanType)) {
            throw new ParsingException("Return type %s of OpGroupNonUniformAll '%s' is not bool", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.predicate().getText());
        if (!(value.getType() instanceof BooleanType)) {
            throw new ParsingException("Predicate type %s of OpGroupNonUniformAll '%s' is not bool", value.getType(), id);
        }
        Event event = EventFactory.newNonUniformOpAll(Integer.toString(nextOpId++), execScope, register, value);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformAny(SpirvParser.OpGroupNonUniformAnyContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof BooleanType)) {
            throw new ParsingException("Return type %s of OpGroupNonUniformAny '%s' is not bool", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.predicate().getText());
        if (!(value.getType() instanceof BooleanType)) {
            throw new ParsingException("Predicate type %s of OpGroupNonUniformAny '%s' is not bool", value.getType(), id);
        }
        Event event = EventFactory.newNonUniformOpAny(Integer.toString(nextOpId++), execScope, register, value);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformIAdd(SpirvParser.OpGroupNonUniformIAddContext ctx) {
        String id = ctx.idResult().getText();
        GroupOp operation = getGroupOperation(ctx.operation());
        if (!operation.isSupported()) {
            throw new ParsingException("Operation %s of OpGroupNonUniformIAdd '%s' is not yet supported", operation, id);
        }
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof IntegerType || (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformIAdd '%s' is not scalar or vector of integer", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformIAdd '%s' between result type and value", id);
        }
        Event event = EventFactory.newNonUniformOpIAdd(Integer.toString(nextOpId++), execScope, register, value, operation);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformIMul(SpirvParser.OpGroupNonUniformIMulContext ctx) {
        String id = ctx.idResult().getText();
        GroupOp operation = getGroupOperation(ctx.operation());
        if (!operation.isSupported()) {
            throw new ParsingException("Operation %s of OpGroupNonUniformIAdd '%s' is not yet supported", operation, id);
        }
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof IntegerType || (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformIMul '%s' is not scalar or vector of integer", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformIMul '%s' between result type and value", id);
        }
        Event event = EventFactory.newNonUniformOpIMul(Integer.toString(nextOpId++), execScope, register, value, operation);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformBitwiseAnd(SpirvParser.OpGroupNonUniformBitwiseAndContext ctx) {
        String id = ctx.idResult().getText();
        GroupOp operation = getGroupOperation(ctx.operation());
        if (!operation.isSupported()) {
            throw new ParsingException("Operation %s of OpGroupNonUniformIAdd '%s' is not yet supported", operation, id);
        }
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof IntegerType || (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformBitwiseAnd '%s' is not scalar or vector of integer", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformBitwiseAnd '%s' between result type and value", id);
        }
        Event event = EventFactory.newNonUniformOpIAnd(Integer.toString(nextOpId++), execScope, register, value, operation);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformBitwiseOr(SpirvParser.OpGroupNonUniformBitwiseOrContext ctx) {
        String id = ctx.idResult().getText();
        GroupOp operation = getGroupOperation(ctx.operation());
        if (!operation.isSupported()) {
            throw new ParsingException("Operation %s of OpGroupNonUniformIAdd '%s' is not yet supported", operation, id);
        }
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof IntegerType || (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformBitwiseOr '%s' is not scalar or vector of integer", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformBitwiseOr '%s' between result type and value", id);
        }
        Event event = EventFactory.newNonUniformOpIOr(Integer.toString(nextOpId++), execScope, register, value, operation);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformBitwiseXor(SpirvParser.OpGroupNonUniformBitwiseXorContext ctx) {
        String id = ctx.idResult().getText();
        GroupOp operation = getGroupOperation(ctx.operation());
        if (!operation.isSupported()) {
            throw new ParsingException("Operation %s of OpGroupNonUniformIAdd '%s' is not yet supported", operation, id);
        }
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof IntegerType || (type instanceof ArrayType aType && aType.getElementType() instanceof IntegerType))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformBitwiseXor '%s' is not scalar or vector of integer", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformBitwiseXor '%s' between result type and value", id);
        }
        Event event = EventFactory.newNonUniformOpIXor(Integer.toString(nextOpId++), execScope, register, value, operation);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformBroadcast(SpirvParser.OpGroupNonUniformBroadcastContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(isScalar(type) || (type instanceof ArrayType aType && isScalar(aType.getElementType())))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformBroadcast '%s' is not scalar or vector of scalar", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformBroadcast '%s' between result type and value", id);
        }
        Expression tid = builder.getExpression(ctx.id().getText());
        // TODO signess?
        if (!(tid.getType() instanceof IntegerType)) {
            throw new ParsingException("The id in OpGroupNonUniformBroadcast '%s' should be of integer type", id);
        }
        Event event = EventFactory.newNonUniformOpBroadcast(Integer.toString(nextOpId++), execScope, register, value, tid);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformShuffle(SpirvParser.OpGroupNonUniformShuffleContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(isScalar(type) || (type instanceof ArrayType aType && isScalar(aType.getElementType())))) {
            throw new ParsingException("Return type %s of OpGroupNonUniformShuffle '%s' is not scalar or vector of scalar", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.valueIdRef().getText());
        if (!(type.equals(value.getType()))) {
            throw new ParsingException("Type mismatch in OpGroupNonUniformShuffle '%s' between result type and value", id);
        }
        Expression tid = builder.getExpression(ctx.id().getText());
        // TODO signess?
        if (!(tid.getType() instanceof IntegerType)) {
            throw new ParsingException("The id in OpGroupNonUniformShuffle '%s' should be of integer type", id);
        }
        Event event = EventFactory.newNonUniformOpShuffle(Integer.toString(nextOpId++), execScope, register, value, tid);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    @Override
    public Event visitOpGroupNonUniformBallot(SpirvParser.OpGroupNonUniformBallotContext ctx) {
        String id = ctx.idResult().getText();
        Type type = builder.getType(ctx.idResultType().getText());
        if (!(type instanceof ArrayType aType && aType.getNumElements() == 4 && aType.getElementType() instanceof IntegerType iType && iType.getBitWidth() == 32)) {
            throw new ParsingException("Return type %s of OpGroupNonUniformBallot '%s' is not vec4 of int32", type, id);
        }
        Register register = builder.addRegister(id, ctx.idResultType().getText());
        String execScope = getScopeTag(ctx.execution().getText());
        if (!Tag.Spirv.SUBGROUP.equals(execScope)) {
            throw new ParsingException("Unsupported execution scope '%s'", execScope);
        }
        Expression value = builder.getExpression(ctx.predicate().getText());
        if (!(value.getType() instanceof BooleanType)) {
            throw new ParsingException("Predicate type %s of OpGroupNonUniformAll '%s' is not bool", value.getType(), id);
        }
        Event event = EventFactory.newNonUniformOpBallot(Integer.toString(nextOpId++), execScope, register, value);
        event.addTags(Tag.Spirv.CONTROL);
        event.addTags(execScope);
        return builder.addEvent(event);
    }

    private GroupOp getGroupOperation(SpirvParser.OperationContext ctx) {
        if (ctx.groupOperation().Reduce() != null) {
            return GroupOp.REDUCE;
        }
        if (ctx.groupOperation().InclusiveScan() != null) {
            return GroupOp.INCLUSIVESCAN;
        }
        if (ctx.groupOperation().ExclusiveScan() != null) {
            return GroupOp.EXCLUSIVESCAN;
        }
        if (ctx.groupOperation().ClusteredReduce() != null) {
            return GroupOp.CLUSTEREDREDUCE;
        }
        throw new ParsingException("Unsupported group operation " + ctx.getText());
    }

    private String getScopeTag(String scopeId) {
        return HelperTags.parseScope(scopeId, builder.getExpression(scopeId));
    }

    public Set<String> getSupportedOps() {
        return Set.of(
                "OpGroupNonUniformAll",
                "OpGroupNonUniformAny",
                "OpGroupNonUniformIAdd",
                "OpGroupNonUniformIMul",
                "OpGroupNonUniformBitwiseAnd",
                "OpGroupNonUniformBitwiseOr",
                "OpGroupNonUniformBitwiseXor",
                "OpGroupNonUniformBroadcast",
                "OpGroupNonUniformShuffle",
                "OpGroupNonUniformBallot"
        );
    }

}
