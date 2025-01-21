package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.ProverWithTracker;
import com.dat3m.dartagnan.encoding.sql.CreateSqlEncoder;
import com.dat3m.dartagnan.encoding.sql.SelectSqlEncoder;
import com.dat3m.dartagnan.program.SqlProgram;
import com.dat3m.dartagnan.program.event.sql.CreateEvent;
import com.dat3m.dartagnan.program.event.sql.SelectEvent;
import com.dat3m.dartagnan.verification.VerificationTask;
import io.github.cvc5.Solver;
import io.github.cvc5.Sort;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;


public class SqlSolver extends ModelChecker {
    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    private final SolverContext ctx;
    private final ProverWithTracker prover;
    private final VerificationTask task;

    private final Solver solver = new Solver();

    private final Map<String, CreateSqlEncoder.Table> tables = new HashMap<>();

    private SqlSolver(SolverContext c, ProverWithTracker p, VerificationTask t) {
        ctx = c;
        prover = p;
        task = t;
    }

    public static SqlSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        SqlSolver s = new SqlSolver(ctx, prover, task);
        s.run();
        return s;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException {

        SqlProgram program = (SqlProgram) task.getProgram();

        for (CreateEvent cEvt : program.getTable_create_stms()) {
            CreateSqlEncoder.Table t = cEvt.sqlExpression.accept(new CreateSqlEncoder(solver));
            tables.put(t.name(),t);
        }

        for (SelectEvent sEvt : program.getAssertions()) {
            sEvt.sstm.accept(new SelectSqlEncoder(solver,sEvt.getGlobalId(),tables));
        }

        logger.info("Pause");
    }

}
