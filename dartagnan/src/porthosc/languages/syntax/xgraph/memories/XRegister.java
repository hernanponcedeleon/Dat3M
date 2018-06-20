package porthosc.languages.syntax.xgraph.memories;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;

import java.util.Objects;


// Local + belongs to a process
public final class XRegister extends XLvalueMemoryUnitBase implements XLocalLvalueMemoryUnit {

    private final XProcessId processId;

    public XRegister(String name, XType type, XProcessId processId, boolean isResolved) {
        super(name, type, isResolved);
        this.processId = processId;
    }

    @Override
    public XProcessId getProcessId() {
        return processId;
    }

    @Override
    public <T> T accept(XMemoryUnitVisitor<T> visitor) {
        return visitor.visit(this);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XRegister)) { return false; }
        if (!super.equals(o)) { return false; }
        XRegister xRegister = (XRegister) o;
        return Objects.equals(getProcessId(), xRegister.getProcessId());
    }

    @Override
    public int hashCode() {
        return Objects.hash(super.hashCode(), getProcessId());
    }
}
