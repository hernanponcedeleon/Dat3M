package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmLoad;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmStore;

import java.util.Collections;
import java.util.List;

import static com.google.common.base.Verify.verify;

class VisitorBase implements EventVisitor<List<Event>> {

    protected final TypeFactory types = TypeFactory.getInstance();
    protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

    protected Function funcToBeCompiled;

    protected VisitorBase() { }

    @Override
    public List<Event> visitEvent(Event e) {
        return Collections.singletonList(e);
    }

    @Override
    public List<Event> visitStoreExclusive(StoreExclusive e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLKMMXchg(LKMMXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitTSOXchg(TSOXchg e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLlvmLoad(LlvmLoad e) {
        throw error(e);
    }

    @Override
    public List<Event> visitLlvmStore(LlvmStore e) {
        throw error(e);
    }

    @Override
    public final List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
        final var type = e.getResultRegister().getType() instanceof AggregateType t ? t : null;
        verify(type != null && type.getFields().size() == 2, "Invalid result type of '%s'", e);
        final Register oldValue = e.getFunction().newUniqueRegister("LlvmCmpXchg.oldValue", e.getExpectedValue().getType());
        final Register success = e.getFunction().newUniqueRegister("LlvmCmpXchg.success", types.getBooleanType());
        final Expression r0 = expressions.makeCast(oldValue, type.getFields().get(0).type());
        final Expression r1 = expressions.makeCast(success, type.getFields().get(1).type());
        final Expression expected = e.getExpectedValue();
        final Expression newValue = e.getStoreValue();
        return EventFactory.eventSequence(
                newLlvmCmpXchg(oldValue, success, e.getAddress(), expected, newValue, e.getMo(), e.isStrong()),
                EventFactory.newLocal(e.getResultRegister(), expressions.makeConstruct(type, List.of(r0, r1)))
        );
    }

    protected List<Event> newLlvmCmpXchg(Register oldValue, Register success, Expression address, Expression expected,
            Expression newValue, String mo, boolean strong) {
        throw new UnsupportedOperationException("Compilation of LlvmCmpXchg by %s.".formatted(getClass()));
    }

    private IllegalArgumentException error(Event e) {
        return new IllegalArgumentException("Compilation for " + e.getClass().getSimpleName() +
                " is not supported by " + getClass().getSimpleName());
    }

}