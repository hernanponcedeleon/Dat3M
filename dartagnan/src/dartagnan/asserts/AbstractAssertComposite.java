package dartagnan.asserts;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractAssertComposite extends AbstractAssert {

    protected List<AbstractAssert> children = new ArrayList<AbstractAssert>();

    public void addChild(AbstractAssert ass){
        children.add(ass);
    }

    public AbstractAssert clone(){
        try{
            AbstractAssertComposite newAssert = getClass().getConstructor().newInstance();
            for(AbstractAssert child : children)
                newAssert.addChild(child);
            return newAssert;

        } catch (ReflectiveOperationException e){
            throw new RuntimeException("Cloning assert failed for " + this + " (" + getClass().getName() + ")");
        }
    }
}
