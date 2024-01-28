package com.dat3m.dartagnan.program.event.core.threading;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.processing.ExpressionVisitor;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.AbstractEvent;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class ThreadCreate extends AbstractEvent implements RegReader {

    protected List<Expression> arguments;
    protected Thread spawnedThread;

    public ThreadCreate(List<Expression> arguments) {
        this.arguments = new ArrayList<>(arguments);
    }

    protected ThreadCreate(ThreadCreate other) {
        super(other);
        this.arguments = new ArrayList<>(other.arguments);
        this.spawnedThread = null;
    }

    public List<Expression> getArguments() { return arguments; }
    public Thread getSpawnedThread() { return spawnedThread; }
    public void setSpawnedThread(Thread spawnedThread) { this.spawnedThread = spawnedThread; }

    @Override
    protected String defaultString() {
        return String.format("ThreadCreate(%s, %s)", spawnedThread,
                arguments.stream().map(Expression::toString).collect(Collectors.joining(", ")));
    }

    @Override
    public ThreadCreate getCopy() {
        return new ThreadCreate(this);
    }

    @Override
    public <T> T accept(EventVisitor<T> visitor) {
        // TODO
        return visitor.visitEvent(this);
    }

    @Override
    public Set<Register.Read> getRegisterReads() {
        final Set<Register.Read> regReads = new HashSet<>();
        arguments.forEach(arg -> Register.collectRegisterReads(arg, Register.UsageType.DATA, regReads));
        return regReads;
    }

    @Override
    public void transformExpressions(ExpressionVisitor<? extends Expression> exprTransformer) {
        arguments.replaceAll(expression -> expression.accept(exprTransformer));
    }
}
