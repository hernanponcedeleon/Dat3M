package porthosc.languages.syntax.wmodel;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.wmodel.visitors.WmodelVisitor;


public interface WEntity {

    boolean containsRecursion();

    <T> T accept(WmodelVisitor<T> visitor);

    Origin origin();
}
