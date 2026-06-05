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
import com.dat3m.dartagnan.parsers.LitmusPTXParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.ParserRuleContext;

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
    public Object visitMain(MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list
    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        programBuilder.initVirLocEqCon(ctx.location().getText(),
                (IntLiteral) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(),
                (IntLiteral) ctx.constant().accept(this), ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(),
                archType, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initVirLocEqLoc(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Proxy declarator list
    @Override
    public Object visitVariableDeclaratorProxy(VariableDeclaratorProxyContext ctx) {
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
    public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
        for (ThreadScopeContext threadScopeContext : ctx.threadScope()) {
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
    public Object visitConstant(ConstantContext ctx) {
        return ExpressionFactory.getInstance().parseValue(ctx.getText(), archType);
    }

    @Override
    public Object visitRegister(RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
    }

    @Override
    public Object visitInstructionRow(InstructionRowContext ctx) {
        for (int i = 0; i < threadCount; i++) {
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitStoreInstruction(StoreInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        Expression constant = (Expression) ctx.value().accept(this);
        String mo = ctx.mo().content;
        Event store = EventFactory.PTX.newStore(object, constant, mo);
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
        return append(store, ctx);
    }

    @Override
    public Object visitLocalValue(LocalValueContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        Expression value = (Expression) ctx.value().accept(this);
        return append(EventFactory.newLocal(register, value), ctx);
    }

    @Override
    public Object visitLocalAdd(LocalAddContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeAdd(lhs, rhs);
        return append(EventFactory.newLocal(rd, exp), ctx);
    }

    @Override
    public Object visitLocalSub(LocalSubContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeSub(lhs, rhs);
        return append(EventFactory.newLocal(rd, exp), ctx);
    }

    @Override
    public Object visitLocalMul(LocalMulContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeMul(lhs, rhs);
        return append(EventFactory.newLocal(rd, exp), ctx);
    }

    @Override
    public Object visitLocalDiv(LocalDivContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeDiv(lhs, rhs, true);
        return append(EventFactory.newLocal(rd, exp), ctx);
    }

    @Override
    public Object visitLoadLocation(LoadLocationContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        String mo = ctx.mo().content;
        Event load = EventFactory.PTX.newLoad(register, location, mo);
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
        return append(load, ctx);
    }

    @Override
    public Object visitAtomOp(AtomOpContext ctx) {
        Register register_destination = (Register) ctx.register().accept(this);
        MemoryObject object = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        IntBinaryOp op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        Event atom = EventFactory.PTX.newAtomOp(object, register_destination, value, op, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return append(atom, ctx);
    }

    @Override
    public Object visitAtomCAS(AtomCASContext ctx) {
        Register register_destination = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        MemoryObject object = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        Expression expected = (Expression) ctx.value(0).accept(this);
        Expression value = (Expression) ctx.value(1).accept(this);
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        Event atom = EventFactory.PTX.newAtomCAS(object, register_destination, expected, value, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return append(atom, ctx);
    }

    @Override 
    public Object visitAtomExchange(AtomExchangeContext ctx) {
        Register register_destination = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        MemoryObject object = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        Event atom = EventFactory.PTX.newAtomExch(object, register_destination, value, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return append(atom, ctx);
    }

    @Override
    public Object visitRedInstruction(RedInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        IntBinaryOp op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Red instruction doesn't support mo: " + mo);
        }
        Event red = EventFactory.PTX.newRedOp(object, value, op, mo, scope);
        red.addTags(ctx.red().redProxy);
        return append(red, ctx);
    }

    @Override
    public Object visitFencePhysic(FencePhysicContext ctx) {
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.SC))) {
            throw new ParsingException("Fence instruction doesn't support mo: " + mo);
        }
        Event fence = EventFactory.PTX.newFence(ctx.getText().toLowerCase());
        fence.addTags(mo, scope, Tag.PTX.GEN);
        return append(fence, ctx);
    }

    @Override
    public Object visitFenceProxy(FenceProxyContext ctx) {
        Event fence = EventFactory.PTX.newFence(ctx.getText().toLowerCase());
        fence.addTags(ctx.proxyType().content);
        return append(fence, ctx);
    }

    @Override
    public Object visitFenceAlias(FenceAliasContext ctx) {
        Event fence = EventFactory.PTX.newFence(ctx.getText().toLowerCase());
        fence.addTags(Tag.PTX.ALIAS);
        return append(fence, ctx);
    }

    @Override
    public Object visitBarrier(BarrierContext ctx) {
        String name = ctx.barrierMode().getText();
        String instanceId = ctx.constant().getText();
        Event barrier;
        if (ctx.barrierId() == null) {
            barrier = EventFactory.newControlBarrier(name, instanceId, Tag.PTX.CTA);
        } else {
            Expression id = (Expression) ctx.barrierId().accept(this);
            Expression quorum = null;
            if (ctx.barrierQuorum() != null) {
                quorum = (Expression) ctx.barrierQuorum().accept(this);
            }
            barrier = EventFactory.newNamedBarrier(name, instanceId, Tag.PTX.CTA, id, quorum);
        }
        if(ctx.barrierMode().Arrive() != null) {
            barrier.addTags(Tag.PTX.ARRIVE);
        }
        return append(barrier, ctx);
    }

    @Override
    public Object visitLabel(LabelContext ctx) {
        return append(programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()), ctx);
    }

    @Override
    public Object visitBranchCond(BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression expr = expressions.makeIntCmp(lhs, ctx.cond().op, rhs);
        return append(EventFactory.newJump(expr, label), ctx);
    }

    @Override
    public Object visitJump(JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        return append(EventFactory.newGoto(label), ctx);
    }

    private Event append(Event event, ParserRuleContext ctx) {
        return programBuilder.addChild(mainThread, event, ctx.getStart().getLine());
    }
}