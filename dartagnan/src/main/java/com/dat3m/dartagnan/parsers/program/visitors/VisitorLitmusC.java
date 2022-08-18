package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.parsers.LitmusCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusCParser;
import com.dat3m.dartagnan.parsers.LitmusCParser.BasicTypeSpecifierContext;
import com.dat3m.dartagnan.parsers.LitmusCParser.PointerTypeSpecifierContext;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.CondJump;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.IfAsJump;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;
import static com.dat3m.dartagnan.program.event.Tag.*;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.List;

public class VisitorLitmusC extends LitmusCBaseVisitor<Object> {

    private final ProgramBuilder programBuilder;
    private int currentThread;
    private int scope;
    private int ifId = 0;
    private Register returnRegister;

    public VisitorLitmusC(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Program visitMain(LitmusCParser.MainContext ctx) {
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitProgram(ctx.program());
        if(ctx.assertionList() != null){
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssert(AssertionHelper.parseAssertionList(programBuilder, raw));
        }
        if(ctx.assertionFilter() != null){
            int a = ctx.assertionFilter().getStart().getStartIndex();
            int b = ctx.assertionFilter().getStop().getStopIndex();
            String raw = ctx.assertionFilter().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssertFilter(AssertionHelper.parseAssertionFilter(programBuilder, raw));
        }
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(LitmusCParser.GlobalDeclaratorLocationContext ctx) {
        if (ctx.initConstantValue() != null) {
            BigInteger value = new BigInteger(ctx.initConstantValue().constant().getText());
            programBuilder.initLocEqConst(ctx.varName().getText(),new IValue(value,-1));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        if (ctx.initConstantValue() != null) {
            BigInteger value = new BigInteger(ctx.initConstantValue().constant().getText());
            programBuilder.initRegEqConst(ctx.threadId().id,ctx.varName().getText(),new IValue(value,-1));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
        if(ctx.Ast() == null){
            programBuilder.initLocEqLocPtr(ctx.varName(0).getText(), ctx.varName(1).getText());
        } else {
            String rightName = ctx.varName(1).getText();
            MemoryObject object = programBuilder.getObject(rightName);
            if(object != null){
                programBuilder.initLocEqConst(ctx.varName(0).getText(), object);
            } else {
                programBuilder.initLocEqLocVal(ctx.varName(0).getText(), ctx.varName(1).getText());
            }
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        if(ctx.Ast() == null){
            programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), ARCH_PRECISION);
        } else {
            String rightName = ctx.varName(1).getText();
            MemoryObject object = programBuilder.getObject(rightName);
            if(object != null){
                programBuilder.initRegEqConst(ctx.threadId().id, ctx.varName(0).getText(), object);
            } else {
                programBuilder.initRegEqLocVal(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), ARCH_PRECISION);
            }
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorArray(LitmusCParser.GlobalDeclaratorArrayContext ctx) {
        String name = ctx.varName().getText();
        Integer size = ctx.DigitSequence() != null ? Integer.parseInt(ctx.DigitSequence().getText()) : null;

        if(ctx.initArray() == null && size != null && size > 0){
            programBuilder.newObject(name,size);
            return null;
        }
        if(ctx.initArray() != null){
            if(size == null || ctx.initArray().arrayElement().size() == size){
                List<IConst> values = new ArrayList<>();
                for(LitmusCParser.ArrayElementContext elCtx : ctx.initArray().arrayElement()){
                    if(elCtx.constant() != null){
                        values.add(new IValue(new BigInteger(elCtx.constant().getText()), ARCH_PRECISION));
                    } else {
                        String varName = elCtx.varName().getText();
                        //see test/resources/arrays/ok/C-array-ok-17.litmus
                        MemoryObject object = programBuilder.getObject(varName);
                        if(object != null){
                            values.add(object);
                        } else {
                            object = programBuilder.getOrNewObject(varName);
                            values.add(elCtx.Ast() == null ? object : object.getInitialValue(0));
                        }
                    }
                }
                MemoryObject object = programBuilder.newObject(name,values.size());
                for(int i = 0; i < values.size(); i++) {
                    object.setInitialValue(i,values.get(i));
                }
                return null;
            }
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Threads (the program itself)

    @Override
    public Object visitThread(LitmusCParser.ThreadContext ctx) {
        scope = currentThread = ctx.threadId().id;
        programBuilder.initThread(currentThread);
        visitThreadArguments(ctx.threadArguments());

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);

        scope = currentThread = -1;
        return null;
    }

    @Override
    public Object visitThreadArguments(LitmusCParser.ThreadArgumentsContext ctx){
        if(ctx != null){
        	int id = 0;
            for(LitmusCParser.VarNameContext varName : ctx.varName()){
                String name = varName.getText();
                MemoryObject object = programBuilder.getOrNewObject(name);
                PointerTypeSpecifierContext pType = ctx.pointerTypeSpecifier(id);
				if(pType != null) {
                    BasicTypeSpecifierContext bType = pType.basicTypeSpecifier();
					if(bType != null) {
                        if(bType.AtomicInt() != null) {
                        	object.markAsAtomic();
                        }
                    }
				}
                Register register = programBuilder.getOrCreateRegister(scope, name, ARCH_PRECISION);
                programBuilder.addChild(currentThread, EventFactory.newLocal(register, object));
                id++;
            }
        }
        return null;
    }

    @Override
    public Object visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
    	ExprInterface expr = (ExprInterface) ctx.re().accept(this);

    	ifId++;
        Label elseL = programBuilder.getOrCreateLabel("else_" + ifId);
        Label endL = programBuilder.getOrCreateLabel("end_" + ifId);

        IfAsJump ifEvent = EventFactory.newIfJumpUnless(expr, elseL, endL);
        programBuilder.addChild(currentThread, ifEvent);

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);
        CondJump jumpToEnd = EventFactory.newGoto(endL);
        jumpToEnd.addFilters(Tag.IFI);
		programBuilder.addChild(currentThread, jumpToEnd);
        
        programBuilder.addChild(currentThread, elseL);
        if(ctx.elseExpression() != null){
            ctx.elseExpression().accept(this);
        }
        programBuilder.addChild(currentThread, endL);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (memory reads, must have register for return value)

    // Returns new value (the value after computation)
    @Override
    public IExpr visitReAtomicOpReturn(LitmusCParser.ReAtomicOpReturnContext ctx){
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = EventFactory.Linux.newRMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public IExpr visitReAtomicFetchOp(LitmusCParser.ReAtomicFetchOpContext ctx){
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = EventFactory.Linux.newRMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

	@Override 
	public IExpr visitC11AtomicOp(LitmusCParser.C11AtomicOpContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = EventFactory.Atomic.newFetchOp(register, getAddress(ctx.address), value, ctx.op, ctx.c11Mo().mo);
        programBuilder.addChild(currentThread, event);
        return register;
	}

    
    @Override
    public IExpr visitReAtomicOpAndTest(LitmusCParser.ReAtomicOpAndTestContext ctx){
        Register register = getReturnRegister(true);
        IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = EventFactory.Linux.newRMWOpAndTest(getAddress(ctx.address), register, value, ctx.op);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public IExpr visitReAtomicAddUnless(LitmusCParser.ReAtomicAddUnlessContext ctx){
        Register register = getReturnRegister(true);
        IExpr value = (IExpr)ctx.value.accept(this);
        ExprInterface cmp = (ExprInterface)ctx.cmp.accept(this);
        programBuilder.addChild(currentThread, EventFactory.Linux.newRMWAddUnless(getAddress(ctx.address), register, cmp, value));
        return register;
    }

    @Override
    public IExpr visitReXchg(LitmusCParser.ReXchgContext ctx){
        Register register = getReturnRegister(true);
        IExpr value = (IExpr)ctx.value.accept(this);
        Event event = EventFactory.Linux.newRMWExchange(getAddress(ctx.address), register, value, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

	@Override 
	public IExpr visitReC11SCmpXchg(LitmusCParser.ReC11SCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = (IExpr)ctx.value.accept(this);
        Event event = EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, true);
        programBuilder.addChild(currentThread, event);
        return register;
	}

	@Override 
	public IExpr visitReC11WCmpXchg(LitmusCParser.ReC11WCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        IExpr value = (IExpr)ctx.value.accept(this);
        Event event = EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, false);
        programBuilder.addChild(currentThread, event);
        return register;
	}

    @Override
    public IExpr visitReCmpXchg(LitmusCParser.ReCmpXchgContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface cmp = (ExprInterface)ctx.cmp.accept(this);
        IExpr value = (IExpr)ctx.value.accept(this);
        Event event = EventFactory.Linux.newRMWCompareExchange(getAddress(ctx.address), register, cmp, value, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

	@Override public IExpr visitReC11Load(LitmusCParser.ReC11LoadContext ctx) {
        Register register = getReturnRegister(true);
        Event event = EventFactory.Atomic.newLoad(register, getAddress(ctx.address), ctx.c11Mo().mo);
        programBuilder.addChild(currentThread, event);
        return register;
	}

    @Override
    public IExpr visitReLoad(LitmusCParser.ReLoadContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReReadOnce(LitmusCParser.ReReadOnceContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReReadNa(LitmusCParser.ReReadNaContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.newLoad(register, getAddress(ctx.address), C11.NONATOMIC);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public ExprInterface visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface)ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface)ctx.re(1).accept(this);
        Atom result = new Atom(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Register register = getReturnRegister(false);
        IExpr v1 = (IExpr)ctx.re(0).accept(this);
        IExpr v2 = (IExpr)ctx.re(1).accept(this);
        IExpr result = new IExprBin(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpBool(LitmusCParser.ReOpBoolContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface)ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface)ctx.re(1).accept(this);
        BExprBin result = new BExprBin(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpBoolNot(LitmusCParser.ReOpBoolNotContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v = (ExprInterface)ctx.re().accept(this);
        BExprUn result = new BExprUn(BOpUn.NOT, v);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReBoolConst(LitmusCParser.ReBoolConstContext ctx){
        return new BConst(ctx.boolConst().value);
    }

    @Override
    public ExprInterface visitReParenthesis(LitmusCParser.ReParenthesisContext ctx){
        return (ExprInterface)ctx.re().accept(this);
    }

    @Override
    public ExprInterface visitReCast(LitmusCParser.ReCastContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface result = (ExprInterface)ctx.re().accept(this);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReVarName(LitmusCParser.ReVarNameContext ctx){
        Register register = getReturnRegister(false);
        IExpr variable = visitVarName(ctx.varName());
        if(variable instanceof Register){
            Register result = (Register)variable;
            return assignToReturnRegister(register, result);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public ExprInterface visitReConst(LitmusCParser.ReConstContext ctx){
        Register register = getReturnRegister(false);
        IValue result = new IValue(new BigInteger(ctx.getText()), ARCH_PRECISION);
        return assignToReturnRegister(register, result);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(LitmusCParser.NreAtomicOpContext ctx){
    	IExpr value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Register register = programBuilder.getOrCreateRegister(scope, null, ARCH_PRECISION);
        Event event = EventFactory.Linux.newRMWOp(getAddress(ctx.address), register, value, ctx.op);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreStore(LitmusCParser.NreStoreContext ctx){
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        if(ctx.mo.equals(Tag.Linux.MO_MB)){
            Event event = EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, Tag.Linux.MO_ONCE);
            programBuilder.addChild(currentThread, event);
            return programBuilder.addChild(currentThread, EventFactory.Linux.newMemoryBarrier());
        }
        Event event = EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, ctx.mo);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreWriteOnce(LitmusCParser.NreWriteOnceContext ctx){
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Event event = EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, ctx.mo);
        return programBuilder.addChild(currentThread, event);
    }

	@Override
	public Object visitNreC11Store(LitmusCParser.NreC11StoreContext ctx) {
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Event event = EventFactory.Atomic.newStore(getAddress(ctx.address), value, ctx.c11Mo().mo);
        return programBuilder.addChild(currentThread, event);
	}

    @Override
    public Object visitNreAssignment(LitmusCParser.NreAssignmentContext ctx){
        ExprInterface variable = (ExprInterface)ctx.varName().accept(this);
        if(ctx.Ast() == null){
            if(variable instanceof Register){
                returnRegister = (Register)variable;
                ctx.re().accept(this);
                return null;
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        ExprInterface value = (ExprInterface)ctx.re().accept(this);
        if(variable instanceof MemoryObject || variable instanceof Register){
            Event event = EventFactory.newStore((IExpr) variable, value, C11.NONATOMIC);
            return programBuilder.addChild(currentThread, event);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(LitmusCParser.NreRegDeclarationContext ctx){
        Register register = programBuilder.getRegister(scope, ctx.varName().getText());
        if(register == null){
            register = programBuilder.getOrCreateRegister(scope, ctx.varName().getText(), ARCH_PRECISION);
            if(ctx.re() != null){
                returnRegister = register;
                ctx.re().accept(this);
            }
            return null;
        }
        throw new ParsingException("Register " + ctx.varName().getText() + " is already initialised");
    }

	@Override
	public Object visitNreC11Fence(LitmusCParser.NreC11FenceContext ctx) {
		return programBuilder.addChild(currentThread, EventFactory.Atomic.newFence(ctx.c11Mo().mo));
	}

    @Override
    public Object visitNreFence(LitmusCParser.NreFenceContext ctx){
        return programBuilder.addChild(currentThread, EventFactory.Linux.newLKMMFence(ctx.name));
    }

    @Override
    public Object visitNreSpinLock(LitmusCParser.NreSpinLockContext ctx) {
    	return programBuilder.addChild(currentThread, EventFactory.Linux.newLock(getAddress(ctx.address)));
    }

    @Override
    public Object visitNreSpinUnlock(LitmusCParser.NreSpinUnlockContext ctx) {
    	return programBuilder.addChild(currentThread, EventFactory.Linux.newUnlock(getAddress(ctx.address)));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public IExpr visitVarName(LitmusCParser.VarNameContext ctx){
        if(scope > -1){
            Register register = programBuilder.getRegister(scope, ctx.getText());
            if(register != null){
                return register;
            }
            MemoryObject object = programBuilder.getObject(ctx.getText());
            if(object != null){
                register = programBuilder.getOrCreateRegister(scope, null, ARCH_PRECISION);
                programBuilder.addChild(currentThread, EventFactory.newLoad(register, object, C11.NONATOMIC));
                return register;
            }
            return programBuilder.getOrCreateRegister(scope, ctx.getText(), ARCH_PRECISION);
        }
        MemoryObject object = programBuilder.getOrNewObject(ctx.getText());
        Register register = programBuilder.getOrCreateRegister(scope, null, ARCH_PRECISION);
        programBuilder.addChild(currentThread, EventFactory.newLoad(register, object, C11.NONATOMIC));
        return register;
    }

    private IExpr getAddress(LitmusCParser.ReContext ctx){
        ExprInterface address = (ExprInterface)ctx.accept(this);
        if(address instanceof IExpr){
           return (IExpr)address;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    private IExpr returnExpressionOrDefault(LitmusCParser.ReContext ctx, BigInteger defaultValue){
        return ctx != null ? (IExpr)ctx.accept(this) : new IValue(defaultValue, ARCH_PRECISION);
    }

    private Register getReturnRegister(boolean createOnNull){
        Register register = returnRegister;
        if(register == null && createOnNull){
            return programBuilder.getOrCreateRegister(scope, null, ARCH_PRECISION);
        }
        returnRegister = null;
        return register;
    }

    private ExprInterface assignToReturnRegister(Register register, ExprInterface value){
        if(register != null){
            programBuilder.addChild(currentThread, EventFactory.newLocal(register, value));
        }
        return value;
    }
}
