package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.IntegerHelper;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.IRHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.DominatorAnalysis;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.event.core.annotations.LoopBound;
import com.dat3m.dartagnan.utils.DominatorTree;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.IntegerOption;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.configuration.OptionNames.BOUND_CAP;

/*
    This pass performs a simple form of "Scalar Evolution" on (not yet unrolled) loops
    to compute a symbolic expression for the number of iterations of a loop.

    (1) It symbolically executes a single iteration of the loop to express the value of each register
        as an affine function "c0 + c1*r1 + ... + cn*rn" over the values the registers have at the loop header.
        This supports additions, subtractions, and multiplications with constants.
    (2) A register r whose value at the end of an iteration is "r + c" forms a recurrence {r, +, c},
        i.e., in the k-th iteration (counting from 0) its value at the loop header is "r_entry + c*k",
        where r_entry is the value of r when entering the loop.
        This also gives an evolution "A + S*k" to every affine function over such registers.
    (3) For each loop exit that is checked in every iteration and whose condition compares such an evolution
        with a loop-invariant value N, it solves for the first iteration k in which the loop is exited.
        This k is the "backedge-taken count" of the loop: the loop header gets executed at most k+1 times.

    The computed count is an expression over register values at loop entry.
    Since the IR has wrap-around semantics, some counts are only valid under an assumption that excludes overflows
    (e.g., "for (i = 0; i <= n; i++)" does not terminate if n is the maximal integer).
    If the count is a constant (and holds unconditionally), the loop gets annotated with a loop bound.

    Example: The loop "for (int i = a; i < n; i += 2) { Body }" has the shape

        Loop:
            r1 <- ITE((i < n), 1, 0)
            if (r1 != 0) then goto Continue
            goto Exit
        Continue:
            Body
            r2 <- (i + 2)
            i <- r2
            goto Loop
        Exit:

    for which we compute the count "(a < n) ? ((n - a - 1) udiv 2) + 1 : 0" under the assumption "n <= MAX_INT - 1".
*/
@Options
public class ScalarEvolution implements FunctionProcessor {

    private static final Logger logger = LoggerFactory.getLogger(ScalarEvolution.class);

    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private static final TypeFactory types = TypeFactory.getInstance();

    @Option(name = BOUND_CAP,
            description = "Caps the loop bounds that get computed automatically: " +
                    "loops with a larger bound get unrolled at least this many times (or more if the bound is larger)." +
                    " The value 0 disables the cap. Defaults to 0.",
            secure = true)
    @IntegerOption(min = 0)
    private int boundCap = 0;

    private final ReachingDefinitionsAnalysis.Config reachingDefinitionsAnalysis;

    private ScalarEvolution(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        reachingDefinitionsAnalysis = ReachingDefinitionsAnalysis.configure(config);
    }

    public static ScalarEvolution fromConfig(Configuration config) throws InvalidConfigurationException {
        return new ScalarEvolution(config);
    }

    @Override
    public void run(Function function) {
        if (!function.hasBody()) {
            return;
        }
        final List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(function).getLoopsOfFunction(function);
        if (loops.isEmpty()) {
            return;
        }
        final DominatorTree<Event> preDominatorTree =
                DominatorAnalysis.computePreDominatorTree(function.getEntry(), function.getExit());

        // (1) Analyze all loops.
        final Map<Label, List<ExitEvolution>> loop2Exits = new LinkedHashMap<>();
        for (LoopAnalysis.LoopInfo loop : loops) {
            final List<Event> body = loop.iterations().get(0).computeBody();
            final List<ExitEvolution> exits = analyzeLoop(body, preDominatorTree);
            if (!exits.isEmpty()) {
                loop2Exits.put((Label) body.get(0), exits);
            }
        }
        if (loop2Exits.isEmpty()) {
            return;
        }

        // (2) The evolutions refer to register values at loop entry: try to resolve those to constants.
        final Map<Label, Map<Register, BigInteger>> loop2EntryValues =
                computeConstantEntryValues(function, loop2Exits, preDominatorTree);

        // (3) Compute the backedge-taken counts and annotate the loops that have a constant count.
        loop2Exits.forEach((loopHeader, exits) -> {
            final Map<Register, BigInteger> entryValues = loop2EntryValues.get(loopHeader);
            exits.stream()
                    .map(exit -> computeCount(exit.substitute(entryValues)))
                    .filter(Objects::nonNull)
                    .reduce(ScalarEvolution::combine)
                    .ifPresent(count -> handleCount(loopHeader, count));
        });
    }

