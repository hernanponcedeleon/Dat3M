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
import com.dat3m.dartagnan.expression.floats.*;
import com.dat3m.dartagnan.expression.integers.*;
import com.dat3m.dartagnan.expression.memory.*;
import com.dat3m.dartagnan.expression.misc.ITEExpr;
import com.dat3m.dartagnan.expression.misc.NamedExpression;
import com.dat3m.dartagnan.expression.processing.ExprSimplifier;
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
import org.sosy_lab.java_smt.api.FormulaType.FloatingPointType;

import java.util.ArrayList;
import java.util.List;

/*
    This class is responsible for doing all encoding related to IR types, in particular, all kinds of expressions.
 */
public class ExpressionEncoder {

    private static final TypeFactory types = TypeFactory.getInstance();

    private final EncodingContext context;
    private final FormulaManagerExt fmgr;
    private final BooleanFormulaManager bmgr;
    private final BitvectorFormulaManager bvmgr;
    private final ExprSimplifier simplifier = new ExprSimplifier(true);
    private final Visitor visitor = new Visitor();

    private final FloatingPointRoundingMode roundingMode;

    ExpressionEncoder(EncodingContext context) {
        this.context = context;
        this.fmgr = context.getFormulaManager();
        this.bmgr = fmgr.getBooleanFormulaManager();
        this.bvmgr = fmgr.getBitvectorFormulaManager();

        this.roundingMode = context.getTask().getProgram().getFloatRoundingMode();
    }

    private FloatingPointFormulaManager floatingPointFormulaManager() {
        return fmgr.getFloatingPointFormulaManager();
    }

    private FloatingPointType getFloatFormulaType(FloatType type) {
        return FormulaType.getFloatingPointType(type.getExponentBits(), type.getMantissaBits());
    }

    // ====================================================================================
    // Public API

    public TypedFormula<?, ?> encodeAt(Expression expression, Event at) {
        Preconditions.checkNotNull(at);
        visitor.setEvent(at);
        return new TypedFormula<>(expression.getType(), expression.accept(visitor));
    }

    public TypedFormula<?, ?> encodeFinal(Expression expression) {
        visitor.setEvent(null);
        return new TypedFormula<>(expression.getType(), expression.accept(visitor));
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
        final Formula variable;
        if (type instanceof BooleanType) {
            variable = bmgr.makeVariable(name);
        } else if (type instanceof IntegerType integerType) {
            variable = bvmgr.makeVariable(integerType.getBitWidth(), name);
        } else if (type instanceof MemoryType memoryType) {
            variable = bvmgr.makeVariable(memoryType.getBitWidth(), name);
        } else if (type instanceof FloatType floatType) {
            variable = floatingPointFormulaManager().makeVariable(name, getFloatFormulaType(floatType));
        } else if (type instanceof AggregateType aggType) {
            final List<Formula> fields = new ArrayList<>(aggType.getFields().size());
            for (TypeOffset field : aggType.getFields()) {
                fields.add(makeVariable(name + "@" + field.offset(), field.type()).formula());
            }
            variable = fmgr.getTupleFormulaManager().makeTuple(fields);
        } else if (type instanceof ArrayType arrType) {
            Preconditions.checkArgument(arrType.hasKnownNumElements(), "Cannot encode array of unknown size.");
            final List<Formula> elements = new ArrayList<>(arrType.getNumElements());
            for (int i = 0; i < arrType.getNumElements(); i++) {
                elements.add(makeVariable(name + "[" + i + "]", arrType.getElementType()).formula());
            }
            variable = fmgr.getTupleFormulaManager().makeTuple(elements);
        } else {
            throw new UnsupportedOperationException(String.format("Cannot make variable of type %s.", type));
        }

        return new TypedFormula<>(type, variable);
    }

    public TypedFormula<BooleanType, BooleanFormula> wrap(BooleanFormula formula) {
        return new TypedFormula<>(types.getBooleanType(), formula);
    }

    // ====================================================================================
    // Utility

    public BooleanFormula equal(Expression left, Expression right) {
        Preconditions.checkArgument(left.getType().equals(right.getType()));
        return encodeBooleanFinal(context.getExpressionFactory().makeEQ(left, right)).formula();
    }

