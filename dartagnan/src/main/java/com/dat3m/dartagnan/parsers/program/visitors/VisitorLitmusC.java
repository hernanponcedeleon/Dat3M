package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.base.BinaryExpressionBase;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusCParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.ScopeHierarchy;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.event.lang.catomic.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;

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
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(LitmusCParser.GlobalDeclaratorLocationContext ctx) {
        if (ctx.initConstantValue() != null) {
            IntLiteral value = expressions.parseValue(ctx.initConstantValue().constant().getText(), archType);
            programBuilder.initLocEqConst(ctx.varName().getText(), value);
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        if (ctx.initConstantValue() != null) {
            // FIXME: We visit declarators before threads, so we need to create threads early
            programBuilder.getOrNewThread(ctx.threadId().id);
            IntLiteral value = expressions.parseValue(ctx.initConstantValue().constant().getText(), archType);
            programBuilder.initRegEqConst(ctx.threadId().id,ctx.varName().getText(), value);
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
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
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        // FIXME: We visit declarators before threads, so we need to create threads early
        programBuilder.getOrNewThread(ctx.threadId().id);
        if(ctx.Ast() == null){
            programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), archType);
        } else {
            String rightName = ctx.varName(1).getText();
            MemoryObject object = programBuilder.getMemoryObject(rightName);
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
            programBuilder.newMemoryObject(name,size);
            return null;
        }
        if(ctx.initArray() != null){
            if(size == null || ctx.initArray().arrayElement().size() == size){
                List<Expression> values = new ArrayList<>();
                for(LitmusCParser.ArrayElementContext elCtx : ctx.initArray().arrayElement()){
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
    public Object visitThread(LitmusCParser.ThreadContext ctx) {
        scope = currentThread = ctx.threadId().id;
        // Declarations in the preamble may have created the thread already
        programBuilder.getOrNewThread(currentThread);
        if (ctx.threadScope() != null) {
            ctx.threadScope().accept(this);
            this.isOpenCL = true;
        } else {
            // Set dummy scope hierarchy for CPU threads
            programBuilder.setThreadScopeHierarchy(currentThread,
                    ScopeHierarchy.ScopeHierarchyForOpenCL(-2, -2));
        }
        visitThreadArguments(ctx.threadArguments());

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);

        scope = currentThread = -1;
        return null;
    }

    @Override
    public Object visitOpenCLThreadScope(LitmusCParser.OpenCLThreadScopeContext ctx) {
        int wgID = ctx.scopeID(0).id;
        int devID = ctx.scopeID(1).id;
        ScopeHierarchy scopeHierarchy = ScopeHierarchy.ScopeHierarchyForOpenCL(devID, wgID);
        programBuilder.setThreadScopeHierarchy(currentThread, scopeHierarchy);
        return null;
    }

    @Override
    public Object visitThreadArguments(LitmusCParser.ThreadArgumentsContext ctx){
        if(ctx != null){
            for(LitmusCParser.ThreadArgumentContext threadArgumentContext : ctx.threadArgument()){
                threadArgumentContext.accept(this);
            }
        }
        return null;
    }

    @Override
    public Object visitThreadArgument(LitmusCParser.ThreadArgumentContext ctx) {
        // TODO: Possibly parse attributes/type modifiers (const, atomic, ...)
        //  For now, herd7 also seems to ignore most modifiers, in particular the atomic one.
        String name = ctx.varName().getText();
        MemoryObject object = programBuilder.getOrNewMemoryObject(name);
        Register register = programBuilder.getOrNewRegister(scope, name, archType);
        boolean atomicity = ctx.pointerTypeSpecifier().atomicTypeSpecifier() != null
                || ctx.pointerTypeSpecifier().basicTypeSpecifier().AtomicInt() != null;
        object.setIsAtomic(atomicity);
        if (this.isOpenCL) {
            if (ctx.openCLSpace() != null) {
                object.setMemorySpace(ctx.openCLSpace().space);
            } else {
                object.setMemorySpace(Tag.OpenCL.DEFAULT_GPU_SPACE);
            }
        } else {
            object.setMemorySpace(Tag.OpenCL.DEFAULT_CPU_SPACE);
        }
        programBuilder.setReg2LocMap(register, object);
        programBuilder.addChild(currentThread, EventFactory.newLocal(register, object));
        return null;
    }

    @Override
    public Object visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
        Expression expr = (Expression) ctx.re().accept(this);

        ifId++;
        Label elseL = programBuilder.getOrCreateLabel(currentThread,"else_" + ifId);
        Label endL = programBuilder.getOrCreateLabel(currentThread,"end_" + ifId);

        IfAsJump ifEvent = EventFactory.newIfJumpUnless(expressions.makeBooleanCast(expr), elseL, endL);
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

	@Override
    public Object visitWhileExpression(LitmusCParser.WhileExpressionContext ctx) {
        whileId++;
        Label headL = programBuilder.getOrCreateLabel(currentThread,"head_" + whileId);
        Label endL = programBuilder.getOrCreateLabel(currentThread,"end_" + whileId);

        programBuilder.addChild(currentThread, headL);
        Expression expr = (Expression) ctx.re().accept(this);

        programBuilder.addChild(currentThread, EventFactory.newJumpUnless(expr, endL));

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression()) {
            expressionContext.accept(this);
        }

        programBuilder.addChild(currentThread, EventFactory.newGoto(headL));
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
        Expression address = getAddress(ctx.address);
        Event event = EventFactory.Atomic.newFetchOp(register, address, value, ctx.op, ctx.c11Mo().mo);
        addOpenCLMemorySpaceTag(event, address);
        if (ctx.openCLScope() != null) {
            event.addTags(ctx.openCLScope().scope);
        } else {
            event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
        }
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
    public Expression visitReC11AtomicXchg(LitmusCParser.ReC11AtomicXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression) ctx.value.accept(this);
        Event event = EventFactory.Atomic.newExchange(register, getAddress(ctx.address), value, ctx.c11Mo().mo);
        programBuilder.addChild(currentThread, event);
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
    public Expression visitReC11SCmpXchgExplicit(LitmusCParser.ReC11SCmpXchgExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        String mo = ctx.c11Mo(0).mo;
        Event event = EventFactory.Atomic.newCompareExchange(register, address, expectedAdd, value, mo, true);
        addOpenCLMemorySpaceTag(event, address);
        if (ctx.openCLScope() != null) {
            event.addTags(ctx.openCLScope().scope);
        } else {
            event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
        }
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReC11SCmpXchg(LitmusCParser.ReC11SCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        Event event = EventFactory.Atomic.newCompareExchange(register, address, expectedAdd, value,
                Tag.OpenCL.DEFAULT_MO, true);
        addOpenCLMemorySpaceTag(event, address);
        event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReC11WCmpXchgExplicit(LitmusCParser.ReC11WCmpXchgExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        String mo = ctx.c11Mo(0).mo;
        Event event = EventFactory.Atomic.newCompareExchange(register, address, expectedAdd, value, mo, false);
        addOpenCLMemorySpaceTag(event, address);
        if (ctx.openCLScope() != null) {
            event.addTags(ctx.openCLScope().scope);
        } else {
            event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
        }
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public Expression visitReC11WCmpXchg(LitmusCParser.ReC11WCmpXchgContext ctx) {
        Register register = getReturnRegister(true);
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        Expression expectedAdd = getAddress(ctx.expectedAdd);
        Event event = EventFactory.Atomic.newCompareExchange(register, address, expectedAdd, value,
                Tag.OpenCL.DEFAULT_MO, false);
        addOpenCLMemorySpaceTag(event, address);
        event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
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

    @Override public Expression visitReC11LoadExplicit(LitmusCParser.ReC11LoadExplicitContext ctx) {
        Register register = getReturnRegister(true);
        Expression address = getAddress(ctx.address);
        AtomicLoad event = EventFactory.Atomic.newLoad(register, address, ctx.c11Mo().mo);
        addOpenCLMemorySpaceTag(event, address);
        if (ctx.openCLScope() != null) {
            event.addTags(ctx.openCLScope().scope);
        } else {
            event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
        }
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override public Expression visitReC11Load(LitmusCParser.ReC11LoadContext ctx) {
        Register register = getReturnRegister(true);
        Expression address = getAddress(ctx.address);
        AtomicLoad event = EventFactory.Atomic.newLoad(register, address, Tag.OpenCL.DEFAULT_MO);
        addOpenCLMemorySpaceTag(event, address);
        event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
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
        Expression address = getAddress(ctx.address);
        Load event = EventFactory.newLoadWithMo(register, address, C11.NONATOMIC);
        addOpenCLMemorySpaceTag(event, address);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public Expression visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeIntCmp(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        Expression result = expressions.makeIntBinary(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpBool(LitmusCParser.ReOpBoolContext ctx){
        Register register = getReturnRegister(false);
        Expression v1 = (Expression)ctx.re(0).accept(this);
        Expression v2 = (Expression)ctx.re(1).accept(this);
        v1 = expressions.makeBooleanCast(v1);
        v2 = expressions.makeBooleanCast(v2);
        Expression result = expressions.makeBoolBinary(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public Expression visitReOpBoolNot(LitmusCParser.ReOpBoolNotContext ctx){
        Register register = getReturnRegister(false);
        Expression v = (Expression)ctx.re().accept(this);
        v = expressions.makeBooleanCast(v);
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
        IntLiteral result = expressions.parseValue(ctx.getText(), archType);
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
    public Object visitNreC11StoreExplicit(LitmusCParser.NreC11StoreExplicitContext ctx) {
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        AtomicStore event = EventFactory.Atomic.newStore(address, value, ctx.c11Mo().mo);
        addOpenCLMemorySpaceTag(event, address);
        if (ctx.openCLScope() != null) {
            event.addTags(ctx.openCLScope().scope);
        } else {
            event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
        }
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreC11Store(LitmusCParser.NreC11StoreContext ctx) {
        Expression value = (Expression)ctx.value.accept(this);
        Expression address = getAddress(ctx.address);
        AtomicStore event = EventFactory.Atomic.newStore(address, value, Tag.OpenCL.DEFAULT_MO);
        addOpenCLMemorySpaceTag(event, address);
        event.addTags(Tag.OpenCL.DEFAULT_SCOPE);
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
            if (variable instanceof Register reg) {
                addOpenCLMemorySpaceTag(event, reg);
                event.addTags(Tag.OpenCL.DEFAULT_WEAK_SCOPE);
            }
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
        AtomicThreadFence fence = EventFactory.Atomic.newFence(ctx.c11Mo().mo);
        fence.addTags(Tag.OpenCL.DEFAULT_SCOPE, Tag.OpenCL.DEFAULT_CPU_SPACE);
        return programBuilder.addChild(currentThread, fence);
    }

    @Override
    public Object visitNreFence(LitmusCParser.NreFenceContext ctx){
        return programBuilder.addChild(currentThread, EventFactory.Linux.newLKMMFence(ctx.name));
    }

    @Override
    public Object visitNreOpenCLFence(LitmusCParser.NreOpenCLFenceContext ctx){
        AtomicThreadFence fence = EventFactory.Atomic.newFence(ctx.c11Mo().mo);
        if (ctx.openCLScope() != null) {
            fence.addTags(ctx.openCLScope().scope);
        }
        if (ctx.openCLFenceFlags() != null) {
            for (LitmusCParser.OpenCLFenceFlagContext flagCtx : ctx.openCLFenceFlags().openCLFenceFlag()) {
                fence.addTags(flagCtx.flag);
            }
        }
        return programBuilder.addChild(currentThread, fence);
    }

    @Override
    public Object visitNreOpenCLBarrier(LitmusCParser.NreOpenCLBarrierContext ctx){
        Expression barrierId = expressions.makeValue(ctx.barrierId().id, archType);
        List<String> flags = ctx.openCLFenceFlags().openCLFenceFlag().stream().map(f -> f.flag).toList();
        Event fence = EventFactory.newControlBarrier(ctx.getText().toLowerCase(), barrierId);
        fence.addTags(flags);
        if (ctx.openCLScope() != null) {
            fence.addTags(ctx.openCLScope().scope);
        }
        return programBuilder.addChild(currentThread, fence);
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
            MemoryObject object = programBuilder.getMemoryObject(ctx.getText());
            if(object != null){
                register = programBuilder.getOrNewRegister(scope, null, archType);
                programBuilder.addChild(currentThread, EventFactory.newLoadWithMo(register, object, C11.NONATOMIC));
                return register;
            }
            return programBuilder.getOrNewRegister(scope, ctx.getText(), archType);
        }
        MemoryObject object = programBuilder.newMemoryObject(ctx.getText(), archSize);
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

    private Expression assignToReturnRegister(Register register, Expression value) {
        if (register != null) {
            Expression cast = expressions.makeCast(value, register.getType());
            programBuilder.addChild(currentThread, EventFactory.newLocal(register, cast));
        }
        return value;
    }

    private void addOpenCLMemorySpaceTag(Event event, Expression address) {
        if (address instanceof Register reg) {
            MemoryObject object = programBuilder.getLocFromReg(reg);
            if (object != null) {
                event.addTags(object.getMemorySpace());
                if (!object.isAtomic()) {
                    event.addTags(Tag.OpenCL.NON_ATOMIC_LOCATION);
                }
            }
        } else if (address instanceof BinaryExpressionBase<?,?> binExpr) {
            // TODO: Convert memory space tags for binary expressions
            addOpenCLMemorySpaceTag(event, binExpr.getLeft());
            addOpenCLMemorySpaceTag(event, binExpr.getRight());
        }
    }
}
