package com.dat3m.dartagnan.encoding;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collection;

import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.FormulaManager;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import com.google.common.collect.ImmutableMap;

public class ProverWithTracker implements AutoCloseable {
    
    private final FormulaManager fmgr;
    private final ProverEnvironment prover;
    private final String fileName;
    private BooleanFormula enc;

    public ProverWithTracker(SolverContext ctx, String filename, ProverOptions... options) {
        this.fmgr = ctx.getFormulaManager();
        this.prover = ctx.newProverEnvironment(options);
        this.enc = ctx.getFormulaManager().getBooleanFormulaManager().makeTrue();
        this.fileName = filename;
    }

    @Override
    public void close() throws Exception {
        if(!fileName.isEmpty()) {
            File file = new File(fileName);
            FileWriter writer;
            try {
                writer = new FileWriter(file, true);
                PrintWriter printer = new PrintWriter(writer);
                printer.append("(set-logic ALL)\n");
                printer.append(fmgr.dumpFormula(enc).toString());
                printer.append("(check-sat)");
                printer.close();
            } catch (IOException e) {
                e.printStackTrace();
            }    
        }
        prover.close();
    }

    public void addConstraint(BooleanFormula f) throws InterruptedException {
        if(!fileName.isEmpty()) {
            enc = fmgr.getBooleanFormulaManager().and(f, enc);
        }
        prover.addConstraint(f);
    }

    public boolean isUnsatWithAssumptions(Collection<BooleanFormula> f) throws SolverException, InterruptedException {
        return prover.isUnsatWithAssumptions(f);
    }

    public boolean isUnsat() throws SolverException, InterruptedException {
        return prover.isUnsat();
    }

    public ImmutableMap<String, String> getStatistics() {
        return prover.getStatistics();
    }

    public Model getModel() throws SolverException {
        return prover.getModel();
    }

    public void push() throws InterruptedException {
        prover.push();
    }

    public void pop() {
        prover.pop();
    }
}
