package porthosc.languages.syntax.ytree;

import porthosc.languages.common.citation.Origin;
import porthosc.languages.syntax.ytree.visitors.YtreeVisitor;


public interface YEntity {

    <T> T accept(YtreeVisitor<T> visitor);

    Origin origin();
}