package porthosc.languages.syntax.xgraph.memories;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;


public final class XLocation extends XLvalueMemoryUnitBase implements XSharedLvalueMemoryUnit {

    public XLocation(String name, XType type, boolean isResolved) {
        super(name, type, isResolved);
    }

    @Override
    public <T> T accept(XMemoryUnitVisitor<T> visitor) {
        return visitor.visit(this);
    }
}
