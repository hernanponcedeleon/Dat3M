package dartagnan.program.memory;

import com.microsoft.z3.Context;
import com.microsoft.z3.IntExpr;

public class Address {

    private int address;

    Address(int address){
        this.address = address;
    }

    public IntExpr toZ3(Context ctx){
        return ctx.mkInt(address);
    }
}
