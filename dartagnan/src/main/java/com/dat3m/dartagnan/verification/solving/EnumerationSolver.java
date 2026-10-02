package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.verification.*;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.verification.EnumerationStatus.*;

public class EnumerationSolver extends SMTModelChecker<EnumerationTask> {

    private static final Logger logger = LoggerFactory.getLogger(EnumerationSolver.class);

    private EnumerationSolver(EnumerationTask task) throws InvalidConfigurationException {
        super(task);
    }

    public static EnumerationSolver create(EnumerationTask task) throws InvalidConfigurationException {
        return new EnumerationSolver(task);
    }

    protected Context preprocessAndAnalyse(Task task) throws InvalidConfigurationException {
        final Configuration config = task.getConfig();
        preprocessProgram(task, config);
        preprocessMemoryModel(task);

        final Context analysisContext = Context.create();
        performStaticProgramAnalyses(task, analysisContext, config);
        performStaticWmmAnalyses(task, analysisContext, config);
        return analysisContext;
    }

    public EnumerationResult enumerate() throws InterruptedException, SolverException, InvalidConfigurationException {
        final Context analysisContext = preprocessAndAnalyse(task);

        initSMTSolver(task.getConfig());
        final SolverContext solverContext = this.solverContext;
        final ProverWithTracker prover = this.prover;

        EncodingContext context = EncodingContext.of(task, analysisContext, solverContext.getFormulaManager());
        ProgramEncoder programEncoder = ProgramEncoder.withContext(context);
        WmmEncoder wmmEncoder = WmmEncoder.withContext(context);
        SymmetryEncoder symmetryEncoder = SymmetryEncoder.withContext(context);
        PropertyEncoder propertyEncoder = PropertyEncoder.withContext(context, wmmEncoder);

        logger.info("Starting encoding using {}", solverContext.getVersion());
        prover.writeComment("Program encoding");
        prover.addConstraint(programEncoder.encodeFullProgram());
        prover.writeComment("Memory model encoding");
        prover.addConstraint(wmmEncoder.encodeFullMemoryModel());
        prover.writeComment("Symmetry breaking encoding");
        prover.addConstraint(symmetryEncoder.encodeFullSymmetryBreaking());
        // Encode last values and enforce termination
        prover.addConstraint(wmmEncoder.encodeLastCoConstraints());
        prover.addConstraint(propertyEncoder.encodeProgramTermination());

        checkForInterrupts();

        final BooleanFormulaManager bmgr = context.getBooleanFormulaManager();
        final ExpressionEncoder expressionEncoder = context.getExpressionEncoder();
        final ExpressionFactory exprs = context.getExpressionFactory();

        final ImmutableList<Expression> finalStateExprs = getFinalStateExprsToEnumerate();
        if (finalStateExprs.isEmpty()) {
            logger.warn("No final states to enumerate");
            return new EnumerationResult(task, COMPLETE, ImmutableList.of(), ImmutableList.of());
        }

        // ===================== Enumerate states =====================
        logger.info("Starting state space enumeration");
        final int MAX_ENUMERATED_STATES = 10000;
        final List<ImmutableMap<Expression, Expression>> visitedStates = new ArrayList<>();
        EnumerationStatus status = COMPLETE;
        while (!prover.isUnsat()) {
            if (visitedStates.size() > MAX_ENUMERATED_STATES) {
                System.out.println("Too many states, stopping enumeration");
                status = LIMITED;
                break;
            }

            checkForInterrupts();

            try (IREvaluator evaluator = context.newEvaluator(prover)) {
                final var state = ImmutableMap.<Expression, Expression>builderWithExpectedSize(finalStateExprs.size());

                final List<BooleanFormula> stateCube = new ArrayList<>(finalStateExprs.size());
                for (Expression finalExpr : finalStateExprs) {
                    final Expression val = toExpression(evaluator.evaluateFinal(finalExpr), exprs);
                    state.put(finalExpr, val);
                    stateCube.add(expressionEncoder.equal(finalExpr, val));
                }

                visitedStates.add(state.build());
                // Block state
                prover.addConstraint(bmgr.not(bmgr.and(stateCube)));
            }
        }
        // ======================================================

        // TODO: Add bounds check

        return new EnumerationResult(task, status, finalStateExprs, ImmutableList.copyOf(visitedStates));

    }

    private Expression toExpression(TypedValue<?, ?> value, ExpressionFactory exprs) {
        if (value.type() instanceof IntegerType intType) {
            return exprs.makeValue((BigInteger) value.value(), intType);
        } else if (value.type() instanceof MemoryType memType) {
            final IntegerType intType = TypeFactory.getInstance().getIntegerType(memType.getBitWidth());
            final Expression intValue =  exprs.makeValue((BigInteger) value.value(), intType);
            return exprs.makeToMemoryCast(intValue);
        }
        throw new UnsupportedOperationException("Unsupported type " + value.type());
    }

    // We collect the expression values to enumerate from the spec
    private ImmutableList<Expression> getFinalStateExprsToEnumerate() {
        final Program p = task.getProgram();

        final Set<Expression> finalStateExprs = new HashSet<>();
        if (p.getSpecification() != null) {
            p.getSpecification().accept(new ExpressionInspector() {
                @Override
                public Expression visitFinalMemoryValue(FinalMemoryValue val) {
                    finalStateExprs.add(val);
                    return val;
                }

                @Override
                public Expression visitRegister(Register reg) {
                    finalStateExprs.add(reg);
                    return reg;
                }
            });
        }

       p.getLocations().forEach(location -> {
            if (location instanceof MemoryObject o) {
                // FIXME: This will fail for mixed size accesses
                finalStateExprs.add(new FinalMemoryValue(o.getName(), o.getInitialValue(0).getType(), o, 0));
            }
        });

        return finalStateExprs.stream()
                .sorted(this::compareExpr)
                .collect(ImmutableList.toImmutableList());
    }

    // For sorting expressions in a canonical manner:
    //  (1) Registers before memory locations
    //     (1.1) Among different-thread registers, sort by thread id
    //     (1.2) Among same-thread registers, sort by name
    //  (2) Memory locations are sorted by name.
    private int compareExpr(Expression x, Expression y) {
        if ((x instanceof Register) != (y instanceof Register)) {
            return (x instanceof Register) ? -1 : 1;
        } else if (x instanceof Register r1 && y instanceof Register r2) {
            if (r1.getThread() != r2.getThread()) {
                return r1.getThread().getId() - r2.getThread().getId();
            }
            return r1.getName().compareTo(r2.getName());
        } else if (x instanceof FinalMemoryValue f1 && y instanceof FinalMemoryValue f2) {
            return f2.getName().compareTo(f1.getName());
        }

        throw new RuntimeException("unreachable");
    }
}