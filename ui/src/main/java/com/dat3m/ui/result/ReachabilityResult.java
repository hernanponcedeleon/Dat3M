package com.dat3m.ui.result;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.ui.options.utils.Options;
import com.dat3m.ui.utils.Utils;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class ReachabilityResult implements Dat3mResult {

    private final Program program;
    private final Wmm wmm;
    private final Options options;

    private Graph graph;
    private String verdict;

    public ReachabilityResult(Program program, Wmm wmm, Options options){
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

            if(options.getDrawGraph()) {
                wmm.setDrawExecutionGraph();
                wmm.addDrawRelations(Graph.getDefaultRelations());
                wmm.addDrawRelations(options.getRelations());
            }

            boolean result = Dartagnan.testProgram(solver, ctx, program, wmm, program.getArch(), options.getBound(),
                    options.getMode(), options.getAlias());

            buildVerdict(result);

            if(options.getDrawGraph() && Dartagnan.canDrawGraph(program.getAss(), result)){
                graph = new Graph(solver.getModel(), ctx, program, options.getRelations().toArray(new String[0]));
            }
            ctx.close();
        }
    }

    private void buildVerdict(boolean result){
        StringBuilder sb = new StringBuilder();
        if(program.getAssFilter() != null){
            sb.append("Filter ").append(program.getAssFilter());
        }
        sb.append("Condition ").append(program.getAss().toStringWithType()).append("\n");
        sb.append(result ? "OK" : "No").append("\n");
        verdict = sb.toString();
    }

    private boolean validate(){
        Arch target = program.getArch() == null ? options.getTarget() : program.getArch();
        if(target == null) {
            Utils.showError("Missing target architecture.");
            return false;
        }
        if(program.getAss() == null){
            Utils.showError("Program must include assertion clause.");
            return false;
        }
        program.setArch(target);
        return true;
    }
}
