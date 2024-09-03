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
        try {
            Files.deleteIfExists(Paths.get(fileName));
            write("(set-info :smt-lib-version 2.6)\n");
            write("(set-logic ALL)\n");
            write("(set-info :category industrial)\n");
            write("(set-info :source |\n" + description + "\n|)\n");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void close() throws Exception {
        removeDuplicatedDeclarations(fileName);
        write("(exit)\n");
        prover.close();
    }

    public void addConstraint(BooleanFormula f) throws InterruptedException {
        if(dump()) {
            write(fmgr.dumpFormula(f).toString());
        }
        prover.addConstraint(f);
    }

    public boolean isUnsatWithAssumptions(Collection<BooleanFormula> fs) throws SolverException, InterruptedException {
        boolean result = prover.isUnsatWithAssumptions(fs);
        String resultString = result ? "unsat" : "sat";
        if(dump()) {
            write("(push)\n");
            for(BooleanFormula f : fs) {
                write(fmgr.dumpFormula(f).toString());
            }
            write("(set-info :status " + resultString + ")\n");
            write("(check-sat)\n");
            write("(pop)\n");
        }
        return result;
    }

    public boolean isUnsat() throws SolverException, InterruptedException {
        boolean result = prover.isUnsat();
        String resultString = result ? "unsat" : "sat";
        if(dump()) {
            write("(set-info :status " + resultString + ")\n");
            write("(check-sat)\n");
        }
        return result;
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
