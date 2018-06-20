package porthosc.languages.syntax.wmodel;

import porthosc.languages.common.citation.Origin;


public abstract class WEntityBase implements WEntity {

    private final Origin origin;
    private final boolean containsRecursion;

    public WEntityBase(Origin origin, boolean containsRecursion) {
        this.origin = origin;
        this.containsRecursion = containsRecursion;
    }

    @Override
    public boolean containsRecursion() {
        return containsRecursion;
    }

    @Override
    public Origin origin() {
        return origin;
    }
}
