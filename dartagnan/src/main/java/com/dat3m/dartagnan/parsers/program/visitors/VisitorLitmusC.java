package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.LitmusCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusCParser.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.Literal;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import java.util.*;

import static com.dat3m.dartagnan.program.event.Tag.C11;

public class VisitorLitmusC extends LitmusCBaseVisitor<Object> {

    private final Program program = new Program(Program.SourceLanguage.LITMUS);
    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Type type = types.getPointerType();
    private Thread thread;
    private final Map<String, Label> labelMap = new HashMap<>();
    private int ifId = 0;
    private Register returnRegister;

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Program visitMain(MainContext ctx) {
        // C programs can be compiled to different targets,
        // thus we don't set the architectures.
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitProgram(ctx.program());
        if (ctx.assertionList() != null) {
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            AssertionHelper.parseAssertionList(program, raw);
        }
        if (ctx.assertionFilter() != null) {
            int a = ctx.assertionFilter().getStart().getStartIndex();
            int b = ctx.assertionFilter().getStop().getStopIndex();
            String raw = ctx.assertionFilter().getStart().getInputStream().getText(new Interval(a, b));
            AssertionHelper.parseAssertionFilter(program, raw);
        }
        VisitorHelper.applyPostParsing(program, labelMap);
        return program;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(GlobalDeclaratorLocationContext ctx) {
        if (ctx.initConstantValue() != null) {
            MemoryObject object = program.getMemory().getOrNewObject(ctx.varName().getText());
            //TODO Unknown precision, defaults to unbound integer?
            Type type = types.getIntegerType();
            object.setInitialValue(0, expressions.parseValue(ctx.initConstantValue().constant().getText(), type));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(GlobalDeclaratorRegisterContext ctx) {
        if (ctx.initConstantValue() != null) {
            Thread thread = program.newThread(Integer.toString(ctx.threadId().id));
            //TODO Unknown precision, defaults to unbound integer?
            Type type = types.getIntegerType();
            Register register = thread.getOrNewRegister(ctx.varName().getText(), type);
            Literal value = expressions.parseValue(ctx.initConstantValue().constant().getText(), type);
            thread.append(EventFactory.newLocal(register, value));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(GlobalDeclaratorLocationLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.varName(0).getText());
        String rightName = ctx.varName(1).getText();
        Expression value = getDeclaratorExpression(rightName, ctx.Ast() == null);
        object.setInitialValue(0, value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(GlobalDeclaratorRegisterLocationContext ctx) {
        Thread thread = program.newThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.varName(0).getText(), type);
        String rightName = ctx.varName(1).getText();
        Expression value = getDeclaratorExpression(rightName, ctx.Ast() == null);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    private Expression getDeclaratorExpression(String rightName, boolean isAddress) {
        if (isAddress) {
            return program.getMemory().getOrNewObject(rightName);
        }
        Optional<MemoryObject> v = program.getMemory().getObject(rightName);
        // Is this really how it should work?
        if (v.isPresent()) {
            return v.get();
        }
        return program.getMemory().getOrNewObject(rightName).getInitialValue(0);
    }

    @Override
    public Object visitGlobalDeclaratorArray(GlobalDeclaratorArrayContext ctx) {
        String name = ctx.varName().getText();
        Integer size = ctx.DigitSequence() != null ? Integer.parseInt(ctx.DigitSequence().getText()) : null;

        if (ctx.initArray() == null && size != null && size > 0) {
            program.getMemory().newObject(name, size);
            return null;
        }
        if (ctx.initArray() != null) {
            if (size == null || ctx.initArray().arrayElement().size() == size) {
                List<Expression> values = new ArrayList<>();
                for (ArrayElementContext elCtx : ctx.initArray().arrayElement()) {
                    if (elCtx.constant() != null) {
                        values.add(expressions.parseValue(elCtx.constant().getText(), type));
                    } else {
                        String varName = elCtx.varName().getText();
                        //see test/resources/arrays/ok/C-array-ok-17.litmus
                        Optional<MemoryObject> object = program.getMemory().getObject(varName);
                        if (object.isPresent()) {
                            values.add(object.get());
                        } else {
                            MemoryObject o = program.getMemory().getOrNewObject(varName);
                            values.add(elCtx.Ast() == null ? o : o.getInitialValue(0));
                        }
                    }
                }
                MemoryObject object = program.getMemory().newObject(name, values.size());
                for (int i = 0; i < values.size(); i++) {
                    object.setInitialValue(i, values.get(i));
                }
                return null;
            }
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Threads (the program itself)

    @Override
    public Object visitThread(ThreadContext ctx) {
        thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        visitThreadArguments(ctx.threadArguments());
        for (ExpressionContext expressionContext : ctx.expression()) {
            expressionContext.accept(this);
        }
        thread = null;
        return null;
    }

    @Override
    public Object visitThreadArguments(ThreadArgumentsContext ctx) {
        if (ctx != null) {
            for (int id = 0; id < ctx.varName().size(); id++) {
                String name = ctx.varName(id).getText();
                MemoryObject object = program.getMemory().getOrNewObject(name);
                PointerTypeSpecifierContext pType = ctx.pointerTypeSpecifier(id);
                if(pType != null) {
                    BasicTypeSpecifierContext bType = pType.basicTypeSpecifier();
                    if(bType != null) {
                        if(bType.AtomicInt() != null) {
                            object.markAsAtomic();
                        }
                    }
                }
                Register register = thread.getOrNewRegister(name, type);
                thread.append(EventFactory.newLocal(register, object));
            }
        }
        return null;
    }

    @Override
    public Object visitIfExpression(IfExpressionContext ctx) {
        Expression expr = (Expression) ctx.re().accept(this);
        ifId++;
        Label elseL = labelMap.computeIfAbsent("else_" + ifId, EventFactory::newLabel);
        Label endL = labelMap.computeIfAbsent("end_" + ifId, EventFactory::newLabel);
        thread.append(EventFactory.newIfJumpUnless(expr, elseL, endL));
        for (ExpressionContext expressionContext : ctx.expression()) {
            expressionContext.accept(this);
        }
        CondJump jumpToEnd = EventFactory.newGoto(endL);
        thread.append(jumpToEnd);
        thread.append(elseL);
        if (ctx.elseExpression() != null) {
            ctx.elseExpression().accept(this);
        }
        thread.append(endL);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (memory reads, must have register for return value)

    // Returns new value (the value after computation)
    @Override
    public Expression visitReAtomicOpReturn(ReAtomicOpReturnContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        thread.append(EventFactory.Linux.newRMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo));
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public Expression visitReAtomicFetchOp(ReAtomicFetchOpContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        thread.append(EventFactory.Linux.newRMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo));
        return register;
    }

    @Override
    public Expression visitC11AtomicOp(C11AtomicOpContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        thread.append(EventFactory.Atomic.newFetchOp(register, getAddress(ctx.address), value, ctx.op, ctx.c11Mo().mo));
        return register;
    }


    @Override
    public Expression visitReAtomicOpAndTest(ReAtomicOpAndTestContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        thread.append(EventFactory.Linux.newRMWOpAndTest(getAddress(ctx.address), register, value, ctx.op));
        return register;
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public Expression visitReAtomicAddUnless(ReAtomicAddUnlessContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Expression cmp = (Expression) ctx.cmp.accept(this);
        thread.append(EventFactory.Linux.newRMWAddUnless(getAddress(ctx.address), register, cmp, value));
        return register;
    }

    @Override
    public Expression visitReXchg(ReXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        thread.append(EventFactory.Linux.newRMWExchange(getAddress(ctx.address), register, value, ctx.mo));
        return register;
    }

    @Override
    public Expression visitReC11SCmpXchg(ReC11SCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        thread.append(EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, true));
        return register;
    }

    @Override
    public Expression visitReC11WCmpXchg(ReC11WCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        thread.append(EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, false));
        return register;
    }

    @Override
    public Expression visitReCmpXchg(ReCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression cmp = (Expression) ctx.cmp.accept(this);
        Expression value = (Expression) ctx.value.accept(this);
        thread.append(EventFactory.Linux.newRMWCompareExchange(getAddress(ctx.address), register, cmp, value, ctx.mo));
        return register;
    }

    @Override
    public Expression visitReC11Load(ReC11LoadContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.Atomic.newLoad(register, getAddress(ctx.address), ctx.c11Mo().mo));
        return register;
    }

    @Override
    public Expression visitReLoad(ReLoadContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo));
        return register;
    }

    @Override
    public Expression visitReReadOnce(ReReadOnceContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo));
        return register;
    }

    @Override
    public Expression visitReReadNa(ReReadNaContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.newLoad(register, getAddress(ctx.address), C11.NONATOMIC));
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public Expression visitReOpCompare(ReOpCompareContext ctx) {
        //TODO boolean register
        Register register = getReturnRegister(false);
        Expression v1 = (Expression) ctx.re(0).accept(this);
        Expression v2 = (Expression) ctx.re(1).accept(this);
        Expression result = expressions.makeBinary(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpArith(ReOpArithContext ctx) {
        Register register = getReturnRegister(false);
        Expression v1 = (Expression) ctx.re(0).accept(this);
        Expression v2 = (Expression) ctx.re(1).accept(this);
        Expression result = expressions.makeBinary(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpBool(ReOpBoolContext ctx) {
        Register register = getReturnRegister(false);
        Expression v1 = (Expression) ctx.re(0).accept(this);
        Expression v2 = (Expression) ctx.re(1).accept(this);
        Expression result = expressions.makeBinary(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpBoolNot(ReOpBoolNotContext ctx) {
        Register register = getReturnRegister(false);
        Expression v = (Expression) ctx.re().accept(this);
        Expression result = expressions.makeNot(v);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReBoolConst(ReBoolConstContext ctx) {
        return expressions.makeValue(ctx.boolConst().value);
    }

    @Override
    public Expression visitReParenthesis(ReParenthesisContext ctx) {
        return (Expression) ctx.re().accept(this);
    }

    @Override
    public Expression visitReCast(ReCastContext ctx) {
        Register register = getReturnRegister(false);
        Expression result = (Expression) ctx.re().accept(this);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReVarName(ReVarNameContext ctx) {
        Register register = getReturnRegister(false);
        Expression variable = visitVarName(ctx.varName());
        if (variable instanceof Register) {
            Register result = (Register) variable;
            return assignToReturnRegister(register, result);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Expression visitReConst(ReConstContext ctx) {
        Register register = getReturnRegister(false);
        Literal result = expressions.parseValue(ctx.getText(), type);
        return assignToReturnRegister(register, result);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(NreAtomicOpContext ctx) {
        Expression value = returnExpressionOrOne(ctx.value);
        Register register = thread.newRegister(type);
        thread.append(EventFactory.Linux.newRMWOp(getAddress(ctx.address), register, value, ctx.op));
        return null;
    }

    @Override
    public Object visitNreStore(NreStoreContext ctx) {
        Expression value = (Expression) ctx.value.accept(this);
        if (ctx.mo.equals(Tag.Linux.MO_MB)) {
            thread.append(EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, Tag.Linux.MO_ONCE));
            thread.append(EventFactory.Linux.newMemoryBarrier());
            return null;
        }
        thread.append(EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, ctx.mo));
        return null;
    }

    @Override
    public Object visitNreWriteOnce(NreWriteOnceContext ctx) {
        Expression value = (Expression) ctx.value.accept(this);
        thread.append(EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, ctx.mo));
        return null;
    }

    @Override
    public Object visitNreC11Store(NreC11StoreContext ctx) {
        Expression value = (Expression) ctx.value.accept(this);
        thread.append(EventFactory.Atomic.newStore(getAddress(ctx.address), value, ctx.c11Mo().mo));
        return null;
    }

    @Override
    public Object visitNreAssignment(NreAssignmentContext ctx) {
        Expression variable = (Expression) ctx.varName().accept(this);
        if (ctx.Ast() == null) {
            if (variable instanceof Register) {
                returnRegister = (Register) variable;
                ctx.re().accept(this);
                return null;
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        Expression value = (Expression) ctx.re().accept(this);
        if (variable instanceof MemoryObject || variable instanceof Register) {
            thread.append(EventFactory.newStore(variable, value, C11.NONATOMIC));
            return null;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(NreRegDeclarationContext ctx) {
        Register register = thread.newRegister(ctx.varName().getText(), type);
        if (ctx.re() != null) {
            returnRegister = register;
            ctx.re().accept(this);
        }
        return null;
    }

    @Override
    public Object visitNreC11Fence(NreC11FenceContext ctx) {
        thread.append(EventFactory.Atomic.newFence(ctx.c11Mo().mo));
        return null;
    }

    @Override
    public Object visitNreFence(NreFenceContext ctx) {
        thread.append(EventFactory.Linux.newLKMMFence(ctx.name));
        return null;
    }

    @Override
    public Object visitNreSpinLock(NreSpinLockContext ctx) {
        thread.append(EventFactory.Linux.newLock(getAddress(ctx.address)));
        return null;
    }

    @Override
    public Object visitNreSpinUnlock(NreSpinUnlockContext ctx) {
        thread.append(EventFactory.Linux.newUnlock(getAddress(ctx.address)));
        return null;
    }

    @Override
    public Object visitNreSrcuSync(NreSrcuSyncContext ctx) {
        thread.append(EventFactory.Linux.newSrcuSync(getAddress(ctx.address)));
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public Expression visitVarName(VarNameContext ctx) {
        String name = ctx.getText();
        if (thread == null) {
            MemoryObject object = program.getMemory().getOrNewObject(name);
            Register register = thread.newRegister(type);
            thread.append(EventFactory.newLoad(register, object, C11.NONATOMIC));
            return register;
        }
        Optional<Register> fetched = thread.getRegister(name);
        if (fetched.isPresent()) {
            return fetched.get();
        }
        Optional<MemoryObject> object = program.getMemory().getObject(name);
        if (object.isPresent()) {
            Register register = thread.newRegister(type);
            thread.append(EventFactory.newLoad(register, object.get(), C11.NONATOMIC));
            return register;
        }
        return thread.getOrNewRegister(name, type);
    }

    private Expression getAddress(ReContext ctx) {
        return (Expression) ctx.accept(this);
    }

    private Expression returnExpressionOrOne(ReContext ctx) {
        return ctx != null ? (Expression) ctx.accept(this) : expressions.makeOne(type);
    }

    private Register getReturnRegister(boolean createOnNull) {
        Register register = returnRegister;
        if (register == null && createOnNull) {
            return thread.newRegister(type);
        }
        returnRegister = null;
        return register;
    }

    private Expression assignToReturnRegister(Register register, Expression value) {
        if (register != null) {
            thread.append(EventFactory.newLocal(register, value));
        }
        return value;
    }
}
