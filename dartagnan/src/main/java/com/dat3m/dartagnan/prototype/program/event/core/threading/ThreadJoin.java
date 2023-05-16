package com.dat3m.dartagnan.prototype.program.event.core.threading;


import com.dat3m.dartagnan.prototype.expr.Type;
import com.dat3m.dartagnan.prototype.expr.types.AggregateType;
import com.dat3m.dartagnan.prototype.expr.types.IntegerType;
import com.dat3m.dartagnan.prototype.program.Register;
import com.dat3m.dartagnan.prototype.program.event.AbstractEvent;
import com.dat3m.dartagnan.prototype.program.event.Event;
import com.dat3m.dartagnan.prototype.program.event.EventUser;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    NOTES on Modelling:
    ====================
    // Original Code
    pthread_t thread;
    // ... pthread_create(&thread, 0, &func, arg);
    int temp = load(&thread);
    int status = pthread_join(temp, &retVal);
    ------------------------------------------------------
    // Compilation
    if (temp == Thread1) { // Here we check with which thread to join (assuming we have created all possible threads already)
        <int1, RetType> r = ThreadJoin(ThreadEnd's of Thread1);
        if (extract(r, 0) == 0) { // Check for success
            store(&retVal, extract(r, 1));
            status = 0;
        } else {
            goto T_END; // We terminate the thread (models no returning join);
        }
        TODO: In the future, we can return an int64 with various values to model SUCCESS, ERROR, and NONTERMINATION.
         Currently, we only have SUCCESS and NONTERMINATION (i.e., we cannot have pthread_join return with an ERROR).
    } else if (temp == Thread2) {
        // ... as above, but for Thread2
    } else if (...) {
    ...
    } else {
        // TODO: In a final else-case that no thread id matches, we could return an ERROR status here.
        status = ERROR_NO_MATCHING_THREAD;
    }

    TODO: We still have to generate a store/load-pair with appropriate barriers to get a synchronizing rf-edge between
     the joining threads.
 */
public abstract class ThreadJoin extends AbstractEvent implements EventUser, Register.Writer {

    private Register resultRegister; // Complex type <Int1, RetType>, where the first entry is the success bit.
    private List<ThreadReturn> incomingValues;

    private ThreadJoin(Register resultRegister, List<ThreadReturn> incomingValues) {
        Preconditions.checkArgument(incomingValues.size() > 0);
        final Type valueType = incomingValues.get(0).getReturnValue().getType();
        Preconditions.checkArgument(incomingValues.stream().allMatch(iv -> iv.getReturnValue().getType().equals(valueType)));
        final Type registerType = AggregateType.get(IntegerType.INT1, valueType);
        Preconditions.checkArgument(resultRegister.getType().equals(registerType));

        this.resultRegister = resultRegister;
        this.incomingValues = incomingValues;

        incomingValues.forEach(iv -> iv.registerUser(this));
    }

    @Override
    public Set<Event> getReferencedEvents() { return new HashSet<>(incomingValues); }

    @Override
    public Register getResultRegister() { return resultRegister; }
}
