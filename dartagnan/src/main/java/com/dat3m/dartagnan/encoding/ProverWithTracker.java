package com.dat3m.dartagnan.encoding;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import com.google.common.collect.ImmutableMap;

public class ProverWithTracker implements AutoCloseable {

    private final FormulaManager fmgr;
    private final ProverEnvironment prover;
    private final String fileName;
    private final Set<String> declarations;

    public ProverWithTracker(SolverContext ctx, String fileName, ProverOptions... options) {
        this.fmgr = ctx.getFormulaManager();
        this.prover = ctx.newProverEnvironment(options);
        this.fileName = fileName;
        this.declarations = new HashSet<>();
        init();
    }

    // An empty filename means there is no need to dump the encoding
    private boolean dump() {
        return !fileName.isEmpty();
    }
    
    private void init() {
        try {
            Files.deleteIfExists(Paths.get(fileName));
            write("(set-logic ALL)\n");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void close() throws Exception {
        removeDuplicatedDeclarations(fileName);
        prover.close();
    }

    public void addConstraint(BooleanFormula f) throws InterruptedException {
        if(dump()) {
            write(fmgr.dumpFormula(f).toString());
        }
        prover.addConstraint(f);
    }

    public boolean isUnsatWithAssumptions(Collection<BooleanFormula> fs) throws SolverException, InterruptedException {
        if(dump()) {
            write("(push)\n");
            for(BooleanFormula f : fs) {
                write(fmgr.dumpFormula(f).toString());
            }
            write("(check-sat)\n");
            write("(pop)\n");
        }
        return prover.isUnsatWithAssumptions(fs);
    }

    public boolean isUnsat() throws SolverException, InterruptedException {
        if(dump()) {
            write("(check-sat)\n");
        }
        return prover.isUnsat();
    }

    public ImmutableMap<String, String> getStatistics() {
        return prover.getStatistics();
    }

    public Model getModel() throws SolverException {
        return prover.getModel();
    }

    public void push() throws InterruptedException {
        if(dump()) {
            write("(push)\n");
        }
        prover.push();
    }

    public void pop() {
        if(dump()) {
            write("(pop)\n");
        }
        prover.pop();
    }

    private void write(String content) {
        File file = new File(fileName);
        FileWriter writer;
        try {
            writer = new FileWriter(file, true);
            PrintWriter printer = new PrintWriter(writer);
            printer.append(removeDuplicatedDeclarations(content));
            printer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private String removeDuplicatedDeclarations(String content) {
        String output = "";
        for(String line : content.split("\n")) {
            if(line.contains("declare-fun") && !declarations.add(line)) {
                continue;
            }
            output += line + "\n";
        }
        return output;
    }
}
