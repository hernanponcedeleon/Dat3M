package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.program.SqlProgram;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.sql.*;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.google.common.collect.Collections2;
import com.google.common.collect.Sets;
import io.github.cvc5.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Stream;


public class SqlSolver extends ModelChecker {
    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    private final SolverContext ctx;
    private final ProverWithTracker prover;
    private final VerificationTask task;

    private final Solver solver;
    private final TermManager tm;

    private final Map<String, CreateSqlEncoder.Table> tables = new HashMap<>();
    public List<Term> inputVariables = new ArrayList<>();

    private SqlSolver(SolverContext c, ProverWithTracker p, VerificationTask t) throws CVC5ApiException {
        ctx = c;
        prover = p;
        task = t;


        this.tm = new TermManager();
        this.solver = new Solver(tm);

        this.solver.setLogic("HO_ALL");
        this.solver.setOption("produce-models", "true");
        this.solver.setOption("produce-unsat-cores", "true");
        this.solver.setOption("output-language", "smtlib2");
    }

    public static SqlSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException, CVC5ApiException {

        SqlSolver s = new SqlSolver(ctx, prover, task);
        s.run();
        return s;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException {

        SqlProgram program = (SqlProgram) task.getProgram();

        List<AbstractSqlEvent> all_events = new ArrayList<>(program.getThreadEvents(AbstractSqlEvent.class));
        all_events.addAll(program.getAssertions());

        for (AbstractSqlEvent evt : all_events) {
            logger.info("{}__{}", evt.getGlobalId(), evt);
        }

        for (CreateEvent cEvt : program.getTable_create_stms()) {
            CreateSqlEncoder.Table t = cEvt.sqlExpression.accept(new CreateSqlEncoder(tm));

            tables.put(t.name(), t);
        }

        for (AssertionEvent sEvt : program.getAssertions()) {
            Term t = sEvt.encode(tm, tables);

            solver.assertFormula(t);
        }

        for (AbstractSqlEvent sEvt : program.getThreadEvents(AbstractSqlEvent.class)) {
            Term t = sEvt.encode(tm, tables);

            solver.assertFormula(t);
        }

        //Encode the Dataflow
        /*
        Each operation/statement generates a patch/subset. A read the patches of all visible are stacked.
         */
        ConstHelper constHelper = new ConstHelper();

        List<Term> dataflows = new ArrayList<>();
        for (AbstractSqlEvent sEvt : all_events) {

            for (AbstractSqlEvent.Table input : sEvt.getInputTables()) {
                List<Term> implications = new ArrayList<>();
                //This is the List of all Operations that write to the table
                List<AbstractSqlEvent> potential_vis_set = all_events.stream()
                        .filter(evt -> !evt.equals(sEvt))
                        .filter(evt -> evt.getOutputTable() != null)
                        .filter(evt -> input.table_name().equals(evt.getOutputTable().table_name()))
                        .toList();

                for (Set<AbstractSqlEvent> subset : Sets.powerSet(new HashSet<>(potential_vis_set))) {
                    List<Term> premise_vis_list = new ArrayList<>();
                    //Premise
                    //VIS Premises
                    for (AbstractSqlEvent evt : potential_vis_set) {
                        Term vis_helper = constHelper.getVISConst(evt, sEvt);
                        if (subset.contains(evt)) {
                            premise_vis_list.add(vis_helper);
                        } else {
                            premise_vis_list.add(tm.mkTerm(Kind.NOT, vis_helper));
                        }
                    }
                    //AR Premises
                    for (List<AbstractSqlEvent> permutation :
                            Collections2.permutations(subset).stream().toList()
                    ) {
                        List<Term> premise_list = new ArrayList<>(premise_vis_list);
                        Term bag = tm.mkEmptyBag(tables.get(input.table_name()).table());
                        for (int idx = 0; idx < permutation.size(); idx++) {
                            AbstractSqlEvent e = permutation.get(idx);
                            if (idx > 0) {
                                premise_list.add(constHelper.getARConst(permutation.get(idx - 1), e));
                            }
                            if (e instanceof InsertEvent) {
                                bag = tm.mkTerm(Kind.BAG_UNION_MAX, e.getOutputTable().constant(), bag);
                            } else if (e instanceof DeleteEvent) {
                                bag = tm.mkTerm(Kind.BAG_DIFFERENCE_SUBTRACT, bag, e.getOutputTable().constant());
                            }

                        }
                        premise_list.add(tm.mkTrue());// just to make the code smaller.
                        //if the list has only one member the true element is neutral against AND so avoid if clause
                        Term premis = tm.mkTerm(Kind.AND, premise_list.toArray(new Term[0]));
                        Term conclusion = tm.mkTerm(Kind.EQUAL, input.constant(), bag);

                        implications.add(tm.mkTerm(Kind.IMPLIES, premis, conclusion));
                    }

                }
                solver.assertFormula(tm.mkTerm(Kind.AND, implications.toArray(new Term[0])));
            }

        }


        //TODO put in CAT
        solver.assertFormula(constHelper.getARdistinct());


        File file = new File("cvc5_assertions.smt2");
        try (FileWriter writer = new FileWriter(file, false);
             PrintWriter printer = new PrintWriter(writer)) {
            for (Term t : solver.getAssertions()) {
                printer.append(t.toString());
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

        logger.info("Start solver ------");


        Result r = solver.checkSat();
        logger.info(r.isSat());
        if (r.isSat()) {
            Stream<Term> alltables = all_events.stream().flatMap(evt -> evt.getTables().stream());
            Stream<Term> visibility = constHelper.vis_consts.values().stream();
            Stream<Term> arbitration = constHelper.ar_consts.values().stream();

            List<Term> terms = Stream.concat(alltables, Stream.concat(visibility, arbitration)).toList();
            String model = solver.getModel(new Sort[0], terms.toArray(new Term[0]));

            logger.info(model);
        } else {
            for (Term t : solver.getUnsatCore()) {
                logger.info(t);
            }
        }


    }

    private class ConstHelper {
        Map<String, Term> vis_consts = new HashMap<>();
        Map<String, Term> ar_consts = new HashMap<>();

        Term getVISConst(Event a, Event b) {
            String name = "VIS_" + a.getGlobalId() + "_" + b.getGlobalId();

            if (vis_consts.containsKey(name)) {
                return vis_consts.get(name);
            }
            Term con = tm.mkConst(tm.getBooleanSort(), name);
            vis_consts.put(name, con);
            return con;
        }

        Term getARConst(Event a, Event b) {
            String name = "AR_" + a.getGlobalId() + "_" + b.getGlobalId();

            if (ar_consts.containsKey(name)) {
                return ar_consts.get(name);
            }
            Term con = tm.mkConst(tm.getBooleanSort(), name);
            ar_consts.put(name, con);
            return con;
        }

        Term getARdistinct() {
            if (ar_consts.isEmpty()) {
                return tm.mkTrue();
            }
            List<Term> t = new ArrayList<>();
            Set<String> ar_links = new HashSet<>(ar_consts.keySet());
            for (String ar : ar_links) {
                Term con = ar_consts.get(ar);

                String[] parts = ar.split("_");
                String ar_ = parts[0] + "_" + parts[2] + "_" + parts[1];

                Term con_ = ar_consts.get(ar_);
                //TODO avoid duplicate distinct
                //ar_links.remove(ar_);

                t.add(tm.mkTerm(Kind.DISTINCT, con, con_));

            }
            return tm.mkTerm(Kind.AND, t.toArray(new Term[0]));
        }
    }

}
