package porthosc.languages.conversion.toxgraph.unrolling;

import porthosc.languages.syntax.xgraph.process.XCyclicProcess;
import porthosc.languages.syntax.xgraph.program.XCyclicProgram;
import porthosc.languages.syntax.xgraph.program.XProgram;
import porthosc.languages.syntax.xgraph.program.XProgramBuilder;


public class XProgramTransformer {

    public static XProgram unroll(XCyclicProgram program, int bound) {
        XProgramBuilder builder = new XProgramBuilder();
        for (XCyclicProcess process : program.getProcesses()) {
            XFlowGraphUnroller unroller = new XFlowGraphUnroller(process, bound);
            unroller.doUnroll();
            builder.addProcess(unroller.getUnrolledGraph());
        }
        return builder.build();
    }

}
