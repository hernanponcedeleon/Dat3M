package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.memories.XLocation;
import porthosc.languages.syntax.xgraph.memories.XLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XRegister;
import porthosc.languages.syntax.xgraph.process.XProcessId;

import java.util.HashMap;
import java.util.Map;

import static porthosc.utils.StringUtils.wrap;


public class XMemoryManagerImpl implements XMemoryManager {

    private final Map<String, XLocation> sharedUnits;
    private final Map<XProcessId, Map<String, XRegister>> localUnitsMap;
    private XProcessId currentProcessId;

    public XMemoryManagerImpl() {
        this.sharedUnits = new HashMap<>();
        this.localUnitsMap = new HashMap<>();
    }

    @Override
    public void reset(XProcessId newProcessId) {
        currentProcessId = newProcessId;
        localUnitsMap.put(currentProcessId, new HashMap<>());
    }

    @Override
    public XLvalueMemoryUnit getDeclaredUnitOrNull(String name) {
        //TODO: in C, local contexts have more priority than global ones. But in our case, we determine type of variable dynamically during interpretation, therefore if a variable has ever been seen as shared, it must be shared!
        // TODO: this architecture sucks! a variable may change its kind during interpretation and thus break consistency.
        // What we need is to have a pre-processor for each conversion:
        // 1) Y->X: it pre-parses sources in order to find and remember jumps
        // 2) X->Z: it pre-watches the Y-tree in order to determine types of variables !
        if (sharedUnits.containsKey(name)) {
            currentLocalUnitsMap().remove(name);//remove it from locals if it is there
            return sharedUnits.get(name);
        }
        if (currentLocalUnitsMap().containsKey(name)) {
            assert !sharedUnits.containsKey(name) : name; //for confidence. // TODO: this is a debugging assert
            return currentLocalUnitsMap().get(name);
        }
        return null;
    }

    @Override
    public XRegister getDeclaredRegister(String name, XProcessId processId) {
        if (!localUnitsMap.containsKey(processId)) {
            throw new IllegalArgumentException("Unregistered process: " + wrap(processId) + ", registered only: " + localUnitsMap.keySet());
        }
        Map<String, XRegister> map = localUnitsMap.get(processId);
        if (!map.containsKey(name)) {
            throw new IllegalArgumentException("Unregistered local memory unit " + wrap(name) +
                                                       " for the process " + wrap(processId));
        }
        return map.get(name);
    }

    @Override
    public XLvalueMemoryUnit declareUnresolvedUnit(String name, boolean isShared) {
        XType type = XType.int32; // TODO: create 'Undefined type' instead
        return isShared
                ? declareLocationImpl(name, type, false)
                : declareRegisterImpl(name, type, false);
    }

    @Override
    public XRegister declareRegister(String name, XType type) {
        return declareRegisterImpl(name, type, true);
    }

    @Override
    public XLocation declareLocation(String name, XType type) {
        if (currentProcessId == XProcessId.PostludeProcessId) {
            throw new IllegalStateException("Cannot declare locations in postlude process");
        }
        return declareLocationImpl(name, type, true);
    }

    // todo: combine this method with declareRegister() by creating method that generates new unique temp name (simplify logic)
    @Override
    public XRegister declareTempRegister(XType type) {
        String tempName = newTempRegisterName();
        Map<String, XRegister> map = currentLocalUnitsMap();
        while (map.containsKey(tempName)) {
            tempName = newTempRegisterName();
        }
        return declareRegister(tempName, type);
    }

    private XRegister declareRegisterImpl(String name, XType type, boolean isResolved) {
        XRegister register = new XRegister(name, type, currentProcessId, isResolved);
        Map<String, XRegister> map = currentLocalUnitsMap();
        assert !map.containsKey(name) : "attempt to register the local variable twice: " + name;
        map.put(name, register);
        return register;
    }

    private XLocation declareLocationImpl(String name, XType type, boolean isResolved) {
        XLocation location = new XLocation(name, type, isResolved);
        if (sharedUnits.containsKey(name)) {
            return sharedUnits.get(name);
        }
        sharedUnits.put(name, location);
        return location;
    }

    private Map<String, XRegister> currentLocalUnitsMap() {
        Map<String, XRegister> result = localUnitsMap.get(currentProcessId);
        assert result != null;
        return result;
    }

    private static int tempRegisterNamesCounter;
    private static String newTempRegisterName() {
        return getRegisterName(tempRegisterNamesCounter++);
    }

    private static String getRegisterName(int count) {
        return "reg_tmp" + count;
    }
}
