package porthosc.languages.syntax.xgraph.program;

import com.google.common.collect.ImmutableList;
import com.microsoft.z3.BoolExpr;
import com.microsoft.z3.Context;
import com.microsoft.z3.Z3Exception;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.memories.XLocalLvalueMemoryUnit;
import porthosc.languages.syntax.xgraph.process.XProcess;
import porthosc.languages.syntax.xgraph.process.XProcessId;
import porthosc.memorymodels.wmm.*;

import java.util.Set;


public final class XProgram extends XProgramBase<XProcess> {

    XProgram(ImmutableList<XProcess> processes) {
        super(processes);
    }

    public XProcess getProcess(XProcessId processId) {
        for (XProcess process : getProcesses()) {
            if (process.getId() == processId) {
                return process;
            }
        }
        throw new IllegalArgumentException("Process not found: " + processId);
    }


    public int compareTopologically(XEvent one, XEvent two) {
        XProcessId pid = one.getProcessId();
        if (pid != two.getProcessId()) {
            throw new IllegalArgumentException("Comparing events must belong to the same process");
        }
        XProcess process = getProcess(pid);
        return process.compareTopologically(one, two);
    }

    public int compareTopologicallyAndCondLevel(XEvent one, XEvent two) {
        XProcessId pid = one.getProcessId();
        if (pid != two.getProcessId()) {
            throw new IllegalArgumentException("Comparing events must belong to the same process");
        }
        XProcess process = getProcess(pid);
        return process.compareTopologicallyAndCondLevel(one, two);
    }

    public Set<XLocalLvalueMemoryUnit> getCondRegs(XEvent event) {
        return getProcess(event.getProcessId()).getCondRegs(event);
    }


    public BoolExpr encodeMM(Context ctx, MemoryModel.Kind mcm) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        switch (mcm){
            case SC:
                enc = ctx.mkAnd(enc, SC.encode(this, ctx));
                break;
            case TSO:
                enc = ctx.mkAnd(enc, TSO.encode(this, ctx));
                break;
            case PSO:
                enc = ctx.mkAnd(enc, PSO.encode(this, ctx));
                break;
            case RMO:
                enc = ctx.mkAnd(enc, RMO.encode(this, ctx));
                break;
            case Alpha:
                enc = ctx.mkAnd(enc, Alpha.encode(this, ctx));
                break;
            case Power:
                enc = ctx.mkAnd(enc, Power.encode(this, ctx));
                break;
            case ARM:
                enc = ctx.mkAnd(enc, ARM.encode(this, ctx));
                break;
            default:
                throw new IllegalStateException();
        }
        return enc;
    }


    public BoolExpr encodeConsistent(Context ctx, MemoryModel.Kind mcm) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        switch (mcm){
            case SC:
                enc = ctx.mkAnd(enc, SC.Consistent(this, ctx));
                break;
            case TSO:
                enc = ctx.mkAnd(enc, TSO.Consistent(this, ctx));
                break;
            case PSO:
                enc = ctx.mkAnd(enc, PSO.Consistent(this, ctx));
                break;
            case RMO:
                enc = ctx.mkAnd(enc, RMO.Consistent(this, ctx));
                break;
            case Alpha:
                enc = ctx.mkAnd(enc, Alpha.Consistent(this, ctx));
                break;
            case Power:
                enc = ctx.mkAnd(enc, Power.Consistent(this, ctx));
                break;
            case ARM:
                enc = ctx.mkAnd(enc, ARM.Consistent(this, ctx));
                break;
            default:
                throw new IllegalStateException();
        }
        return enc;
    }

    public BoolExpr encodeInconsistent(Context ctx, MemoryModel.Kind mcm) throws Z3Exception {
        BoolExpr enc = ctx.mkTrue();
        switch (mcm) {
            case SC:
                enc = ctx.mkAnd(enc, SC.Inconsistent(this, ctx));
                break;
            case TSO:
                enc = ctx.mkAnd(enc, TSO.Inconsistent(this, ctx));
                break;
            case PSO:
                enc = ctx.mkAnd(enc, PSO.Inconsistent(this, ctx));
                break;
            case RMO:
                enc = ctx.mkAnd(enc, RMO.Inconsistent(this, ctx));
                break;
            case Alpha:
                enc = ctx.mkAnd(enc, Alpha.Inconsistent(this, ctx));
                break;
            case Power:
                enc = ctx.mkAnd(enc, Power.Inconsistent(this, ctx));
                break;
            case ARM:
                enc = ctx.mkAnd(enc, ARM.Inconsistent(this, ctx));
                break;
            default:
                System.out.println("Check encodeInconsistent!");
        }
        return enc;
    }

}