    public BooleanFormula equalAt(Expression left, Event leftAt, Expression right, Event rightAt) {
        return equal(encodeAt(left, leftAt), encodeAt(right, rightAt));
    }

    public enum ConversionMode {
        STRICT,                     // No conversion, types must match exactly
        CAST,                       // Immediate cast
        MEMORY_ROUND_TRIP_STRICT,   // Round-trip over memory, but source/target type sizes must match (~bitcast)
        MEMORY_ROUND_TRIP_RELAXED,  // Round-trip over memory, source/target can have mismatching sizes
    }

    // Encodes assignment equality "left := right" with a possible conversion applied to the rhs.
    public BooleanFormula assignEqual(Expression left, Expression right, ConversionMode conversion) {
        final ExpressionFactory exprs = context.getExpressionFactory();

        final Expression value = switch (conversion) {
            case STRICT -> {
                Preconditions.checkArgument(left.getType().equals(right.getType()));
                yield right;
            }
            case CAST -> {
                yield exprs.makeCast(right, left.getType());
            }
            case MEMORY_ROUND_TRIP_STRICT, MEMORY_ROUND_TRIP_RELAXED -> {
                final boolean strict = conversion == ConversionMode.MEMORY_ROUND_TRIP_STRICT;
                yield exprs.makeCastOverMemory(right, left.getType(), strict);
            }
        };

        return equal(left, value.accept(simplifier));
    }


    public BooleanFormula assignEqual(Expression left, Expression right) {
        return assignEqual(left, right, ConversionMode.STRICT);
    }

    public BooleanFormula assignEqualAt(Expression left, Event leftAt, Expression right, Event rightAt) {
        return assignEqual(encodeAt(left, leftAt), encodeAt(right, rightAt));
    }

    // ====================================================================================
    // Private implementation

    private void checkMemoryCastSupport(Type type) {
        if (!(type instanceof IntegerType) && !(type instanceof FloatType)) {
            throw new UnsupportedOperationException("Cannot cast between memory and type: " + type);
        }
    }

    private class Visitor implements ExpressionVisitor<Formula> {

        private Event event;
        public void setEvent(Event e) {
            this.event = e;
        }

        public Formula encode(Expression expression) {
            return expression.accept(this);
        }

