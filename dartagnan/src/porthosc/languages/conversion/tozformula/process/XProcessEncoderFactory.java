package porthosc.languages.conversion.tozformula.process;

import com.microsoft.z3.Context;
import porthosc.languages.conversion.tozformula.StaticSingleAssignmentMap;
import porthosc.languages.conversion.tozformula.XDataflowEncoder;
import porthosc.languages.syntax.xgraph.process.XProcess;
import porthosc.languages.syntax.xgraph.process.XProcessId;


public class XProcessEncoderFactory {

    private final Context ctx;
    private final StaticSingleAssignmentMap ssaMap;
    private final XDataflowEncoder dataFlowEncoder;

    public XProcessEncoderFactory(Context ctx, StaticSingleAssignmentMap ssaMap, XDataflowEncoder dataFlowEncoder) {
        this.ctx = ctx;
        this.ssaMap = ssaMap;
        this.dataFlowEncoder = dataFlowEncoder;
    }

    public XFlowGraphEncoder getEncoder(XProcess process) {
        // TODO: switch not by process-id, by but type
        XProcessId processId = process.getId();
        if (processId == XProcessId.PreludeProcessId) {
            return new XPreludeEncoder(ctx, ssaMap, dataFlowEncoder);
        }
        if (processId == XProcessId.PostludeProcessId) {
            return new XPostludeEncoder(ctx, ssaMap, dataFlowEncoder);
        }
        return new XProcessEncoder(ctx, ssaMap, dataFlowEncoder);
    }
}
