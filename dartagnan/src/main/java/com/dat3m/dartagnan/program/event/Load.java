package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.sosy_lab.java_smt.api.Formula;
import org.sosy_lab.java_smt.api.SolverContext;

public class Load extends MemEvent implements RegWriter {

    protected final Register resultRegister;

    public Load(Register register, IExpr address, String mo) {
        super(address, mo);
        this.resultRegister = register;
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.REG_WRITER);
    }
    
    protected Load(Load other){
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public void initialise(VerificationTask task, SolverContext ctx) {
        super.initialise(task, ctx);
        memValueExpr = resultRegister.toIntFormulaResult(this, ctx);
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public Formula getResultRegisterExpr(){
        return memValueExpr;
    }

    @Override
    public String toString() {
        return resultRegister + " = load(*" + address + (mo != null ? ", " + mo : "") + ")";
    }

    @Override
    public String label(){
        return "R" + (mo != null ? "_" + mo : "");
    }

    @Override
    public ExprInterface getMemValue(){
        return resultRegister;
    }

    // Unrolling
    // -----------------------------------------------------------------------------------------------------------------

    @Override
    public Load getCopy(){
        return new Load(this);
    }
}
