package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.List;

/*
    Lowers by building a high-level event of a dialect the compiler understands and compiling it.
    The compilation schemes thus stay defined in one place: the compilation visitors.
 */
class CompilerBasedLowering implements TargetLowering {

    private final Arch target;
    private final VisitorBase compiler;
    // VisitorLKMM only compiles LKMM events, all other compilers accept C11-style atomics.
    private final boolean useLinuxEvents;

    CompilerBasedLowering(Arch target, VisitorBase compiler) {
        this.target = target;
        this.compiler = compiler;
        this.useLinuxEvents = target == Arch.LKMM;
    }

    @Override
    public List<Event> newLoad(Function context, Register result, Expression address, Order order) {
        final Event load = useLinuxEvents ?
                EventFactory.Linux.newLoad(result, address, toLinux(order)) :
                EventFactory.Atomic.newLoad(result, address, toC11(order));
        return compile(context, load);
    }

    @Override
    public List<Event> newStore(Function context, Expression address, Expression value, Order order) {
        final Event store = useLinuxEvents ?
                EventFactory.Linux.newStore(address, value, toLinux(order)) :
                EventFactory.Atomic.newStore(address, value, toC11(order));
        return compile(context, store);
    }

    @Override
    public List<Event> newFetchOp(Function context, Register result, Expression address, Expression operand,
                                  IntBinaryOp op, Order order) {
        final Event fetchOp = useLinuxEvents ?
                EventFactory.Linux.newRMWFetchOp(address, result, operand, op, toLinux(order)) :
                EventFactory.Atomic.newFetchOp(result, address, operand, op, toC11(order));
        return compile(context, fetchOp);
    }

    @Override
    public Init newInit(MemoryObject base, int offset) {
        final Init init = EventFactory.newInit(base, offset);
        if (target == Arch.C11 || target == Arch.OPENCL) {
            init.addTags(Tag.C11.NONATOMIC);
        }
        return init;
    }

    // ------------------------------------------------------------------------------------------

    private List<Event> compile(Function context, Event highLevelEvent) {
        // The compilers allocate helper registers in the function the events are compiled for.
        compiler.funcToBeCompiled = context;
        return highLevelEvent.accept(compiler);
    }

    private static String toC11(Order order) {
        return switch (order) {
            case RELAXED -> Tag.C11.MO_RELAXED;
            case ACQUIRE -> Tag.C11.MO_ACQUIRE;
            case RELEASE -> Tag.C11.MO_RELEASE;
            case ACQ_REL -> Tag.C11.MO_ACQUIRE_RELEASE;
            case SEQ_CST -> Tag.C11.MO_SC;
        };
    }

    private static String toLinux(Order order) {
        return switch (order) {
            case RELAXED -> Tag.Linux.MO_ONCE;
            case ACQUIRE -> Tag.Linux.MO_ACQUIRE;
            case RELEASE -> Tag.Linux.MO_RELEASE;
            case SEQ_CST -> Tag.Linux.MO_MB;
            case ACQ_REL -> throw new UnsupportedOperationException("LKMM has no acquire-release accesses");
        };
    }
}
