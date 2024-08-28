package com.dat3m.dartagnan.encoding;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import com.google.common.collect.ImmutableMap;

public class ProverWithTracker implements AutoCloseable {
    
    private final FormulaManager fmgr;
    private final ProverEnvironment prover;
    private final String fileName;

    public ProverWithTracker(SolverContext ctx, String fileName, ProverOptions... options) {
        this.fmgr = ctx.getFormulaManager();
        this.prover = ctx.newProverEnvironment(options);
        this.fileName = fileName;
        init();
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

    private void removeDuplicatedDeclarations(String fileName) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(fileName));
            List<String> newLines = new ArrayList<>();
            String line;
            while ((line = reader.readLine()) != null) {
                // We only skip repeated declarations
                if (!line.contains("declare-fun") || !newLines.contains(line)) {
                    newLines.add(line);
                }
            }
            reader.close();

            BufferedWriter writer = new BufferedWriter(new FileWriter(fileName));
            for (String newLine : newLines) {
                writer.write(newLine);
                writer.newLine();
            }
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void addConstraint(BooleanFormula f) throws InterruptedException {
        if(!fileName.isEmpty()) {
            write(fmgr.dumpFormula(f).toString());
        }
        prover.addConstraint(f);
    }

    public boolean isUnsatWithAssumptions(Collection<BooleanFormula> fs) throws SolverException, InterruptedException {
        if(!fileName.isEmpty()) {
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
        if(!fileName.isEmpty()) {
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
        if(!fileName.isEmpty()) {
            write("(push)\n");
        }
        prover.push();
    }

    public void pop() {
        if(!fileName.isEmpty()) {
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
            printer.append(content);
            printer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
