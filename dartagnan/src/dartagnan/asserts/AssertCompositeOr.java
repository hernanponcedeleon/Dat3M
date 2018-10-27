package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.stream.Collectors;

public class AssertCompositeOr extends AbstractAssertComposite {

    public AssertCompositeOr(){}

    public AssertCompositeOr(AbstractAssert a1, AbstractAssert a2){
        addChild(a1);
        addChild(a2);
    }

    @Override
    public BoolExpr encode(Context ctx) {
        if(!children.isEmpty()){
            BoolExpr enc = ctx.mkFalse();
            for(AbstractAssert child : children){
                enc = ctx.mkOr(enc, child.encode(ctx));
            }
            return enc;
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
    }

    @Override
    public String toString() {
        return "(" + children.stream()
                .map(AbstractAssert::toString)
                .collect(Collectors.joining(" || " )) + ")";
    }
}
