package com.dat3m.dartagnan.program.processing;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.processing.ExprTransformer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.analysis.LoopAnalysis;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.RegReader;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Alloc;
import com.dat3m.dartagnan.program.event.core.Local;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.expression.integers.IntBinaryOp.*;
import static com.dat3m.dartagnan.expression.integers.IntCmpOp.*;

/*
    This pass tries to remove unnecessary NULL checks in a very simple manner:
    it tries to figure out the signedness of expressions and if they are always positive, then they cannot be NULL.

    The signedness is determined as follows:
      - Registers written to by Allocs as well as MemoryObject expressions are always positive (allocations always succeed!)
      - Positive constants are positive (duh).
      - Some operations (like addition) preserve positiveness.

    TODO: The pass is very naive: it globally assigns a signedness to registers rather than per program point.
    TODO 2: This pass only runs correctly on unrolled code and will skip functions with loops.
 */
public class RemoveDeadNullChecks implements FunctionProcessor {

    private final static Logger logger = LogManager.getLogger(RemoveDeadNullChecks.class)
;
    private RemoveDeadNullChecks() { }

    public static RemoveDeadNullChecks newInstance() { return new RemoveDeadNullChecks(); }

    private enum Sign {
        UNKNOWN,
        NON_NEG,
        POS;

        static Sign meet(Sign a, Sign b) {
            if (a == UNKNOWN || b == UNKNOWN) {
                return UNKNOWN;
            } else if (a == NON_NEG || b == NON_NEG) {
                return NON_NEG;
            }
            return POS;
        }
    }

    @Override
    public void run(Function function) {
        final List<LoopAnalysis.LoopInfo> loops = LoopAnalysis.onFunction(function).getLoopsOfFunction(function);
        if (loops.stream().anyMatch(loop -> !loop.isUnrolled())) {
            logger.warn("Skipping null check deletion on function with loops: {}", function);
            return;
        }

        // Collects signs of registers.
        final SignChecker signChecker = new SignChecker();
        function.getEvents().forEach(e -> e.accept(signChecker));

        // Simplify null checks on always-positive (and hence non-null) expressions.
        final NullCheckReplacer replacer = new NullCheckReplacer(signChecker);
        function.getEvents(RegReader.class).forEach(reader -> reader.transformExpressions(replacer));

    }

    private static class NullCheckReplacer extends ExprTransformer {

        private final SignChecker signChecker;

        private NullCheckReplacer(SignChecker signChecker) {
            this.signChecker = signChecker;
        }

        @Override
        public Expression visitIntCmpExpression(IntCmpExpr cmp) {
            if (cmp.getRight() instanceof IntLiteral lit && lit.isZero() && cmp.getLeft().accept(signChecker) == Sign.POS) {
                // Simplify "expr cop 0" if <expr> is known to be positive.
                final IntCmpOp op = cmp.getKind();
                final boolean valueOnNonNull = (op == NEQ || op == GT || op == GTE || op == UGT || op == UGTE);
                return ExpressionFactory.getInstance().makeValue(valueOnNonNull);
            }
            return cmp;
        }
    }

    private static class SignChecker implements ExpressionVisitor<Sign>, EventVisitor<Void> {

        private final Map<Register, Sign> signMap = new HashMap<>();

        @Override
        public Void visitEvent(Event e) {
            if (e instanceof RegWriter writer) {
                signMap.put(writer.getResultRegister(), Sign.UNKNOWN);
            }
            return null;
        }

        @Override
        public Void visitLocal(Local e) {
            final Sign sign = e.getExpr().accept(this);
            signMap.compute(e.getResultRegister(), (key, s) -> s == null ? sign : Sign.meet(s, sign));
            return null;
        }

        @Override
        public Void visitAlloc(Alloc e) {
            final Sign sign = Sign.POS;
            signMap.compute(e.getResultRegister(), (key, s) -> s == null ? sign : Sign.meet(s, sign));
            return null;
        }


        // ============================== Expressions ==============================

        @Override
        public Sign visitExpression(Expression expr) {
            return Sign.UNKNOWN;
        }

        @Override
        public Sign visitRegister(Register reg) {
            return signMap.getOrDefault(reg, Sign.UNKNOWN);
        }

        @Override
        public Sign visitMemoryObject(MemoryObject memObj) {
            return Sign.POS;
        }

        @Override
        public Sign visitFunction(Function function) {
            return Sign.POS;
        }

        @Override
        public Sign visitIntLiteral(IntLiteral lit) {
            final int cmpRes = lit.getValue().compareTo(BigInteger.ZERO);
            return cmpRes > 0 ? Sign.POS : cmpRes == 0 ? Sign.NON_NEG : Sign.UNKNOWN;
        }

        @Override
        public Sign visitIntBinaryExpression(IntBinaryExpr expr) {
            final Sign leftSign = expr.getLeft().accept(this);
            final Sign rightSign = expr.getRight().accept(this);
            if (leftSign == Sign.UNKNOWN || rightSign == Sign.UNKNOWN) {
                return Sign.UNKNOWN;
            }

            // --- Both subexpressions are (at least) non-negative ---
            final IntBinaryOp op = expr.getKind();
            if ((leftSign == Sign.POS || rightSign == Sign.POS) && op == ADD) {
                return Sign.POS;
            } else if (op == MUL || op == UREM || op == UDIV) {
                return Sign.NON_NEG;
            }
            // TODO: We can add more cases for precision, but the above already works quite well
            return Sign.UNKNOWN;
        }

        @Override
        public Sign visitITEExpression(ITEExpr expr) {
            return Sign.meet(expr.getTrueCase().accept(this), expr.getFalseCase().accept(this));
        }

    }

}
