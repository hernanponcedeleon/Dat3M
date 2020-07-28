package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public class IExprBin extends IExpr implements ExprInterface {

    private final ExprInterface lhs;
    private final ExprInterface rhs;
    private final IOpBin op;

    public IExprBin(ExprInterface lhs, IOpBin op, ExprInterface rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
        this.op = op;
    }

    @Override
    public Expr toZ3NumExpr(Event e, EncodingConf conf) {
        return op.encode(lhs.toZ3NumExpr(e, conf), rhs.toZ3NumExpr(e, conf), conf);
    }

    @Override
    public Expr getLastValueExpr(EncodingConf conf){
        return op.encode(lhs.getLastValueExpr(conf), rhs.getLastValueExpr(conf), conf);
    }

    @Override
    public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(lhs.getRegs()).addAll(rhs.getRegs()).build();
    }

    @Override
    public String toString() {
        return "(" + lhs + " " + op + " " + rhs + ")";
    }

    @Override
    public int getIntValue(Event e, Model model, EncodingConf conf){
        return op.combine(lhs.getIntValue(e, model, conf), rhs.getIntValue(e, model, conf));
    }
    
    @Override
	public IConst reduce() {
		int v1 = lhs.reduce().getValue();
		int v2 = rhs.reduce().getValue();
		return new IConst(op.combine(v1,  v2));
	}
}
