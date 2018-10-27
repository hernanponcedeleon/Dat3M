package dartagnan.asserts;

import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;

import java.util.stream.Collectors;

public class AssertCompositeAnd extends AbstractAssertComposite {

    public AssertCompositeAnd(){}

    public AssertCompositeAnd(AbstractAssert a1, AbstractAssert a2){
        addChild(a1);
        addChild(a2);
    }

    @Override
    public BoolExpr encode(Context ctx) {
        if(!children.isEmpty()){
            BoolExpr enc = ctx.mkTrue();
            for(AbstractAssert child : children){
                enc = ctx.mkAnd(enc, child.encode(ctx));
            }
            return enc;
        }
        throw new RuntimeException("Empty assertion clause in " + this.getClass().getName());
    }

    @Override
    public String toString() {
        return children.stream()
                .map(AbstractAssert::toString)
                .collect(Collectors.joining(" && " ));
    }
}
