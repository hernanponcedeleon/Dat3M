package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.parsers.LitmusCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusCParser.*;
import com.dat3m.dartagnan.parsers.LitmusCParser.BasicTypeSpecifierContext;
import com.dat3m.dartagnan.parsers.LitmusCParser.PointerTypeSpecifierContext;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
import static com.dat3m.dartagnan.program.event.Tag.C11;

public class VisitorLitmusC extends LitmusCBaseVisitor<Object> {

    private final Program program = new Program(Program.SourceLanguage.LITMUS);
    private final int archPrecision = getArchPrecision();
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
        for (Thread thread : program.getThreads()) {
            thread.append(labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel));
        }
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setOId(e.getGlobalId()));
        return program;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(GlobalDeclaratorLocationContext ctx) {
        if (ctx.initConstantValue() != null) {
            MemoryObject object = program.getMemory().getOrNewObject(ctx.varName().getText());
            BigInteger value = new BigInteger(ctx.initConstantValue().constant().getText());
            // Unknown precision, defaults to unbound integer?
            object.setInitialValue(0, new IValue(value, -1));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(GlobalDeclaratorRegisterContext ctx) {
        if (ctx.initConstantValue() != null) {
            Thread thread = program.newThread(Integer.toString(ctx.threadId().id));
            // Unknown precision, defaults to unbound integer?
            Register register = thread.getOrNewRegister(ctx.varName().getText(), -1);
            BigInteger value = new BigInteger(ctx.initConstantValue().constant().getText());
            thread.append(EventFactory.newLocal(register, new IValue(value, -1)));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(GlobalDeclaratorLocationLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.varName(0).getText());
        String rightName = ctx.varName(1).getText();
        IConst value;
        if (ctx.Ast() == null) {
            value = program.getMemory().getOrNewObject(rightName);
        } else {
            Optional<MemoryObject> v = program.getMemory().getObject(rightName);
            // Is this really how it should work?
            if (v.isPresent()) {
                value = v.get();
            } else {
                value = program.getMemory().getOrNewObject(rightName).getInitialValue(0);
            }
        }
        object.setInitialValue(0, value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(GlobalDeclaratorRegisterLocationContext ctx) {
        Thread thread = program.newThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.varName(0).getText(), archPrecision);
        String rightName = ctx.varName(1).getText();
        IConst value;
        if (ctx.Ast() == null) {
            value = program.getMemory().getOrNewObject(rightName);
        } else {
            Optional<MemoryObject> v = program.getMemory().getObject(rightName);
            if (v.isPresent()) {
                value = v.get();
            } else {
                value = program.getMemory().getOrNewObject(rightName).getInitialValue(0);
            }
        }
        thread.append(EventFactory.newLocal(register, value));
        return null;
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
                List<IConst> values = new ArrayList<>();
                for (ArrayElementContext elCtx : ctx.initArray().arrayElement()) {
                    if (elCtx.constant() != null) {
                        values.add(new IValue(new BigInteger(elCtx.constant().getText()), archPrecision));
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
                Register register = thread.getOrNewRegister(name, archPrecision);
                thread.append(EventFactory.newLocal(register, object));
            }
        }
        return null;
    }

    @Override
    public Object visitIfExpression(IfExpressionContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.re().accept(this);
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
    public IExpr visitReAtomicOpReturn(ReAtomicOpReturnContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        thread.append(EventFactory.Linux.newRMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo));
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public IExpr visitReAtomicFetchOp(ReAtomicFetchOpContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        thread.append(EventFactory.Linux.newRMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo));
        return register;
    }

    @Override
    public IExpr visitC11AtomicOp(C11AtomicOpContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        thread.append(EventFactory.Atomic.newFetchOp(register, getAddress(ctx.address), value, ctx.op, ctx.c11Mo().mo));
        return register;
    }


    @Override
    public IExpr visitReAtomicOpAndTest(ReAtomicOpAndTestContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        thread.append(EventFactory.Linux.newRMWOpAndTest(getAddress(ctx.address), register, value, ctx.op));
        return register;
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public IExpr visitReAtomicAddUnless(ReAtomicAddUnlessContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = (IExpr) ctx.value.accept(this);
        ExprInterface cmp = (ExprInterface) ctx.cmp.accept(this);
        thread.append(EventFactory.Linux.newRMWAddUnless(getAddress(ctx.address), register, cmp, value));
        return register;
    }

    @Override
    public IExpr visitReXchg(ReXchgContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = (IExpr) ctx.value.accept(this);
        thread.append(EventFactory.Linux.newRMWExchange(getAddress(ctx.address), register, value, ctx.mo));
        return register;
    }

    @Override
    public IExpr visitReC11SCmpXchg(ReC11SCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = (IExpr) ctx.value.accept(this);
        thread.append(EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, true));
        return register;
    }

    @Override
    public IExpr visitReC11WCmpXchg(ReC11WCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = (IExpr) ctx.value.accept(this);
        thread.append(EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, false));
        return register;
    }

    @Override
    public IExpr visitReCmpXchg(ReCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        ExprInterface cmp = (ExprInterface) ctx.cmp.accept(this);
        IExpr value = (IExpr) ctx.value.accept(this);
        thread.append(EventFactory.Linux.newRMWCompareExchange(getAddress(ctx.address), register, cmp, value, ctx.mo));
        return register;
    }

    @Override
    public IExpr visitReC11Load(ReC11LoadContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.Atomic.newLoad(register, getAddress(ctx.address), ctx.c11Mo().mo));
        return register;
    }

    @Override
    public IExpr visitReLoad(ReLoadContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo));
        return register;
    }

    @Override
    public IExpr visitReReadOnce(ReReadOnceContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo));
        return register;
    }

    @Override
    public IExpr visitReReadNa(ReReadNaContext ctx) {
        Register register = getReturnRegister(true);
        thread.append(EventFactory.newLoad(register, getAddress(ctx.address), C11.NONATOMIC));
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public ExprInterface visitReOpCompare(ReOpCompareContext ctx) {
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface) ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface) ctx.re(1).accept(this);
        Atom result = new Atom(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpArith(ReOpArithContext ctx) {
        Register register = getReturnRegister(false);
        IExpr v1 = (IExpr) ctx.re(0).accept(this);
        IExpr v2 = (IExpr) ctx.re(1).accept(this);
        IExpr result = new IExprBin(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpBool(ReOpBoolContext ctx) {
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface) ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface) ctx.re(1).accept(this);
        BExprBin result = new BExprBin(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpBoolNot(ReOpBoolNotContext ctx) {
        Register register = getReturnRegister(false);
        ExprInterface v = (ExprInterface) ctx.re().accept(this);
        BExprUn result = new BExprUn(BOpUn.NOT, v);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReBoolConst(ReBoolConstContext ctx) {
        return new BConst(ctx.boolConst().value);
    }

    @Override
    public ExprInterface visitReParenthesis(ReParenthesisContext ctx) {
        return (ExprInterface) ctx.re().accept(this);
    }

    @Override
    public ExprInterface visitReCast(ReCastContext ctx) {
        Register register = getReturnRegister(false);
        ExprInterface result = (ExprInterface) ctx.re().accept(this);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReVarName(ReVarNameContext ctx) {
        Register register = getReturnRegister(false);
        IExpr variable = visitVarName(ctx.varName());
        if (variable instanceof Register) {
            Register result = (Register) variable;
            return assignToReturnRegister(register, result);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public ExprInterface visitReConst(ReConstContext ctx) {
        Register register = getReturnRegister(false);
        IValue result = new IValue(new BigInteger(ctx.getText()), archPrecision);
        return assignToReturnRegister(register, result);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(NreAtomicOpContext ctx) {
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Register register = thread.newRegister(archPrecision);
        thread.append(EventFactory.Linux.newRMWOp(getAddress(ctx.address), register, value, ctx.op));
        return null;
    }

    @Override
    public Object visitNreStore(NreStoreContext ctx) {
        ExprInterface value = (ExprInterface) ctx.value.accept(this);
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
        ExprInterface value = (ExprInterface) ctx.value.accept(this);
        thread.append(EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, ctx.mo));
        return null;
    }

    @Override
    public Object visitNreC11Store(NreC11StoreContext ctx) {
        ExprInterface value = (ExprInterface) ctx.value.accept(this);
        thread.append(EventFactory.Atomic.newStore(getAddress(ctx.address), value, ctx.c11Mo().mo));
        return null;
    }

    @Override
    public Object visitNreAssignment(NreAssignmentContext ctx) {
        ExprInterface variable = (ExprInterface) ctx.varName().accept(this);
        if (ctx.Ast() == null) {
            if (variable instanceof Register) {
                returnRegister = (Register) variable;
                ctx.re().accept(this);
                return null;
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        ExprInterface value = (ExprInterface) ctx.re().accept(this);
        if (variable instanceof MemoryObject || variable instanceof Register) {
            thread.append(EventFactory.newStore((IExpr) variable, value, C11.NONATOMIC));
            return null;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(NreRegDeclarationContext ctx) {
        Register register = thread.newRegister(ctx.varName().getText(), archPrecision);
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
    public IExpr visitVarName(VarNameContext ctx) {
        String name = ctx.getText();
        if (thread == null) {
            MemoryObject object = program.getMemory().getOrNewObject(name);
            Register register = thread.newRegister(archPrecision);
            thread.append(EventFactory.newLoad(register, object, C11.NONATOMIC));
            return register;
        }
        Optional<Register> fetched = thread.getRegister(name);
        if (fetched.isPresent()) {
            return fetched.get();
        }
        Optional<MemoryObject> object = program.getMemory().getObject(name);
        if (object.isPresent()) {
            Register register = thread.newRegister(archPrecision);
            thread.append(EventFactory.newLoad(register, object.get(), C11.NONATOMIC));
            return register;
        }
        return thread.getOrNewRegister(name, archPrecision);
    }

    private IExpr getAddress(ReContext ctx) {
        ExprInterface address = (ExprInterface) ctx.accept(this);
        if (address instanceof IExpr) {
            return (IExpr) address;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    private IExpr returnExpressionOrDefault(ReContext ctx, BigInteger defaultValue) {
        return ctx != null ? (IExpr) ctx.accept(this) : new IValue(defaultValue, archPrecision);
    }

    private Register getReturnRegister(boolean createOnNull) {
        Register register = returnRegister;
        if (register == null && createOnNull) {
            return thread.newRegister(archPrecision);
        }
        returnRegister = null;
        return register;
    }

    private ExprInterface assignToReturnRegister(Register register, ExprInterface value) {
        if (register != null) {
            thread.append(EventFactory.newLocal(register, value));
        }
        return value;
    }
}
