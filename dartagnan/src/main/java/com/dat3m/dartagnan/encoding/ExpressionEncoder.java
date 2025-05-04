package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.aggregates.AggregateCmpExpr;
import com.dat3m.dartagnan.expression.aggregates.ConstructExpr;
import com.dat3m.dartagnan.expression.aggregates.ExtractExpr;
import com.dat3m.dartagnan.expression.aggregates.InsertExpr;
import com.dat3m.dartagnan.expression.booleans.BoolBinaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolLiteral;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryExpr;
import com.dat3m.dartagnan.expression.booleans.BoolUnaryOp;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.type.*;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.dat3m.dartagnan.smt.FormulaManagerExt;
import com.dat3m.dartagnan.smt.TupleFormula;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import static com.google.common.base.Preconditions.checkArgument;
import static com.google.common.base.Preconditions.checkState;
import static java.util.Arrays.asList;

/*
    This class is responsible for doing all encoding related to IR types, in particular, all kinds of expressions.
 */
public class ExpressionEncoder {

    private static final TypeFactory types = TypeFactory.getInstance();

    private final EncodingContext context;
    private final FormulaManagerExt fmgr;
    private final BooleanFormulaManager bmgr;
    private final Visitor visitor = new Visitor();

    ExpressionEncoder(EncodingContext context) {
        this.context = context;
        this.fmgr = context.getFormulaManager();
        this.bmgr = fmgr.getBooleanFormulaManager();
    }

    private IntegerFormulaManager integerFormulaManager() {
        return fmgr.getIntegerFormulaManager();
    }

    private BitvectorFormulaManager bitvectorFormulaManager() {
        return fmgr.getBitvectorFormulaManager();
    }

    // ====================================================================================
    // Public API

    public TypedFormula<?, ?> encodeAt(Expression expression, Event at) {
        Preconditions.checkNotNull(at);
        visitor.setEvent(at);
        return expression.accept(visitor);
    }

    public TypedFormula<?, ?> encodeFinal(Expression expression) {
        visitor.setEvent(null);
        return expression.accept(visitor);
    }

    @SuppressWarnings("unchecked")
    public TypedFormula<BooleanType, BooleanFormula> encodeBooleanAt(Expression expression, Event at) {
        Preconditions.checkArgument(expression.getType() instanceof BooleanType);
        return (TypedFormula<BooleanType, BooleanFormula>) encodeAt(expression, at);
    }

    @SuppressWarnings("unchecked")
    public TypedFormula<BooleanType, BooleanFormula> encodeBooleanFinal(Expression expression) {
        Preconditions.checkArgument(expression.getType() instanceof BooleanType);
        return (TypedFormula<BooleanType, BooleanFormula>) encodeFinal(expression);
    }

    public <TType extends Type> TypedFormula<TType, ?> makeVariable(String name, TType type) {
        Formula variable = null;
        if (type instanceof BooleanType) {
            variable = bmgr.makeVariable(name);
        } else if (type instanceof IntegerType integerType) {
            variable = context.useIntegers
                    ? integerFormulaManager().makeVariable(name)
                    : bitvectorFormulaManager().makeVariable(integerType.getBitWidth(), name);
        } else if (type instanceof AggregateType || type instanceof ArrayType) {
            final Map<Integer, Type> primitives = types.decomposeIntoPrimitives(type);
            if (primitives != null) {
                final List<Formula> elements = new ArrayList<>();
                for (Map.Entry<Integer, Type> entry : primitives.entrySet()) {
                    elements.add(makeVariable(name + "@" + entry.getKey(), entry.getValue()).formula());
                }
                variable = fmgr.getTupleFormulaManager().makeTuple(elements);
            }
        }

        if (variable == null) {
            throw new UnsupportedOperationException(String.format("Cannot make variable of type %s.", type));
        }
        return new TypedFormula<>(type, variable);
    }

