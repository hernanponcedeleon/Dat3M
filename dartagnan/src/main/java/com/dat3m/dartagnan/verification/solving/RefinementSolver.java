package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.asserts.AssertTrue;
import com.dat3m.dartagnan.encoding.ProgramEncoder;
import com.dat3m.dartagnan.encoding.PropertyEncoder;
import com.dat3m.dartagnan.encoding.SymmetryEncoder;
import com.dat3m.dartagnan.encoding.WmmEncoder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.solver.caat.CAATSolver;
import com.dat3m.dartagnan.solver.caat4wmm.Refiner;
import com.dat3m.dartagnan.solver.caat4wmm.WMMSolver;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreLiteral;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.RelLiteral;
import com.dat3m.dartagnan.utils.Result;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;
import com.dat3m.dartagnan.verification.RefinementTask;
import com.dat3m.dartagnan.verification.model.EventData;
import com.dat3m.dartagnan.verification.model.ExecutionModel;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.ForceEncodeAxiom;
import com.dat3m.dartagnan.wmm.relation.RecursiveRelation;
import com.dat3m.dartagnan.wmm.relation.Relation;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelCartesian;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelFencerel;
import com.dat3m.dartagnan.wmm.relation.base.stat.RelSetIdentity;
import com.dat3m.dartagnan.wmm.relation.binary.RelMinus;
import com.dat3m.dartagnan.wmm.utils.RelationRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.Model;
import org.sosy_lab.java_smt.api.ProverEnvironment;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.function.BiPredicate;

import static com.dat3m.dartagnan.GlobalSettings.REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONCLUSIVE;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONSISTENT;
import static com.dat3m.dartagnan.utils.Result.*;
import static com.dat3m.dartagnan.utils.visualization.ExecutionGraphVisualizer.generateGraphvizFile;

/*
    Refinement is a custom solving procedure that starts from a weak memory model (possibly the empty model)
    and iteratively refines it to perform a verification task.
    It can be understood as a lazy offline-SMT solver.
    More concretely, it iteratively:
        - Finds some assertion-violating execution w.r.t. to some (very weak) baseline memory model
        - Checks the consistency of this execution using a custom theory solver (CAAT-Solver)
        - Refines the used memory model if the found execution was inconsistent, using the explanations
          provided by the theory solver.
 */
public class RefinementSolver {

    private static final Logger logger = LogManager.getLogger(RefinementSolver.class);

