package porthosc.languages.syntax.xgraph.memories;


import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;

import java.util.Objects;


// Note: here the 'memoryevents' does not signifies the RAM memoryevents, it's just a storage
// containing some value (e.g. shared memoryevents = RAM, or local memoryevents = register)
abstract class XLvalueMemoryUnitBase extends XMemoryUnitBase implements XLvalueMemoryUnit {

    private final int uniqueId;
    private final String name;
    private final boolean isResolved; //TODO: this information should be stored as a map in MemoryManager!!!

    XLvalueMemoryUnitBase(String name, XType type, boolean isResolved) {
        super(type);
        this.uniqueId = createId();
        this.name = name;
        this.isResolved = isResolved;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public boolean isResolved() {
        return isResolved;
    }

    @Override
    public <T> T accept(XMemoryUnitVisitor<T> visitor) {
        return null;
    }

    @Override
    public String toString() {
        return getName();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) { return true; }
        if (!(o instanceof XLvalueMemoryUnitBase)) { return false; }
        XLvalueMemoryUnitBase that = (XLvalueMemoryUnitBase) o;
        return uniqueId == that.uniqueId &&
                Objects.equals(getName(), that.getName());
    }

    @Override
    public int hashCode() {
        return Objects.hash(uniqueId, getName(), isResolved());
    }

    private static int lastUniqueId = 0;
    private static int createId() {
        return ++lastUniqueId;
    }
}
