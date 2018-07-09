package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public abstract class AssertInterface {

    private boolean invertFlag = false;

    public abstract BoolExpr encode(Context ctx) throws Z3Exception;

    public void setInvert(boolean flag){
        invertFlag = flag;
    }

    public boolean getInvert(){
        return invertFlag;
    }
}