    //TODO: We do not yet use Witness information. The problem is that WitnessGraph.encode() generates
    // constraints on hb, which is not encoded in Refinement.
    public static Result run(SolverContext ctx, ProverEnvironment prover, RefinementTask task)
            throws InterruptedException, SolverException, InvalidConfigurationException {

		task.preprocessProgram();
		if(task.getProgram().getAss() instanceof AssertTrue) {
            logger.info("Verification finished: assertion trivially holds");
            return PASS;
        }

        // We cut the rhs of differences to get a semi-positive model, if possible.
        Set<Relation> cutRelations = cutRelationDifferences(task.getMemoryModel(), task.getBaselineModel());

        task.performStaticProgramAnalyses();
        task.performStaticWmmAnalyses();
		task.initializeEncoders(ctx);

        ProgramEncoder programEncoder = task.getProgramEncoder();
        PropertyEncoder propertyEncoder = task.getPropertyEncoder();
        WmmEncoder baselineEncoder = task.getBaselineWmmEncoder();
        SymmetryEncoder symmEncoder = task.getSymmetryEncoder();

        Program program = task.getProgram();
        WMMSolver solver = new WMMSolver(task, cutRelations);
        Refiner refiner = new Refiner(task);
        CAATSolver.Status status = INCONSISTENT;

        logger.info("Starting encoding using " + ctx.getVersion());
        prover.addConstraint(programEncoder.encodeFullProgram(ctx));
        prover.addConstraint(baselineEncoder.encodeFullMemoryModel(ctx));
        prover.addConstraint(symmEncoder.encodeFullSymmetry(ctx));

        prover.push();
        prover.addConstraint(propertyEncoder.encodeSpecification(task.getProperty(), ctx));

        //  ------ Just for statistics ------
        List<DNF<CoreLiteral>> foundCoreReasons = new ArrayList<>();
        List<WMMSolver.Statistics> statList = new ArrayList<>();
        int iterationCount = 0;
        long lastTime = System.currentTimeMillis();
        long curTime;
        long totalNativeSolvingTime = 0;
        long totalCaatTime = 0;
        //  ---------------------------------

        logger.info("Refinement procedure started.");
        while (!prover.isUnsat()) {
        	if(iterationCount == 0 && logger.isDebugEnabled()) {
        		String smtStatistics = "\n ===== SMT Statistics (after first iteration) ===== \n";
        		for(String key : prover.getStatistics().keySet()) {
        			smtStatistics += String.format("\t%s -> %s\n", key, prover.getStatistics().get(key));
        		}
        		logger.debug(smtStatistics);
        	}
            iterationCount++;
            curTime = System.currentTimeMillis();
            totalNativeSolvingTime += (curTime - lastTime);

            logger.debug("Solver iteration: \n" +
                            " ===== Iteration: {} =====\n" +
                            "Solving time(ms): {}", iterationCount, curTime - lastTime);

            curTime = System.currentTimeMillis();
            WMMSolver.Result solverResult;
            try (Model model = prover.getModel()) {
                solverResult = solver.check(model, ctx);
            } catch (SolverException e) {
                logger.error(e);
                throw e;
            }

            WMMSolver.Statistics stats = solverResult.getStatistics();
            statList.add(stats);
            logger.debug("Refinement iteration:\n{}", stats);

            status = solverResult.getStatus();
            if (status == INCONSISTENT) {
                DNF<CoreLiteral> reasons = solverResult.getCoreReasons();
                foundCoreReasons.add(reasons);
                prover.addConstraint(refiner.refine(reasons, ctx));

                if (REFINEMENT_GENERATE_GRAPHVIZ_DEBUG_FILES) {
                    generateGraphvizFiles(task, solver.getExecution(), iterationCount, reasons);
                }
                if (logger.isTraceEnabled()) {
                    // Some statistics
                    StringBuilder message = new StringBuilder().append("Found inconsistency reasons:");
                    for (Conjunction<CoreLiteral> cube : reasons.getCubes()) {
                        message.append("\n").append(cube);
                    }
                    logger.trace(message);
                }
            } else {
                // No violations found, we can't refine
                break;
            }
            totalCaatTime += (System.currentTimeMillis() - curTime);
            lastTime = System.currentTimeMillis();
        }
        iterationCount++;
        curTime = System.currentTimeMillis();
        totalNativeSolvingTime += (curTime - lastTime);

        logger.debug("Final solver iteration:\n" +
                        " ===== Final Iteration: {} =====\n" +
                        "Native Solving/Proof time(ms): {}", iterationCount, curTime - lastTime);
		
        if (logger.isInfoEnabled()) {
            String message;
            switch (status) {
                case INCONCLUSIVE:
                    message = "CAAT Solver was inconclusive (bug?).";
                    break;
                case CONSISTENT:
                    message = "Violation verified.";
                    break;
                case INCONSISTENT:
                    message = "Bounded safety proven.";
                    break;
                default:
                    throw new IllegalStateException("Unknown result type returned by CAAT Solver.");
            }
            logger.info(message);
        }

        if (status == INCONCLUSIVE) {
            // CAATSolver got no result (should not be able to happen), so we cannot proceed further.
            return UNKNOWN;
        }


        Result veriResult;
        long boundCheckTime = 0;
        if (prover.isUnsat()) {
            // ------- CHECK BOUNDS -------
            lastTime = System.currentTimeMillis();
            prover.pop();
            // Add bound check
            prover.addConstraint(propertyEncoder.encodeBoundEventExec(ctx));
            // Add back the constraints found during Refinement (TODO: We might need to perform a second refinement)
            for (DNF<CoreLiteral> reason : foundCoreReasons) {
                prover.addConstraint(refiner.refine(reason, ctx));
            }
            veriResult = !prover.isUnsat() ? UNKNOWN : PASS;
            boundCheckTime = System.currentTimeMillis() - lastTime;
        } else {
            veriResult = FAIL;
        }

        if (logger.isInfoEnabled()) {
            logger.info(generateSummary(statList, iterationCount, totalNativeSolvingTime, totalCaatTime, boundCheckTime));
        }

        if(logger.isDebugEnabled()) {        	
            String smtStatistics = "\n ===== SMT Statistics (after final iteration) ===== \n";
    		for(String key : prover.getStatistics().keySet()) {
    			smtStatistics += String.format("\t%s -> %s\n", key, prover.getStatistics().get(key));
    		}
    		logger.debug(smtStatistics);
        }

        veriResult = program.getAss().getInvert() ? veriResult.invert() : veriResult;
        logger.info("Verification finished with result " + veriResult);
        return veriResult;
    }
    // ======================= Helper Methods ======================

