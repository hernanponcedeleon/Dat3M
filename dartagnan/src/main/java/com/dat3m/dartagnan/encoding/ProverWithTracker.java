package com.dat3m.dartagnan.encoding;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.SolverContext.ProverOptions;

import com.google.common.collect.ImmutableMap;

public class ProverWithTracker implements ProverEnvironment {

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
        if(dump()) {
            try {
                Files.deleteIfExists(Paths.get(fileName));
            } catch (IOException e) {
                e.printStackTrace();
            }
            StringBuilder description = new StringBuilder();
            LocalDate currentDate = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("YYYY-MM-DD");
            description.append("Generated on: " + currentDate.format(formatter) + "\n");
            description.append("Generator: Dartagnan\n");
            description.append("Application: Bounded model checking for weak memory models\n");
            description.append("Publications: \n" +
                "- Hernán Ponce de León, Florian Furbach, Keijo Heljanko, " +
                "Roland Meyer: Dartagnan: Bounded Model Checking for Weak Memory Models " +
                "(Competition Contribution). TACAS (2) 2020: 378-382\n" +
                "- Thomas Haas, Roland Meyer, Hernán Ponce de León: " +
                "CAAT: consistency as a theory. Proc. ACM Program. Lang. 6(OOPSLA2): 114-144 (2022)"
            );
            write("(set-info :smt-lib-version 2.6)\n");
            write("(set-logic ALL)\n");
            write("(set-info :category \"industrial\")\n");
            write("(set-info :source |\n" + description + "\n|)\n");
            write("(set-info :license \"https://creativecommons.org/licenses/by/4.0/\")\n");
        }
    }

    @Override
    public void close() {
        if(dump()) {
            removeDuplicatedDeclarations(fileName);
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
        if (dump()) {
            File file = new File(fileName);
            try (FileWriter writer = new FileWriter(file, true);
                    PrintWriter printer = new PrintWriter(writer)) {
                printer.append(removeDuplicatedDeclarations(content));
                printer.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void writeComment(String content) {
        write("; " + content);
    }

    // FIXME: This is only correct as long as no declarations are popped and then
    // later redeclared (which is currently guarenteed by the way we use the solver)
    private StringBuilder removeDuplicatedDeclarations(String content) {
        StringBuilder builder = new StringBuilder();
        for(String line : content.split("\n")) {
            if(line.contains("declare-fun") && !declarations.add(line)) {
                continue;
            }
            builder.append(line + "\n");
        }
        return builder;
    }
}
