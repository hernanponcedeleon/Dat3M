package com.dat3m.dartagnan.program.event.core;

import com.dat3m.dartagnan.encoding.EncodingContext;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Tag;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;

public class Termination extends GenericVisibleEvent {

    public Termination() {
        super("Termination", Tag.TERMINATION);
    }

    @Override
    public GenericVisibleEvent getCopy() {
        throw new ProgramProcessingException("Termination event cannot be copied");
    }

    @Override
    public boolean cfImpliesExec() {
        return false;
    }

    @Override
    public BooleanFormula encodeExec(EncodingContext ctx) {
        Program program = getThread().getProgram();
        final BooleanFormulaManager bmgr = ctx.getBooleanFormulaManager();
        final BooleanFormula exitReached = bmgr.and(program.getThreads().stream()
                .filter(t -> !t.equals(getThread()))
                .map(t -> bmgr.equivalence(ctx.execution(t.getEntry()), ctx.execution(t.getExit())))
                .toList());
        final BooleanFormula terminated = program.getThreadEventsWithAllTags(Tag.NONTERMINATION).stream()
                .map(CondJump.class::cast)
                .map(jump -> bmgr.not(ctx.jumpTaken(jump)))
                .reduce(bmgr.makeTrue(), bmgr::and);
        return bmgr.implication(ctx.execution(this), bmgr.and(ctx.controlFlow(this), exitReached, terminated));
    }
}
