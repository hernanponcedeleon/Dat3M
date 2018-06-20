package porthosc.languages.syntax.xgraph.memories;


import porthosc.languages.common.XType;


abstract class XMemoryUnitBase implements XMemoryUnit {

    private final XType type;

    XMemoryUnitBase(XType type) {
        this.type = type;
    }

    @Override
    public XType getType() {
        return type;
    }
}
