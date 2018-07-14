package dartagnan.asserts;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractAssertComposite extends AbstractAssert {

    protected List<AbstractAssert> children = new ArrayList<AbstractAssert>();

    public void addChild(AbstractAssert ass){
        children.add(ass);
    }
}