        public BitvectorFormula encodeIntegerExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof IntegerType);
            final Formula formula = encode(expression);
            assert formula instanceof BitvectorFormula;
            return (BitvectorFormula) formula;
        }

        public BitvectorFormula encodeMemoryExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof MemoryType);
            final Formula formula = encode(expression);
            assert formula instanceof BitvectorFormula;
            return (BitvectorFormula) formula;
        }

        public FloatingPointFormula encodeFloatExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof FloatType);
            final Formula formula = encode(expression);
            assert formula instanceof FloatingPointFormula;
            return (FloatingPointFormula) formula;
        }

        public BooleanFormula encodeBooleanExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof BooleanType);
            final Formula formula = encode(expression);
            assert formula instanceof BooleanFormula;
            return (BooleanFormula) formula;
        }

        public TupleFormula encodeAggregateExpr(Expression expression) {
            Preconditions.checkArgument(ExpressionHelper.isAggregateLike(expression));
            final Formula formula = encode(expression);
            assert formula instanceof TupleFormula;
            return (TupleFormula) formula;
        }

        @Override
        public Formula visitLeafExpression(LeafExpression expr) {
            if (expr instanceof TypedFormula<?, ?> typedFormula) {
                return typedFormula.formula();
            }
            return visitExpression(expr);
        }

        // ====================================================================================
        // Booleans

        @Override
        public BooleanFormula visitBoolLiteral(BoolLiteral boolLiteral) {
            return bmgr.makeBoolean(boolLiteral.getValue());
        }

        @Override
        public BooleanFormula visitBoolBinaryExpression(BoolBinaryExpr bBin) {
            final BooleanFormula lhs = encodeBooleanExpr(bBin.getLeft());
            final BooleanFormula rhs = encodeBooleanExpr(bBin.getRight());
            return switch (bBin.getKind()) {
                case AND -> bmgr.and(lhs, rhs);
                case OR -> bmgr.or(lhs, rhs);
                case IFF -> bmgr.equivalence(lhs, rhs);
            };
        }

        @Override
        public BooleanFormula visitBoolUnaryExpression(BoolUnaryExpr bUn) {
            final BooleanFormula inner = encodeBooleanExpr(bUn.getOperand());
            assert bUn.getKind() == BoolUnaryOp.NOT;
            return bmgr.not(inner);
        }

        // ====================================================================================
        // Integers

        @Override
        public Formula visitIntLiteral(IntLiteral intLiteral) {
            return bvmgr.makeBitvector(intLiteral.getType().getBitWidth(), intLiteral.getValue());
        }

        @Override
        public Formula visitIntBinaryExpression(IntBinaryExpr iBin) {
            final BitvectorFormula bv1 = encodeIntegerExpr(iBin.getLeft());
            final BitvectorFormula bv2 = encodeIntegerExpr(iBin.getRight());

            return switch (iBin.getKind()) {
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
                case SMAX -> bmgr.ifThenElse(bvmgr.greaterOrEquals(bv1, bv2, true), bv1, bv2);
                case SMIN -> bmgr.ifThenElse(bvmgr.lessOrEquals(bv1, bv2, true), bv1, bv2);
                case UMAX -> bmgr.ifThenElse(bvmgr.greaterOrEquals(bv1, bv2, false), bv1, bv2);
                case UMIN -> bmgr.ifThenElse(bvmgr.lessOrEquals(bv1, bv2, false), bv1, bv2);
            };
        }

        @Override
        public Formula visitIntSizeCastExpression(IntSizeCast expr) {
            final BitvectorFormula inner = encodeIntegerExpr(expr.getOperand());
            final Formula enc;

            if (expr.isNoop()) {
                return inner;
            } else {
                final int targetBitWidth = expr.getTargetType().getBitWidth();
                final int sourceBitWidth = expr.getSourceType().getBitWidth();
                assert (sourceBitWidth == bvmgr.getLength(inner));

                enc = expr.isExtension()
                        ? bvmgr.extend(inner, targetBitWidth - sourceBitWidth, expr.preservesSign())
                        : bvmgr.extract(inner, targetBitWidth - 1, 0);
            }
            return enc;
        }

        @Override
        public Formula visitIntUnaryExpression(IntUnaryExpr iUn) {
            final BitvectorFormula bv = encodeIntegerExpr(iUn.getOperand());
            return switch (iUn.getKind()) {
                case MINUS -> bvmgr.negate(bv);
                case NOT -> bvmgr.not(bv);
                case CTPOP -> {
                    final int bvLength = bvmgr.getLength(bv);
                    BitvectorFormula count = bvmgr.extend(bvmgr.extract(bv, 0, 0), bvLength - 1, false);
                    for (int i = 1; i < bvLength; i++) {
                        BitvectorFormula bvbit = bvmgr.extend(bvmgr.extract(bv, i, i), bvLength - 1, false);
                        count = bvmgr.add(bvbit, count);
                    }
                    yield count;
                }
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
        }

        @Override
        public BooleanFormula visitIntCmpExpression(IntCmpExpr cmp) {
            final BitvectorFormula l = encodeIntegerExpr(cmp.getLeft());
            final BitvectorFormula r = encodeIntegerExpr(cmp.getRight());
            final IntCmpOp op = cmp.getKind();
            final boolean isSigned = op.isSigned();
            return switch (op) {
                case EQ -> bvmgr.equal(l, r);
                case NEQ -> fmgr.getBooleanFormulaManager().not(bvmgr.equal(l, r));
                case LT, ULT -> bvmgr.lessThan(l, r, isSigned);
                case LTE, ULTE -> bvmgr.lessOrEquals(l, r, isSigned);
                case GT, UGT -> bvmgr.greaterThan(l, r, isSigned);
                case GTE, UGTE -> bvmgr.greaterOrEquals(l, r, isSigned);
            };
        }

        @Override
        public Formula visitIntConcat(IntConcat expr) {
            Preconditions.checkArgument(!expr.getOperands().isEmpty());
            final List<BitvectorFormula> operands = expr.getOperands().stream()
                    .map(this::encodeIntegerExpr)
                    .toList();
            BitvectorFormula enc = operands.get(0);
            for (final BitvectorFormula op : operands.subList(1, operands.size())) {
                enc = bvmgr.concat(op, enc);
            }
            return enc;
        }

        @Override
        public Formula visitIntExtract(IntExtract expr) {
            final BitvectorFormula operand = encodeIntegerExpr(expr.getOperand());
            return bvmgr.extract(operand, expr.getHighBit(), expr.getLowBit());
        }

        @Override
        public Formula visitIntToFloatCastExpression(IntToFloatCast expr) {
            final Formula operand = encodeIntegerExpr(expr.getOperand());
            final FloatType fType = expr.getTargetType();
            final FloatingPointType targetType = getFloatFormulaType(fType);
            return floatingPointFormulaManager().castFrom(operand, true, targetType, roundingMode);
        }

        // ====================================================================================
        // Floats

        @Override
        public Formula visitFloatLiteral(FloatLiteral floatLiteral) {
            final FloatingPointType fFType = getFloatFormulaType(floatLiteral.getType());
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            if (floatLiteral.isNaN()) {
                return fpmgr.makeNaN(fFType);
            } else if (floatLiteral.isPlusInf()) {
                return fpmgr.makePlusInfinity(fFType);
            } else if (floatLiteral.isMinusInf()) {
                return fpmgr.makeMinusInfinity(fFType);
            } else {
                assert floatLiteral.hasFiniteValue();
                final FloatingPointFormula absVal = fpmgr.makeNumber(floatLiteral.getAbsValue(), fFType, roundingMode);
                return floatLiteral.isNegative() ? fpmgr.negate(absVal) : absVal;
            }
        }

        @Override
        public FloatingPointFormula visitFloatBinaryExpression(FloatBinaryExpr fBin) {
            final FloatingPointFormula fp1 = encodeFloatExpr(fBin.getLeft());
            final FloatingPointFormula fp2 = encodeFloatExpr(fBin.getRight());
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();

            return switch (fBin.getKind()) {
                case FADD -> fpmgr.add(fp1, fp2, roundingMode);
                case FSUB -> fpmgr.subtract(fp1, fp2, roundingMode);
                case FMUL -> fpmgr.multiply(fp1, fp2, roundingMode);
                case FDIV -> fpmgr.divide(fp1, fp2, roundingMode);
                case FREM -> fpmgr.remainder(fp1, fp2);
                case FMAX -> fpmgr.max(fp1, fp2);
                case FMIN -> fpmgr.min(fp1, fp2);
            };
        }

        @Override
        public FloatingPointFormula visitFloatUnaryExpression(FloatUnaryExpr fUn) {
            final FloatingPointFormula inner = encodeFloatExpr(fUn.getOperand());
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            return switch (fUn.getKind()) {
                case NEG -> fpmgr.negate(inner);
                case FABS -> fpmgr.abs(inner);
            };
        }

        @Override
        public BooleanFormula visitFloatCmpExpression(FloatCmpExpr cmp) {
            final FloatingPointFormula l = encodeFloatExpr(cmp.getLeft());
            final FloatingPointFormula r = encodeFloatExpr(cmp.getRight());
            final FloatCmpOp op = cmp.getKind();
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();

            return switch (op) {
                case EQ -> fpmgr.assignment(l, r);
                case NEQ -> bmgr.not(fpmgr.assignment(l, r));
                case OEQ -> toOrd(l, r, fpmgr.equalWithFPSemantics(l, r));
                case ONEQ -> toOrd(l, r, bmgr.not(fpmgr.equalWithFPSemantics(l, r)));
                case OLT -> toOrd(l, r, fpmgr.lessThan(l, r));
                case OLTE -> toOrd(l, r, fpmgr.lessOrEquals(l, r));
                case OGT -> toOrd(l, r, fpmgr.greaterThan(l, r));
                case OGTE -> toOrd(l, r, fpmgr.greaterOrEquals(l, r));
                case ORD -> toOrd(l, r, bmgr.makeTrue());
                case UEQ -> toUnord(l, r, fpmgr.equalWithFPSemantics(l, r));
                case UNEQ -> toUnord(l, r, bmgr.not(fpmgr.equalWithFPSemantics(l, r)));
                case ULT -> toUnord(l, r, fpmgr.lessThan(l, r));
                case ULTE -> toUnord(l, r, fpmgr.lessOrEquals(l, r));
                case UGT -> toUnord(l, r, fpmgr.greaterThan(l, r));
                case UGTE -> toUnord(l, r, fpmgr.greaterOrEquals(l, r));
                case UNO -> toUnord(l, r, bmgr.makeFalse());
            };
        }

        private BooleanFormula toOrd(FloatingPointFormula l, FloatingPointFormula r, BooleanFormula cmp) {
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            return bmgr.and(bmgr.not(fpmgr.isNaN(l)), bmgr.not(fpmgr.isNaN(r)), cmp);
        }

        private BooleanFormula toUnord(FloatingPointFormula l, FloatingPointFormula r, BooleanFormula cmp) {
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            return bmgr.or(fpmgr.isNaN(l), fpmgr.isNaN(r), cmp);
        }

        @Override
        public Formula visitFloatSizeCastExpression(FloatSizeCast expr) {
            final Formula inner = encodeFloatExpr(expr.getOperand());
            if (expr.isNoop()) {
                return inner;
            }

            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            final FloatingPointType fType = getFloatFormulaType(expr.getTargetType());
            return fpmgr.castFrom(inner, true, fType, roundingMode);
        }

        @Override
        public Formula visitFloatToIntCastExpression(FloatToIntCast expr) {
            final FormulaType<?> targetFormulaType = FormulaType.getBitvectorTypeWithSize(expr.getTargetType().getBitWidth());
            // Instructions fptoui and fptosi convert their floating-point operand into the nearest (rounding towards zero) integer value
            // https://llvm.org/docs/LangRef.html#fptoui-to-instruction
            // https://llvm.org/docs/LangRef.html#fptosi-to-instruction
            final FloatingPointFormula inner = encodeFloatExpr(expr.getOperand());
            return floatingPointFormulaManager().castTo(
                    inner, expr.isSigned(), targetFormulaType, FloatingPointRoundingMode.TOWARD_ZERO);
        }

        // ====================================================================================
        // Aggregates

        @Override
        public TupleFormula visitConstructExpression(ConstructExpr construct) {
            final List<Formula> elements = new ArrayList<>();
            for (Expression inner : construct.getOperands()) {
                elements.add(encode(inner));
            }
            return fmgr.getTupleFormulaManager().makeTuple(elements);
        }

        @Override
        public BooleanFormula visitAggregateCmpExpression(AggregateCmpExpr expr) {
            final TupleFormula left = encodeAggregateExpr(expr.getLeft());
            final TupleFormula right = encodeAggregateExpr(expr.getRight());

            final BooleanFormula eq = fmgr.equal(left, right);
            return switch (expr.getKind()) {
                case EQ -> eq;
                case NEQ -> context.getBooleanFormulaManager().not(eq);
            };
        }

        @Override
        public Formula visitExtractExpression(ExtractExpr extract) {
            final TupleFormula inner = encodeAggregateExpr(extract.getOperand());
            return fmgr.getTupleFormulaManager().extract(inner, extract.getIndices());
        }

        @Override
        public TupleFormula visitInsertExpression(InsertExpr insert) {
            final TupleFormula agg = encodeAggregateExpr(insert.getAggregate());
            final Formula value = encode(insert.getInsertedValue());
            return fmgr.getTupleFormulaManager().insert(agg, value, insert.getIndices());
        }

        // ====================================================================================
        // Memory type

        @Override
        public Formula visitToMemoryCastExpression(ToMemoryCast expr) {
            checkMemoryCastSupport(expr.getSourceType());

            final Formula inner = encode(expr.getOperand());
            final Type type = expr.getOperand().getType();
            final MemoryType targetType = types.getMemoryTypeFor(expr.getSourceType());

            if (type instanceof IntegerType iType) {
                final int extBits =  targetType.getBitWidth() - iType.getBitWidth();
                if (extBits > 0) {
                    return bvmgr.extend((BitvectorFormula) inner, extBits, false);
                } else {
                    return inner;
                }
            } else if (type instanceof FloatType fType) {
                assert targetType.getBitWidth() == fType.getBitWidth();
                final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
                return fpmgr.toIeeeBitvector((FloatingPointFormula) inner);
            } else {
                throw new UnsupportedOperationException("unreachable");
            }
        }

        @Override
        public Formula visitFromMemoryCastExpression(FromMemoryCast expr) {
            checkMemoryCastSupport(expr.getTargetType());

            final BitvectorFormula inner = encodeMemoryExpr(expr.getOperand());
            final Type targetType = expr.getTargetType();

            if (targetType instanceof IntegerType bvType) {
                final int targetSize = bvType.getBitWidth();
                if (targetSize < expr.getSourceType().getBitWidth()) {
                    return bvmgr.extract(inner, targetSize - 1, 0);
                } else {
                    return inner;
                }
            } else if (targetType instanceof FloatType fType) {
                assert fType.getBitWidth() == expr.getSourceType().getBitWidth();
                return floatingPointFormulaManager().fromIeeeBitvector(inner, getFloatFormulaType(fType));
            } else {
                throw new UnsupportedOperationException("unreachable");
            }
        }

        @Override
        public Formula visitMemoryConcatExpression(MemoryConcat expr) {
            Preconditions.checkArgument(!expr.getOperands().isEmpty());

            final List<? extends Formula> operands = expr.getOperands().stream()
                    .map(this::encodeMemoryExpr)
                    .toList();
            BitvectorFormula enc = (BitvectorFormula) operands.get(0);
            for (final Formula op : operands.subList(1, operands.size())) {
                enc = bvmgr.concat((BitvectorFormula) op, enc);
            }
            return enc;
        }

        @Override
        public Formula visitMemoryExtractExpression(MemoryExtract expr) {
            final BitvectorFormula operand = encodeMemoryExpr(expr.getOperand());
            return bvmgr.extract(operand, expr.getHighBit(), expr.getLowBit());
        }

        @Override
        public Formula visitMemoryExtendExpression(MemoryExtend expr) {
            final BitvectorFormula operand = encodeMemoryExpr(expr.getOperand());
            final int extendedBits = expr.getTargetType().getBitWidth() - expr.getSourceType().getBitWidth();
            return bvmgr.extend(operand, extendedBits, false);
        }

        @Override
        public BooleanFormula visitMemoryEqualExpression(MemoryEqualExpr expr) {
            final Formula left = expr.getLeft().accept(this);
            final Formula right = expr.getRight().accept(this);

            return fmgr.equal(left, right);
        }

        // ====================================================================================
        // Misc

        @Override
        public Formula visitITEExpression(ITEExpr iteExpr) {
            final BooleanFormula guard = encodeBooleanExpr(iteExpr.getCondition());
            final Formula tBranch = encode(iteExpr.getTrueCase());
            final Formula fBranch = encode(iteExpr.getFalseCase());
            return fmgr.ifThenElse(guard, tBranch, fBranch);
        }

        @Override
        public Formula visitNamedExpression(NamedExpression expr) {
            return expr.getOperand().accept(this);
        }

        // ====================================================================================
        // Program primitives

        @Override
        public Formula visitNonDetValue(NonDetValue nonDet) {
            return makeVariable(nonDet.toString(), nonDet.getType());
        }

        @Override
        public Formula visitRegister(Register reg) {
            final String name = event == null ?
                    reg.getName() + "_" + reg.getFunction().getId() + "_final" :
                    reg.getName() + "(" + event.getGlobalId() + ")";
            return makeVariable(name, reg.getType());
        }

        @Override
        public Formula visitMemoryObject(MemoryObject memObj) {
            return makeVariable(String.format("addrof(%s)", memObj), memObj.getType());
        }

        @Override
        public Formula visitFinalMemoryValue(FinalMemoryValue val) {
            Preconditions.checkState(event == null, "Cannot evaluate final memory value of %s at event %s.", val, event);
            final MemoryObject base = val.getMemoryObject();
            final int offset = val.getOffset();
            Preconditions.checkArgument(base.isInRange(offset), "Array index out of bounds");
            final String name = String.format("last_val_at_%s_%d", base, offset);
            return makeVariable(name, val.getType());
        }

        private Formula makeVariable(String name, Type type) {
            return ExpressionEncoder.this.makeVariable(name, type).formula();
        }
    }
}