    private static Set<Relation> cutRelationDifferences(Wmm targetWmm, Wmm baselineWmm) {
        RelationRepository repo = baselineWmm.getRelationRepository();
        Set<Relation> cutRelations = new HashSet<>();
        for (Relation rel : targetWmm.getRelationRepository().getRelations()) {
            if (rel instanceof RelMinus) {
                Relation sec = rel.getSecond();
                if (sec.getDependencies().size() != 0 || sec instanceof RelSetIdentity || sec instanceof RelCartesian) {
                    // NOTE: The check for RelSetIdentity/RelCartesian is needed because they appear non-derived
                    // in our Wmm but for CAAT they are derived from unary predicates!
                    logger.info("Found difference {}. Cutting rhs relation {}", rel, sec);
                    cutRelations.add(sec);
                    baselineWmm.addAxiom(new ForceEncodeAxiom(getCopyOfRelation(sec, repo)));
                }
            }
        }
        return cutRelations;
    }

    private static Relation getCopyOfRelation(Relation rel, RelationRepository repo) {
        if (repo.containsRelation(rel.getName())) {
            return repo.getRelation(rel.getName());
        }

        if (rel instanceof RecursiveRelation) {
            throw new IllegalArgumentException(
                    String.format("Cannot cut recursively defined relation %s from memory model. ", rel));
        }

        Relation copy = repo.getRelation(rel.getName());
        if (copy == null) {
            List<Object> deps = new ArrayList<>(rel.getDependencies().size());
            if (rel instanceof RelSetIdentity) {
                deps.add(((RelSetIdentity)rel).getFilter());
            } else if (rel instanceof RelCartesian) {
                deps.add(((RelCartesian) rel).getFirstFilter());
                deps.add(((RelCartesian) rel).getSecondFilter());
            } else if (rel instanceof RelFencerel) {
                deps.add(((RelFencerel)rel).getFenceName());
            } else {
                for (Relation dep : rel.getDependencies()) {
                    deps.add(getCopyOfRelation(dep, repo));
                }
            }

            copy = repo.getRelation(rel.getClass(), deps.toArray());
            if (rel.getIsNamed()) {
                copy.setName(rel.getName());
                repo.updateRelation(copy);
            }
        }

        return copy;
    }

    // -------------------- Printing -----------------------------

