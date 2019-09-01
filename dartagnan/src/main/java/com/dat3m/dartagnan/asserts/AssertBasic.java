package com.dat3m.dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;

public class AssertBasic extends AbstractAssert {

    private final ExprInterface e1;
    private final ExprInterface e2;
    private final COpBin op;

    public AssertBasic(ExprInterface e1, COpBin op, ExprInterface e2){
        this.e1 = e1;
        this.e2 = e2;
        this.op = op;
    }

    @Override
    public BoolExpr encode(Context ctx) {
        return op.encode(e1.getLastValueExpr(ctx), e2.getLastValueExpr(ctx), ctx);
    }

    @Override
    public String toString(){
        return valueToString(e1) + op + valueToString(e2);
    }

    private String valueToString(ExprInterface value){
        if(value instanceof Register){
            return ((Register)value).getThreadId() + ":" + value;
        }
        return value.toString();
    }

	@Override
	public Set<Register> getRegs() {
		return Stream.concat(e1.getRegs().stream(),e2.getRegs().stream()).collect(Collectors.toSet());
	}

	@Override
	public Set<Address> getAdds() {
		Set<Address> variables = new HashSet<Address>();
		if(e1 instanceof Location) {
			variables.add(((Location)e1).getAddress());
		}
		if(e2 instanceof Location) {
			variables.add(((Location)e2).getAddress());
		}
		return variables;
	}
}
