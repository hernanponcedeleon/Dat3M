package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusPTXBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusPTXParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.RedOp;
import com.dat3m.dartagnan.program.event.arch.ptx.AtomOp;
import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;

import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

public class VisitorLitmusPTX extends LitmusPTXBaseVisitor<Object> {
    private final ProgramBuilder programBuilder;
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusPTX(ProgramBuilder pb) {
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusPTXParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        if (ctx.assertionList() != null) {
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssert(AssertionHelper.parseAssertionList(programBuilder, raw));
        }
        if (ctx.assertionFilter() != null) {
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
        programBuilder.initLocEqConst(ctx.location().getText(),
                (IConst) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPTXParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(),
                (IConst) ctx.constant().accept(this));
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
        if (ctx.proxyType().content.equals(Tag.PTX.GEN)) {
            programBuilder.initLocEqLocAliasGen(ctx.location(0).getText(),
                    ctx.location(1).getText());
        } else {
            programBuilder.initLocEqLocAliasProxy(ctx.location(0).getText(),
                    ctx.location(1).getText());
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions)
    @Override
    public Object visitThreadDeclaratorList(LitmusPTXParser.ThreadDeclaratorListContext ctx) {
        for (LitmusPTXParser.ThreadScopeContext threadScopeContext : ctx.threadScope()) {
            int ctaID = threadScopeContext.scopeID().ctaID().id;
            int gpuID = threadScopeContext.scopeID().gpuID().id;
            programBuilder.initScopedThread(threadScopeContext.threadId().id, ctaID, gpuID);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)
    @Override
    public Object visitConstant(LitmusPTXParser.ConstantContext ctx) {
        return new IValue(new BigInteger(ctx.getText()), getArchPrecision());
    }

    @Override
    public Object visitInstructionRow(LitmusPTXParser.InstructionRowContext ctx) {
        for (int i = 0; i < threadCount; i++) {
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitStoreConstant(LitmusPTXParser.StoreConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        String mo = ctx.mo().content;
        String scope;
        switch (mo) {
            case Tag.PTX.WEAK:
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
                }
                scope = Tag.PTX.SYS;
                break;
            case Tag.PTX.REL:
            case Tag.PTX.RLX:
                scope = ctx.scope().content;
                break;
            default:
                throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        Store store = EventFactory.newStore(object, constant, mo);
        store.addFilters(scope);
        store.addFilters(ctx.store().storeProxy);
        store.addFilters(Tag.PTX.CON);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitStoreRegister(LitmusPTXParser.StoreRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        String mo = ctx.mo().content;
        String scope;
        switch (mo) {
            case Tag.PTX.WEAK:
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
                }
                scope = Tag.PTX.SYS;
                break;
            case Tag.PTX.REL:
            case Tag.PTX.RLX:
                scope = ctx.scope().content;
                break;
            default:
                throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        Store store = EventFactory.newStore(object, register, mo);
        store.addFilters(scope);
        store.addFilters(ctx.store().storeProxy);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitLocalConstant(LitmusPTXParser.LocalConstantContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        IConst constant = (IConst) ctx.constant().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadLocation(LitmusPTXParser.LoadLocationContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        MemoryObject location = programBuilder.getOrNewObject(ctx.location().getText());
        String mo = ctx.mo().content;
        String scope;
        switch (mo) {
            case Tag.PTX.WEAK:
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
                }
                scope = Tag.PTX.SYS;
                break;
            case Tag.PTX.ACQ:
            case Tag.PTX.RLX:
                scope = ctx.scope().content;
                break;
            default:
                throw new ParsingException("Load instruction doesn't support mo: " + mo);
        }
        Load load = EventFactory.newLoad(register, location, mo);
        load.addFilters(scope);
        load.addFilters(ctx.load().loadProxy);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitAtomConstant(LitmusPTXParser.AtomConstantContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        IOpBin op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope;
        if (mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        AtomOp atom = EventFactory.PTX.newTaggedAtomOp(object, register_destination, constant, op, mo, scope);
        atom.addFilters(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override
    public Object visitAtomRegister(LitmusPTXParser.AtomRegisterContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(0).getText(), getArchPrecision());
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(1).getText(), getArchPrecision());
        IOpBin op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope;
        if (mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        AtomOp atom = EventFactory.PTX.newTaggedAtomOp(object, register_destination, register_operand, op, mo, scope);
        atom.addFilters(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override
    public Object visitRedConstant(LitmusPTXParser.RedConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        IOpBin op = ctx.operation().op;
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, getArchPrecision());
        String mo = ctx.mo().content;
        String scope;
        if (mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Red instruction doesn't support mo: " + mo);
        }
        RedOp red = EventFactory.PTX.newTaggedRedOp(object, register_destination, constant, op, mo, scope);
        red.addFilters(ctx.red().redProxy);
        return programBuilder.addChild(mainThread, red);
    }

    @Override
    public Object visitRedRegister(LitmusPTXParser.RedRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        IOpBin op = ctx.operation().op;
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, getArchPrecision());
        String mo = ctx.mo().content;
        String scope;
        if (mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Red instruction doesn't support mo: " + mo);
        }
        RedOp red = EventFactory.PTX.newTaggedRedOp(object, register_destination, register_operand, op, mo, scope);
        red.addFilters(ctx.red().redProxy);
        return programBuilder.addChild(mainThread, red);
    }

    @Override
    public Object visitFencePhysic(LitmusPTXParser.FencePhysicContext ctx) {
        String mo = ctx.mo().content;
        String scope;
        if (mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.SC)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Fence instruction doesn't support mo: " + mo);
        }
        Fence fence = EventFactory.newFence(ctx.getText().toLowerCase());
        fence.addFilters(mo);
        fence.addFilters(scope);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitFenceProxy(LitmusPTXParser.FenceProxyContext ctx) {
        Fence fence = EventFactory.newFence(ctx.getText().toLowerCase());
        fence.addFilters(ctx.proxyType().content);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitFenceAlias(LitmusPTXParser.FenceAliasContext ctx) {
        Fence fence = EventFactory.newFence(ctx.getText().toLowerCase());
        fence.addFilters(Tag.PTX.GEN);
        fence.addFilters(Tag.PTX.ALIAS);
        return programBuilder.addChild(mainThread, fence);
    }
}