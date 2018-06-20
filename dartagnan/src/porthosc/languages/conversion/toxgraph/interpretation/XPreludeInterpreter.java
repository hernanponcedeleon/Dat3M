package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.utils.exceptions.xgraph.XInterpretationError;


public class XPreludeInterpreter extends XLudeInterpreterBase {

    public XPreludeInterpreter(XProcessId processId, XMemoryManager memoryManager) {
        super(processId, memoryManager);
    }

    @Override
    public XAssertionEvent emitAssertionEvent(XBinaryComputationEvent assertion) {
        throw new XInterpretationError(getIllegalOperationMessage());
    }
}
