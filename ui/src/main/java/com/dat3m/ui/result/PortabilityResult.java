package com.dat3m.ui.result;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.utils.Arch;
import com.dat3m.porthos.Porthos;
import com.dat3m.porthos.PorthosResult;
import com.dat3m.ui.options.utils.Options;
import com.dat3m.ui.utils.Utils;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class PortabilityResult implements Dat3mResult {

    private final Program sourceProgram;
    private final Program targetProgram;
    private final Wmm sourceWmm;
    private final Wmm targetWmm;
    private final Options options;

    private Graph graph;
    private String verdict;

    public PortabilityResult(Program sourceProgram, Program targetProgram, Wmm sourceWmm, Wmm targetWmm, Options options){
        this.sourceProgram = sourceProgram;
        this.targetProgram = targetProgram;
        this.sourceWmm = sourceWmm;
        this.targetWmm = targetWmm;
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
            Solver s1 = ctx.mkSolver();
            Solver s2 = ctx.mkSolver();

            if(options.getDrawGraph()) {
                sourceWmm.setDrawExecutionGraph();
                targetWmm.setDrawExecutionGraph();
                sourceWmm.addDrawRelations(Graph.getDefaultRelations());
                targetWmm.addDrawRelations(Graph.getDefaultRelations());
                sourceWmm.addDrawRelations(options.getRelations());
                targetWmm.addDrawRelations(options.getRelations());
            }

            PorthosResult result = Porthos.testProgram(s1, s2, ctx, sourceProgram, targetProgram, sourceProgram.getArch(),
                    targetProgram.getArch(), sourceWmm, targetWmm, options.getBound(), options.getMode(), options.getAlias());

            verdict = "The program is" + (result.getIsPortable() ? " " : " not ") + "state-portable\n"
                    + "Iterations: " + result.getIterations();

            if(!result.getIsPortable()){
                graph = new Graph(s1.getModel(), ctx, sourceProgram, targetProgram, options.getRelations().toArray(new String[0]));
            }
            ctx.close();
        }
    }

    private boolean validate(){
        Arch sourceArch = sourceProgram.getArch() == null ? options.getSource() : sourceProgram.getArch();
        if(sourceArch == null) {
            Utils.showError("Missing source architecture.");
            return false;
        }
        Arch targetArch = targetProgram.getArch() == null ? options.getTarget() : targetProgram.getArch();
        if(targetArch == null) {
            Utils.showError("Missing target architecture.");
            return false;
        }
        sourceProgram.setArch(sourceArch);
        targetProgram.setArch(targetArch);
        return true;
    }
}
