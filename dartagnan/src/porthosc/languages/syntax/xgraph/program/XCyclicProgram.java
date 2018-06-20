package porthosc.languages.syntax.xgraph.program;

import com.google.common.collect.ImmutableList;
import porthosc.languages.syntax.xgraph.process.XCyclicProcess;


public final class XCyclicProgram extends XProgramBase<XCyclicProcess> {

    XCyclicProgram(ImmutableList<XCyclicProcess> processes) {
        super(processes);
    }
}
