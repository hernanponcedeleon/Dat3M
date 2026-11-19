package com.dat3m.dartagnan.smt;

import com.google.common.collect.ImmutableMap;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import java.io.IOException;
import java.nio.file.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

import static java.nio.file.StandardOpenOption.*;

public class ProverWithTracker implements ProverEnvironment {

    private final FormulaManager fmgr;
    private final ProverEnvironment prover;
    private final Path dumpFilePath;
    private final Set<String> declarations;

    public ProverWithTracker(SolverContext ctx, Path dumpFilePath, ProverOptions... options) {
        this.fmgr = ctx.getFormulaManager();
        this.prover = ctx.newProverEnvironment(options);
        this.dumpFilePath = dumpFilePath;
        this.declarations = new HashSet<>();
        init();
    }

    private boolean dump() {
        return dumpFilePath != null;
    }

    private void init() {
        if (!dump()) {
            return;
        }

        try {
            Files.deleteIfExists(dumpFilePath);
        } catch (IOException e) {
            e.printStackTrace();
        }

        StringBuilder description = new StringBuilder();
        LocalDate currentDate = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        description.append("Generated on: ").append(currentDate.format(formatter)).append("\n");
        description.append("Generator: Dartagnan\n");
        description.append("Application: Bounded model checking for weak memory models\n");
        description.append("""
                Publications:\s
                - Hernán Ponce de León, Florian Furbach, Keijo Heljanko, \
                Roland Meyer: Dartagnan: Bounded Model Checking for Weak Memory Models \
                (Competition Contribution). TACAS (2) 2020: 378-382
                - Thomas Haas, Roland Meyer, Hernán Ponce de León: \
                CAAT: consistency as a theory. Proc. ACM Program. Lang. 6(OOPSLA2): 114-144 (2022)"""
        );
        write("(set-info :smt-lib-version 2.6)\n");
        write("(set-logic ALL)\n");
        write("(set-info :category \"industrial\")\n");
        write("(set-info :source |\n" + description + "\n|)\n");
        write("(set-info :license \"https://creativecommons.org/licenses/by/4.0/\")\n");
    }

    @Override
    public void close() {
        if(dump()) {
            write("(exit)\n");
        }
        prover.close();
    }

    @Override
    public Void addConstraint(BooleanFormula f) throws InterruptedException {
        if(dump()) {
            write(fmgr.dumpFormula(f).toString());
        }
        return prover.addConstraint(f);
    }

    @Override
    public boolean isUnsatWithAssumptions(Collection<BooleanFormula> fs) throws SolverException, InterruptedException {

        if(dump()) {
            write("(push 1)\n");
            for(BooleanFormula f : fs) {
                write(fmgr.dumpFormula(f).toString());
            }
        }

        long start = System.currentTimeMillis();
        boolean result = prover.isUnsatWithAssumptions(fs);
        long end = System.currentTimeMillis();

        if(dump()) {
            write("(set-info :status " + (result ? "unsat" : "sat") + ")\n");
            write("(check-sat)\n");
            writeComment("Original solving time: " + (end - start) + " ms");
            write("(pop 1)\n");
        }

        return result;
    }

    @Override
    public boolean isUnsat() throws SolverException, InterruptedException {
        long start = System.currentTimeMillis();
        boolean result = prover.isUnsat();
        long end = System.currentTimeMillis();
        if(dump()) {
            write("(set-info :status " + (result ? "unsat" : "sat") + ")\n");
            write("(check-sat)\n");
            writeComment("Original solving time: " + (end - start) + " ms");
        }
        return result;
    }

    @Override
    public ImmutableMap<String, String> getStatistics() {
        return prover.getStatistics();
    }

    @Override
    public Model getModel() throws SolverException {
        return prover.getModel();
    }

    @Override
    public void push() throws InterruptedException {
        if(dump()) {
            write("(push 1)\n");
        }
        prover.push();
    }

    @Override
    public void pop() {
        if(dump()) {
            write("(pop 1)\n");
        }
        prover.pop();
    }

    @Override
    public <R> R allSat(AllSatCallback<R> arg0, List<BooleanFormula> arg1) throws InterruptedException, SolverException {
        return prover.allSat(arg0, arg1);
    }

    @Override
    public boolean registerUserPropagator(UserPropagator propagator) {
        return prover.registerUserPropagator(propagator);
    }

    @Override
    public List<BooleanFormula> getUnsatCore() {
        return prover.getUnsatCore();
    }

    @Override
    public int size() {
        return prover.size();
    }

    @Override
    public Optional<List<BooleanFormula>> unsatCoreOverAssumptions(Collection<BooleanFormula> arg0)
            throws SolverException, InterruptedException {
        return prover.unsatCoreOverAssumptions(arg0);
    }

    private void write(String content) {
        if (!dump()) {
            return;
        }

        try {
            Files.writeString(dumpFilePath, removeDuplicatedDeclarations(content),  WRITE, APPEND, CREATE);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void writeComment(String content) {
        write("; " + content);
    }

    // FIXME: This is only correct as long as no declarations are popped and then
    //  later redeclared (which is currently guaranteed by the way we use the solver)
    private StringBuilder removeDuplicatedDeclarations(String content) {
        StringBuilder builder = new StringBuilder();
        for(String line : content.split("\n")) {
            if(line.contains("declare-fun") && !declarations.add(line)) {
                continue;
            }
            builder.append(line).append("\n");
        }
        return builder;
    }
}
