package porthosc.languages.conversion.toxgraph.interpretation;

import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.process.XProcessId;


public class XPostludeInterpreter extends XLudeInterpreterBase {

    public XPostludeInterpreter(XProcessId processId, XMemoryManager memoryManager) {
        super(processId, memoryManager);
    }

    @Override
    public XAssertionEvent emitAssertionEvent(XBinaryComputationEvent assertion) {
        XAssertionEvent assertionEvent = new XAssertionEvent(assertion);
        processNextEvent(assertionEvent);
        return assertionEvent;
    }
}
