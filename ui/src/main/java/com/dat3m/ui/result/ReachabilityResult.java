package com.dat3m.ui.result;

import static com.dat3m.dartagnan.analysis.Refinement.runAnalysisGraphRefinement;
import static com.dat3m.dartagnan.analysis.Base.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.Refinement.runAnalysisGraphRefinementEmptyCoherence;
import static com.dat3m.dartagnan.utils.Result.FAIL;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.options.utils.Method;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class ReachabilityResult implements Dat3mResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;

    private Graph graph;
    private String verdict;

    public ReachabilityResult(Program program, Wmm wmm, UiOptions options){
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        run();
    }
    
    public Graph getGraph(){
        return graph;
    }

    public String getVerdict(){
        return verdict;
    }

    private void run(){
        if(validate()){
            Context ctx = new Context();
            Solver solver = ctx.mkSolver();
            Result result = null;
            if (options.getMethod() == Method.GRAPH)
                result = runAnalysisGraphRefinement(solver, ctx, program, wmm, options.getTarget(), options.getSettings());
            else if (options.getMethod() == Method.INCREMENTAL)
                result = runAnalysisIncrementalSolver(solver, ctx, program, wmm, options.getTarget(), options.getSettings());
            buildVerdict(result);
            if(options.getSettings().getDrawGraph() && Dartagnan.canDrawGraph(program.getAss(), result == FAIL)){
                graph = new Graph(solver.getModel(), ctx, program, options.getSettings().getGraphRelations());
            }
            ctx.close();
        }
    }

    private void buildVerdict(Result result){
        StringBuilder sb = new StringBuilder();
        sb.append("Condition ").append(program.getAss().toStringWithType()).append("\n");
        sb.append(result).append("\n");
        verdict = sb.toString();
    }

    private boolean validate(){
        Arch target = program.getArch() == null ? options.getTarget() : program.getArch();
        if(target == null) {
            Utils.showError("Missing target architecture.");
            return false;
        }
        program.setArch(target);
        return true;
    }
}
