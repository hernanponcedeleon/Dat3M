package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusPTXBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusPTXParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomCAS;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXAtomOp;
import com.dat3m.dartagnan.program.event.arch.ptx.PTXRedOp;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

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
        programBuilder.initVirLocEqCon(ctx.location().getText(),
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
    public Object visitStoreConstant(LitmusPTXParser.StoreConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        String mo = ctx.mo().content;
        String scope;
        switch (mo) {
            case Tag.PTX.WEAK -> {
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
                }
                scope = Tag.PTX.SYS;
            }
            case Tag.PTX.REL, Tag.PTX.RLX -> scope = ctx.scope().content;
            default -> throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        Store store = EventFactory.newStoreWithMo(object, constant, mo);
        store.addTags(scope, ctx.store().storeProxy, Tag.PTX.CON);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitStoreRegister(LitmusPTXParser.StoreRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register register = (Register) ctx.register().accept(this);
        String mo = ctx.mo().content;
        String scope;
        switch (mo) {
            case Tag.PTX.WEAK -> {
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
                }
                scope = Tag.PTX.SYS;
            }
            case Tag.PTX.REL, Tag.PTX.RLX -> scope = ctx.scope().content;
            default -> throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        Store store = EventFactory.newStoreWithMo(object, register, mo);
        store.addTags(scope, ctx.store().storeProxy);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitLocalConstant(LitmusPTXParser.LocalConstantContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        IConst constant = (IConst) ctx.constant().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLocalAdd(LitmusPTXParser.LocalAddContext ctx) {
        Register rd = (Register) ctx.register().get(0).accept(this);
        Register rs = (Register) ctx.register().get(1).accept(this);
        IConst constant = (IConst) ctx.constant().accept(this);
        Expression exp = expressions.makeADD(rd, constant);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalSub(LitmusPTXParser.LocalSubContext ctx) {
        Register rd = (Register) ctx.register().get(0).accept(this);
        Register rs = (Register) ctx.register().get(1).accept(this);
        IConst constant = (IConst) ctx.constant().accept(this);
        Expression exp = expressions.makeSUB(rd, constant);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalMul(LitmusPTXParser.LocalMulContext ctx) {
        Register rd = (Register) ctx.register().get(0).accept(this);
        Register rs = (Register) ctx.register().get(1).accept(this);
        IConst constant = (IConst) ctx.constant().accept(this);
        Expression exp = expressions.makeMUL(rd, constant);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalDiv(LitmusPTXParser.LocalDivContext ctx) {
        Register rd = (Register) ctx.register().get(0).accept(this);
        Register rs = (Register) ctx.register().get(1).accept(this);
        IConst constant = (IConst) ctx.constant().accept(this);
        Expression exp = expressions.makeDIV(rd, constant, true);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLoadLocation(LitmusPTXParser.LoadLocationContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        String mo = ctx.mo().content;
        String scope;
        switch (mo) {
            case Tag.PTX.WEAK -> {
                if (ctx.scope() != null) {
                    throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
                }
                scope = Tag.PTX.SYS;
            }
            case Tag.PTX.ACQ, Tag.PTX.RLX -> scope = ctx.scope().content;
            default -> throw new ParsingException("Load instruction doesn't support mo: " + mo);
        }
        Load load = EventFactory.newLoadWithMo(register, location, mo);
        load.addTags(scope, ctx.load().loadProxy);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitAtomConstant(LitmusPTXParser.AtomConstantContext ctx) {
        Register register_destination = (Register) ctx.register().accept(this);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        IOpBin op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        PTXAtomOp atom = EventFactory.PTX.newAtomOp(object, register_destination, constant, op, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override
    public Object visitAtomRegister(LitmusPTXParser.AtomRegisterContext ctx) {
        Register register_destination = programBuilder.getOrNewRegister(mainThread, ctx.register().get(0).getText(), archType);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrNewRegister(mainThread, ctx.register().get(1).getText(), archType);
        IOpBin op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Atom instruction doesn't support mo: " + mo);
        }
        PTXAtomOp atom = EventFactory.PTX.newAtomOp(object, register_destination, register_operand, op, mo, scope);
        atom.addTags(ctx.atom().atomProxy);
        return programBuilder.addChild(mainThread, atom);
    }

    @Override
    public Object visitAtomCAS(LitmusPTXParser.AtomCASContext ctx) {
        Register register_destination = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register expected = programBuilder.getOrNewRegister(mainThread, ctx.constant().get(0).getText(), archType);
        Register value = programBuilder.getOrNewRegister(mainThread, ctx.constant().get(1).getText(), archType);
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
    public Object visitRedConstant(LitmusPTXParser.RedConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        IOpBin op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Red instruction doesn't support mo: " + mo);
        }
        PTXRedOp red = EventFactory.PTX.newRedOp(object, constant, op, mo, scope);
        red.addTags(ctx.red().redProxy);
        return programBuilder.addChild(mainThread, red);
    }

    @Override
    public Object visitRedRegister(LitmusPTXParser.RedRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register register_operand = (Register) ctx.register().accept(this);
        IOpBin op = ctx.operation().op;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        if (!(mo.equals(Tag.PTX.ACQ) || mo.equals(Tag.PTX.REL) || mo.equals(Tag.PTX.ACQ_REL) || mo.equals(Tag.PTX.RLX))) {
            throw new ParsingException("Red instruction doesn't support mo: " + mo);
        }
        PTXRedOp red = EventFactory.PTX.newRedOp(object, register_operand, op, mo, scope);
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
        fence.addTags(mo, scope);
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
        Expression fenceId = (Expression) ctx.barID().accept(this);
        Event fence = EventFactory.newFenceWithId(ctx.getText().toLowerCase(), fenceId);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitLabel(LitmusPTXParser.LabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
    }

    @Override
    public Object visitBranchCond(LitmusPTXParser.BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Register r1 = programBuilder.getOrNewRegister(mainThread, ctx.register(0).getText(), archType);
        Register r2 = programBuilder.getOrNewRegister(mainThread, ctx.register(1).getText(), archType);
        Expression expr = expressions.makeBinary(r1, ctx.cond().op, r2);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitJump(LitmusPTXParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        return programBuilder.addChild(mainThread, EventFactory.newGoto(label));
    }

}