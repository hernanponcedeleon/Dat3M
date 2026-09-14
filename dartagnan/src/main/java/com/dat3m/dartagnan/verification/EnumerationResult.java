package com.dat3m.dartagnan.verification;

import com.dat3m.dartagnan.encoding.IREvaluator;
import com.dat3m.dartagnan.expression.Expression;
import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

import java.util.List;
import java.util.Map;

public final class EnumerationResult implements TaskResult<EnumerationTask> {

    private final EnumerationTask task;
    private final ResultStatus status;
    private final ImmutableList<Expression> vars;
    private final ImmutableList<ImmutableMap<Expression, Expression>> enumeratedStates;

    public EnumerationResult(EnumerationTask task, ResultStatus status, List<Expression> vars, List<ImmutableMap<Expression, Expression>> enumeratedStates) {
        this.task = Preconditions.checkNotNull(task);
        this.status = status;
        this.vars = ImmutableList.copyOf(vars);
        this.enumeratedStates = ImmutableList.copyOf(enumeratedStates);
    }

    @Override
    public ResultStatus getStatus() {
        return status;
    }

    @Override
    public EnumerationTask getTask() {
        return task;
    }

    public ImmutableList<Expression> getVars() { return vars;}

    public ImmutableList<ImmutableMap<Expression, Expression>> getEnumeratedStates() {
        return  enumeratedStates;
    }

    @Override
    public String toString() {
        return "EnumerationResult[Vars=%s, #States=%s]".formatted(vars, enumeratedStates.size());
    }

}
