package porthosc.languages.conversion.tozformula.process;

import com.microsoft.z3.BoolExpr;
import porthosc.languages.syntax.xgraph.process.XProcess;


public interface XFlowGraphEncoder {

    BoolExpr encodeProcess(XProcess process);

    BoolExpr encodeProcessRFRelation(XProcess process);
}
