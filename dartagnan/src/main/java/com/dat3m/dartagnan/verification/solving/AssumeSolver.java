package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.verification.Context;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.verification.model.ExecutionModelManager;
import com.dat3m.dartagnan.verification.model.event.EventModel;
import com.dat3m.dartagnan.verification.model.event.MemoryEventModel;
import com.dat3m.dartagnan.wmm.Wmm;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.*;

import java.math.BigInteger;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

import static com.dat3m.dartagnan.utils.Result.FAIL;
import static com.dat3m.dartagnan.utils.Result.PASS;
import static java.util.Collections.singletonList;

public class AssumeSolver extends ModelChecker {

    private static final Logger logger = LogManager.getLogger(AssumeSolver.class);

    private final SolverContext ctx;
    private final ProverWithTracker prover;
    private final VerificationTask task;

    private AssumeSolver(SolverContext c, ProverWithTracker p, VerificationTask t) {
        ctx = c;
        prover = p;
        task = t;
    }

    public static AssumeSolver run(SolverContext ctx, ProverWithTracker prover, VerificationTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {
        AssumeSolver s = new AssumeSolver(ctx, prover, task);
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
        // For validation this contains information.
        // For verification graph.encode() just returns ctx.mkTrue()
        prover.writeComment("Witness encoding");
        prover.addConstraint(task.getWitness().encode(context));
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());

        // ----------------------------------------
        analyzeValueRanges(prover);
        // ----------------------------------------

        BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();
        BooleanFormula assumptionLiteral = bmgr.makeVariable("DAT3M_spec_assumption");
        BooleanFormula propertyEncoding = propertyEncoder.encodeProperties(task.getProperty());
        BooleanFormula assumedSpec = bmgr.implication(assumptionLiteral, propertyEncoding);
        prover.writeComment("Property encoding");
        prover.addConstraint(assumedSpec);

        logger.info("Starting first solver.check()");
        if (prover.isUnsatWithAssumptions(singletonList(assumptionLiteral))) {
            prover.writeComment("Bound encoding");
            prover.addConstraint(propertyEncoder.encodeBoundEventExec());
            logger.info("Starting second solver.check()");
            res = prover.isUnsat() ? PASS : Result.UNKNOWN;
        } else {
            res = FAIL;
            saveFlaggedPairsOutput(memoryModel, wmmEncoder, prover, context, task.getProgram());
        }

        if (logger.isDebugEnabled()) {
            String smtStatistics = "\n ===== SMT Statistics ===== \n";
            for (String key : prover.getStatistics().keySet()) {
                smtStatistics += String.format("\t%s -> %s\n", key, prover.getStatistics().get(key));
            }
            logger.debug(smtStatistics);
        }

        // For Safety specs, we have SAT=FAIL, but for reachability specs, we have SAT=PASS
        res = Property.getCombinedType(task.getProperty(), task) == Property.Type.SAFETY ? res : res.invert();
        logger.info("Verification finished with result " + res);
    }


    private boolean trackEvent(Event e) {
        return e instanceof Load load && load.getResultRegister().getType() instanceof IntegerType
                || e instanceof Store store && store.getMemValue().getType() instanceof IntegerType;
    }

    private void analyzeValueRanges(ProverEnvironment prover) throws InterruptedException, SolverException {
        final BooleanFormulaManager bmgr = ctx.getFormulaManager().getBooleanFormulaManager();

        final Map<Event, Set<BigInteger>> valuesPerEvent = new LinkedHashMap<>();
        for (Event e : task.getProgram().getThreadEvents()) {
            if (trackEvent(e)) {
                valuesPerEvent.put(e, new HashSet<>());
            }
        }

        prover.push();

        for (Event e : valuesPerEvent.keySet()) {
            System.out.println("======== Analyzing values of " + e.getGlobalId() + ": " + e);
            prover.push();

            // Execute event
            prover.addConstraint(context.execution(e));

            // Avoid already seen values
            for (BigInteger value : valuesPerEvent.get(e)) {
                prover.addConstraint(bmgr.not(makeEqual(e, value)));
            }

            // Try to find new values
            while (!prover.isUnsat()) {
                try (Model model = prover.getModel()) {
                    final var exec = new ExecutionModelManager().buildExecutionModel(context, model);
                    for (EventModel eModel : exec.getEventModels()) {
                        if (!valuesPerEvent.containsKey(eModel.getEvent()) || !(eModel instanceof MemoryEventModel memModel)) {
                            continue;
                        }

                        final BigInteger value = memModel.getValue().getValue() instanceof BigInteger val ? val : null;
                        if (value != null) {
                            valuesPerEvent.get(eModel.getEvent()).add(value);
                            if (eModel.getEvent() == e) {
                                prover.addConstraint(bmgr.not(makeEqual(e, value)));
                            }
                        }
                    }
                }
            }

            // Found all possible values
            prover.pop();
            System.out.println("     " + valuesPerEvent.get(e));
            BooleanFormula values = bmgr.makeFalse();
            for (BigInteger value : valuesPerEvent.get(e)) {
                values = bmgr.or(values, makeEqual(e, value));
            }
            prover.addConstraint(bmgr.implication(context.execution(e), values));
        }
        // ===============================================================================

        // NOTE: If we remove this pop, then all the range information will be inside the prover environment
        // for the actual check by the AssumeSolver.
        prover.pop();

        computeMaxBitRange(valuesPerEvent);
    }

    private static void computeMaxBitRange(Map<Event, Set<BigInteger>> valuesPerEvent) {
        BigInteger min = BigInteger.ZERO;
        BigInteger max = BigInteger.ZERO;

        for (var col : valuesPerEvent.values()) {
            for (BigInteger value : col) {
                min = min.min(value);
                max = max.max(value);
            }
        }

        BigInteger diff = max.subtract(min);
        System.out.println("Necessary bits: " + diff.bitLength());
    }

    private BooleanFormula makeEqual(Event e, BigInteger value) {
        final BitvectorFormulaManager bvmgr = ctx.getFormulaManager().getBitvectorFormulaManager();
        if (e instanceof Load load) {
            final int width = load.getResultRegister().getType() instanceof IntegerType t ? t.getBitWidth() : -1;
            return context.equal(context.value(load), bvmgr.makeBitvector(width, value));
        } else if (e instanceof Store store) {
            final int width = store.getMemValue().getType() instanceof IntegerType t ? t.getBitWidth() : -1;
            return context.equal(context.value(store), bvmgr.makeBitvector(width, value));
        }
        throw new RuntimeException("Unknown event type: " + e);
    }
}