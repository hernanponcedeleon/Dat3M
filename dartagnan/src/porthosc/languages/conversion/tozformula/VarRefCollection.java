package porthosc.languages.conversion.tozformula;

import porthosc.languages.syntax.xgraph.memories.XLvalueMemoryUnit;
import porthosc.utils.exceptions.xgraph.XInterpretationError;

import java.util.HashMap;
import java.util.Map;

import static porthosc.utils.StringUtils.wrap;


public class VarRefCollection implements Cloneable {

    private final Map<XLvalueMemoryUnit, Integer> map;

    VarRefCollection() {
        this(new HashMap<>());
    }

    private VarRefCollection(Map<XLvalueMemoryUnit, Integer> map) {
        this.map = map;
    }

    public void addAll(VarRefCollection other) {
        for (Map.Entry<XLvalueMemoryUnit, Integer> pair : other.map.entrySet()) {
            XLvalueMemoryUnit memoryUnit = pair.getKey();
            int otherIndex = pair.getValue();
            int index = map.containsKey(memoryUnit)
                    ? Integer.max(otherIndex, map.get(memoryUnit))
                    : otherIndex;
            map.put(memoryUnit, index);
        }
    }

    public void addNew(XLvalueMemoryUnit memoryUnit) {
        add(memoryUnit, 0);
    }

    public void add(XLvalueMemoryUnit memoryUnit, int index) {
        assert !map.containsKey(memoryUnit) : "already contains key: " + memoryUnit;
        map.put(memoryUnit, index);
    }

    //public Set<XLvalueMemoryUnit> getVars() {
    //    return map.keySet();
    //}

    public boolean containsVarRef(XLvalueMemoryUnit memoryUnit) {
        return map.containsKey(memoryUnit);
    }

    public int updateRef(XLvalueMemoryUnit memoryUnit) {
        int index = getRefIndex(memoryUnit) + 1;
        map.put(memoryUnit, index);
        return index;
    }

    public void resetRef(XLvalueMemoryUnit memoryUnit, int newIndex) {
        assert map.containsKey(memoryUnit) : "attempt to reset non-set value";
        map.put(memoryUnit, newIndex);
    }

    public int getRefIndex(XLvalueMemoryUnit memoryUnit) {
        if (!map.containsKey(memoryUnit)) {
            throw new XInterpretationError("ssa-map: unregistered memory unit: " + wrap(memoryUnit)); // TODO: more eloquent message
        }
        return map.get(memoryUnit);
    }

    public static VarRefCollection copy(VarRefCollection collection) {
        return new VarRefCollection(new HashMap<>(collection.map));
    }

    @Override
    public String toString() {
        return "[" + map + "]";
    }


    // Encoding of the memory units + computation events

}