    private void handleCount(Label loopHeader, Count count) {
        if (logger.isDebugEnabled()) {
            logger.debug("Loop {} in function {} takes its backedge at most ({}) times, assuming ({}).",
                    loopHeader.getName(), loopHeader.getFunction().getName(), count.value(), count.assumption());
        }
        if (!(count.value() instanceof IntLiteral literal && isTrue(count.assumption()))
                || loopHeader.getPredecessor() instanceof LoopBound) {
            // We can only annotate constant bounds, and we do not overwrite existing annotations.
            return;
        }
        // The last iteration only performs the exit check, hence the "+1".
        final int bitWidth = literal.getType().getBitWidth();
        final BigInteger bound = IntegerHelper.normalizeUnsigned(literal.getValue(), bitWidth).add(BigInteger.ONE);
        // We cap large bounds (if enabled) to avoid excessive unrolling. Since a capped bound is insufficient
        // to fully unroll the loop, it is only a soft bound that the user can overwrite by a larger global bound.
        final BigInteger cap = BigInteger.valueOf(boundCap);
        final boolean isCapped = boundCap > 0 && bound.compareTo(cap) > 0;
        if (!isCapped && bound.bitLength() >= Integer.SIZE) {
            // The loop is too large to get unrolled.
            return;
        }
        final Expression boundExpr = expressions.makeValue(isCapped ? cap : bound, types.getArchType());
        loopHeader.insertBefore(EventFactory.newLoopBound(boundExpr, isCapped));
    }

    // ======================================================================================
    // Symbolic values

    private sealed interface Value permits Affine, Comparison { }

    // The integer value "constant + SUM coefficients[r]*r" modulo 2^bitWidth.
    // All numbers are normalized to their unsigned representation and there are no zero-coefficients.
    private record Affine(IntegerType type, BigInteger constant, Map<Register, BigInteger> coefficients) implements Value {

        private static Affine of(BigInteger constant, IntegerType type) {
            return new Affine(type, normalize(constant, type), Map.of());
        }

        private static Affine of(Register register, IntegerType type) {
            return new Affine(type, BigInteger.ZERO, Map.of(register, BigInteger.ONE));
        }

        private static BigInteger normalize(BigInteger value, IntegerType type) {
            return value.mod(BigInteger.ONE.shiftLeft(type.getBitWidth()));
        }

        private boolean isConstant() {
            return coefficients.isEmpty();
        }

        private Affine add(Affine other) {
            final Map<Register, BigInteger> sum = new LinkedHashMap<>(coefficients);
            other.coefficients.forEach((reg, coeff) -> sum.merge(reg, coeff, (x, y) -> normalize(x.add(y), type)));
            sum.values().removeIf(coeff -> coeff.signum() == 0);
            return new Affine(type, normalize(constant.add(other.constant), type), sum);
        }

        private Affine add(long value) {
            return add(Affine.of(BigInteger.valueOf(value), type));
        }

        private Affine sub(Affine other) {
            return add(other.scale(BigInteger.ONE.negate()));
        }

        private Affine scale(BigInteger factor) {
            final Map<Register, BigInteger> scaled = new LinkedHashMap<>();
            coefficients.forEach((reg, coeff) -> scaled.put(reg, normalize(coeff.multiply(factor), type)));
            scaled.values().removeIf(coeff -> coeff.signum() == 0);
            return new Affine(type, normalize(constant.multiply(factor), type), scaled);
        }

