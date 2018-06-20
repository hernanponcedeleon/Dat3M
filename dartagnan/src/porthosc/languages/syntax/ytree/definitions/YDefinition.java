package porthosc.languages.syntax.ytree.definitions;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.YEntity;


public abstract class YDefinition implements YEntity {

    private final Origin origin;

    protected YDefinition(Origin origin) {
        this.origin = origin;
    }

    @Override
    public Origin origin() {
        return origin;
    }

}
