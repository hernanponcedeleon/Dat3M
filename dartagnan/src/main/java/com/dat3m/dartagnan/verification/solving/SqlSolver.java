package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.encoding.sql.SelectSqlEncoder;
import com.dat3m.dartagnan.program.SqlProgram;
import com.dat3m.dartagnan.program.event.sql.CreateEvent;
import com.dat3m.dartagnan.program.event.sql.SelectEvent;
import com.dat3m.dartagnan.verification.VerificationTask;
import io.github.cvc5.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.*;


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
        this.solver.setOption("incremental", "true");
    }

    public static SqlSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException, CVC5ApiException {
        SqlSolver s = new SqlSolver(ctx, prover, task);
        s.run();
        return s;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException {

        SqlProgram program = (SqlProgram) task.getProgram();

        for (CreateEvent cEvt : program.getTable_create_stms()) {
            CreateSqlEncoder.Table t = cEvt.sqlExpression.accept(new CreateSqlEncoder(tm));

            tables.put(t.name(),t);
        }

        for (SelectEvent sEvt : program.getAssertions()) {
            SelectSqlEncoder enc = new SelectSqlEncoder(tm,sEvt.getGlobalId(),tables);
            Term t = enc.visit(sEvt.sstm);
            logger.info(t.toString());
            solver.assertFormula(t);

            inputVariables.addAll(enc.inputVariables);

        }


        Result r = solver.checkSat();
        logger.info(r.isSat());
        Sort[] sorts = (Sort[]) tables.values().stream().map(table -> table.table()).toList().toArray(new Sort[0]);
        String model = solver.getModel(new Sort[0],inputVariables.toArray(new Term[0]));
        logger.info(model);
    }

}