    private static CharSequence generateSummary(List<WMMSolver.Statistics> statList, int iterationCount,
                                                long totalNativeSolvingTime, long totalCaatTime, long boundCheckTime) {
        long totalModelExtractTime = 0;
        long totalPopulationTime = 0;
        long totalConsistencyCheckTime = 0;
        long totalReasonComputationTime = 0;
        long totalNumReasons = 0;
        long totalNumReducedReasons = 0;
        long totalModelSize = 0;
        long minModelSize = Long.MAX_VALUE;
        long maxModelSize = Long.MIN_VALUE;

        for (WMMSolver.Statistics stats : statList) {
            totalModelExtractTime += stats.getModelExtractionTime();
            totalPopulationTime += stats.getPopulationTime();
            totalConsistencyCheckTime += stats.getConsistencyCheckTime();
            totalReasonComputationTime += stats.getBaseReasonComputationTime() + stats.getCoreReasonComputationTime();
            totalNumReasons += stats.getNumComputedCoreReasons();
            totalNumReducedReasons += stats.getNumComputedReducedCoreReasons();

            totalModelSize += stats.getModelSize();
            minModelSize = Math.min(stats.getModelSize(), minModelSize);
            maxModelSize = Math.max(stats.getModelSize(), maxModelSize);
        }

        StringBuilder message = new StringBuilder().append("Summary").append("\n")
                .append(" ======== Summary ========").append("\n")
                .append("Number of iterations: ").append(iterationCount).append("\n")
                .append("Total native solving time(ms): ").append(totalNativeSolvingTime + boundCheckTime).append("\n")
                .append("   -- Bound check time(ms): ").append(boundCheckTime).append("\n")
                .append("Total CAAT solving time(ms): ").append(totalCaatTime).append("\n")
                .append("   -- Model extraction time(ms): ").append(totalModelExtractTime).append("\n")
                .append("   -- Population time(ms): ").append(totalPopulationTime).append("\n")
                .append("   -- Consistency check time(ms): ").append(totalConsistencyCheckTime).append("\n")
                .append("   -- Reason computation time(ms): ").append(totalReasonComputationTime).append("\n")
                .append("   -- #Computed core reasons: ").append(totalNumReasons).append("\n")
                .append("   -- #Computed core reduced reasons: ").append(totalNumReducedReasons).append("\n");
        if (statList.size() > 0) {
            message.append("   -- Min model size (#events): ").append(minModelSize).append("\n")
                    .append("   -- Average model size (#events): ").append(totalModelSize / statList.size()).append("\n")
                    .append("   -- Max model size (#events): ").append(maxModelSize).append("\n");
        }

        return message;
    }

    // This code is pure debugging code that will generate graphical representations
    // of each refinement iteration.
    // Generate .dot files and .png files per iteration
    private static void generateGraphvizFiles(RefinementTask task, ExecutionModel model, int iterationCount, DNF<CoreLiteral> reasons) {
        //   =============== Visualization code ==================
        // The edgeFilter filters those co/rf that belong to some violation reason
        BiPredicate<EventData, EventData> edgeFilter = (e1, e2) -> {
            for (Conjunction<CoreLiteral> cube : reasons.getCubes()) {
                for (CoreLiteral lit : cube.getLiterals()) {
                    if (lit instanceof RelLiteral) {
                        RelLiteral edgeLit = (RelLiteral) lit;
                        if (model.getData(edgeLit.getData().getFirst()).get() == e1 &&
                                model.getData(edgeLit.getData().getSecond()).get() == e2) {
                            return true;
                        }
                    }
                }
            }
            return false;
        };

        String programName = task.getProgram().getName();
        programName = programName.substring(0, programName.lastIndexOf("."));
        String directoryName = String.format("%s/output/refinement/%s-%s-debug/", System.getenv("DAT3M_HOME"), programName, task.getProgram().getArch());
        String fileNameBase = String.format("%s-%d", programName, iterationCount);
        // File with reason edges only
        generateGraphvizFile(model, iterationCount, edgeFilter, directoryName, fileNameBase);
        // File with all edges
        generateGraphvizFile(model, iterationCount, (x,y) -> true, directoryName, fileNameBase + "-full");
    }
}