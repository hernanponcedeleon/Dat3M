package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Init;
import com.dat3m.dartagnan.program.memory.MemoryObject;

import java.util.List;

/*
    Creates target-level events for passes that run after compilation and need to introduce memory accesses
    (e.g. ThreadCreation's thread state protocol, or Init events from MemoryAllocation).
    The returned events are fresh: they are not inserted anywhere and carry no metadata.
    Sequences may contain several events, e.g. fences or exclusive load/store pairs,
    and may use helper registers allocated in the given context function.
 */
public interface TargetLowering {

    enum Order { RELAXED, ACQUIRE, RELEASE, ACQ_REL, SEQ_CST }

    List<Event> newLoad(Function context, Register result, Expression address, Order order);

    List<Event> newStore(Function context, Expression address, Expression value, Order order);

    // Atomically performs "result := *address; *address := result op operand".
    List<Event> newFetchOp(Function context, Register result, Expression address, Expression operand,
                           IntBinaryOp op, Order order);

    // Plain (non-atomic) accesses, represented the way the target represents plain accesses of the source language
    // (e.g. IMM has no non-atomics and makes them relaxed).
    Event newPlainLoad(Function context, Register result, Expression address);

    Event newPlainStore(Function context, Expression address, Expression value);

    // Initial write to a memory location, tagged as required by the target.
    Init newInit(MemoryObject base, int offset);
}
