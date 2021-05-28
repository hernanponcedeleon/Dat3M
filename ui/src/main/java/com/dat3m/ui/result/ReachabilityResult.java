package com.dat3m.ui.result;

import static com.dat3m.dartagnan.analysis.Base.runAnalysisIncrementalSolver;
import static com.dat3m.dartagnan.analysis.Base.runAnalysis;
import static com.dat3m.ui.options.utils.Method.INCREMENTAL;
import static com.dat3m.ui.options.utils.Method.TWOSOLVERS;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.utils.UiOptions;
import com.dat3m.ui.utils.Utils;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class ReachabilityResult {

    private final Program program;
    private final Wmm wmm;
    private final UiOptions options;

    private String verdict;

    public ReachabilityResult(Program program, Wmm wmm, UiOptions options){
        this.program = program;
        this.wmm = wmm;
        this.options = options;
        run();
    }
    
    public String getVerdict(){
        return verdict;
    }

    private void run(){
        if(validate()){
            VerificationTask task = new VerificationTask(program, wmm, options.getTarget(), options.getSettings());
            Context ctx = new Context();
            Solver solver = ctx.mkSolver();
            Result result = null;
            if (options.getMethod() == INCREMENTAL)
                result = runAnalysisIncrementalSolver(solver, ctx, task);
            else if (options.getMethod() == TWOSOLVERS)
                result = runAnalysis(solver, ctx, task);
            buildVerdict(result);
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
