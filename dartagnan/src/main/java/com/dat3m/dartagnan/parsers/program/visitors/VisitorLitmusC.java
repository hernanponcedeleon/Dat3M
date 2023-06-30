package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.type.IntegerType;
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

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.C11;

public class VisitorLitmusC extends LitmusCBaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = programBuilder.getTypeFactory().getArchType();
    private int currentThread;
    private int scope;
    private int ifId = 0;
    private Register returnRegister;

    public VisitorLitmusC(){
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Program visitMain(LitmusCParser.MainContext ctx) {
        //FIXME: We should visit thread declarations before variable declarations
        // because variable declaration refer to threads.
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
            IValue value = expressions.parseValue(ctx.initConstantValue().constant().getText(), archType);
            programBuilder.initLocEqConst(ctx.varName().getText(), value);
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        if (ctx.initConstantValue() != null) {
            // FIXME: We visit declarators before threads, so we need to create threads early
            programBuilder.getOrNewThread(ctx.threadId().id);
            IValue value = expressions.parseValue(ctx.initConstantValue().constant().getText(), archType);
            programBuilder.initRegEqConst(ctx.threadId().id,ctx.varName().getText(), value);
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
        // FIXME: We visit declarators before threads, so we need to create threads early
        programBuilder.getOrNewThread(ctx.threadId().id);
        if(ctx.Ast() == null){
            programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), archType);
        } else {
            String rightName = ctx.varName(1).getText();
            MemoryObject object = programBuilder.getObject(rightName);
            if(object != null){
                programBuilder.initRegEqConst(ctx.threadId().id, ctx.varName(0).getText(), object);
            } else {
                programBuilder.initRegEqLocVal(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), archType);
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
                        values.add(expressions.parseValue(elCtx.constant().getText(), archType));
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
        // Declarations in the preamble may have created the thread already
        programBuilder.getOrNewThread(currentThread);
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
                Register register = programBuilder.getOrNewRegister(scope, name, archType);
                programBuilder.addChild(currentThread, EventFactory.newLocal(register, object));
                id++;
            }
        }
        return null;
    }

    @Override
    public Object visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
        Expression expr = (Expression) ctx.re().accept(this);

        ifId++;
        Label elseL = programBuilder.getOrCreateLabel(currentThread,"else_" + ifId);
        Label endL = programBuilder.getOrCreateLabel(currentThread,"end_" + ifId);

        IfAsJump ifEvent = EventFactory.newIfJumpUnless(expr, elseL, endL);
        programBuilder.addChild(currentThread, ifEvent);

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);
        CondJump jumpToEnd = EventFactory.newGoto(endL);
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
    public Expression visitReAtomicOpReturn(LitmusCParser.ReAtomicOpReturnContext ctx){
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public Expression visitReAtomicFetchOp(LitmusCParser.ReAtomicFetchOpContext ctx){
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitC11AtomicOp(LitmusCParser.C11AtomicOpContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Atomic.newFetchOp(register, getAddress(ctx.address), value, ctx.op, ctx.c11Mo().mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }


    @Override
    public Expression visitReAtomicOpAndTest(LitmusCParser.ReAtomicOpAndTestContext ctx){
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWOpAndTest(getAddress(ctx.address), register, value, ctx.op);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public Expression visitReAtomicAddUnless(LitmusCParser.ReAtomicAddUnlessContext ctx){
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Expression cmp = (Expression) ctx.cmp.accept(this);
        programBuilder.addChild(currentThread, EventFactory.Linux.newRMWAddUnless(getAddress(ctx.address), register, cmp, value));
        return register;
    }

    @Override
    public Expression visitReXchg(LitmusCParser.ReXchgContext ctx){
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Event event = EventFactory.Linux.newRMWExchange(getAddress(ctx.address), register, value, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReC11SCmpXchg(LitmusCParser.ReC11SCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, true);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReC11WCmpXchg(LitmusCParser.ReC11WCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Atomic.newCompareExchange(register, getAddress(ctx.address), getAddress(ctx.expectedAdd), value, ctx.c11Mo(0).mo, false);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReCmpXchg(LitmusCParser.ReCmpXchgContext ctx){
        Register register = getReturnRegister(true);
        Expression cmp = (Expression)ctx.cmp.accept(this);
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Linux.newRMWCompareExchange(getAddress(ctx.address), register, cmp, value, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override public Expression visitReC11Load(LitmusCParser.ReC11LoadContext ctx) {
        Register register = getReturnRegister(true);
        Event event = EventFactory.Atomic.newLoad(register, getAddress(ctx.address), ctx.c11Mo().mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReLoad(LitmusCParser.ReLoadContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReReadOnce(LitmusCParser.ReReadOnceContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.Linux.newLKMMLoad(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReReadNa(LitmusCParser.ReReadNaContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.newLoadWithMo(register, getAddress(ctx.address), C11.NONATOMIC);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public Expression visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        //TODO boolean register
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeBinary(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeBinary(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpBool(LitmusCParser.ReOpBoolContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeBinary(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpBoolNot(LitmusCParser.ReOpBoolNotContext ctx){
        Register register = getReturnRegister(false);
        Expression v = (Expression)ctx.re().accept(this);
        Expression result = expressions.makeNot(v);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReBoolConst(LitmusCParser.ReBoolConstContext ctx){
        return expressions.makeValue(ctx.boolConst().value);
    }

    @Override
    public Expression visitReParenthesis(LitmusCParser.ReParenthesisContext ctx){
        return (Expression)ctx.re().accept(this);
    }

    @Override
    public Expression visitReCast(LitmusCParser.ReCastContext ctx){
        Register register = getReturnRegister(false);
        Expression result = (Expression)ctx.re().accept(this);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReVarName(LitmusCParser.ReVarNameContext ctx){
        Register register = getReturnRegister(false);
        Expression variable = visitVarName(ctx.varName());
        if (variable instanceof Register result) {
            return assignToReturnRegister(register, result);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Expression visitReConst(LitmusCParser.ReConstContext ctx){
        Register register = getReturnRegister(false);
        IValue result = expressions.parseValue(ctx.getText(), archType);
        return assignToReturnRegister(register, result);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(LitmusCParser.NreAtomicOpContext ctx){
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWOp(getAddress(ctx.address), value, ctx.op);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreStore(LitmusCParser.NreStoreContext ctx){
        Expression value = (Expression)ctx.value.accept(this);
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
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Linux.newLKMMStore(getAddress(ctx.address), value, ctx.mo);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreC11Store(LitmusCParser.NreC11StoreContext ctx) {
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Atomic.newStore(getAddress(ctx.address), value, ctx.c11Mo().mo);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreAssignment(LitmusCParser.NreAssignmentContext ctx){
        Expression variable = (Expression)ctx.varName().accept(this);
        if(ctx.Ast() == null){
            if(variable instanceof Register){
                returnRegister = (Register)variable;
                ctx.re().accept(this);
                return null;
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        Expression value = (Expression)ctx.re().accept(this);
        if(variable instanceof MemoryObject || variable instanceof Register){
            Event event = EventFactory.newStoreWithMo(variable, value, C11.NONATOMIC);
            return programBuilder.addChild(currentThread, event);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(LitmusCParser.NreRegDeclarationContext ctx){
        Register register = programBuilder.getRegister(scope, ctx.varName().getText());
        if(register == null){
            register = programBuilder.getOrNewRegister(scope, ctx.varName().getText(), archType);
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

    @Override
    public Object visitNreSrcuSync(LitmusCParser.NreSrcuSyncContext ctx) {
        return programBuilder.addChild(currentThread, EventFactory.Linux.newSrcuSync(getAddress(ctx.address)));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public Expression visitVarName(LitmusCParser.VarNameContext ctx){
        if(scope > -1){
            Register register = programBuilder.getRegister(scope, ctx.getText());
            if(register != null){
                return register;
            }
            MemoryObject object = programBuilder.getObject(ctx.getText());
            if(object != null){
                register = programBuilder.getOrNewRegister(scope, null, archType);
                programBuilder.addChild(currentThread, EventFactory.newLoadWithMo(register, object, C11.NONATOMIC));
                return register;
            }
            return programBuilder.getOrNewRegister(scope, ctx.getText(), archType);
        }
        MemoryObject object = programBuilder.getOrNewObject(ctx.getText());
        Register register = programBuilder.getOrNewRegister(scope, null, archType);
        programBuilder.addChild(currentThread, EventFactory.newLoadWithMo(register, object, C11.NONATOMIC));
        return register;
    }

    private Expression getAddress(LitmusCParser.ReContext ctx){
        Expression address = (Expression)ctx.accept(this);
        if(address.getType() instanceof IntegerType){
           return address;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    private Expression returnExpressionOrOne(LitmusCParser.ReContext ctx) {
        return ctx != null ? (Expression) ctx.accept(this) : expressions.makeOne(archType);
    }

    private Register getReturnRegister(boolean createOnNull){
        Register register = returnRegister;
        if(register == null && createOnNull){
            return programBuilder.getOrNewRegister(scope, null, archType);
        }
        returnRegister = null;
        return register;
    }

    private Expression assignToReturnRegister(Register register, Expression value){
        if(register != null){
            programBuilder.addChild(currentThread, EventFactory.newLocal(register, value));
        }
        return value;
    }
}
