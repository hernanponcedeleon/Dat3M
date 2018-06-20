package porthosc.languages.syntax.wmodel;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;
import porthosc.utils.exceptions.NotImplementedException;


public class WMemoryModel implements WEntity {

    @Override
    public boolean containsRecursion() {
        throw new NotImplementedException();
    }

    @Override
    public <T> T accept(WmodelVisitor<T> visitor) {
        throw new NotImplementedException();
    }

    @Override
    public Origin origin() {
        throw new NotImplementedException();
    }
}
