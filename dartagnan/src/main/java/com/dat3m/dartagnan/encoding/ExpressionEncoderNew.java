package com.dat3m.dartagnan.encoding;

import com.dat3m.dartagnan.encoding.formulas.TupleFormula;
import com.dat3m.dartagnan.encoding.formulas.TypedFormula;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionVisitor;
import com.dat3m.dartagnan.expression.Type;
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
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.utils.ExpressionHelper;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.misc.NonDetValue;
import com.google.common.base.Preconditions;
import org.sosy_lab.java_smt.api.*;
import org.sosy_lab.java_smt.api.NumeralFormula.IntegerFormula;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

import static com.google.common.base.Preconditions.checkState;
import static java.util.Arrays.asList;

class ExpressionEncoderNew {

    private static final TypeFactory types = TypeFactory.getInstance();

    private final EncodingContext context;
    private final FormulaManager formulaManager;
    private final BooleanFormulaManager booleanFormulaManager;
    private final Visitor visitor = new Visitor();

    ExpressionEncoderNew(EncodingContext context) {
        this.context = context;
        this.formulaManager = context.getFormulaManager();
        this.booleanFormulaManager = formulaManager.getBooleanFormulaManager();
    }

    private IntegerFormulaManager integerFormulaManager() {
        return formulaManager.getIntegerFormulaManager();
    }

    private BitvectorFormulaManager bitvectorFormulaManager() {
        return formulaManager.getBitvectorFormulaManager();
    }

    // ====================================================================================
    // Standard API

    public TypedFormula<?, ?> encode(Expression expression, Event at) {
        visitor.setEvent(at);
        return expression.accept(visitor);
    }

    public TypedFormula<IntegerType, ?> encodeIntegerExpr(Expression expression, Event at) {
        visitor.setEvent(at);
        return visitor.encodeIntegerExpr(expression);
    }

    public TypedFormula<BooleanType, BooleanFormula> encodeBooleanExpr(Expression expression, Event at) {
        visitor.setEvent(at);
        return visitor.encodeBooleanExpr(expression);
    }

    public TypedFormula<?, TupleFormula> encodeAggregateExpr(Expression expression, Event at) {
        visitor.setEvent(at);
        return visitor.encodeAggregateExpr(expression);
    }

    public <TType extends Type> TypedFormula<TType, ?> makeZero(TType type) {
        final Formula form;
        if (type instanceof BooleanType) {
            form = booleanFormulaManager.makeFalse();
        } else if (type instanceof IntegerType intType) {
            form = context.useIntegers ?
                    integerFormulaManager().makeNumber(0) :
                    bitvectorFormulaManager().makeBitvector(intType.getBitWidth(), 0);
        } else {
            final String error = String.format("Cannot make zero formula for type %s", type);
            throw new UnsupportedOperationException(error);
        }

        return new TypedFormula<>(type, form);
    }

    // ====================================================================================
    // (Dynamic) Conversation operations

    // TODO: We might want to have an universal intermediate type T with the following properties:
    //  (1) every other type has a lossless conversion to T
    //  (2) T can be converted to every other type (possibly with loss)
    //  (3) A round-trip through T is always lossless.
    public TypedFormula<?, ?> convert(TypedFormula<?, ?> form, Type targetType) {
        if (form.type() == targetType) {
            return form;
        } else if (targetType instanceof BooleanType) {
            return convertToBool(form);
        } else if (targetType instanceof IntegerType intType) {
            return convertToInteger(form, intType);
        } else {
            final String error = String.format("Cannot convert typed formula %s to type %s", form, targetType);
            throw new UnsupportedOperationException(error);
        }
    }

    @SuppressWarnings("unchecked")
    public TypedFormula<BooleanType, BooleanFormula> convertToBool(TypedFormula<?, ?> form) {
        if (form.type() instanceof BooleanType) {
            return (TypedFormula<BooleanType, BooleanFormula>) form;
        } else if (form.type() instanceof IntegerType) {
            if (context.useIntegers) {
                final IntegerFormulaManager imgr = integerFormulaManager();
                final IntegerFormula intForm = (IntegerFormula) form.formula();
                final IntegerFormula zero = imgr.makeNumber(0);
                return new TypedFormula<>(types.getBooleanType(), imgr.greaterThan(intForm, zero));
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula bvForm = (BitvectorFormula) form.formula();
                final BitvectorFormula zero = bvmgr.makeBitvector(bvmgr.getLength(bvForm), 0);
                return new TypedFormula<>(types.getBooleanType(), bvmgr.greaterThan(bvForm, zero, false));
            }
        } else {
            final String error = String.format("Cannot convert typed formula %s to type %s", form, types.getBooleanType());
            throw new UnsupportedOperationException(error);
        }
    }

