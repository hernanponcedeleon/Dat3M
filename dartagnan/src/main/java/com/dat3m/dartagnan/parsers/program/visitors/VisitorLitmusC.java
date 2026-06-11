package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusCParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.ParserRuleContext;

import java.util.ArrayList;
import java.util.List;

import static com.dat3m.dartagnan.program.event.Tag.C11;

public class VisitorLitmusC extends LitmusCBaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forLanguage(Program.SourceLanguage.LITMUS);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = programBuilder.getTypeFactory().getArchType();
    private final int archSize = TypeFactory.getInstance().getMemorySizeInBytes(archType);
    private int currentThread;
    private int scope;
    private int ifId = 0;
    private int whileId = 0;
    private Register returnRegister;
    private boolean isOpenCL = false;
    private final List<Integer> threadIds = new ArrayList<>();

    public VisitorLitmusC(){
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Program visitMain(MainContext ctx) {
        isOpenCL = ctx.LitmusLanguage().getText().equals("OPENCL");
        for (ThreadDeclaratorContext threadDeclaratorContext : ctx.threadDeclarator()) {
            visitThreadDeclarator(threadDeclaratorContext);
        }
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        int threadIndex = 0;
        for (ThreadContentContext threadContentContext : ctx.threadContent()) {
            scope = currentThread = threadIds.get(threadIndex++);
            visitThreadContent(threadContentContext);
        }
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(GlobalDeclaratorLocationContext ctx) {
        if (ctx.initConstantValue() != null) {
            IntLiteral value = expressions.parseValue(ctx.initConstantValue().constant().getText(), archType);
            programBuilder.initLocEqConst(ctx.varName().getText(), value);
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(GlobalDeclaratorRegisterContext ctx) {
        if (ctx.initConstantValue() != null) {
            IntLiteral value = expressions.parseValue(ctx.initConstantValue().constant().getText(), archType);
            programBuilder.initRegEqConst(ctx.threadId().id,ctx.varName().getText(), value, ctx.getStart().getLine());
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(GlobalDeclaratorLocationLocationContext ctx) {
        if(ctx.Ast() == null) {
            programBuilder.initLocEqLocPtr(ctx.varName(0).getText(), ctx.varName(1).getText());
        } else {
            String rightName = ctx.varName(1).getText();
            MemoryObject object = programBuilder.getMemoryObject(rightName);
            if(object != null){
                programBuilder.initLocEqConst(ctx.varName(0).getText(), object);
            } else {
                programBuilder.initLocEqLocVal(ctx.varName(0).getText(), ctx.varName(1).getText());
            }
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(GlobalDeclaratorRegisterLocationContext ctx) {
        // FIXME: We visit declarators before threads, so we need to create threads early
        final int lineOfCode = ctx.getStart().getLine();
        if(ctx.Ast() == null){
            programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), archType, lineOfCode);
        } else {
            String rightName = ctx.varName(1).getText();
            MemoryObject object = programBuilder.getMemoryObject(rightName);
            if(object != null){
                programBuilder.initRegEqConst(ctx.threadId().id, ctx.varName(0).getText(), object, lineOfCode);
            } else {
                programBuilder.initRegEqLocVal(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), archType, lineOfCode);
            }
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorArray(GlobalDeclaratorArrayContext ctx) {
        String name = ctx.varName().getText();
        Integer size = ctx.DigitSequence() != null ? Integer.parseInt(ctx.DigitSequence().getText()) : null;

        if(ctx.initArray() == null && size != null && size > 0){
            programBuilder.newMemoryObject(name,size);
            return null;
        }
        if(ctx.initArray() != null){
            if(size == null || ctx.initArray().arrayElement().size() == size){
                List<Expression> values = new ArrayList<>();
                for(ArrayElementContext elCtx : ctx.initArray().arrayElement()){
                    if(elCtx.constant() != null){
                        values.add(expressions.parseValue(elCtx.constant().getText(), archType));
                    } else {
                        String varName = elCtx.varName().getText();
                        //see test/resources/arrays/ok/C-array-ok-17.litmus
                        MemoryObject object = programBuilder.getMemoryObject(varName);
                        if(object != null){
                            values.add(object);
                        } else {
                            object = programBuilder.getOrNewMemoryObject(varName);
                            values.add(elCtx.Ast() == null ? object : object.getInitialValue(0));
                        }
                    }
                }
                MemoryObject object = programBuilder.newMemoryObject(name,values.size() * archSize);
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
    public Object visitThreadDeclarator(ThreadDeclaratorContext ctx) {
        scope = currentThread = ctx.threadId().id;
        threadIds.add(currentThread);
        if (isOpenCL && ctx.threadScope() != null) {
            int sgID = 0; // Use subgroup ID 0 as default for OpenCL Litmus
            int wgID = ctx.threadScope().scopeID(0).id;
            int devID = ctx.threadScope().scopeID(1).id;
            programBuilder.newScopedThread(Arch.OPENCL, currentThread, devID, wgID, sgID);
        } else {
            programBuilder.newThread(currentThread);
        }
        scope = currentThread = -1;
        return null;
    }

    @Override
    public Object visitThreadContent(ThreadContentContext ctx) {
        visitThreadArguments(ctx.threadArguments());
        for(ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);
        return null;
    }

    @Override
    public Object visitThreadArguments(ThreadArgumentsContext ctx){
        if(ctx != null){
            for(ThreadArgumentContext threadArgumentContext : ctx.threadArgument()){
                threadArgumentContext.accept(this);
            }
        }
        return null;
    }

    @Override
    public Object visitThreadArgument(ThreadArgumentContext ctx) {
        // TODO: Possibly parse attributes/type modifiers (const, ...)
        //  For now, herd7 also seems to ignore most modifiers, in particular the atomic one.
        String name = ctx.varName().getText();
        MemoryObject object = programBuilder.getOrNewMemoryObject(name);
        Register register = programBuilder.getOrNewRegister(scope, name, archType);
        boolean atomicity = ctx.pointerTypeSpecifier().atomicTypeSpecifier() != null
                || ctx.pointerTypeSpecifier().basicTypeSpecifier().AtomicInt() != null;
        if (!atomicity) {
            object.addFeatureTag(C11.NON_ATOMIC_LOCATION);
        }
        if (isOpenCL) {
            if (ctx.pointerTypeSpecifier().openCLSpace() != null) {
                object.addFeatureTag(ctx.pointerTypeSpecifier().openCLSpace().space);
            } else {
                object.addFeatureTag(Tag.OpenCL.DEFAULT_SPACE);
            }
        }
        append(EventFactory.newLocal(register, object), ctx);
        return null;
    }

    @Override
    public Object visitIfExpression(IfExpressionContext ctx) {
        Expression expr = (Expression) ctx.re().accept(this);

        ifId++;
        Label elseL = programBuilder.getOrCreateLabel(currentThread,"else_" + ifId);
        Label endL = programBuilder.getOrCreateLabel(currentThread,"end_" + ifId);

        IfAsJump ifEvent = EventFactory.newIfJumpUnless(expressions.makeBooleanCast(expr), elseL, endL);
        append(ifEvent, ctx);

        for(ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);
        CondJump jumpToEnd = EventFactory.newGoto(endL);
        append(jumpToEnd, ctx);

        append(elseL, ctx);
        if(ctx.elseExpression() != null){
            ctx.elseExpression().accept(this);
        }
        append(endL, ctx);
        return null;
    }

	@Override
    public Object visitWhileExpression(WhileExpressionContext ctx) {
        whileId++;
        Label headL = programBuilder.getOrCreateLabel(currentThread,"head_" + whileId);
        Label endL = programBuilder.getOrCreateLabel(currentThread,"end_" + whileId);

        append(headL, ctx);
        Expression expr = (Expression) ctx.re().accept(this);

        append(EventFactory.newJumpUnless(expr, endL), ctx);

        for(ExpressionContext expressionContext : ctx.expression()) {
            expressionContext.accept(this);
        }

        append(EventFactory.newGoto(headL), ctx);
        append(endL, ctx);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (memory reads, must have register for return value)

    // Returns new value (the value after computation)
    @Override
    public Expression visitReAtomicOpReturn(ReAtomicOpReturnContext ctx){
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        append(event, ctx);
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public Expression visitReAtomicFetchOp(ReAtomicFetchOpContext ctx){
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitC11AtomicOp(C11AtomicOpContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newFetchOp(register, address, value, ctx.op, ctx.c11Mo().mo);
        addScopeTag(event, ctx.openCLScope());
        append(event, ctx);
        return register;
    }


    @Override
    public Expression visitReAtomicOpAndTest(ReAtomicOpAndTestContext ctx){
        Register register = getReturnRegister(true);
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWOpAndTest(getAddress(ctx.address), register, value, ctx.op);
        append(event, ctx);
        return register;
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public Expression visitReAtomicAddUnless(ReAtomicAddUnlessContext ctx){
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Expression cmp = (Expression) ctx.cmp.accept(this);
        append(EventFactory.Linux.newRMWAddUnless(getAddress(ctx.address), register, cmp, value), ctx);
        return register;
    }

    @Override
    public Expression visitReC11AtomicXchg(ReC11AtomicXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newExchange(register, address, value, Tag.C11.MO_SC);
        addScopeTag(event, null);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReC11AtomicXchgExplicit(ReC11AtomicXchgExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newExchange(register, address, value, ctx.c11Mo().mo);
        addScopeTag(event, ctx.openCLScope());
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReXchg(ReXchgContext ctx){
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Event event = EventFactory.Linux.newRMWExchange(getAddress(ctx.address), register, value, ctx.mo);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReC11SCmpXchgExplicit(ReC11SCmpXchgExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        String mo = ctx.c11Mo(0).mo;
        addCmpXchg(register, address, expectedAdd, value, mo, true, ctx.openCLScope(), ctx);
        return register;
    }

    @Override
    public Expression visitReC11SCmpXchg(ReC11SCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        addCmpXchg(register, address, expectedAdd, value, C11.DEFAULT_MO, true, null, ctx);
        return register;
    }

    @Override
    public Expression visitReC11WCmpXchgExplicit(ReC11WCmpXchgExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        String mo = ctx.c11Mo(0).mo;
        addCmpXchg(register, address, expectedAdd, value, mo, false, ctx.openCLScope(), ctx);
        return register;
    }

    @Override
    public Expression visitReC11WCmpXchg(ReC11WCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        addCmpXchg(register, address, expectedAdd, value, C11.DEFAULT_MO, false, null, ctx);
        return register;
    }

    private void addCmpXchg(Register register, Expression address, Expression expectedAddress, Expression value,
            String mo, boolean strong, OpenCLScopeContext scope, ParserRuleContext ctx) {
        final Event event = EventFactory.Atomic.newCompareExchange(register, address, expectedAddress, value, mo, strong);
        addScopeTag(event, scope);
        append(event, ctx);
    }

    @Override
    public Expression visitReCmpXchg(ReCmpXchgContext ctx){
        Register register = getReturnRegister(true);
        Expression cmp = (Expression)ctx.cmp.accept(this);
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Linux.newRMWCompareExchange(getAddress(ctx.address), register, cmp, value, ctx.mo);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReC11LoadExplicit(ReC11LoadExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newLoad(register, address, ctx.c11Mo().mo);
        addScopeTag(event, ctx.openCLScope());
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReC11Load(ReC11LoadContext ctx) {
        Register register = getReturnRegister(true);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newLoad(register, address, C11.DEFAULT_MO);
        addScopeTag(event, null);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReLoad(ReLoadContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.Linux.newLoad(register, getAddress(ctx.address), ctx.mo);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReReadOnce(ReReadOnceContext ctx){
        Register register = getReturnRegister(true);
        Event event = EventFactory.Linux.newLoad(register, getAddress(ctx.address), ctx.mo);
        append(event, ctx);
        return register;
    }

    @Override
    public Expression visitReReadNa(ReReadNaContext ctx){
        Register register = getReturnRegister(true);
        Expression address = getAddress(ctx.address);
        Load event = EventFactory.newLoadWithMo(register, address, C11.NONATOMIC);
        append(event, ctx);
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public Expression visitReOpCompare(ReOpCompareContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeIntCmp(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result, ctx);
    }

    @Override
    public Expression visitReOpArith(ReOpArithContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeIntBinary(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result, ctx);
    }

    @Override
    public Expression visitReOpBool(ReOpBoolContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        v1 = expressions.makeBooleanCast(v1);
        v2 = expressions.makeBooleanCast(v2);
        Expression result = expressions.makeBoolBinary(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result, ctx);
    }

    @Override
    public Expression visitReOpBoolNot(ReOpBoolNotContext ctx){
        Register register = getReturnRegister(false);
        Expression v = (Expression)ctx.re().accept(this);
        v = expressions.makeBooleanCast(v);
        Expression result = expressions.makeNot(v);
        return assignToReturnRegister(register, result, ctx);
    }

    @Override
    public Expression visitReBoolConst(ReBoolConstContext ctx){
        return expressions.makeValue(ctx.boolConst().value);
    }

    @Override
    public Expression visitReParenthesis(ReParenthesisContext ctx){
        return (Expression)ctx.re().accept(this);
    }

    @Override
    public Expression visitReCast(ReCastContext ctx){
        Register register = getReturnRegister(false);
        Expression result = (Expression)ctx.re().accept(this);
        return assignToReturnRegister(register, result, ctx);
    }

    @Override
    public Expression visitReVarName(ReVarNameContext ctx){
        Register register = getReturnRegister(false);
        Expression variable = visitVarName(ctx.varName());
        if (variable instanceof Register result) {
            return assignToReturnRegister(register, result, ctx);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Expression visitReConst(ReConstContext ctx){
        Register register = getReturnRegister(false);
        IntLiteral result = expressions.parseValue(ctx.getText(), archType);
        return assignToReturnRegister(register, result, ctx);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(NreAtomicOpContext ctx){
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Linux.newRMWOp(getAddress(ctx.address), value, ctx.op);
        return append(event, ctx);
    }

    @Override
    public Object visitNreC11AtomicOp(NreC11AtomicOpContext ctx){
        Expression value = returnExpressionOrOne(ctx.value);
        Event event = EventFactory.Atomic.newRMWOp(getAddress(ctx.address), value, ctx.op, ctx.c11Mo().mo);
        return append(event, ctx);
    }

    @Override
    public Object visitNreStore(NreStoreContext ctx){
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Linux.newStore(getAddress(ctx.address), value, ctx.mo);
        return append(event, ctx);
    }

    @Override
    public Object visitNreWriteOnce(NreWriteOnceContext ctx){
        Expression value = (Expression)ctx.value.accept(this);
        Event event = EventFactory.Linux.newStore(getAddress(ctx.address), value, ctx.mo);
        return append(event, ctx);
    }

    @Override
    public Object visitNreC11StoreExplicit(NreC11StoreExplicitContext ctx) {
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newStore(address, value, ctx.c11Mo().mo);
        addScopeTag(event, ctx.openCLScope());
        return append(event, ctx);
    }

    @Override
    public Object visitNreC11Store(NreC11StoreContext ctx) {
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newStore(address, value, C11.DEFAULT_MO);
        addScopeTag(event, null);
        return append(event, ctx);
    }

    @Override
    public Object visitNreAssignment(NreAssignmentContext ctx){
        Expression variable = (Expression)ctx.varName().accept(this);
        if(ctx.Ast() == null){
            if(variable instanceof Register reg){
                returnRegister = reg;
                ctx.re().accept(this);
                return null;
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        Expression value = (Expression)ctx.re().accept(this);
        if(variable instanceof MemoryObject || variable instanceof Register){
            Event event = EventFactory.newStoreWithMo(variable, value, C11.NONATOMIC);
            if (isOpenCL) {
                event.addTags(Tag.OpenCL.DEFAULT_WEAK_SCOPE);
            }
            return append(event, ctx);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(NreRegDeclarationContext ctx){
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
    public Object visitNreC11Fence(NreC11FenceContext ctx) {
        Event fence = EventFactory.Atomic.newFence(ctx.c11Mo().mo);
        return append(fence, ctx);
    }

    @Override
    public Object visitNreFence(NreFenceContext ctx){
        return append(EventFactory.Linux.newBarrier(ctx.name), ctx);
    }

    @Override
    public Object visitNreOpenCLFence(NreOpenCLFenceContext ctx){
        Event fence = EventFactory.Atomic.newFence(ctx.c11Mo().mo);
        if (ctx.openCLScope() != null) {
            fence.addTags(ctx.openCLScope().scope);
        }
        if (ctx.openCLFenceFlags() != null) {
            for (OpenCLFenceFlagContext flagCtx : ctx.openCLFenceFlags().openCLFenceFlag()) {
                fence.addTags(flagCtx.flag);
            }
        }
        return append(fence, ctx);
    }

    @Override
    public Object visitNreOpenCLBarrier(NreOpenCLBarrierContext ctx){
        List<String> flags = ctx.openCLFenceFlags().openCLFenceFlag().stream().map(f -> f.flag).toList();
        String barrierScope = ctx.openCLScope() != null ? ctx.openCLScope().scope : Tag.OpenCL.WORK_GROUP;
        String name = String.format("barrier(%s.%s)", ctx.openCLFenceFlags().getText(), barrierScope).toLowerCase();
        Event fence = EventFactory.newControlBarrier(name, ctx.barrierId().getText(), Tag.OpenCL.WORK_GROUP);
        fence.addTags(flags);
        if (!Tag.OpenCL.WORK_GROUP.equals(barrierScope)) {
            throw new ParsingException("Unsupported control barrier scope '%s'", barrierScope);
        }
        fence.addTags(barrierScope);
        return append(fence, ctx);
    }

    @Override
    public Object visitNreSpinLock(NreSpinLockContext ctx) {
        return append(EventFactory.Linux.newLock(getAddress(ctx.address)), ctx);
    }

    @Override
    public Object visitNreSpinUnlock(NreSpinUnlockContext ctx) {
        return append(EventFactory.Linux.newUnlock(getAddress(ctx.address)), ctx);
    }

    @Override
    public Object visitNreSrcuSync(NreSrcuSyncContext ctx) {
        return append(EventFactory.Linux.newSrcuSync(getAddress(ctx.address)), ctx);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public Expression visitVarName(VarNameContext ctx){
        if(scope > -1){
            Register register = programBuilder.getRegister(scope, ctx.getText());
            if(register != null){
                return register;
            }
            MemoryObject object = programBuilder.getMemoryObject(ctx.getText());
            if(object != null){
                register = programBuilder.getOrNewRegister(scope, null, archType);
                append(EventFactory.newLoadWithMo(register, object, C11.NONATOMIC), ctx);
                return register;
            }
            return programBuilder.getOrNewRegister(scope, ctx.getText(), archType);
        }
        MemoryObject object = programBuilder.newMemoryObject(ctx.getText(), archSize);
        Register register = programBuilder.getOrNewRegister(scope, null, archType);
        append(EventFactory.newLoadWithMo(register, object, C11.NONATOMIC), ctx);
        return register;
    }

    private Expression getAddress(ReContext ctx){
        Expression address = (Expression)ctx.accept(this);
        if(address.getType() instanceof IntegerType){
           return address;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    private Expression returnExpressionOrOne(ReContext ctx) {
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

    private Expression assignToReturnRegister(Register register, Expression value, ParserRuleContext ctx) {
        if (register != null) {
            Expression cast = expressions.makeCast(value, register.getType());
            append(EventFactory.newLocal(register, cast), ctx);
        }
        return value;
    }

    private void addScopeTag(Event event, OpenCLScopeContext ctx) {
        if (isOpenCL) {
            if (ctx != null) {
                event.addTags(ctx.scope);
            } else {
                event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
            }
        }
    }

    private Event append(Event event, ParserRuleContext ctx) {
        final int line = ctx.getStart().getLine();
        return programBuilder.addChild(currentThread, event, line);
    }
}
