package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import com.dat3m.dartagnan.encoding.ProverWithTracker;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.EnumSet;

import static com.dat3m.dartagnan.utils.Result.*;

public class DataRaceSolver extends ModelChecker {

    // This analysis assumes that CAT file defining the memory model has a happens-before
    // relation named hb: it should contain the following axiom "acyclic hb"

    private static final Logger logger = LogManager.getLogger(DataRaceSolver.class);

    private final SolverContext ctx;
    private final ProverWithTracker prover;
    private final VerificationTask task;

    private DataRaceSolver(SolverContext c, ProverWithTracker p, VerificationTask t) {
        ctx = c;
        prover = p;
        task = t;
    }

    public static DataRaceSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        DataRaceSolver s = new DataRaceSolver(ctx, prover, task);
        s.run();
        return s;
    }

    private void run() throws InterruptedException, SolverException, InvalidConfigurationException {
        Wmm memoryModel = task.getMemoryModel();
        Context analysisContext = Context.create();
        Configuration config = task.getConfig();

        memoryModel.configureAll(config);
        preprocessProgram(task, config);
        preprocessMemoryModel(task, config);
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);

        context = EncodingContext.of(task, analysisContext, ctx.getFormulaManager());
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context);
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());
        prover.push();
        prover.writeComment("Property encoding");
        prover.addConstraint(propertyEncoder.encodeProperties(EnumSet.of(Property.DATARACEFREEDOM)));

        logger.info("Starting first solver.check()");
        if (prover.isUnsat()) {
            prover.pop();
            prover.writeComment("Bound encoding");
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat() ? PASS : UNKNOWN;
        } else {
            res = FAIL;
        }

        logger.info("Verification finished with result " + res);
    }
}