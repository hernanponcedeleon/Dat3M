package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusPTXBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusPTXParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomCAS;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomExch;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;

public class VisitorLitmusPTX extends LitmusPTXBaseVisitor<Object> {
    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.PTX);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType archType = types.getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusPTX() {
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusPTXParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list
    @Override
    public Object visitVariableDeclaratorLocation(LitmusPTXParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initVirLocEqCon(ctx.location().getText(),
                (IntLiteral) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPTXParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(),
                (IntLiteral) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPTXParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(),
                archType);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusPTXParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initVirLocEqLoc(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Proxy declarator list
    @Override
    public Object visitVariableDeclaratorProxy(LitmusPTXParser.VariableDeclaratorProxyContext ctx) {
        if (ctx.proxyType().content.equals(Tag.PTX.GEN)) {
            programBuilder.initVirLocEqLocAliasGen(ctx.location(0).getText(),
                    ctx.location(1).getText());
        } else {
            programBuilder.initVirLocEqLocAliasProxy(ctx.location(0).getText(),
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
            // NB: the order of scopeIDs is important
            programBuilder.newScopedThread(Arch.PTX, threadScopeContext.threadId().id, gpuID, ctaID);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)
    @Override
    public Object visitConstant(LitmusPTXParser.ConstantContext ctx) {
        return ExpressionFactory.getInstance().parseValue(ctx.getText(), archType);
    }

    @Override
    public Object visitRegister(LitmusPTXParser.RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
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
    public Object visitStoreInstruction(LitmusPTXParser.StoreInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression constant = (Expression) ctx.value().accept(this);
        String mo = ctx.mo().content;
        Store store = EventFactory.newStoreWithMo(object, constant, mo);
        switch (mo) {
            case Tag.PTX.WEAK -> {
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
                }
            }
            case Tag.PTX.REL, Tag.PTX.RLX -> store.addTags(ctx.scope().content);
            default -> throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        store.addTags(ctx.store().storeProxy);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitLocalValue(LitmusPTXParser.LocalValueContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        Expression value = (Expression) ctx.value().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, value));
    }

    @Override
    public Object visitLocalAdd(LitmusPTXParser.LocalAddContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeAdd(lhs, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalSub(LitmusPTXParser.LocalSubContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeSub(lhs, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalMul(LitmusPTXParser.LocalMulContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeMul(lhs, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalDiv(LitmusPTXParser.LocalDivContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeDiv(lhs, rhs, true);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLoadLocation(LitmusPTXParser.LoadLocationContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        String mo = ctx.mo().content;
        Load load = EventFactory.newLoadWithMo(register, location, mo);
        switch (mo) {
            case Tag.PTX.WEAK -> {
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
                }
            }
            case Tag.PTX.ACQ, Tag.PTX.RLX -> load.addTags(ctx.scope().content);
            default -> throw new ParsingException("Load instruction doesn't support mo: " + mo);
        }
        load.addTags(ctx.load().loadProxy);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitAtomOp(LitmusPTXParser.AtomOpContext ctx) {
        Register register_destination = (Register) ctx.register().accept(this);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        IntBinaryOp op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        PTXAtomOp atom = EventFactory.PTX.newAtomOp(object, register_destination, value, op, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override
    public Object visitAtomCAS(LitmusPTXParser.AtomCASContext ctx) {
        Register register_destination = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression expected = (Expression) ctx.value(0).accept(this);
        Expression value = (Expression) ctx.value(1).accept(this);
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        PTXAtomCAS atom = EventFactory.PTX.newAtomCAS(object, register_destination, expected, value, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override 
    public Object visitAtomExchange(LitmusPTXParser.AtomExchangeContext ctx) {
        Register register_destination = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        PTXAtomExch atom = EventFactory.PTX.newAtomExch(object, register_destination, value, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override
    public Object visitRedInstruction(LitmusPTXParser.RedInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        IntBinaryOp op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Red instruction doesn't support mo: " + mo);
        }
        PTXRedOp red = EventFactory.PTX.newRedOp(object, value, op, mo, scope);
        red.addTags(ctx.red().redProxy);
        return programBuilder.addChild(mainThread, red);
    }

    @Override
    public Object visitFencePhysic(LitmusPTXParser.FencePhysicContext ctx) {
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.SC))) {
            throw new ParsingException("Fence instruction doesn't support mo: " + mo);
        }
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        fence.addTags(mo, scope, Tag.PTX.GEN);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitFenceProxy(LitmusPTXParser.FenceProxyContext ctx) {
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        fence.addTags(ctx.proxyType().content);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitFenceAlias(LitmusPTXParser.FenceAliasContext ctx) {
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        fence.addTags(Tag.PTX.ALIAS);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitBarrier(LitmusPTXParser.BarrierContext ctx) {
        Expression barrierId = (Expression) ctx.value().accept(this);
        Event barrier = EventFactory.newControlBarrier(ctx.getText().toLowerCase(), barrierId);
        if(ctx.barrierMode().Arrive() != null) {
            barrier.addTags(Tag.PTX.ARRIVE);
        }
        return programBuilder.addChild(mainThread, barrier);
    }

    @Override
    public Object visitLabel(LitmusPTXParser.LabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
    }

    @Override
    public Object visitBranchCond(LitmusPTXParser.BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression expr = expressions.makeIntCmp(lhs, ctx.cond().op, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitJump(LitmusPTXParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        return programBuilder.addChild(mainThread, EventFactory.newGoto(label));
    }

}