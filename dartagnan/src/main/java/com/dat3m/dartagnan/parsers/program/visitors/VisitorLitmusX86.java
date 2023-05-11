package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.parsers.LitmusX86BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusX86Parser.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.expression.ExpressionFactory;
import com.dat3m.dartagnan.program.expression.type.Type;
import com.dat3m.dartagnan.program.expression.type.TypeFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.EventIdReassignment;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.misc.Interval;

import static com.dat3m.dartagnan.wmm.relation.RelationNameRepository.MFENCE;

public class VisitorLitmusX86 extends LitmusX86BaseVisitor<Object> {

    private final static ImmutableSet<String> fences = ImmutableSet.of(MFENCE);

    private final Program program = new Program(Program.SourceLanguage.LITMUS);
    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Type type = types.getPointerType();
    private Thread[] threadList;
    private Thread thread;

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        program.setArch(Arch.TSO);
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
            thread.append(EventFactory.newLabel(thread.getEndLabelName()));
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
        IValue value = expressions.parseValue(ctx.constant().getText(), type);
        object.setInitialValue(0, value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        Thread thread = program.getOrNewThread(Integer.toString(ctx.threadId().id));
        Register register = thread.getOrNewRegister(ctx.register().getText(), type);
        IValue value = expressions.parseValue(ctx.constant().getText(), type);
        thread.append(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        Register register = thread.getOrNewRegister(ctx.register().getText(), type);
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
        thread.append(EventFactory.newLocal(register, object.getInitialValue(0)));
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
            int id = ctx.threadId(i).id;
            threadList[i] = program.newThread(Integer.toString(id));
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
    public Object visitLoadValueToRegister(LoadValueToRegisterContext ctx) {
        Register register = thread.getOrNewRegister(ctx.register().getText(), type);
        IValue constant = expressions.parseValue(ctx.constant().getText(), type);
        thread.append(EventFactory.newLocal(register, constant));
        return null;
    }

    @Override
    public Object visitLoadLocationToRegister(LoadLocationToRegisterContext ctx) {
        Register register = thread.getOrNewRegister(ctx.register().getText(), type);
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
        thread.append(EventFactory.newLoad(register, object, "_rx"));
        return null;
    }

    @Override
    public Object visitStoreValueToLocation(StoreValueToLocationContext ctx) {
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
        IValue constant = expressions.parseValue(ctx.constant().getText(), type);
        thread.append(EventFactory.newStore(object, constant, "_rx"));
        return null;
    }

    @Override
    public Object visitStoreRegisterToLocation(StoreRegisterToLocationContext ctx) {
        String name = ctx.register().getText();
        Register register = thread.getRegister(name).orElseThrow();
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
        thread.append(EventFactory.newStore(object, register, "_rx"));
        return null;
    }

    @Override
    public Object visitExchangeRegisterLocation(ExchangeRegisterLocationContext ctx) {
        Register register = thread.getRegister(ctx.register().getText()).orElseThrow();
        MemoryObject object = program.getMemory().getOrNewObject(ctx.location().getText());
        thread.append(EventFactory.X86.newExchange(object, register));
        return null;
    }

    @Override
    public Object visitIncrementLocation(IncrementLocationContext ctx) {
        // TODO: Implementation
        throw new ParsingException("INC is not implemented");
    }

    @Override
    public Object visitCompareRegisterValue(CompareRegisterValueContext ctx) {
        // TODO: Implementation
        throw new ParsingException("CMP is not implemented");
    }

    @Override
    public Object visitCompareLocationValue(CompareLocationValueContext ctx) {
        // TODO: Implementation
        throw new ParsingException("CMP is not implemented");
    }

    @Override
    public Object visitAddRegisterRegister(AddRegisterRegisterContext ctx) {
        // TODO: Implementation
        throw new ParsingException("ADD is not implemented");
    }

    @Override
    public Object visitAddRegisterValue(AddRegisterValueContext ctx) {
        // TODO: Implementation
        throw new ParsingException("ADD is not implemented");
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