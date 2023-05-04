package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Cmp;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

public class VisitorLitmusAArch64 extends LitmusAArch64BaseVisitor<Object> {

    private final Program program = new Program(Program.SourceLanguage.LITMUS);
    private final int archPrecision = getArchPrecision();
    private Thread[] threadList;
    private Thread thread;
    private final Map<String, Label> labelMap = new HashMap<>();

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        program.setArch(Arch.ARM8);
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
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
        for (Thread thread : threadList) {
            thread.append(labelMap.computeIfAbsent(thread.getEndLabelName(), EventFactory::newLabel));
        }
        EventIdReassignment.newInstance().run(program);
        program.getEvents().forEach(e -> e.setOId(e.getGlobalId()));
        return program;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        object.setInitialValue(0, value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.register64().id, archPrecision);
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.register64().id, archPrecision);
        MemoryObject value = program.getMemory().getObject(ctx.location().getText()).orElseThrow();
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location(0).getText());
        MemoryObject value = program.getMemory().getObject(ctx.location(1).getText()).orElseThrow();
        object.setInitialValue(0, value);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
        threadList = new Thread[ctx.threadId().size()];
        for (int i = 0; i < threadList.length; i++) {
            threadList[i] = program.getOrNewThread(Integer.toString(ctx.threadId(i).id));
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(InstructionRowContext ctx) {
        for (int i = 0; i < threadList.length; i++) {
            thread = threadList[i];
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitMov(MovContext ctx) {
        Register register = thread.getOrNewRegister(ctx.rD, archPrecision);
        IExpr expr = ctx.expr32() != null ? (IExpr) ctx.expr32().accept(this) : (IExpr) ctx.expr64().accept(this);
        thread.append(EventFactory.newLocal(register, expr));
        return null;
    }

    @Override
    public Object visitCmp(CmpContext ctx) {
        Register register = thread.getOrNewRegister(ctx.rD, archPrecision);
        IExpr expr = ctx.expr32() != null ? (IExpr) ctx.expr32().accept(this) : (IExpr) ctx.expr64().accept(this);
        thread.append(EventFactory.newCompare(register, expr));
        return null;
    }

    @Override
    public Object visitArithmetic(ArithmeticContext ctx) {
        Register rD = thread.getOrNewRegister(ctx.rD, archPrecision);
        Register r1 = thread.getRegister(ctx.rV).orElseThrow();
        IExpr expr = ctx.expr32() != null ? (IExpr) ctx.expr32().accept(this) : (IExpr) ctx.expr64().accept(this);
        thread.append(EventFactory.newLocal(rD, new IExprBin(r1, ctx.arithmeticInstruction().op, expr)));
        return null;
    }

    @Override
    public Object visitLoad(LoadContext ctx) {
        Register register = thread.getOrNewRegister(ctx.rD, archPrecision);
        Register address = thread.getRegister(ctx.address().id).orElseThrow();
        if (ctx.offset() != null) {
            address = visitOffset(ctx.offset(), address);
        }
        thread.append(EventFactory.newLoad(register, address, ctx.loadInstruction().mo));
        return null;
    }

    @Override
    public Object visitLoadExclusive(LoadExclusiveContext ctx) {
        Register register = thread.getOrNewRegister(ctx.rD, archPrecision);
        Register address = thread.getRegister(ctx.address().id).orElseThrow();
        if (ctx.offset() != null) {
            address = visitOffset(ctx.offset(), address);
        }
        thread.append(EventFactory.newRMWLoadExclusive(register, address, ctx.loadExclusiveInstruction().mo));
        return null;
    }

    @Override
    public Object visitStore(StoreContext ctx) {
        Register register = thread.getOrNewRegister(ctx.rV, archPrecision);
        Register address = thread.getRegister(ctx.address().id).orElseThrow();
        if (ctx.offset() != null) {
            address = visitOffset(ctx.offset(), address);
        }
        thread.append(EventFactory.newStore(address, register, ctx.storeInstruction().mo));
        return null;
    }

    @Override
    public Object visitStoreExclusive(StoreExclusiveContext ctx) {
        Register register = thread.getOrNewRegister(ctx.rV, archPrecision);
        Register statusReg = thread.getOrNewRegister(ctx.rS, archPrecision);
        Register address = thread.getRegister(ctx.address().id).orElseThrow();
        if (ctx.offset() != null) {
            address = visitOffset(ctx.offset(), address);
        }
        thread.append(EventFactory.Common.newExclusiveStore(statusReg, address, register, ctx.storeExclusiveInstruction().mo));
        return null;
    }

    @Override
    public Object visitBranch(BranchContext ctx) {
        Label label = labelMap.computeIfAbsent(ctx.label().getText(), EventFactory::newLabel);
        if (ctx.branchCondition() == null) {
            thread.append(EventFactory.newGoto(label));
            return null;
        }
        Event lastEvent = thread.getExit();
        if (!(lastEvent instanceof Cmp)) {
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }
        Cmp cmp = (Cmp) lastEvent;
        Atom expr = new Atom(cmp.getLeft(), ctx.branchCondition().op, cmp.getRight());
        thread.append(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchRegister(BranchRegisterContext ctx) {
        Register register = thread.getRegister(ctx.rV).orElseThrow();
        Atom expr = new Atom(register, ctx.branchRegInstruction().op, IValue.ZERO);
        Label label = labelMap.computeIfAbsent(ctx.label().getText(), EventFactory::newLabel);
        thread.append(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchLabel(BranchLabelContext ctx) {
        Label label = labelMap.computeIfAbsent(ctx.label().getText(), EventFactory::newLabel);
        thread.append(label);
        return null;
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        thread.append(EventFactory.newFenceOpt(ctx.Fence().getText(), ctx.opt));
        return null;
    }

    @Override
    public IExpr visitExpressionRegister64(ExpressionRegister64Context ctx) {
        IExpr expr = thread.getOrNewRegister(ctx.register64().id, archPrecision);
        if (ctx.shift() != null) {
            IValue val = new IValue(new BigInteger(ctx.shift().immediate().constant().getText()), archPrecision);
            expr = new IExprBin(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public IExpr visitExpressionRegister32(ExpressionRegister32Context ctx) {
        IExpr expr = thread.getOrNewRegister(ctx.register32().id, archPrecision);
        if (ctx.shift() != null) {
            IValue val = new IValue(new BigInteger(ctx.shift().immediate().constant().getText()), archPrecision);
            expr = new IExprBin(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public IExpr visitExpressionImmediate(ExpressionImmediateContext ctx) {
        IExpr expr = new IValue(new BigInteger(ctx.immediate().constant().getText()), archPrecision);
        if (ctx.shift() != null) {
            IValue val = new IValue(new BigInteger(ctx.shift().immediate().constant().getText()), archPrecision);
            expr = new IExprBin(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public IExpr visitExpressionConversion(ExpressionConversionContext ctx) {
        // TODO: Implement when adding support for mixed-size accesses
        return thread.getOrNewRegister(ctx.register32().id, archPrecision);
    }

    private Register visitOffset(OffsetContext ctx, Register register) {
        Register result = thread.newRegister(archPrecision);
        IExpr expr = ctx.immediate() == null
                ? thread.getRegister(ctx.expressionConversion().register32().id).orElseThrow()
                : new IValue(new BigInteger(ctx.immediate().constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(result, new IExprBin(register, IOpBin.PLUS, expr)));
        return result;
    }
}
