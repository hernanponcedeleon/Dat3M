package com.dat3m.dartagnan.programNew.event.core.threading;


import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.types.IntegerType;
import com.dat3m.dartagnan.programNew.Function;
import com.dat3m.dartagnan.programNew.Register;
import com.dat3m.dartagnan.programNew.event.AbstractEvent;
import com.google.common.base.Preconditions;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/*
    NOTES on Modelling:
    ====================
    // Original Code
    pthread_t thread;
    int status = pthread_create(&thread, 0, &func, arg);
    // ... in LLVM
    %0 = alloca i64 1; // Pthread variable
    %1 = arg; // Some expression parameter
    %status = call pthread_create(%0, 0, &func, %1);
    ------------------------------------------------------
    // Compilation
    %1 = arg;
    if (*) {
        status = 0; // Set status to 0 (= SUCCESS)
        int threadId = ThreadCreate(Func, %1); // Func is a concrete function now
        store(%0, threadId); // Store threadId
    } else {
        // Only for non-deterministic failure of pthread_create.
        // In case we assume always success, we can get rid of the non-deterministic choice.
        i = ERROR;
    }
    TODO: We still have to generate a store/load-pair with appropriate barriers to get a synchronizing rf-edge between
     the spawning and the spawned thread.
 */

/*
    ThreadCreate spawns a thread that executes a given function, and returns the ID of the spawned thread.
 */
public abstract class ThreadCreate extends AbstractEvent implements Register.Writer, Register.Reader {

    private Register tidRegister;
    private Function functionToExecute;
    private List<Expression> arguments;

    private ThreadCreate(Register tidRegister, Function functionToExecute, List<Expression> arguments) {
        Preconditions.checkArgument(tidRegister.getType() instanceof IntegerType);
        this.tidRegister = tidRegister;
        this.functionToExecute = functionToExecute;
        this.arguments = arguments;
    }

    public Function getFunctionToExecute() { return functionToExecute; }
    public List<Expression> getArguments() { return arguments; }

    @Override
    public Register getResultRegister() { return tidRegister; }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        arguments.forEach(arg -> Register.collectRegisterReads(arg, Register.UsageType.DATA, regReads));
        return regReads;
    }
}
