package com.dat3m.dartagnan.expression;

import com.google.common.collect.ImmutableSet;
import com.microsoft.z3.Expr;
import com.microsoft.z3.Model;
import com.dat3m.dartagnan.expression.op.IOpUn;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.EncodingConf;

public class IExprUn extends IExpr {

	private final ExprInterface b;
	private final IOpUn op;

    public IExprUn(IOpUn op, ExprInterface b) {
        this.b = b;
        this.op = op;
    }

	@Override
	public Expr toZ3Int(Event e, EncodingConf conf) {
		return op.encode(b.toZ3Int(e, conf), conf);
	}

	@Override
	public Expr getLastValueExpr(EncodingConf conf) {
        return op.encode(b.getLastValueExpr(conf), conf);
	}

	@Override
	public int getIntValue(Event e, Model model, EncodingConf conf) {
        return -(b.getIntValue(e, model, conf));
	}

	@Override
	public ImmutableSet<Register> getRegs() {
        return new ImmutableSet.Builder<Register>().addAll(b.getRegs()).build();
	}

    @Override
    public String toString() {
        return "(" + op + b + ")";
    }

    @Override
	public IConst reduce() {
        switch(op){
			case MINUS:
				return new IConst(-b.reduce().getValue());
        }
        throw new UnsupportedOperationException("Reduce not supported for " + this);
	}
}
