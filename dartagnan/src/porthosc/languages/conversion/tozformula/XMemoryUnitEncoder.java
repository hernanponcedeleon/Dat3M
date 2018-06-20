package porthosc.languages.conversion.tozformula;

import com.microsoft.z3.*;
import porthosc.languages.syntax.xgraph.events.XEvent;
import porthosc.languages.syntax.xgraph.events.computation.XAssertionEvent;
import porthosc.languages.syntax.xgraph.events.computation.XBinaryComputationEvent;
import porthosc.languages.syntax.xgraph.events.computation.XUnaryComputationEvent;
import porthosc.languages.syntax.xgraph.memories.*;
import porthosc.languages.syntax.xgraph.visitors.XMemoryUnitVisitor;
import porthosc.utils.Utils;
import porthosc.utils.exceptions.NotImplementedException;
import porthosc.utils.exceptions.xgraph.XInterpretationError;

import static porthosc.utils.StringUtils.wrap;


class XMemoryUnitEncoder {

    private final Context ctx;
    private final StaticSingleAssignmentMap ssaMap;

    XMemoryUnitEncoder(Context ctx, StaticSingleAssignmentMap ssaMap) {
        this.ctx = ctx;
        this.ssaMap = ssaMap;
    }

    public BoolExpr encodeAssertion(XAssertionEvent assertion) {
        XMemoryUnitEncoderVisitor visitor = getVisitor(assertion);
        Expr result = assertion.accept(visitor);
        if (!(result instanceof BoolExpr)) {
            throw new XInterpretationError("non-boolean assertion: " + wrap(result));
        }
        return (BoolExpr) result;
    }

    public Expr encodeVar(XMemoryUnit unit, XEvent accessingEvent) {
        XMemoryUnitEncoderVisitor visitor = getVisitor(accessingEvent);
        return unit.accept(visitor);
    }

    public Expr updateVarRef(XLvalueMemoryUnit unit, XEvent event) {
        VarRefCollection refsCollection = ssaMap.getEventMap(event);
        refsCollection.updateRef(unit);
        ssaMap.addLastModEvent(unit, event);

        XMemoryUnitEncoderVisitor visitor = createVisitor(refsCollection);
        return unit.accept(visitor);
    }

    private XMemoryUnitEncoderVisitor getVisitor(XEvent event) {
        return createVisitor(ssaMap.getEventMap(event));
    }

    private XMemoryUnitEncoderVisitor createVisitor(VarRefCollection varRefCollection) {
        return new XMemoryUnitEncoderVisitor(varRefCollection);
    }

    // --

    private final class XMemoryUnitEncoderVisitor implements XMemoryUnitVisitor<Expr> {

        private final VarRefCollection varRefCollection;

        private boolean isLastValue;

        public XMemoryUnitEncoderVisitor(VarRefCollection varRefCollection) {
            this.varRefCollection = varRefCollection;
        }

        @Override
        public Expr visit(XUnaryComputationEvent event) {
            Expr operand = event.getOperand().accept(this);
            switch (event.getOperator()) {
                case BitNegation:
                    if (!(operand instanceof BoolExpr)) {
                        throw new ToZ3ConversionException("Expected boolean operand of unary computation event "
                                                                  + event + ", found: " + operand.getClass().getSimpleName());
                    }
                    return ctx.mkNot((BoolExpr) operand);
                case NoOperation:
                    return operand;
                default:
                    throw new IllegalArgumentException(event.getOperator().name());
            }
        }

