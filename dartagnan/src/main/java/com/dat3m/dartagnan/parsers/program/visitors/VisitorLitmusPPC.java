package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusPPCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusPPCParser.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Cmp;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.expression.Expression;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.misc.Interval;

import java.util.HashMap;
import java.util.Map;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;
import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.*;

public class VisitorLitmusPPC extends LitmusPPCBaseVisitor<Object> {

    private final static ImmutableSet<String> fences = ImmutableSet.of(SYNC, LWSYNC, ISYNC);

    private final Program program = new Program(Program.SourceLanguage.LITMUS);
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final int archPrecision = getArchPrecision();
    private Thread[] threadList;
    private Thread thread;
    private final Map<String, Label> labelMap = new HashMap<>();

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        program.setArch(Arch.POWER);
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
        IValue value = expressions.parseValue(ctx.constant().getText(), archPrecision);
        object.setInitialValue(0, value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.register().getText(), archPrecision);
        IValue value = expressions.parseValue(ctx.constant().getText(), archPrecision);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.register().getText(), archPrecision);
        MemoryObject value = program.getMemory().getOrNewObject(ctx.location().getText());
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location(0).getText());
        MemoryObject value = program.getMemory().getOrNewObject(ctx.location(1).getText());
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
    public Object visitLi(LiContext ctx) {
        Register register = thread.getOrNewRegister(ctx.register().getText(), archPrecision);
        IValue value = expressions.parseValue(ctx.constant().getText(), archPrecision);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitLwz(LwzContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register address = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newLoad(result, address, "_rx"));
        return null;
    }

    @Override
    public Object visitLwzx(LwzxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("lwzx is not implemented");
    }

    @Override
    public Object visitStw(StwContext ctx) {
        Register value = thread.getRegister(ctx.register(0).getText()).orElseThrow();
        Register address = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newStore(address, value, "_rx"));
        return null;
    }

    @Override
    public Object visitStwx(StwxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("stwx is not implemented");
    }

    @Override
    public Object visitMr(MrContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register value = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newLocal(result, value));
        return null;
    }

    @Override
    public Object visitAddi(AddiContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        IValue right = expressions.parseValue(ctx.constant().getText(), archPrecision);
        thread.append(EventFactory.newLocal(result, expressions.makeBinary(left, IOpBin.PLUS, right)));
        return null;
    }

    @Override
    public Object visitXor(XorContext ctx) {
        Register result = thread.getOrNewRegister(ctx.register(0).getText(), archPrecision);
        Register left = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        Register right = thread.getRegister(ctx.register(2).getText()).orElseThrow();
        thread.append(EventFactory.newLocal(result, expressions.makeBinary(left, IOpBin.XOR, right)));
        return null;
    }

    @Override
    public Object visitCmpw(CmpwContext ctx) {
        Register left = thread.getRegister(ctx.register(0).getText()).orElseThrow();
        Register right = thread.getRegister(ctx.register(1).getText()).orElseThrow();
        thread.append(EventFactory.newCompare(left, right));
        return null;
    }

    @Override
    public Object visitBranchCond(BranchCondContext ctx) {
        Label label = labelMap.computeIfAbsent(ctx.Label().getText(), EventFactory::newLabel);
        Event lastEvent = thread.getExit();
        if (!(lastEvent instanceof Cmp)) {
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }
        Cmp cmp = (Cmp) lastEvent;
        Expression expr = expressions.makeBinary(cmp.getLeft(), ctx.cond().op, cmp.getRight());
        thread.append(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        Label label = labelMap.computeIfAbsent(ctx.Label().getText(), EventFactory::newLabel);
        thread.append(label);
        return null;
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        String name = ctx.getText().toLowerCase();
        if (!fences.contains(name)) {
            throw new ParsingException("Unrecognised fence " + name);
        }
        thread.append(EventFactory.newFence(name));
        return null;
    }
}
