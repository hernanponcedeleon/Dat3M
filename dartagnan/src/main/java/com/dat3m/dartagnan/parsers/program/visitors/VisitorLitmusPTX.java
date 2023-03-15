package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;

public class VisitorLitmusPTX
        extends LitmusPTXBaseVisitor<Object> {
    private final ProgramBuilder programBuilder;
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusPTX(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusPTXParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
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
    // Variable declarator list
    @Override
    public Object visitVariableDeclaratorLocation(LitmusPTXParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initLocEqConst(ctx.location().getText(), new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPTXParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPTXParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), getArchPrecision());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusPTXParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Proxy declarator list
    @Override
    public Object visitVariableDeclaratorProxy(LitmusPTXParser.VariableDeclaratorProxyContext ctx) {
        programBuilder.initAliasProxy(ctx.location(0).getText(), ctx.location(1).getText(), ctx.proxyType().content);
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions)
    @Override
    public Object visitThreadDeclaratorList(LitmusPTXParser.ThreadDeclaratorListContext ctx) {
        for(LitmusPTXParser.ThreadScopeContext threadScopeContext : ctx.threadScope()){
            int ctaID = threadScopeContext.scopeID().ctaID().id;
            int gpuID = threadScopeContext.scopeID().gpuID().id;
            programBuilder.initScopedThread(threadScopeContext.threadId().id, ctaID, gpuID);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)
    @Override public Object visitConstant(LitmusPTXParser.ConstantContext ctx) {
        return new IValue(new BigInteger(ctx.getText()),-1);
    }

    @Override
    public Object visitInstructionRow(LitmusPTXParser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitStoreConstant(LitmusPTXParser.StoreConstantContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Store instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread, EventFactory.PTX.newTaggedStore(object, constant, sem, scope));
    }

    public Object visitStoreRegister(LitmusPTXParser.StoreRegisterContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Store instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread, EventFactory.PTX.newTaggedStore(object, register, sem, scope));
    }

    @Override
    public Object visitLoadConstant(LitmusPTXParser.LoadConstantContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.ACQ) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Load instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadLocation(LitmusPTXParser.LoadLocationContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        MemoryObject location = programBuilder.getOrNewObject(ctx.location().getText());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.ACQ) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Load instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedLoad(register, location, sem, scope));
    }

    @Override
    public Object visitAtomConstant(LitmusPTXParser.AtomConstantContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Atom instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedAtomOp(object, register_destination, constant, op, sem, scope));
    }

    @Override
    public Object visitAtomRegister(LitmusPTXParser.AtomRegisterContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(0).getText(), getArchPrecision());
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(1).getText(), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Atom instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedAtomOp(object, register_destination, register_operand, op, sem, scope));
    }

    @Override
    public Object visitRedConstant(LitmusPTXParser.RedConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Red instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedRedOp(object, register_destination, constant, op, sem, scope));
    }

    @Override
    public Object visitRedRegister(LitmusPTXParser.RedRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Red instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedRedOp(object, register_destination, register_operand, op, sem, scope));
    }

    @Override
    public Object visitFencePhysic(LitmusPTXParser.FencePhysicContext ctx){
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.SC)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Fence instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedFence(sem, scope));
    }
}