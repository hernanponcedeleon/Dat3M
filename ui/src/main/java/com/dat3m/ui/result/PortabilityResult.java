package com.dat3m.ui.result;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.utils.Graph;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.porthos.Porthos;
import com.dat3m.porthos.PorthosResult;
import com.dat3m.ui.options.Options;
import com.microsoft.z3.Context;
import com.microsoft.z3.Solver;

public class PortabilityResult implements Dat3mResult {

    private final Program sourceProgram;
    private final Program targetProgram;
    private final Wmm sourceWmm;
    private final Wmm targetWmm;
    private final Options options;
    private boolean isSat = false;

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

    public Program getSourceProgram() {
    	return sourceProgram;
    }
    
    public Program getTargetProgram() {
    	return targetProgram;
    }
    
    public Graph getGraph(){
        return graph;
    }

    public String getVerdict(){
        return verdict;
    }

    private void run(){
        Context ctx = new Context();
        Solver s1 = ctx.mkSolver();
        Solver s2 = ctx.mkSolver();

        PorthosResult result = Porthos.testProgram(s1, s2, ctx, sourceProgram, targetProgram, options.getSource(),
                options.getTarget(), sourceWmm, targetWmm, options.getBound(), options.getMode(), options.getAlias());

        verdict = "The program is" + (result.getIsPortable() ? " " : " not ") + "state-portable\n"
                + "Iterations: " + result.getIterations();

        if(!result.getIsPortable()){
            graph = new Graph(s1.getModel(), ctx);
            graph.build(sourceProgram, targetProgram);
            isSat = true;
        }
        ctx.close();
    }

	@Override
	public boolean isSat() {
		return isSat;
	}
}