        private Affine substitute(Map<Register, BigInteger> values) {
            Affine result = Affine.of(constant, type);
            for (Map.Entry<Register, BigInteger> entry : coefficients.entrySet()) {
                final BigInteger value = values.get(entry.getKey());
                final Affine term = value != null ? Affine.of(value, type) : Affine.of(entry.getKey(), type);
                result = result.add(term.scale(entry.getValue()));
            }
            return result;
        }

        private Expression toExpression() {
            final int bitWidth = type.getBitWidth();
            Expression result = null;
            // We first add the positive terms, then subtract the negative ones, and handle the constant last.
            for (boolean positive : List.of(true, false)) {
                for (Map.Entry<Register, BigInteger> entry : coefficients.entrySet()) {
                    final BigInteger coeff = IntegerHelper.normalizeSigned(entry.getValue(), bitWidth);
                    if ((coeff.signum() > 0) != positive) {
                        continue;
                    }
                    final Expression term = coeff.abs().equals(BigInteger.ONE) ? entry.getKey()
                            : expressions.makeMul(expressions.makeValue(coeff.abs(), type), entry.getKey());
                    result = (result == null) ? (positive ? term : expressions.makeNeg(term))
                            : (positive ? expressions.makeAdd(result, term) : expressions.makeSub(result, term));
                }
            }
            final BigInteger c = IntegerHelper.normalizeSigned(constant, bitWidth);
            if (result == null) {
                return expressions.makeValue(c, type);
            } else if (c.signum() == 0) {
                return result;
            }
            final Expression absConstant = expressions.makeValue(c.abs(), type);
            return c.signum() > 0 ? expressions.makeAdd(result, absConstant) : expressions.makeSub(result, absConstant);
        }
    }

    // The truth value of "left op right", either as boolean or as integer (1 or 0).
    private record Comparison(Affine left, IntCmpOp op, Affine right) implements Value {

        private Comparison negate() {
            return new Comparison(left, op.inverted(), right);
        }
    }

    // Evaluates expressions to symbolic values relative to a state.
    // The state maps registers to their current symbolic value, where NULL stands for an unknown value.
    // Registers that are missing in the state have not been modified so far.
    private static final class Evaluator implements ExpressionVisitor<Value> {

        private Map<Register, Value> state;

        private static Value lookup(Map<Register, Value> state, Register reg) {
            if (state.containsKey(reg)) {
                return state.get(reg);
            }
            return reg.getType() instanceof IntegerType type ? Affine.of(reg, type) : null;
        }

        private Value evaluate(Expression expr, Map<Register, Value> state) {
            this.state = state;
            return expr.accept(this);
        }

        @Override
        public Value visitExpression(Expression expr) {
            return null;
        }

        @Override
        public Value visitRegister(Register reg) {
            return lookup(state, reg);
        }

        @Override
        public Value visitIntLiteral(IntLiteral lit) {
            return Affine.of(lit.getValue(), lit.getType());
        }

        @Override
        public Value visitIntBinaryExpression(IntBinaryExpr expr) {
            if (!(expr.getLeft().accept(this) instanceof Affine left
                    && expr.getRight().accept(this) instanceof Affine right)) {
                return null;
            }
            return switch (expr.getKind()) {
                case ADD -> left.add(right);
                case SUB -> left.sub(right);
                case MUL -> left.isConstant() ? right.scale(left.constant())
                        : right.isConstant() ? left.scale(right.constant())
                        : null;
                case LSHIFT -> right.isConstant() && right.constant().bitLength() < Integer.SIZE
                        ? left.scale(BigInteger.ONE.shiftLeft(right.constant().intValue()))
                        : null;
                default -> null;
            };
        }

        @Override
        public Value visitIntUnaryExpression(IntUnaryExpr expr) {
            if (!(expr.getOperand().accept(this) instanceof Affine operand)) {
                return null;
            }
            final Affine negated = operand.scale(BigInteger.ONE.negate());
            return switch (expr.getKind()) {
                case MINUS -> negated;
                case NOT -> negated.add(-1);
                default -> null;
            };
        }

