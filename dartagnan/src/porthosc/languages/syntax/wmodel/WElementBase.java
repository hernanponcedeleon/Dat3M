package porthosc.languages.syntax.wmodel;

import porthosc.languages.common.citation.Origin;


public abstract class WElementBase extends WEntityBase implements WElement {

    public WElementBase(Origin origin, boolean containsRecursion) {
        super(origin, containsRecursion);
    }
}
