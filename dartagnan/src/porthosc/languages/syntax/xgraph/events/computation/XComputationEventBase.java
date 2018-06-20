package porthosc.languages.syntax.xgraph.events.computation;

import porthosc.languages.common.XType;
import porthosc.languages.syntax.xgraph.events.XEventBase;
import porthosc.languages.syntax.xgraph.events.XEventInfo;


// TODO: remove nullary computation event, inherit the XLocalMemoryUnit from XEventBase and XComputationEvent (because it's read from registry)
abstract class XComputationEventBase extends XEventBase implements XComputationEvent {

    private final XOperator operator;
    private final XType type;

    XComputationEventBase(int refId, XEventInfo info, XType type, XOperator operator) {
        super(refId, info);
        this.type = type;
        this.operator = operator;
    }

    protected XOperator getOperator() {
        return operator;
    }

    @Override
    public XType getType() {
        return type;
    }
}
