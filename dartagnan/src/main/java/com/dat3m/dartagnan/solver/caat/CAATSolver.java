package com.dat3m.dartagnan.solver.caat;


import com.dat3m.dartagnan.solver.caat.constraints.AcyclicityConstraint;
import com.dat3m.dartagnan.solver.caat.constraints.Constraint;
import com.dat3m.dartagnan.solver.caat.misc.PathAlgorithm;
import com.dat3m.dartagnan.solver.caat.predicates.relationGraphs.Edge;
import com.dat3m.dartagnan.solver.caat.reasoning.CAATLiteral;
import com.dat3m.dartagnan.solver.caat.reasoning.Reasoner;
import com.dat3m.dartagnan.utils.logic.Conjunction;
import com.dat3m.dartagnan.utils.logic.DNF;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.CONSISTENT;
import static com.dat3m.dartagnan.solver.caat.CAATSolver.Status.INCONSISTENT;


public class CAATSolver {

    // ======================================== Fields  ==============================================

    private final Reasoner reasoner;

    // The statistics of the last call
    private Statistics stats;

    // ======================================== Construction ==============================================

    private CAATSolver() {
        this.reasoner = new Reasoner();
    }

    public static CAATSolver create() {
        return new CAATSolver();
    }

    // ======================================== Accessors ==============================================

    public Reasoner getReasoner() { return reasoner; }

    public Statistics getStatistics() { return stats; }

    // ======================================== Solving ==============================================

    /*
        <check> assumes the following:
            - The CAATModel <model> has been initialized to some domain (<model.initializeToDomain>)
            - All base predicates are populated or will populate themselves.

        <check> will:
            - Populate the derived predicates in <model>
            - Check consistency of <model>
            - If applicable, compute base reasons of consistency violations
            - Return results about the computation
     */
    public Result check(CAATModel model) {
        Result result = new Result();
        stats = result.getStatistics();

        PathAlgorithm.ensureCapacity(model.getDomain().size());
        // ============== Populate derived predicates ===============
        long curTime = System.currentTimeMillis();
        model.populate();
        stats.populationTime = System.currentTimeMillis() - curTime;

        // ============== Check for inconsistencies ===============
        curTime = System.currentTimeMillis();
        List<Constraint> violatedConstraints = model.getViolatedConstraints();
        Status status = violatedConstraints.isEmpty() ? CONSISTENT : INCONSISTENT;
        result.setStatus(status);
        stats.consistencyCheckTime = System.currentTimeMillis() - curTime;

        if (status == INCONSISTENT) {
            result.setViolatedConstraints(violatedConstraints);
            // ============== Compute reasons ===============
            curTime = System.currentTimeMillis();
            result.setBaseReasons(computeInconsistencyReasons(violatedConstraints));
            stats.reasonComputationTime += (System.currentTimeMillis() - curTime);
        }

        return result;
    }

    // ======================================== Reason computation ==============================================

    private DNF<CAATLiteral> computeInconsistencyReasons(List<Constraint> violatedConstraints) {
        List<Conjunction<CAATLiteral>> reasons = new ArrayList<>();
        for (Constraint constraint : violatedConstraints) {
            reasons.addAll(reasoner.computeViolationReasons(constraint).getCubes());
        }
        stats.numComputedReasons += reasons.size();
        DNF<CAATLiteral> result = new DNF<>(reasons); // The conversion to DNF removes duplicates and dominated clauses
        stats.numComputedReducedReasons += result.getNumberOfCubes();

        return result;
    }

    public DNF<CAATLiteral> computeNextInconsistencyReason(Result result) {
        for (Constraint constraint : result.getViolatedConstraints()) {
            if (constraint instanceof AcyclicityConstraint acyclicity) {
                Optional<List<Edge>> cycle =
                        acyclicity.getNextUnreportedViolation();
                if (cycle.isPresent()) {
                    Conjunction<CAATLiteral> reason = reasoner.computeViolationReason(constraint, cycle.get());
                    stats.numComputedReasons++;
                    if (!reason.isFalse()) {
                        stats.numComputedReducedReasons++;
                    }
                    return new DNF<>(List.of(reason));
                }
            }
        }
        return DNF.FALSE();
    }

    // ======================================== Inner Classes ==============================================

    public static class Result {
        private Status status;
        private DNF<CAATLiteral> baseReasons;
        private List<Constraint> violatedConstraints;
        private final Statistics stats;

        public Status getStatus() { return status; }
        public DNF<CAATLiteral> getBaseReasons() { return baseReasons; }
        public List<Constraint> getViolatedConstraints() { return violatedConstraints; }
        public Statistics getStatistics() { return stats; }

        void setStatus(Status status) { this.status = status; }
        void setBaseReasons(DNF<CAATLiteral> reasons) {
            this.baseReasons = reasons;
        }
        void setViolatedConstraints(List<Constraint> constraints) {
            this.violatedConstraints = new ArrayList<>(constraints);
        }

        public Result() {
            stats = new Statistics();
            status = Status.INCONCLUSIVE;
            baseReasons = DNF.FALSE();
            violatedConstraints = List.of();
        }

        @Override
        public String toString() {
            return status + "\n" +
                    baseReasons + "\n" +
                    stats;
        }
    }

    public static class Statistics {
        long populationTime;
        long consistencyCheckTime;
        long reasonComputationTime;
        int numComputedReasons;
        int numComputedReducedReasons;

        public long getPopulationTime() { return populationTime; }
        public long getReasonComputationTime() { return reasonComputationTime; }
        public long getConsistencyCheckTime() { return consistencyCheckTime; }
        public int getNumComputedReasons() { return numComputedReasons; }
        public int getNumComputedReducedReasons() { return numComputedReducedReasons; }

        public String toString() {
            StringBuilder str = new StringBuilder();
            str.append("Model construction time(ms): ").append(populationTime).append("\n");
            str.append("Consistency check time(ms): ").append(consistencyCheckTime).append("\n");
            str.append("Reason computation time(ms): ").append(reasonComputationTime).append("\n");
            str.append("#Computed reasons: ").append(numComputedReasons).append("\n");
            str.append("#Computed reduced reasons: ").append(numComputedReducedReasons).append("\n");

            return str.toString();
        }
    }

    public enum Status {
        CONSISTENT, INCONSISTENT, INCONCLUSIVE;

        @Override
        public String toString() {
            return switch (this) {
                case CONSISTENT -> "Consistent";
                case INCONSISTENT -> "Inconsistent";
                case INCONCLUSIVE -> "Inconclusive";
            };
        }
    }

}
