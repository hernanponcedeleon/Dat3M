package porthosc.languages.syntax.xgraph.memories;

import porthosc.languages.common.NamedAtom;


public interface XLvalueMemoryUnit extends XMemoryUnit, NamedAtom {
    boolean isResolved();
}
