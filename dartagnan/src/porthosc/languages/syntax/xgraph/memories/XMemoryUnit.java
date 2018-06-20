package porthosc.languages.syntax.xgraph.memories;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.XEntity;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;


public interface XMemoryUnit extends XEntity {

    XType getType();

    <T> T accept(XMemoryUnitVisitor<T> visitor);
}
