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

import com.google.common.base.Verify;

import java.util.List;

/*
    Lowers by building a high-level event of a dialect the compiler understands and compiling it.
    The compilation schemes thus stay defined in one place: the compilation visitors.
 */
class CompilerBasedLowering implements TargetLowering {

    private final Arch target;
    private final Compiler compiler;
    // VisitorLKMM only compiles LKMM events, all other compilers accept the C-family (LLVM) events.
    private final boolean useLinuxEvents;

    CompilerBasedLowering(Compiler compiler) {
        this.target = compiler.getTarget();
        this.compiler = compiler;
        this.useLinuxEvents = target == Arch.LKMM;
    }

    @Override
    public List<Event> newLoad(Function context, Register result, Expression address, Order order) {
        final Event load = useLinuxEvents ?
                EventFactory.Linux.newLoad(result, address, toLinux(order)) :
                EventFactory.Llvm.newLoad(result, address, toC11(order));
        return compile(context, load);
    }

    @Override
    public List<Event> newStore(Function context, Expression address, Expression value, Order order) {
        final Event store = useLinuxEvents ?
                EventFactory.Linux.newStore(address, value, toLinux(order)) :
                EventFactory.Llvm.newStore(address, value, toC11(order));
        return compile(context, store);
    }

    @Override
    public List<Event> newFetchOp(Function context, Register result, Expression address, Expression operand,
                                  IntBinaryOp op, Order order) {
        final Event fetchOp = useLinuxEvents ?
                EventFactory.Linux.newRMWFetchOp(address, result, operand, op, toLinux(order)) :
                EventFactory.Llvm.newRMW(result, address, operand, op, toC11(order));
        return compile(context, fetchOp);
    }

    @Override
    public Event newPlainLoad(Function context, Register result, Expression address) {
        return compileSingle(context, EventFactory.newLoad(result, address));
    }

    @Override
    public Event newPlainStore(Function context, Expression address, Expression value) {
        return compileSingle(context, EventFactory.newStore(address, value));
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
        return compiler.compile(highLevelEvent, context);
    }

    private Event compileSingle(Function context, Event plainAccess) {
        final List<Event> compiled = compile(context, plainAccess);
        Verify.verify(compiled.size() == 1, "Plain access compiled to %s events", compiled.size());
        return compiled.getFirst();
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