        @Override
        public Expr visit(XBinaryComputationEvent event) {
            // no need to visit children recursively here, X is already linearised structure
            Expr op1 = event.getFirstOperand().accept(this);
            Expr op2 = event.getSecondOperand().accept(this);
            switch (event.getOperator()) {
                case Addition:
                    return ctx.mkAdd(asArithExpr(op1), asArithExpr(op2));
                case Subtraction:
                    return ctx.mkSub(asArithExpr(op1), asArithExpr(op2));
                case Multiplication:
                    return ctx.mkMul(asArithExpr(op1), asArithExpr(op2));
                case Division:
                    return ctx.mkDiv(asArithExpr(op1), asArithExpr(op2));
                case Modulo:
                    return ctx.mkMod(asIntExpr(op1), asIntExpr(op2)); //todo: check whether this is indeed modulo operation

                case LeftShift:
                    throw new NotImplementedException(); // bit vectors yet not supported
                case RightShift:
                    throw new NotImplementedException(); // bit vectors yet not supported
                case BitAnd:
                    throw new NotImplementedException(); // bit vectors yet not supported
                case BitOr:
                    throw new NotImplementedException(); // bit vectors yet not supported
                case BitXor:
                    throw new NotImplementedException(); // bit vectors yet not supported

                case CompareEquals:
                    return ctx.mkEq(op1, op2);
                case CompareNotEquals:
                    return ctx.mkNot(ctx.mkEq(op1, op2));

                case CompareLess:
                    return ctx.mkLt(asArithExpr(op1), asArithExpr(op2));
                case CompareLessOrEquals:
                    return ctx.mkLe(asArithExpr(op1), asArithExpr(op2));
                case CompareGreater:
                    return ctx.mkGt(asArithExpr(op1), asArithExpr(op2));
                case CompareGreaterOrEquals:
                    return ctx.mkGe(asArithExpr(op1), asArithExpr(op2));

                case Conjunction:
                    return ctx.mkAnd(asBoolExpr(op1), asBoolExpr(op2));
                case Disjunction:
                    return ctx.mkOr(asBoolExpr(op1), asBoolExpr(op2));
                default:
                    throw new IllegalArgumentException(event.getOperator().name());
            }
        }

        @Override
        public Expr visit(XConstant constant) {
            // TODO: determine type of constant here
            Object value = constant.getValue();
            // Note, this casting is temporary, we need to have a proper typisation
            if (value instanceof Boolean) {
                return ctx.mkBool((Boolean) value);
            }
            if (value instanceof Integer) {
                return ctx.mkInt((Integer) value);
            }
            throw new NotImplementedException(value.getClass().getSimpleName());
            //for now, we don't preserve consistency of types, it's Mocks and int32 everywhere
            //switch (constant.getType()) {
            //    case bit1:
            //        assert value instanceof Boolean : value;
            //        return ctx.mkBool((Boolean) value);
            //    case int32:
            //        assert value instanceof Integer : value;
            //        return ctx.mkInt((Integer) value);
            //    default:
            //        throw new NotImplementedException();
            //}
        }

        @Override
        public Expr visit(XRegister register) {
            if (isLastValue) {
                return Utils.lastValueReg(register, ctx);
            }
            else {
                return Utils.ssaReg(register, varRefCollection.getRefIndex(register), ctx);
            }
        }

        @Override
        public Expr visit(XLocation location) {
            if (isLastValue) {
                return Utils.lastValueLoc(location, ctx);
            }
            else {
                return Utils.ssaLoc(location, varRefCollection.getRefIndex(location), ctx);
            }
        }

        @Override
        public Expr visit(XAssertionEvent entity) {
            isLastValue = true;
            return entity.getAssertion().accept(this);
        }

        private ArithExpr asArithExpr(Expr expr) {
            if (!(expr instanceof ArithExpr)) {
                throw new ToZ3ConversionException("expression " + expr + " is supposed to be of type ArithExpr");
            }
            return (ArithExpr) expr;
        }

        private IntExpr asIntExpr(Expr expr) {
            if (!(expr instanceof IntExpr)) {
                throw new ToZ3ConversionException("expression " + expr + " is supposed to be of type IntExpr");
            }
            return (IntExpr) expr;
        }

        private BoolExpr asBoolExpr(Expr expr) {
            if (!(expr instanceof BoolExpr)) {
                throw new ToZ3ConversionException("expression " + expr + " is supposed to be of type BoolExpr");
            }
            return (BoolExpr) expr;
        }
    }
}
