package com.dat3m.dartagnan.verification.solving;

import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.misc.NamedExpression;
import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.MemoryType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.smt.ProverWithTracker;
import com.dat3m.dartagnan.verification.*;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;
import org.sosy_lab.java_smt.api.BooleanFormula;
import org.sosy_lab.java_smt.api.BooleanFormulaManager;
import org.sosy_lab.java_smt.api.SolverContext;
import org.sosy_lab.java_smt.api.SolverException;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.ENUMERATION_LIMIT;
import static com.dat3m.dartagnan.verification.EnumerationStatus.*;

@Options
public class EnumerationSolver extends SMTModelChecker<EnumerationTask> {

    private static final Logger logger = LoggerFactory.getLogger(EnumerationSolver.class);

    // ================================================================================================================
    // Configuration

    @Option(name=ENUMERATION_LIMIT,
            description="Sets a limit for number of enumerated states. The value -1 means no limit.",
            secure=true,
            toUppercase=true)
    private int numLimitEnumeratedStates = 5000;

    // ================================================================================================================

    private EnumerationSolver(EnumerationTask task) throws InvalidConfigurationException {
        super(task);

        task.getConfig().inject(this);
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

        final ImmutableList<Expression> observables = getObservablesToEnumerate();
        if (observables.isEmpty()) {
            logger.warn("No final states to enumerate");
            return new EnumerationResult(task, COMPLETE, ImmutableList.of(), ImmutableList.of());
        }

        // ===================== Enumerate states =====================
        logger.info("Starting state space enumeration");
        final List<ImmutableMap<Expression, Expression>> visitedStates = new ArrayList<>();
        EnumerationStatus status = COMPLETE;
        while (!prover.isUnsat()) {
            if (numLimitEnumeratedStates != -1 && visitedStates.size() > numLimitEnumeratedStates) {
                logger.info("Enumeration limit reached.");
                visitedStates.remove(visitedStates.size() - 1);
                status = LIMITED;
                break;
            }

            checkForInterrupts();

            try (IREvaluator evaluator = context.newEvaluator(prover)) {
                final var state = ImmutableMap.<Expression, Expression>builderWithExpectedSize(observables.size());

                final List<BooleanFormula> stateCube = new ArrayList<>(observables.size());
                for (Expression finalExpr : observables) {
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

        return new EnumerationResult(task, status, observables, ImmutableList.copyOf(visitedStates));

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

    // We collect the expression values to enumerate from the spec and the explicitly specified locations
    // TODO: The program should specify all observables in a single place
    private ImmutableList<Expression> getObservablesToEnumerate() {
        final Program p = task.getProgram();

        final Set<Expression> observables = new HashSet<>();
        if (p.getSpecification() != null) {
            p.getSpecification().accept(new ExpressionInspector() {
                @Override
                public Expression visitFinalMemoryValue(FinalMemoryValue val) {
                    observables.add(val);
                    return val;
                }

                @Override
                public Expression visitRegister(Register reg) {
                    observables.add(reg);
                    return reg;
                }

                @Override
                public Expression visitNamedExpression(NamedExpression expr) {
                    observables.add(expr);
                    return expr;
                }
            });
        }

        observables.addAll(p.getLocations());

        return observables.stream()
                .sorted(this::compareExpr)
                .collect(ImmutableList.toImmutableList());
    }

    // For sorting expressions in a canonical manner:
    //  (1) Registers before everything else
    //     (1.1) Among different-thread registers, sort by thread id
    //     (1.2) Among same-thread registers, sort by name
    //  (2) The rest are sorted by name (string representation)
    private int compareExpr(Expression x, Expression y) {
        if ((x instanceof Register) != (y instanceof Register)) {
            return (x instanceof Register) ? -1 : 1;
        } else if (x instanceof Register r1 && y instanceof Register r2) {
            if (r1.getThread() != r2.getThread()) {
                return r1.getThread().getId() - r2.getThread().getId();
            }
            return r1.getName().compareTo(r2.getName());
        } else {
            return x.toString().compareTo(y.toString());
        }

    }
}