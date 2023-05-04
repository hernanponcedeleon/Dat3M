package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusRISCVParser.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

public class VisitorLitmusRISCV extends LitmusRISCVBaseVisitor<Object> {

    private final Program program = new Program(Program.SourceLanguage.LITMUS);
    private final int archPrecision = getArchPrecision();
    private Thread[] threadList;
    private Thread thread;
    private final Map<String, Label> labelMap = new HashMap<>();

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        program.setArch(Arch.RISCV);
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
    // Variable declarator list

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
        Register register = thread.getOrNewRegister(ctx.register().getText(), archPrecision);
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.register().getText(), archPrecision);
        MemoryObject value = program.getMemory().getObject(ctx.location().getText()).orElseThrow();
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location(0).getText());
        MemoryObject value = program.getMemory().getObject(ctx.location(1).getText()).orElseThrow();
        object.setInitialValue(0, value.getInitialValue(0));
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
    public Object visitLi(LiContext ctx) {
        Register register = thread.getOrNewRegister(ctx.register().getText(), archPrecision);
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitXor(XorContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        Register right = thread.getRegister(ctx.register(2).getText()).orElseThrow();
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.XOR, right)));
        return null;
    }

    @Override
    public Object visitAnd(AndContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        Register right = thread.getRegister(ctx.register(2).getText()).orElseThrow();
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.AND, right)));
        return null;
    }

    @Override
    public Object visitOr(OrContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        Register right = thread.getRegister(ctx.register(2).getText()).orElseThrow();
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.OR, right)));
        return null;
    }

    @Override
    public Object visitAdd(AddContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        Register right = thread.getRegister(ctx.register(2).getText()).orElseThrow();
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.PLUS, right)));
        return null;
    }

    @Override
    public Object visitXori(XoriContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.XOR, value)));
        return null;
    }

    @Override
    public Object visitAndi(AndiContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.AND, value)));
        return null;
    }

    @Override
    public Object visitOri(OriContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        // Why not require that this register is already defined?
        Register left = thread.getOrNewRegister(ctx.register(1).getText(), archPrecision);
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.OR, value)));
        return null;
    }

    @Override
    public Object visitAddi(AddiContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        // Why not require that this register is already defined?
        Register left = thread.getOrNewRegister(ctx.register(1).getText(), archPrecision);
        IValue value = new IValue(new BigInteger(ctx.constant().getText()), archPrecision);
        thread.append(EventFactory.newLocal(result, new IExprBin(left, IOpBin.PLUS, value)));
        return null;
    }

    @Override
    public Object visitLw(LwContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register address = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newLoad(result, address, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
        return null;
    }

    @Override
    public Object visitSw(SwContext ctx) {
        Register value = thread.getRegister(ctx.register(0).getText()).orElseThrow();
        Register address = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newStore(address, value, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
        return null;
    }

    @Override
    public Object visitLr(LrContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register address = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newRMWLoadExclusive(result, address, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
        return null;
    }

    @Override
    public Object visitSc(ScContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register value = thread.getOrNewRegister(ctx.register(1).getText(), archPrecision);
        Register address = thread.getRegister(ctx.register(2).getText()).orElseThrow();
        thread.append(EventFactory.Common.newExclusiveStore(result, address, value, getMo(ctx.moRISCV(0), ctx.moRISCV(1))));
        return null;
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        Label label = labelMap.computeIfAbsent(ctx.Label().getText(), EventFactory::newLabel);
        thread.append(label);
        return null;
    }

    @Override
    public Object visitBranchCond(BranchCondContext ctx) {
        Label label = labelMap.computeIfAbsent(ctx.Label().getText(), EventFactory::newLabel);
        Register left = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register right = thread.getOrNewRegister(ctx.register(1).getText(), archPrecision);
        Atom expr = new Atom(left, ctx.cond().op, right);
        thread.append(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        thread.append(EventFactory.newFence("Fence." + ctx.fenceMode().mode));
        return null;
    }

    @Override
    public Object visitAmoadd(AmoaddContext ctx) {
        throw new ParsingException("No support for amoadd instructions");
    }

    @Override
    public Object visitAmoor(AmoorContext ctx) {
        throw new ParsingException("No support for amoor instructions");
    }

    @Override
    public Object visitAmoswap(AmoswapContext ctx) {
        throw new ParsingException("No support for amoswap instructions");
    }

    // =======================================
    // ================ Utils ================
    // =======================================

    private String getMo(MoRISCVContext mo1, MoRISCVContext mo2) {
        String moR = mo1 != null ? mo1.mo : "";
        String moW = mo2 != null ? mo2.mo : "";
        return !moR.isEmpty() ? (!moW.isEmpty() ? Tag.RISCV.MO_ACQ_REL : moR) : moW;
    }
}
