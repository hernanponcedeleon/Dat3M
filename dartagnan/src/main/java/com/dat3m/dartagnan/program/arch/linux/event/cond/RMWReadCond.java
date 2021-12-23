package com.dat3m.dartagnan.program.arch.linux.event.cond;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.parsers.program.exception.UnrollException;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.Load;
import com.dat3m.dartagnan.program.event.utils.RegReaderData;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.utils.recursion.RecursiveAction;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.ImmutableSet;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.SolverContext;

import static com.dat3m.dartagnan.program.utils.Utils.generalEqual;

public abstract class RMWReadCond extends Load implements RegWriter, RegReaderData {

    protected ExprInterface cmp;
    private final ImmutableSet<Register> dataRegs;
    protected BooleanFormula formulaCond;

    RMWReadCond(Register reg, ExprInterface cmp, IExpr address, String atomic) {
        super(reg, address, atomic);
        this.cmp = cmp;
        this.dataRegs = cmp.getRegs();
        addFilters(EType.RMW, EType.REG_READER);
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
        formulaCond = generalEqual(memValueExpr, cmp.toIntFormula(this, ctx), ctx);
    }

    public BooleanFormula getCond(){
        if(formulaCond != null){
            return formulaCond;
        }
        throw new IllegalStateException("formulaCond is requested before it has been initialised in " + this.getClass().getName());
    }

    @Override
    public ImmutableSet<Register> getDataRegs(){
        return dataRegs;
    }

    public abstract String condToString();

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------


    @Override
    protected RecursiveAction unrollRecursive(int bound, Event predecessor, int depth) {
        throw new UnrollException("RMWReadCond cannot be unrolled: event must be generated during compilation");
    }
}
