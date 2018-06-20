package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.memories.XLocation;
import porthosc.languages.syntax.xgraph.memories.XLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.memories.XRegister;
import porthosc.languages.syntax.xgraph.process.XProcessId;


public interface XMemoryManager {

    void reset(XProcessId processId);

    XLocation declareLocation(String name, XType type);

    XRegister declareRegister(String name, XType type);

    XRegister declareTempRegister(XType type);

    XLvalueMemoryUnit declareUnresolvedUnit(String name, boolean isGlobal);

    XLvalueMemoryUnit getDeclaredUnitOrNull(String name);

    XRegister getDeclaredRegister(String name, XProcessId processId);
}