    public TypedFormula<BooleanType, BooleanFormula> wrap(BooleanFormula formula) {
        return new TypedFormula<>(types.getBooleanType(), formula);
    }

    public <TType extends Type, TFormula extends Formula> TypedFormula<TType, TFormula> wrap(TType type, TFormula formula) {
        return new TypedFormula<>(type, formula);
    }

    // ====================================================================================
    // Utility

    // TODO: For conversion operations, we might want to have an universal intermediate type T with the following properties:
    //  (1) every other type has a lossless conversion to T
    //  (2) T can be converted to every other type (possibly with loss)
    //  (3) A round-trip through T is always lossless.
    //  See comments on TypedFormula class for more details.
    public enum ConversionMode {
        NO,
        LEFT_TO_RIGHT,
        RIGHT_TO_LEFT,
    }

    public BooleanFormula equal(Expression left, Expression right, ConversionMode cMode) {
        final ExpressionFactory exprs = context.getExpressionFactory();
        switch (cMode) {
            case NO -> {}
            case LEFT_TO_RIGHT -> left = exprs.makeCast(left, right.getType());
            case RIGHT_TO_LEFT -> right = exprs.makeCast(right, left.getType());
        }

        return encodeBooleanFinal(exprs.makeEQ(left, right)).formula();
    }

    public BooleanFormula equal(Expression left, Expression right) {
        return equal(left, right, ConversionMode.NO);
    }

    public BooleanFormula equalAt(Expression left, Event leftAt, Expression right, Event rightAt, ConversionMode cMode) {
        return equal(encodeAt(left, leftAt), encodeAt(right, rightAt), cMode);
    }

    public BooleanFormula equalAt(Expression left, Event leftAt, Expression right, Event rightAt) {
        return equal(encodeAt(left, leftAt), encodeAt(right, rightAt));
    }

    // ====================================================================================
    // Private implementation

    // TODO: We can probably just return plain formulas and let the outer class
    //  wrap them correctly.
    private class Visitor implements ExpressionVisitor<TypedFormula<?, ?>> {

        private Event event;
        public void setEvent(Event e) {
            this.event = e;
        }

        public TypedFormula<?, ?> encode(Expression expression) {
            return expression.accept(this);
        }

