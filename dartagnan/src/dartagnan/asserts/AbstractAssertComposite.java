package dartagnan.asserts;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractAssertComposite extends AbstractAssert {

    protected List<AbstractAssert> children = new ArrayList<>();

    public void addChild(AbstractAssert ass){
        children.add(ass);
    }

    @Override
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
