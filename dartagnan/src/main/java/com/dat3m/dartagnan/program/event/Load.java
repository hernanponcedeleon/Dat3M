package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.verification.VerificationTask;
import com.microsoft.z3.Context;
import com.microsoft.z3.Expr;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.utils.RegWriter;
import com.dat3m.dartagnan.program.utils.EType;

public class Load extends MemEvent implements RegWriter {

    protected final Register resultRegister;

    public Load(Register register, IExpr address, String mo, int cLine) {
        super(address, mo, cLine);
        this.resultRegister = register;
        addFilters(EType.ANY, EType.VISIBLE, EType.MEMORY, EType.READ, EType.REG_WRITER);
    }

    public Load(Register register, IExpr address, String mo) {
    	this(register, address, mo, -1);
    }
    
    protected Load(Load other){
        super(other);
        this.resultRegister = other.resultRegister;
    }

    @Override
    public void initialise(VerificationTask task, Context ctx) {
        super.initialise(task, ctx);
        memValueExpr = resultRegister.toZ3IntResult(this, ctx);
    }

    @Override
    public Register getResultRegister(){
        return resultRegister;
    }

    @Override
    public Expr getResultRegisterExpr(){
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