        @SuppressWarnings("unchecked")
        public TypedFormula<IntegerType, ?> encodeIntegerExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof IntegerType);
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.getType() == expression.getType();
            assert typedFormula.formula() instanceof IntegerFormula || typedFormula.formula() instanceof BitvectorFormula;
            return (TypedFormula<IntegerType, ?>) typedFormula;
        }

        @SuppressWarnings("unchecked")
        public TypedFormula<BooleanType, BooleanFormula> encodeBooleanExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof BooleanType);
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.getType() == expression.getType();
            assert typedFormula.formula() instanceof BooleanFormula;
            return (TypedFormula<BooleanType, BooleanFormula>) typedFormula;
        }

        @SuppressWarnings("unchecked")
        public TypedFormula<?, TupleFormula> encodeAggregateExpr(Expression expression) {
            Preconditions.checkArgument(ExpressionHelper.isAggregateLike(expression));
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.getType() == expression.getType();
            assert typedFormula.formula() instanceof TupleFormula;
            return (TypedFormula<?, TupleFormula>) typedFormula;
        }

        @Override
        public TypedFormula<?, ?> visitLeafExpression(LeafExpression expr) {
            if (expr instanceof TypedFormula<?, ?> typedFormula) {
                return typedFormula;
            }
            return visitExpression(expr);
        }

        // ====================================================================================
        // Booleans

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitBoolLiteral(BoolLiteral boolLiteral) {
            return new TypedFormula<>(types.getBooleanType(), bmgr.makeBoolean(boolLiteral.getValue()));
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitBoolBinaryExpression(BoolBinaryExpr bBin) {
            final TypedFormula<BooleanType, BooleanFormula> lhs = encodeBooleanExpr(bBin.getLeft());
            final TypedFormula<BooleanType, BooleanFormula> rhs = encodeBooleanExpr(bBin.getRight());
            final BooleanFormula result = switch (bBin.getKind()) {
                case AND -> bmgr.and(lhs.formula(), rhs.formula());
                case OR -> bmgr.or(lhs.formula(), rhs.formula());
                case IFF -> bmgr.equivalence(lhs.formula(), rhs.formula());
            };
            return new TypedFormula<>(types.getBooleanType(), result);
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitBoolUnaryExpression(BoolUnaryExpr bUn) {
            final TypedFormula<BooleanType, BooleanFormula> inner = encodeBooleanExpr(bUn.getOperand());
            assert bUn.getKind() == BoolUnaryOp.NOT;
            return new TypedFormula<>(types.getBooleanType(), bmgr.not(inner.formula()));
        }

        // ====================================================================================
        // Integers

        @Override
        public TypedFormula<IntegerType, ?> visitIntLiteral(IntLiteral intLiteral) {
            final Formula result = context.useIntegers
                    ? integerFormulaManager().makeNumber(intLiteral.getValue())
                    : bitvectorFormulaManager().makeBitvector(intLiteral.getType().getBitWidth(), intLiteral.getValue());
            return new TypedFormula<>(intLiteral.getType(), result);
        }

        @Override
        public TypedFormula<IntegerType, ?> visitIntBinaryExpression(IntBinaryExpr iBin) {
            final TypedFormula<IntegerType, ?> lhs = encodeIntegerExpr(iBin.getLeft());
            final TypedFormula<IntegerType, ?> rhs = encodeIntegerExpr(iBin.getRight());
            final IntegerType type = iBin.getType();
            final int bitWidth = type.getBitWidth();

            if (context.useIntegers) {
                final IntegerFormula i1 = (IntegerFormula) lhs.formula();
                final IntegerFormula i2 = (IntegerFormula) rhs.formula();

                final BitvectorFormulaManager bvmgr;
                final IntegerFormulaManager imgr = integerFormulaManager();
                final IntegerFormula result = switch (iBin.getKind()) {
                    case ADD -> imgr.add(i1, i2);
                    case SUB -> imgr.subtract(i1, i2);
                    case MUL -> imgr.multiply(i1, i2);
                    case DIV, UDIV -> imgr.divide(i1, i2);
                    case AND -> {
                        bvmgr = bitvectorFormulaManager();
                        final BitvectorFormula resultBv = bvmgr.and(bvmgr.makeBitvector(bitWidth, i1), bvmgr.makeBitvector(bitWidth, i2));
                        yield bvmgr.toIntegerFormula(resultBv, false);
                    }
                    case OR -> {
                        bvmgr = bitvectorFormulaManager();
                        final BitvectorFormula resultBv = bvmgr.or(bvmgr.makeBitvector(bitWidth, i1), bvmgr.makeBitvector(bitWidth, i2));
                        yield bvmgr.toIntegerFormula(resultBv, false);
                    }
                    case XOR -> {
                        bvmgr = bitvectorFormulaManager();
                        final BitvectorFormula resultBv = bvmgr.xor(bvmgr.makeBitvector(bitWidth, i1), bvmgr.makeBitvector(bitWidth, i2));
                        yield bvmgr.toIntegerFormula(resultBv, false);
                    }
                    case LSHIFT -> {
                        bvmgr = bitvectorFormulaManager();
                        final BitvectorFormula resultBv = bvmgr.shiftLeft(bvmgr.makeBitvector(bitWidth, i1), bvmgr.makeBitvector(bitWidth, i2));
                        yield bvmgr.toIntegerFormula(resultBv, false);
                    }
                    case RSHIFT -> {
                        bvmgr = bitvectorFormulaManager();
                        final BitvectorFormula resultBv = bvmgr.shiftRight(bvmgr.makeBitvector(bitWidth, i1), bvmgr.makeBitvector(bitWidth, i2), false);
                        yield bvmgr.toIntegerFormula(resultBv, false);
                    }
                    case ARSHIFT -> {
                        bvmgr = bitvectorFormulaManager();
                        final BitvectorFormula resultBv = bvmgr.shiftRight(bvmgr.makeBitvector(bitWidth, i1), bvmgr.makeBitvector(bitWidth, i2), true);
                        yield bvmgr.toIntegerFormula(resultBv, false);
                    }
                    case SREM, UREM -> {
                        final IntegerFormula zero = imgr.makeNumber(0);
                        final IntegerFormula modulo = imgr.modulo(i1, i2);
                        final BooleanFormula cond = bmgr.and(
                                imgr.distinct(asList(modulo, zero)),
                                imgr.lessThan(i1, zero)
                        );
                        yield fmgr.ifThenElse(cond, imgr.subtract(modulo, i2), modulo);
                    }
                };

                return new TypedFormula<>(type, result);
            } else {
                final BitvectorFormula bv1 = (BitvectorFormula) lhs.formula();
                final BitvectorFormula bv2 = (BitvectorFormula) rhs.formula();

                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula result = switch (iBin.getKind()) {
                    case ADD -> bvmgr.add(bv1, bv2);
                    case SUB -> bvmgr.subtract(bv1, bv2);
                    case MUL -> bvmgr.multiply(bv1, bv2);
                    case DIV -> bvmgr.divide(bv1, bv2, true);
                    case UDIV -> bvmgr.divide(bv1, bv2, false);
                    case SREM -> bvmgr.remainder(bv1, bv2, true);
                    case UREM -> bvmgr.remainder(bv1, bv2, false);
                    case AND -> bvmgr.and(bv1, bv2);
                    case OR -> bvmgr.or(bv1, bv2);
                    case XOR -> bvmgr.xor(bv1, bv2);
                    case LSHIFT -> bvmgr.shiftLeft(bv1, bv2);
                    case RSHIFT -> bvmgr.shiftRight(bv1, bv2, false);
                    case ARSHIFT -> bvmgr.shiftRight(bv1, bv2, true);
                };

                return new TypedFormula<>(type, result);
            }
        }

        @Override
        public TypedFormula<IntegerType, ?> visitIntSizeCastExpression(IntSizeCast expr) {
            final TypedFormula<IntegerType, ?> inner = encodeIntegerExpr(expr.getOperand());

            if (expr.isNoop()) {
                return inner;
            } else if (context.useIntegers) {
                //TODO If narrowing, constrain the value.
                return new TypedFormula<>(expr.getType(), inner.formula());
            } else {
                assert inner.formula() instanceof BitvectorFormula;

                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula innerBv = (BitvectorFormula) inner.formula();
                final int targetBitWidth = expr.getTargetType().getBitWidth();
                final int sourceBitWidth = expr.getSourceType().getBitWidth();
                assert (sourceBitWidth == bvmgr.getLength(innerBv));

                final BitvectorFormula result = expr.isExtension()
                        ? bvmgr.extend(innerBv, targetBitWidth - sourceBitWidth, expr.preservesSign())
                        : bvmgr.extract(innerBv, targetBitWidth - 1, 0);
                return new TypedFormula<IntegerType, Formula>(expr.getType(), result);
            }
        }

        @Override
        public TypedFormula<IntegerType, ?> visitIntUnaryExpression(IntUnaryExpr iUn) {
            final TypedFormula<IntegerType, ?> inner = encodeIntegerExpr(iUn.getOperand());

            if (context.useIntegers) {
                final IntegerFormulaManager imgr = integerFormulaManager();
                final IntegerFormula innerForm = (IntegerFormula) inner.formula();
                final IntegerFormula result = switch (iUn.getKind()) {
                    case MINUS -> imgr.negate(innerForm);
                    default ->
                            throw new UnsupportedOperationException("Unsupported operation on mathematical integers: " + iUn.getKind());
                };

                return new TypedFormula<IntegerType, Formula>(iUn.getType(), result);
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula bv = (BitvectorFormula) inner.formula();

                final BitvectorFormula result = switch (iUn.getKind()) {
                    case MINUS -> bvmgr.negate(bv);
                    case CTLZ -> {
                        final int bvLength = bvmgr.getLength(bv);
                        final BitvectorFormula bv1 = bvmgr.makeBitvector(1, 1);

                        // enc = extract(bv, 63, 63) == 1 ? 0 : (extract(bv, 62, 62) == 1 ? 1 : extract ... extract(bv, 0, 0) == 1 ? 63 : 64)
                        BitvectorFormula ctlz = bvmgr.makeBitvector(bvLength, bvLength);
                        for (int i = bvLength - 1; i >= 0; i--) {
                            BitvectorFormula bvi = bvmgr.makeBitvector(bvLength, i);
                            BitvectorFormula bvbit = bvmgr.extract(bv, bvLength - (i + 1), bvLength - (i + 1));
                            ctlz = fmgr.ifThenElse(bvmgr.equal(bvbit, bv1), bvi, ctlz);
                        }
                        yield ctlz;
                    }
                    case CTTZ -> {
                        final int bvLength = bvmgr.getLength(bv);
                        final BitvectorFormula bv1 = bvmgr.makeBitvector(1, 1);

                        // enc = extract(bv, 0, 0) == 1 ? 0 : (extract(bv, 1, 1) == 1 ? 1 : extract ... extract(bv, 63, 63) == 1? 63 : 64)
                        BitvectorFormula cttz = bvmgr.makeBitvector(bvLength, bvLength);
                        for (int i = bvLength - 1; i >= 0; i--) {
                            BitvectorFormula bvi = bvmgr.makeBitvector(bvLength, i);
                            BitvectorFormula bvbit = bvmgr.extract(bv, i, i);
                            cttz = fmgr.ifThenElse(bvmgr.equal(bvbit, bv1), bvi, cttz);
                        }
                        yield cttz;
                    }
                };

                return new TypedFormula<IntegerType, Formula>(iUn.getType(), result);
            }
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitIntCmpExpression(IntCmpExpr cmp) {
            final TypedFormula<?, ?> lhs = encode(cmp.getLeft());
            final TypedFormula<?, ?> rhs = encode(cmp.getRight());
            final IntCmpOp op = cmp.getKind();

            if (context.useIntegers) {
                final IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
                final IntegerFormula l = (IntegerFormula) lhs.formula();
                final IntegerFormula r = (IntegerFormula) rhs.formula();

                final BooleanFormula result = switch (op) {
                    case EQ -> imgr.equal(l, r);
                    case NEQ -> fmgr.getBooleanFormulaManager().not(imgr.equal(l, r));
                    case LT, ULT -> imgr.lessThan(l, r);
                    case LTE, ULTE -> imgr.lessOrEquals(l, r);
                    case GT, UGT -> imgr.greaterThan(l, r);
                    case GTE, UGTE -> imgr.greaterOrEquals(l, r);
                };

                return new TypedFormula<>(types.getBooleanType(), result);
            } else {
                final BitvectorFormulaManager bvmgr = fmgr.getBitvectorFormulaManager();
                final BitvectorFormula l = (BitvectorFormula) lhs.formula();
                final BitvectorFormula r = (BitvectorFormula) rhs.formula();
                final boolean isSigned = op.isSigned();

                final BooleanFormula result = switch (op) {
                    case EQ -> bvmgr.equal(l, r);
                    case NEQ -> fmgr.getBooleanFormulaManager().not(bvmgr.equal(l, r));
                    case LT, ULT -> bvmgr.lessThan(l, r, isSigned);
                    case LTE, ULTE -> bvmgr.lessOrEquals(l, r, isSigned);
                    case GT, UGT -> bvmgr.greaterThan(l, r, isSigned);
                    case GTE, UGTE -> bvmgr.greaterOrEquals(l, r, isSigned);
                };

                return new TypedFormula<>(types.getBooleanType(), result);
            }
        }

        // ====================================================================================
        // Aggregates

        @Override
        public TypedFormula<?, TupleFormula> visitConstructExpression(ConstructExpr construct) {
            final List<Formula> elements = new ArrayList<>();
            for (Expression inner : construct.getOperands()) {
                elements.add(encode(inner).formula());
            }
            return new TypedFormula<>(construct.getType(), fmgr.getTupleFormulaManager().makeTuple(elements));
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitAggregateCmpExpression(AggregateCmpExpr expr) {
            final TypedFormula<?, TupleFormula> left = encodeAggregateExpr(expr.getLeft());
            final TypedFormula<?, TupleFormula> right = encodeAggregateExpr(expr.getRight());

            final BooleanFormula eq = fmgr.equal(left.formula(), right.formula());
            final BooleanFormula result = switch (expr.getKind()) {
                case EQ -> eq;
                case NEQ -> context.getBooleanFormulaManager().not(eq);
            };
            return new TypedFormula<>(types.getBooleanType(), result);
        }

        @Override
        public TypedFormula<?, ?> visitExtractExpression(ExtractExpr extract) {
            final TypedFormula<?, TupleFormula> inner = encodeAggregateExpr(extract.getOperand());
            final Formula extractForm = fmgr.getTupleFormulaManager().extract(inner.formula(), extract.getIndices());
            return new TypedFormula<>(extract.getType(), extractForm);
        }

        @Override
        public TypedFormula<?, TupleFormula> visitInsertExpression(InsertExpr insert) {
            final TupleFormula agg = encodeAggregateExpr(insert.getAggregate()).formula();
            final Formula value = encode(insert.getInsertedValue()).formula();
            final TupleFormula insertForm = fmgr.getTupleFormulaManager().insert(agg, value, insert.getIndices());
            return new TypedFormula<>(insert.getType(), insertForm);
        }

        // ====================================================================================
        // Misc

        @Override
        public TypedFormula<?, ?> visitITEExpression(ITEExpr iteExpr) {
            final BooleanFormula guard = encodeBooleanExpr(iteExpr.getCondition()).formula();
            final Formula tBranch = encode(iteExpr.getTrueCase()).formula();
            final Formula fBranch = encode(iteExpr.getFalseCase()).formula();
            final Formula ite = fmgr.ifThenElse(guard, tBranch, fBranch);
            return new TypedFormula<>(iteExpr.getType(), ite);
        }

        // ====================================================================================
        // Program primitives

        @Override
        public TypedFormula<?, ?> visitNonDetValue(NonDetValue nonDet) {
            return makeVariable(nonDet.toString(), nonDet.getType());
        }

        @Override
        public TypedFormula<?, ?> visitRegister(Register reg) {
            final String name = event == null ?
                    reg.getName() + "_" + reg.getFunction().getId() + "_final" :
                    reg.getName() + "(" + event.getGlobalId() + ")";
            return makeVariable(name, reg.getType());
        }

        @Override
        public TypedFormula<?, ?> visitMemoryObject(MemoryObject memObj) {
            return makeVariable(String.format("addrof(%s)", memObj), memObj.getType());
        }

        @Override
        public TypedFormula<?, ?> visitFinalMemoryValue(FinalMemoryValue val) {
            checkState(event == null, "Cannot evaluate final memory value of %s at event %s.", val, event);
            final MemoryObject base = val.getMemoryObject();
            final int offset = val.getOffset();
            checkArgument(base.isInRange(offset), "Array index out of bounds");
            final String name = String.format("last_val_at_%s_%d", base, offset);
            return makeVariable(name, val.getType());
        }
    }
}