        @Override
        public Value visitIntCmpExpression(IntCmpExpr expr) {
            final Value left = expr.getLeft().accept(this);
            final Value right = expr.getRight().accept(this);
            if (left instanceof Affine l && right instanceof Affine r) {
                return new Comparison(l, expr.getKind(), r);
            }
            // Check for (in)equality tests between a comparison result and the constants 0 or 1.
            final Value other = left instanceof Comparison ? right : left;
            if (!((left instanceof Comparison || right instanceof Comparison)
                    && other instanceof Affine constant && constant.isConstant()
                    && constant.constant().bitLength() <= 1
                    && (expr.getKind() == IntCmpOp.EQ || expr.getKind() == IntCmpOp.NEQ))) {
                return null;
            }
            final Comparison cmp = (Comparison) (left instanceof Comparison ? left : right);
            final boolean testsForTrue = (expr.getKind() == IntCmpOp.EQ) == (constant.constant().signum() != 0);
            return testsForTrue ? cmp : cmp.negate();
        }

        @Override
        public Value visitBoolUnaryExpression(BoolUnaryExpr expr) {
            // There is only negation.
            return expr.getOperand().accept(this) instanceof Comparison cmp ? cmp.negate() : null;
        }

        @Override
        public Value visitITEExpression(ITEExpr expr) {
            // Check for the conversion of a comparison result to an integer.
            if (!(expr.getCondition().accept(this) instanceof Comparison cmp
                    && expr.getTrueCase().accept(this) instanceof Affine t && t.isConstant()
                    && expr.getFalseCase().accept(this) instanceof Affine f && f.isConstant()
                    && t.constant().add(f.constant()).equals(BigInteger.ONE))) {
                return null;
            }
            return f.constant().signum() == 0 ? cmp : cmp.negate();
        }
    }

    // ======================================================================================
    // Loop analysis

    // Describes a loop exit that is checked in every iteration:
    // The k-th iteration (counting from 0) only reaches the backjump if "(start + step*k) op limit" holds,
    // where <start> and <limit> are evaluated at loop entry. <step> is non-zero.
    private record ExitEvolution(Affine start, BigInteger step, IntCmpOp op, Affine limit) {

        private Set<Register> getRegisters() {
            final Set<Register> registers = new LinkedHashSet<>(start.coefficients().keySet());
            registers.addAll(limit.coefficients().keySet());
            return registers;
        }

        private ExitEvolution substitute(Map<Register, BigInteger> values) {
            return new ExitEvolution(start.substitute(values), step, op, limit.substitute(values));
        }
    }