    @SuppressWarnings("unchecked")
    public TypedFormula<IntegerType, ?> convertToInteger(TypedFormula<?, ?> form, IntegerType targetType) {
        if (form.type() == targetType) {
            return (TypedFormula<IntegerType, ?>) form;
        } else if (form.type() instanceof BooleanType) {
            final BooleanFormula boolForm = (BooleanFormula) form.formula();
            final Formula zero;
            final Formula one;
            if (context.useIntegers) {
                final IntegerFormulaManager imgr = integerFormulaManager();
                zero = imgr.makeNumber(0);
                one = imgr.makeNumber(1);
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                zero = bvmgr.makeBitvector(targetType.getBitWidth(), 0);
                one = bvmgr.makeBitvector(targetType.getBitWidth(), 1);
            }
            return new TypedFormula<>(targetType, booleanFormulaManager.ifThenElse(boolForm, zero, one));
        } else if (form.type() instanceof IntegerType sourceType) {
            if (context.useIntegers) {
                // TODO: Add truncation
                return new TypedFormula<IntegerType, Formula>(targetType, form.formula());
            } else {
                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula bvForm = (BitvectorFormula) form.formula();
                final int sourceWidth = sourceType.getBitWidth();
                final int targetWidth = targetType.getBitWidth();

                // NOTE: The conversion is unsigned here
                final BitvectorFormula result = sourceWidth >= targetWidth ?
                        bvmgr.extract(bvForm, targetWidth - 1, 0) :
                        bvmgr.extend(bvForm, targetWidth - sourceWidth, false);
                return new TypedFormula<IntegerType, Formula>(targetType, result);
            }
        } else {
            final String error = String.format("Cannot convert typed formula %s to type %s", form, targetType);
            throw new UnsupportedOperationException(error);
        }
    }

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
            assert typedFormula.type() == expression.getType();
            assert typedFormula.formula() instanceof IntegerFormula || typedFormula.formula() instanceof BitvectorFormula;
            return (TypedFormula<IntegerType, ?>) typedFormula;
        }

        @SuppressWarnings("unchecked")
        public TypedFormula<BooleanType, BooleanFormula> encodeBooleanExpr(Expression expression) {
            Preconditions.checkArgument(expression.getType() instanceof BooleanType);
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.type() == expression.getType();
            assert typedFormula.formula() instanceof BooleanFormula;
            return (TypedFormula<BooleanType, BooleanFormula>) typedFormula;
        }

        @SuppressWarnings("unchecked")
        public TypedFormula<?, TupleFormula> encodeAggregateExpr(Expression expression) {
            Preconditions.checkArgument(ExpressionHelper.isAggregateLike(expression));
            final TypedFormula<?, ?> typedFormula = encode(expression);
            assert typedFormula.type() == expression.getType();
            assert typedFormula.formula() instanceof TupleFormula;
            return (TypedFormula<?, TupleFormula>) typedFormula;
        }

        // ====================================================================================
        // Booleans

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitBoolLiteral(BoolLiteral boolLiteral) {
            return new TypedFormula<>(types.getBooleanType(), booleanFormulaManager.makeBoolean(boolLiteral.getValue()));
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitBoolBinaryExpression(BoolBinaryExpr bBin) {
            final TypedFormula<BooleanType, BooleanFormula> lhs = encodeBooleanExpr(bBin.getLeft());
            final TypedFormula<BooleanType, BooleanFormula> rhs = encodeBooleanExpr(bBin.getRight());
            final BooleanFormula result = switch (bBin.getKind()) {
                case AND -> booleanFormulaManager.and(lhs.formula(), rhs.formula());
                case OR -> booleanFormulaManager.or(lhs.formula(), rhs.formula());
                case IFF -> booleanFormulaManager.equivalence(lhs.formula(), rhs.formula());
            };
            return new TypedFormula<>(types.getBooleanType(), result);
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitBoolUnaryExpression(BoolUnaryExpr bUn) {
            final TypedFormula<BooleanType, BooleanFormula> inner = encodeBooleanExpr(bUn.getOperand());
            assert bUn.getKind() == BoolUnaryOp.NOT;
            return new TypedFormula<>(types.getBooleanType(), booleanFormulaManager.not(inner.formula()));
        }

        // ====================================================================================
        // Integers

        @Override
        public TypedFormula<IntegerType, ?> visitIntLiteral(IntLiteral intLiteral) {
            final BigInteger value = intLiteral.getValue();
            final IntegerType type = intLiteral.getType();
            return new TypedFormula<>(type, context.makeLiteral(type, value));
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
                        final BooleanFormula cond = booleanFormulaManager.and(
                                imgr.distinct(asList(modulo, zero)),
                                imgr.lessThan(i1, zero)
                        );
                        yield booleanFormulaManager.ifThenElse(cond, imgr.subtract(modulo, i2), modulo);
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

            if (context.useIntegers || expr.isNoop()) {
                //TODO If narrowing, constrain the value.
                return inner;
            } else {
                assert inner.formula() instanceof BitvectorFormula;

                final BitvectorFormulaManager bvmgr = bitvectorFormulaManager();
                final BitvectorFormula innerBv = (BitvectorFormula) inner.formula();
                final int targetBitWidth = expr.getTargetType().getBitWidth();
                final int sourceBitWidth = expr.getSourceType().getBitWidth();
                assert (sourceBitWidth == bvmgr.getLength(innerBv));

                final BitvectorFormula result;
                if (expr.isExtension()) {
                    result = bvmgr.extend(innerBv, targetBitWidth - sourceBitWidth, expr.preservesSign());
                } else {
                    result = bvmgr.extract(innerBv, targetBitWidth - 1, 0);
                }

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
                            ctlz = booleanFormulaManager.ifThenElse(bvmgr.equal(bvbit, bv1), bvi, ctlz);
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
                            cttz = booleanFormulaManager.ifThenElse(bvmgr.equal(bvbit, bv1), bvi, cttz);
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
            return new TypedFormula<>(types.getBooleanType(),
                    new EncodingHelper(context).encodeComparison(cmp.getKind(), lhs.formula(), rhs.formula()));
        }

        // ====================================================================================
        // Aggregates

        @Override
        public TypedFormula<?, TupleFormula> visitConstructExpression(ConstructExpr construct) {
            final List<Formula> elements = new ArrayList<>();
            for (Expression inner : construct.getOperands()) {
                elements.add(encode(inner).formula());
            }
            return new TypedFormula<>(construct.getType(), context.getTupleFormulaManager().makeTuple(elements));
        }

        @Override
        public TypedFormula<BooleanType, BooleanFormula> visitAggregateCmpExpression(AggregateCmpExpr expr) {
            final TypedFormula<?, TupleFormula> left = encodeAggregateExpr(expr.getLeft());
            final TypedFormula<?, TupleFormula> right = encodeAggregateExpr(expr.getRight());

            final BooleanFormula eq = new EncodingHelper(context).equal(left.formula(), right.formula());
            final BooleanFormula result = switch (expr.getKind()) {
                case EQ -> eq;
                case NEQ -> context.getBooleanFormulaManager().not(eq);
            };
            return new TypedFormula<>(types.getBooleanType(), result);
        }

        @Override
        public TypedFormula<?, ?> visitExtractExpression(ExtractExpr extract) {
            final TypedFormula<?, TupleFormula> inner = encodeAggregateExpr(extract.getOperand());
            final Formula extractForm = context.getTupleFormulaManager().extract(inner.formula(), extract.getIndices());
            return new TypedFormula<>(extract.getType(), extractForm);
        }

        @Override
        public TypedFormula<?, TupleFormula> visitInsertExpression(InsertExpr insert) {
            final TupleFormula agg = encodeAggregateExpr(insert.getAggregate()).formula();
            final Formula value = encode(insert.getInsertedValue()).formula();
            final TupleFormula insertForm = context.getTupleFormulaManager().insert(agg, value, insert.getIndices());
            return new TypedFormula<>(insert.getType(), insertForm);
        }

        // ====================================================================================
        // Misc

        @Override
        public TypedFormula<?, ?> visitITEExpression(ITEExpr iteExpr) {
            final BooleanFormula guard = encodeBooleanExpr(iteExpr.getCondition()).formula();
            final Formula tBranch = encode(iteExpr.getTrueCase()).formula();
            final Formula fBranch = encode(iteExpr.getFalseCase()).formula();
            final Formula ite = booleanFormulaManager.ifThenElse(guard, tBranch, fBranch);
            return new TypedFormula<>(iteExpr.getType(), ite);
        }

        // ====================================================================================
        // Program primitives

        @Override
        public TypedFormula<?, ?> visitNonDetValue(NonDetValue nonDet) {
            return new TypedFormula<>(nonDet.getType(), context.makeVariable(nonDet.toString(), nonDet.getType()));
        }

        @Override
        public TypedFormula<?, ?> visitRegister(Register reg) {
            final String name = event == null ?
                    reg.getName() + "_" + reg.getFunction().getId() + "_final" :
                    reg.getName() + "(" + event.getGlobalId() + ")";
            final Type type = reg.getType();
            return new TypedFormula<>(reg.getType(), context.makeVariable(name, type));
        }

        @Override
        public TypedFormula<?, ?> visitMemoryObject(MemoryObject memObj) {
            // TODO: Once we have a PointerType, this needs to get updated.
            return new TypedFormula<>(memObj.getType(), context.address(memObj));
        }

        @Override
        public TypedFormula<?, ?> visitFinalMemoryValue(FinalMemoryValue val) {
            checkState(event == null, "Cannot evaluate final memory value of %s at event %s.", val, event);
            final int size = types.getMemorySizeInBits(val.getType());
            return new TypedFormula<>(val.getType(), context.lastValue(val.getMemoryObject(), val.getOffset(), size));
        }
    }
}
