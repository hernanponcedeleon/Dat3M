package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;

public class AssertNot extends AbstractAssert {

    private AbstractAssert child;

    public AssertNot(AbstractAssert child){
        this.child = child;
    }

    public AbstractAssert getChild(){
        return child;
    }

    public BoolExpr encode(Context ctx) throws Z3Exception {
        if(child == null){
            throw new RuntimeException("Empty assertion clause");
        }
        return ctx.mkNot(child.encode(ctx));
    }

    public String toString() {
        return "!" + child.toString();
    }

    public AbstractAssert clone(){
        return new AssertNot(child.clone());
    }
}