    private List<ExitEvolution> analyzeLoop(List<Event> body, DominatorTree<Event> preDominatorTree) {
        final Label loopHeader = (Label) body.get(0);
        final Event backJump = body.get(body.size() - 1);
        final Set<Event> bodySet = new HashSet<>(body);
        final Evaluator evaluator = new Evaluator();

        // ----- Symbolically execute a single loop iteration -----
        // NOTE: Besides the backjumps of nested loops, all jumps inside the body are forward jumps.
        final Map<Label, Map<Register, Value>> pendingStates = new HashMap<>();
        final Map<CondJump, Comparison> continueConditions = new LinkedHashMap<>();
        Map<Register, Value> state = new HashMap<>(); // NULL if the current event is unreachable
        for (Event event : body) {
            if (event instanceof Label label && label != loopHeader) {
                state = merge(state, pendingStates.remove(label));
                if (state != null) {
                    // If this is a nested loop, we lose all information about the registers it modifies.
                    for (Register reg : getRegistersModifiedByLoop(label)) {
                        state.put(reg, null);
                    }
                }
            }
            if (state == null) {
                continue;
            }

            if (event instanceof RegWriter writer) {
                final Value value = (writer instanceof Local local) ? evaluator.evaluate(local.getExpr(), state) : null;
                state.put(writer.getResultRegister(), value);
            } else if (event instanceof CondJump jump) {
                final boolean isExit = !bodySet.contains(jump.getLabel());
                if (!isExit && !IRHelper.isBackJump(jump)) {
                    pendingStates.merge(jump.getLabel(), new HashMap<>(state), ScalarEvolution::merge);
                }

                // We detect exits of the two shapes
                //      (1) if (exitCond) goto Exit;
                //      (2) if (continueCond) goto L; goto Exit;
                // The exit is checked in every iteration if the conditional jump dominates the backjump.
                final boolean isExitingFallthrough = !jump.isGoto() && !isExit
                        && jump.getSuccessor() instanceof CondJump next && next.isGoto()
                        && !bodySet.contains(next.getLabel());
                if (!jump.isGoto() && (isExit || isExitingFallthrough)
                        && dominates(preDominatorTree, jump, backJump)
                        && evaluator.evaluate(jump.getGuard(), state) instanceof Comparison guard) {
                    continueConditions.put(jump, isExit ? guard.negate() : guard);
                }
            }

            if (event == backJump) {
                break; // Do not kill the final state
            } else if (IRHelper.isAlwaysBranching(event)) {
                state = null;
            }
        }
        if (state == null) {
            return List.of();
        }

        // ----- Find the recurrences {r, +, step} -----
        // NOTE: Unmodified registers form the trivial recurrence with step 0.
        final Map<Register, Value> finalState = state;
        final java.util.function.Function<Register, BigInteger> stepOf = reg -> {
            if (!(Evaluator.lookup(finalState, reg) instanceof Affine affine)) {
                return null;
            }
            final Affine step = affine.sub(Affine.of(reg, affine.type()));
            return step.isConstant() ? step.constant() : null;
        };

        // ----- Compute the evolutions of the continue-conditions -----
        final List<ExitEvolution> exits = new ArrayList<>();
        for (Comparison cond : continueConditions.values()) {
            final IntegerType type = cond.left().type();
            final BigInteger leftStep = computeStep(cond.left(), stepOf);
            final BigInteger rightStep = computeStep(cond.right(), stepOf);
            if (leftStep == null || rightStep == null) {
                continue;
            }
            final boolean leftEvolves = leftStep.signum() != 0;
            final boolean rightEvolves = rightStep.signum() != 0;
            if (leftEvolves && !rightEvolves) {
                exits.add(new ExitEvolution(cond.left(), leftStep, cond.op(), cond.right()));
            } else if (!leftEvolves && rightEvolves) {
                exits.add(new ExitEvolution(cond.right(), rightStep, cond.op().reverse(), cond.left()));
            } else if (cond.op() == IntCmpOp.NEQ && !leftStep.equals(rightStep)) {
                // "x != y" is equivalent to "x - y != 0" even if overflows occur (unlike for inequalities).
                final BigInteger step = Affine.normalize(leftStep.subtract(rightStep), type);
                final Affine zero = Affine.of(BigInteger.ZERO, type);
                exits.add(new ExitEvolution(cond.left().sub(cond.right()), step, IntCmpOp.NEQ, zero));
            }
        }
        return exits;
    }

    // Computes the amount by which the value changes per iteration, or NULL if that is not a constant.
    private static BigInteger computeStep(Affine value, java.util.function.Function<Register, BigInteger> stepOf) {
        BigInteger step = BigInteger.ZERO;
        for (Map.Entry<Register, BigInteger> entry : value.coefficients().entrySet()) {
            final BigInteger regStep = stepOf.apply(entry.getKey());
            if (regStep == null) {
                return null;
            }
            step = step.add(regStep.multiply(entry.getValue()));
        }
        return Affine.normalize(step, value.type());
    }

    // Merges the states of two joining control-flow paths. NULL represents the state of an unreachable path.
    // NOTE: The returned state is either NULL or one of the (possibly modified) input states.
    private static Map<Register, Value> merge(Map<Register, Value> first, Map<Register, Value> second) {
        if (first == null || second == null) {
            return first == null ? second : first;
        }
        final Set<Register> registers = new HashSet<>(first.keySet());
        registers.addAll(second.keySet());
        for (Register reg : registers) {
            final Value value = Evaluator.lookup(first, reg);
            first.put(reg, Objects.equals(value, Evaluator.lookup(second, reg)) ? value : null);
        }
        return first;
    }

