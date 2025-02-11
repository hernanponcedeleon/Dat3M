package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.program.SqlProgram;
import com.dat3m.dartagnan.program.event.sql.AbstractSqlEvent;
import com.dat3m.dartagnan.program.event.sql.CreateEvent;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import com.google.common.collect.Table;
import io.github.cvc5.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.solvers.cvc5.CVC5Formula;
import org.sosy_lab.java_smt.solvers.cvc5.CVC5FormulaCreator;
import org.sosy_lab.java_smt.solvers.cvc5.CVC5SolverContext;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import static java.util.Collections.singletonList;


public class SqlSolver extends ModelChecker {
    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    private final CVC5SolverContext ctx;
    private final ProverWithTracker prover;
    private final VerificationTask task;

    private final Solver solver;
    private final CVC5FormulaCreator formula_creator;

    //private final Map<String, CreateSqlEncoder.Table> tables = new HashMap<>();
    public List<Term> inputVariables = new ArrayList<>();

    private SqlSolver(SolverContext c, ProverWithTracker p, VerificationTask t) throws CVC5ApiException, NoSuchFieldException, IllegalAccessException, ClassNotFoundException {


        task = t;
        ctx = (CVC5SolverContext) c;
        prover = p;
        formula_creator = (CVC5FormulaCreator) ((org.sosy_lab.java_smt.basicimpl.AbstractFormulaManager)ctx.getFormulaManager()).getFormulaCreator();

        Class<?> clazz_basic = Class.forName("org.sosy_lab.java_smt.basicimpl.withAssumptionsWrapper.BasicProverWithAssumptionsWrapper");
        Field proverField = clazz_basic.getDeclaredField("delegate");
        proverField.setAccessible(true);
        Object CVC5AbstractProver = proverField.get(prover.getProverEnvironment());

        Class<?> clazz = Class.forName("org.sosy_lab.java_smt.solvers.cvc5.CVC5AbstractProver");
        Field solverField = clazz.getDeclaredField("solver");
        solverField.setAccessible(true);
        this.solver = (Solver) solverField.get(CVC5AbstractProver);

        this.solver.setLogic("HO_ALL");
        this.solver.setOption("produce-models", "true");
        this.solver.setOption("output-language", "smtlib2");


//        for(String name :solver.getOptionNames()){
//            try {
//                logger.info("{} = {}", name, solver.getOption(name));
//            } catch (Exception ignored) {}
//        }
    }

    public static SqlSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException, CVC5ApiException, NoSuchFieldException, IllegalAccessException, ClassNotFoundException, InvocationTargetException, InstantiationException {

        SqlSolver s = new SqlSolver(ctx, prover, task);
        s.run();
        return s;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException, ClassNotFoundException, InvocationTargetException, InstantiationException, IllegalAccessException, NoSuchFieldException {
        Wmm memoryModel = task.getMemoryModel();
        com.dat3m.dartagnan.verification.Context analysisContext = Context.create();
        Configuration config = task.getConfig();

        memoryModel.configureAll(config);

        //For SQL Programs this does not do much but can in future iterations
        preprocessProgram(task, config);
        preprocessMemoryModel(task, config);
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);

        context = EncodingContext.of(task, analysisContext, ctx.getFormulaManager(), solver, formula_creator);
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
        BooleanFormula propertyEncoding = propertyEncoder.encodeProperties(task.getProperty());
        BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEncoding);
        prover.writeComment("Property encoding");
        prover.addConstraint(assumedSpec);


        File file = new File("cvc5_assertions.smt2");
        try (FileWriter writer = new FileWriter(file, false);
             PrintWriter printer = new PrintWriter(writer)) {
            for (Term t : context.solver.getAssertions()) {
                printer.append(t.toString()).append("\n");
                logger.info(t.toString());
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        logger.info("------ Start solver ------");

        boolean any_execution = !prover.isUnsat();

        logger.info("Can there be any execution? {}", any_execution);
        if(any_execution) {
            Field field_variablesCache = CVC5FormulaCreator.class.getDeclaredField("variablesCache");
            field_variablesCache.setAccessible(true);
            Table<String, String, Term> variablesCache = (Table<String, String, Term>) field_variablesCache.get(context.formula_creator);
            logger.info(solver.getModel(new Sort[0], variablesCache.values().toArray(new Term[0])));
        }else{
            for(Formula f :prover.getUnsatCore()){
                logger.info(f);
            };
        }

        //Does one execution violates the property
        prover.addConstraint(assumptionLiteral);
        boolean isUnsat = prover.isUnsat();
        logger.info("Is the Assertion Violated? {}", !isUnsat);
        if(!isUnsat) {
            Field field_variablesCache = CVC5FormulaCreator.class.getDeclaredField("variablesCache");
            field_variablesCache.setAccessible(true);
            Table<String, String, Term> variablesCache = (Table<String, String, Term>) field_variablesCache.get(context.formula_creator);
            logger.info(solver.getModel(new Sort[0], variablesCache.values().toArray(new Term[0])));
        }else{
            for(Formula f :prover.getUnsatCore()){
                logger.info(f);
            };
        }


        //logger.info(prover.getModelAssignments());

    }
}