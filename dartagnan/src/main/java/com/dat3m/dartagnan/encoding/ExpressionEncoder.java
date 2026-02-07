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
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

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
        final Formula variable;
        if (type instanceof BooleanType) {
            variable = bmgr.makeVariable(name);
        } else if (type instanceof IntegerType integerType) {
            variable = context.useIntegers
                    ? integerFormulaManager().makeVariable(name)
                    : bitvectorFormulaManager().makeVariable(integerType.getBitWidth(), name);
        } else if (type instanceof MemoryType memoryType) {
            assert !context.useIntegers;
            variable = bitvectorFormulaManager().makeVariable(memoryType.getBitWidth(), name);
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
        MEMORY_ROUND_TRIP_STRICT,   // Round-trip over memory, but source/target type sizes must match
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

        return equal(left, value);
    }


    public BooleanFormula assignEqual(Expression left, Expression right) {
        return assignEqual(left, right, ConversionMode.STRICT);
    }

    public BooleanFormula assignEqualAt(Expression left, Event leftAt, Expression right, Event rightAt) {
        return assignEqual(encodeAt(left, leftAt), encodeAt(right, rightAt));
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
        public TypedFormula<MemoryType, ?> encodeMemoryExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof MemoryType);
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.getType() == expression.getType();
            assert typedFormula.formula() instanceof IntegerFormula || typedFormula.formula() instanceof BitvectorFormula;
            return (TypedFormula<MemoryType, ?>) typedFormula;
        }

        @SuppressWarnings("unchecked")
        public TypedFormula<FloatType, ?> encodeFloatExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof FloatType);
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.getType() == expression.getType();
            assert typedFormula.formula() instanceof FloatingPointFormula;
            return (TypedFormula<FloatType, ?>) typedFormula;
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
            final Formula enc;

            if (expr.isNoop()) {
                return inner;
            } else if (context.useIntegers) {
                final IntegerFormulaManager imgr = integerFormulaManager();
                final IntegerFormula innerInt = (IntegerFormula) inner.formula();
                if (expr.isExtension()) {
                    if (expr.preservesSign()) {
                        enc = innerInt;
                    } else {
                        // Proper zero extension will always yield a positive value
                        enc = bmgr.ifThenElse(
                                imgr.lessThan(innerInt, imgr.makeNumber(0)),
                                imgr.negate(innerInt),
                                innerInt
                        );
                    }
                } else {
                    final BigInteger highValue = BigInteger.TWO.pow(expr.getType().getBitWidth());
                    enc = imgr.modulo(innerInt, imgr.makeNumber(highValue));
                }
            } else {
                assert inner.formula() instanceof BitvectorFormula;

                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula innerBv = (BitvectorFormula) inner.formula();
                final int targetBitWidth = expr.getTargetType().getBitWidth();
                final int sourceBitWidth = expr.getSourceType().getBitWidth();
                assert (sourceBitWidth == bvmgr.getLength(innerBv));

                enc = expr.isExtension()
                        ? bvmgr.extend(innerBv, targetBitWidth - sourceBitWidth, expr.preservesSign())
                        : bvmgr.extract(innerBv, targetBitWidth - 1, 0);
            }
            return new TypedFormula<>(expr.getType(), enc);
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

        @Override
        public TypedFormula<IntegerType, ?> visitIntConcat(IntConcat expr) {
            Preconditions.checkArgument(!expr.getOperands().isEmpty());
            final List<? extends TypedFormula<IntegerType, ?>> operands = expr.getOperands().stream()
                    .map(this::encodeIntegerExpr)
                    .toList();
            Formula enc = operands.get(0).formula();
            if (context.useIntegers) {
                final IntegerFormulaManager imgr = fmgr.getIntegerFormulaManager();
                int offset = operands.get(0).type().getBitWidth();
                for (TypedFormula<IntegerType, ?> op : operands.subList(1, operands.size())) {
                    final IntegerFormula offsetValue = imgr.makeNumber(BigInteger.TWO.pow(offset - 1));
                    enc = imgr.add((IntegerFormula) enc, imgr.multiply((IntegerFormula) op.formula(), offsetValue));
                    offset += op.type().getBitWidth();
                }
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                for (TypedFormula<IntegerType, ?> op : operands.subList(1, operands.size())) {
                    enc = bvmgr.concat((BitvectorFormula) op.formula(), (BitvectorFormula) enc);
                }
            }
            return new TypedFormula<>(expr.getType(), enc);
        }

        @Override
        public TypedFormula<IntegerType, ?> visitIntExtract(IntExtract expr) {
            final Formula operand = encodeIntegerExpr(expr.getOperand()).formula();
            final Formula enc;
            if (context.useIntegers) {
                final IntegerFormulaManager imgr = integerFormulaManager();
                final IntegerFormula highBitValue = imgr.makeNumber(BigInteger.TWO.pow(expr.getHighBit() + 1));
                final IntegerFormula lowBitValue = imgr.makeNumber(BigInteger.TWO.pow(expr.getLowBit()));
                final IntegerFormula op = (IntegerFormula) operand;
                final IntegerFormula extracted = expr.isExtractingHighBits() ? op : imgr.modulo(op, highBitValue);
                enc = expr.isExtractingLowBits() ? extracted : imgr.divide(extracted, lowBitValue);
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                enc = bvmgr.extract((BitvectorFormula) operand, expr.getHighBit(), expr.getLowBit());
            }
            return new TypedFormula<>(expr.getType(), enc);
        }

        public TypedFormula<FloatType, ?> visitIntToFloatCastExpression(IntToFloatCast expr) {
            final Formula operand = encodeIntegerExpr(expr.getOperand()).formula();
            final FloatType fType = expr.getTargetType();
            final FloatingPointType targetType = getFloatFormulaType(fType);
            final Formula enc = floatingPointFormulaManager().castFrom(operand, true, targetType, context.roundingModeFloats);
            return new TypedFormula<>(fType, enc);
        }

        // ====================================================================================
        // Floats

        @Override
        public TypedFormula<FloatType, ?> visitFloatLiteral(FloatLiteral floatLiteral) {
            final FloatingPointType fFType = getFloatFormulaType(floatLiteral.getType());
            final Formula result;
            if (floatLiteral.isNaN()) {
                result = floatingPointFormulaManager().makeNaN(fFType);
            } else if (floatLiteral.isPlusInf()) {
                result = floatingPointFormulaManager().makePlusInfinity(fFType);
            } else if (floatLiteral.isMinusInf()) {
                result = floatingPointFormulaManager().makeMinusInfinity(fFType);
            } else {
                result = floatingPointFormulaManager().makeNumber(floatLiteral.getValue(), fFType, context.roundingModeFloats);
            }
            return new TypedFormula<>(floatLiteral.getType(), result);
        }

        @Override
        public TypedFormula<FloatType, ?> visitFloatBinaryExpression(FloatBinaryExpr fBin) {
            final TypedFormula<FloatType, ?> lhs = encodeFloatExpr(fBin.getLeft());
            final TypedFormula<FloatType, ?> rhs = encodeFloatExpr(fBin.getRight());
            final FloatingPointFormula fp1 = (FloatingPointFormula) lhs.formula();
            final FloatingPointFormula fp2 = (FloatingPointFormula) rhs.formula();
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();

            final FloatingPointFormula result = switch (fBin.getKind()) {
                case FADD -> fpmgr.add(fp1, fp2, context.roundingModeFloats);
                case FSUB -> fpmgr.subtract(fp1, fp2, context.roundingModeFloats);
                case FMUL -> fpmgr.multiply(fp1, fp2, context.roundingModeFloats);
                case FDIV -> fpmgr.divide(fp1, fp2, context.roundingModeFloats);
                case FREM -> fpmgr.remainder(fp1, fp2);
                case FMAX -> fpmgr.max(fp1, fp2);
                case FMIN -> fpmgr.min(fp1, fp2);
            };
            return new TypedFormula<>(fBin.getType(), result);
        }

        @Override
        public TypedFormula<FloatType, ?> visitFloatUnaryExpression(FloatUnaryExpr fUn) {
            final TypedFormula<FloatType, ?> inner = encodeFloatExpr(fUn.getOperand());
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            final FloatingPointFormula innerForm = (FloatingPointFormula) inner.formula();
            final FloatingPointFormula result = switch (fUn.getKind()) {
                case NEG -> fpmgr.negate(innerForm);
                case FABS -> fpmgr.abs(innerForm);
            };
            return new TypedFormula<FloatType, Formula>(fUn.getType(), result);
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitFloatCmpExpression(FloatCmpExpr cmp) {
            final TypedFormula<?, ?> lhs = encode(cmp.getLeft());
            final TypedFormula<?, ?> rhs = encode(cmp.getRight());
            final FloatCmpOp op = cmp.getKind();
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
            final FloatingPointFormula l = (FloatingPointFormula) lhs.formula();
            final FloatingPointFormula r = (FloatingPointFormula) rhs.formula();

            final BooleanFormula result = switch (op) {
                case EQ -> fpmgr.assignment(l, r);
                case NEQ -> bmgr.not(fpmgr.assignment(l, r));
                case OEQ -> fromUnordToOrd(l, r, fpmgr.equalWithFPSemantics(l, r));
                case ONEQ -> fromUnordToOrd(l, r, bmgr.not(fpmgr.equalWithFPSemantics(l, r)));
                case OLT -> fromUnordToOrd(l, r, fpmgr.lessThan(l, r));
                case OLTE -> fromUnordToOrd(l, r, fpmgr.lessOrEquals(l, r));
                case OGT -> fromUnordToOrd(l, r, fpmgr.greaterThan(l, r));
                case OGTE -> fromUnordToOrd(l, r, fpmgr.greaterOrEquals(l, r));
                case ORD -> bmgr.not(bmgr.or(fpmgr.isNaN(l), fpmgr.isNaN(r)));
                case UEQ -> fpmgr.equalWithFPSemantics(l, r);
                case UNEQ -> bmgr.not(fpmgr.equalWithFPSemantics(l, r));
                case ULT -> fpmgr.lessThan(l, r);
                case ULTE -> fpmgr.lessOrEquals(l, r);
                case UGT -> fpmgr.greaterThan(l, r);
                case UGTE -> fpmgr.greaterOrEquals(l, r);
                case UNO -> bmgr.or(fpmgr.isNaN(l), fpmgr.isNaN(r));
            };
            return new TypedFormula<>(types.getBooleanType(), result);
        }

        private BooleanFormula fromUnordToOrd(FloatingPointFormula l, FloatingPointFormula r, BooleanFormula cmp) {
            final BooleanFormulaManager bmgr = fmgr.getBooleanFormulaManager();
            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            return fmgr.ifThenElse(bmgr.or(fpmgr.isNaN(l), fpmgr.isNaN(r)), bmgr.makeFalse(), cmp);
        }

        @Override
        public TypedFormula<FloatType, ?> visitFloatSizeCastExpression(FloatSizeCast expr) {
            final TypedFormula<FloatType, ?> inner = encodeFloatExpr(expr.getOperand());
            if (expr.isNoop()) {
                return inner;
            }

            final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
            final FloatingPointType fType = getFloatFormulaType(expr.getTargetType());
            final Formula enc = fpmgr.castFrom(inner.formula(), true, fType, context.roundingModeFloats);
            return new TypedFormula<>(expr.getType(), enc);
        }

        @Override
        public TypedFormula<?, ?> visitFloatToIntCastExpression(FloatToIntCast expr) {
            final FormulaType<?> targetFormulaType = context.useIntegers ?
                FormulaType.IntegerType :
                FormulaType.getBitvectorTypeWithSize(expr.getTargetType().getBitWidth());
            // Instructions fptoui and fptosi convert their floating-point operand into the nearest (rounding towards zero) integer value
            // https://llvm.org/docs/LangRef.html#fptoui-to-instruction
            // https://llvm.org/docs/LangRef.html#fptosi-to-instruction
            final FloatingPointFormula inner = (FloatingPointFormula) encodeFloatExpr(expr.getOperand()).formula();
            final Formula enc = floatingPointFormulaManager().castTo(
                    inner, expr.isSigned(), targetFormulaType, FloatingPointRoundingMode .TOWARD_ZERO);
            return new TypedFormula<>(expr.getTargetType(), enc);
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
        // Memory type

        private void checkMemoryCastSupport(Type type) {
            if (!(type instanceof IntegerType) && !(type instanceof FloatType)) {
                throw new UnsupportedOperationException("Cannot cast between memory and type: " + type);
            }
        }

        @Override
        public TypedFormula<MemoryType, ?> visitToMemoryCastExpression(ToMemoryCast expr) {
            final TypedFormula<?, ?> inner = encode(expr.getOperand());
            final MemoryType targetType = types.getMemoryTypeFor(expr.getSourceType());

            checkMemoryCastSupport(expr.getSourceType());

            Formula enc = inner.formula();
            if (inner.getType() instanceof IntegerType iType && !context.useIntegers) {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final int extBits =  targetType.getBitWidth() - iType.getBitWidth();
                if (extBits > 0) {
                    enc = bvmgr.extend((BitvectorFormula) inner.formula(), extBits, false);
                }
            } else if (inner.getType() instanceof FloatType fType) {
                assert targetType.getBitWidth() == fType.getBitWidth();
                final FloatingPointFormulaManager fpmgr = floatingPointFormulaManager();
                enc = fpmgr.toIeeeBitvector((FloatingPointFormula) inner.formula());
            }

            return new TypedFormula<>(targetType, enc);
        }

        @Override
        public TypedFormula<?, ?> visitFromMemoryCastExpression(FromMemoryCast expr) {
            final TypedFormula<MemoryType, ?> inner = encodeMemoryExpr(expr.getOperand());
            final Type targetType = expr.getTargetType();

            checkMemoryCastSupport(targetType);

            Formula enc = inner.formula();
            if (!context.useIntegers && targetType instanceof IntegerType bvType) {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final int targetSize = bvType.getBitWidth();
                if (targetSize < expr.getSourceType().getBitWidth()) {
                    enc = bvmgr.extract((BitvectorFormula) inner.formula(), targetSize - 1, 0);
                }
            } else if (targetType instanceof FloatType fType) {
                assert !context.useIntegers;
                enc = floatingPointFormulaManager().fromIeeeBitvector((BitvectorFormula) inner.formula(), getFloatFormulaType(fType));
            }

            return new TypedFormula<>(targetType, enc);
        }

        @Override
        public TypedFormula<?, ?> visitMemoryConcatExpression(MemoryConcat expr) {
            Preconditions.checkArgument(!expr.getOperands().isEmpty());
            Preconditions.checkState(!context.useIntegers);

            // TODO: We just do normal bitvector concatenation for now
            final List<? extends TypedFormula<MemoryType, ?>> operands = expr.getOperands().stream()
                    .map(this::encodeMemoryExpr)
                    .toList();
            Formula enc = operands.get(0).formula();
            final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
            for (TypedFormula<MemoryType, ?> op : operands.subList(1, operands.size())) {
                enc = bvmgr.concat((BitvectorFormula) op.formula(), (BitvectorFormula) enc);
            }
            return new TypedFormula<>(expr.getType(), enc);
        }

        @Override
        public TypedFormula<?, ?> visitMemoryExtractExpression(MemoryExtract expr) {
            // TODO: We just do normal bitvector extraction for now
            //  NOTE: We need to support mathematical integers for some unit tests, which is a bit awkward
            final Formula operand = encodeMemoryExpr(expr.getOperand()).formula();
            final Formula enc;
            if (context.useIntegers) {
                final IntegerFormulaManager imgr = integerFormulaManager();
                final IntegerFormula highBitValue = imgr.makeNumber(BigInteger.TWO.pow(expr.getHighBit() + 1));
                final IntegerFormula lowBitValue = imgr.makeNumber(BigInteger.TWO.pow(expr.getLowBit()));
                final IntegerFormula op = (IntegerFormula) operand;
                final IntegerFormula extracted = expr.isExtractingHighBits() ? op : imgr.modulo(op, highBitValue);
                enc = expr.isExtractingLowBits() ? extracted : imgr.divide(extracted, lowBitValue);
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                enc = bvmgr.extract((BitvectorFormula) operand, expr.getHighBit(), expr.getLowBit());
            }
            return new TypedFormula<>(expr.getType(), enc);
        }

        @Override
        public TypedFormula<?, ?> visitMemoryExtend(MemoryExtend expr) {
            final Formula operand = encodeMemoryExpr(expr.getOperand()).formula();
            final Formula enc;
            if (context.useIntegers) {
                enc = operand; // Maybe remove sign?
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final int extendedBits = expr.getTargetType().getBitWidth() - expr.getSourceType().getBitWidth();
                enc = bvmgr.extend((BitvectorFormula) operand, extendedBits, false);
            }
            return new TypedFormula<>(expr.getType(), enc);

        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitMemoryEqualExpression(MemoryEqualExpr expr) {
            final Formula left = expr.getLeft().accept(this).formula();
            final Formula right = expr.getRight().accept(this).formula();

            return new TypedFormula<>(types.getBooleanType(), fmgr.equal(left, right));
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
            Preconditions.checkArgument(base.isInRange(offset), "Array index out of bounds");
            final String name = String.format("last_val_at_%s_%d", base, offset);
            return makeVariable(name, val.getType());
        }
    }
}