    private static Set<Register> getRegistersModifiedByLoop(Label loopHeader) {
        final Set<Register> registers = new HashSet<>();
        loopHeader.getJumpSet().stream().filter(IRHelper::isBackJump).forEach(backJump ->
                IRHelper.getEventsFromTo(loopHeader, backJump, true).stream()
                        .filter(RegWriter.class::isInstance).map(RegWriter.class::cast)
                        .forEach(writer -> registers.add(writer.getResultRegister()))
        );
        return registers;
    }

    private static boolean dominates(DominatorTree<Event> preDominatorTree, Event dominator, Event event) {
        return preDominatorTree.contains(dominator) && preDominatorTree.contains(event)
                && preDominatorTree.isDominatedBy(event, dominator);
    }

    // ======================================================================================
    // Register values at loop entry

    private Map<Label, Map<Register, BigInteger>> computeConstantEntryValues(
            Function function, Map<Label, List<ExitEvolution>> loop2Exits, DominatorTree<Event> preDominatorTree) {
        // To find the definitions that reach the loop from the outside,
        // we temporarily insert events in front of the loop that read the registers of interest.
        final Map<Label, Map<Register, LoopBound>> loop2Probes = new LinkedHashMap<>();
        loop2Exits.forEach((loopHeader, exits) -> {
            final Map<Register, LoopBound> probes = new LinkedHashMap<>();
            for (ExitEvolution exit : exits) {
                for (Register reg : exit.getRegisters()) {
                    probes.computeIfAbsent(reg, EventFactory::newLoopBound);
                }
            }
            loopHeader.insertBefore(probes.values());
            loop2Probes.put(loopHeader, probes);
        });

        final ReachingDefinitionsAnalysis reachingDefinitions = reachingDefinitionsAnalysis.forFunction(function);
        final Map<Label, Map<Register, BigInteger>> loop2EntryValues = new HashMap<>();
        loop2Probes.forEach((loopHeader, probes) -> {
            final Map<Register, BigInteger> entryValues = new HashMap<>();
            probes.forEach((reg, probe) -> {
                final BigInteger value = findConstantValue(probe, reg, loopHeader, reachingDefinitions, preDominatorTree);
                if (value != null) {
                    entryValues.put(reg, value);
                }
            });
            loop2EntryValues.put(loopHeader, entryValues);
        });

        loop2Probes.values().forEach(probes -> probes.values().forEach(Event::forceDelete));
        return loop2EntryValues;
    }

    // Returns the constant value of <register> as read by <reader>, or NULL if there is no such constant.
    // <position> is the position of the reader in the dominator tree.
    private BigInteger findConstantValue(RegReader reader, Register register, Event position,
                                         ReachingDefinitionsAnalysis reachingDefinitions,
                                         DominatorTree<Event> preDominatorTree) {
        while (true) {
            final List<RegWriter> writers = reachingDefinitions.getWriters(reader).ofRegister(register).getMayWriters();
            // We require a unique assignment that is always executed (the register may be uninitialized otherwise).
            if (!(writers.size() == 1 && writers.get(0) instanceof Local def
                    && def != position && dominates(preDominatorTree, def, position))) {
                return null;
            }
            if (def.getExpr() instanceof IntLiteral literal) {
                return literal.getValue();
            } else if (def.getExpr() instanceof Register copiedRegister) {
                // Chase the chain of trivial copy assignments.
                reader = def;
                register = copiedRegister;
                position = def;
            } else {
                return null;
            }
        }
    }

    // ======================================================================================
    // Backedge-taken counts

    // An (unsigned) upper bound on the number of times the backjump of a loop is taken.
    // The bound is only valid if <assumption> holds. Both expressions are evaluated at loop entry.
    private record Count(Expression value, Expression assumption) { }

    private static boolean isTrue(Expression expr) {
        return expr instanceof BoolLiteral literal && literal.getValue();
    }

    private static Expression simplify(Expression expr) {
        return expr.accept(new ExprSimplifier(true));
    }

