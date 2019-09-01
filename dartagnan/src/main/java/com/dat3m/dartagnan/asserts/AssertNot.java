package com.dat3m.dartagnan.asserts;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.Address;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

public class AssertNot extends AbstractAssert {

    private AbstractAssert child;

    public AssertNot(AbstractAssert child){
        this.child = child;
    }

    AbstractAssert getChild(){
        return child;
    }

    @Override
    public BoolExpr encode(Context ctx) {
        if(child != null){
            return ctx.mkNot(child.encode(ctx));
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
    }

    @Override
    public String toString() {
        return "!" + child.toString();
    }

	@Override
	public Set<Register> getRegs() {
        if(child != null){
    		return child.getRegs();
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
	}

	@Override
	public Set<Address> getAdds() {
        if(child != null){
    		return child.getAdds();
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
	}
}