    private static Count combine(Count first, Count second) {
        if (!isTrue(first.assumption()) || !isTrue(second.assumption())) {
            return isTrue(second.assumption()) ? second : first;
        }
        if (!first.value().getType().equals(second.value().getType())) {
            return first;
        }
        final Expression min = expressions.makeIntBinary(first.value(), IntBinaryOp.UMIN, second.value());
        return new Count(simplify(min), first.assumption());
    }

    // Computes the first k for which "(start + step*k) op limit" is violated.
    // Returns NULL if there is no such k, or we cannot compute it.
    private Count computeCount(ExitEvolution exit) {
        final IntegerType type = exit.start().type();
        final int bitWidth = type.getBitWidth();
        final BigInteger step = IntegerHelper.normalizeSigned(exit.step(), bitWidth);
        final IntCmpOp op = exit.op();

        Expression count;
        Expression assumption = expressions.makeTrue();
        if (op == IntCmpOp.NEQ) {
            // We solve "step * k == limit - start" modulo 2^bitWidth:
            // Let step = 2^t * odd. If 2^t divides "limit - start" then "k = ((limit - start) * odd^-1) >> t".
            final BigInteger unsignedStep = exit.step();
            final int twoExponent = unsignedStep.getLowestSetBit();
            final BigInteger oddInverse = unsignedStep.shiftRight(twoExponent).modInverse(BigInteger.ONE.shiftLeft(bitWidth));
            final Affine distance = exit.limit().sub(exit.start());
            count = distance.scale(oddInverse).toExpression();
            if (twoExponent > 0) {
                final Expression lowBits = expressions.makeIntAnd(distance.toExpression(),
                        expressions.makeValue(BigInteger.ONE.shiftLeft(twoExponent).subtract(BigInteger.ONE), type));
                count = expressions.makeRshift(count, expressions.makeValue(twoExponent, type), false);
                assumption = expressions.makeEQ(lowBits, expressions.makeZero(type));
            }
        } else if (op != IntCmpOp.EQ) {
            final boolean signed = op.isSigned();
            final boolean countsUp = op.isLessCategory();
            if (countsUp != (step.signum() > 0)) {
                // The evolution moves away from the limit.
                return null;
            }
            final BigInteger absStep = step.abs();
            final Expression stepSize = expressions.makeValue(absStep, type);
            final Expression start = exit.start().toExpression();
            final Expression limit = exit.limit().toExpression();
            final Expression entered = expressions.makeIntCmp(start, op, limit);
            final Affine distance = countsUp ? exit.limit().sub(exit.start()) : exit.start().sub(exit.limit());

            // The loop gets exited once the evolution reaches or steps over the limit: this must happen without
            // overflow, i.e., there must be enough space between the limit and the maximal/minimal integer.
            final Expression iterations;
            final BigInteger space;
            if (op.isStrict()) {
                // We have "k = ceil(distance / |step|)" which lands at most |step|-1 behind the limit.
                iterations = absStep.equals(BigInteger.ONE) ? distance.toExpression() : expressions.makeAdd(
                        expressions.makeDiv(distance.add(-1).toExpression(), stepSize, false),
                        expressions.makeOne(type));
                space = absStep.subtract(BigInteger.ONE);
            } else {
                // We have "k = floor(distance / |step|) + 1" which lands at most |step| behind the limit.
                iterations = expressions.makeAdd(
                        expressions.makeDiv(distance.toExpression(), stepSize, false),
                        expressions.makeOne(type));
                space = absStep;
            }
            count = expressions.makeITE(entered, iterations, expressions.makeZero(type));
            if (space.signum() > 0) {
                final Expression extremalLimit = expressions.makeValue(countsUp
                        ? type.getMaximumValue(signed).subtract(space)
                        : type.getMinimumValue(signed).add(space), type);
                assumption = countsUp ? expressions.makeLTE(limit, extremalLimit, signed)
                        : expressions.makeGTE(limit, extremalLimit, signed);
            }
        } else {
            return null;
        }

        assumption = simplify(assumption);
        if (assumption instanceof BoolLiteral literal && !literal.getValue()) {
            return null;
        }
        return new Count(simplify(count), assumption);
    }
}
