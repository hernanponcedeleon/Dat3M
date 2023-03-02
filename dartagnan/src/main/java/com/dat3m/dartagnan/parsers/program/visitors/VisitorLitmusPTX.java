package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import static com.dat3m.dartagnan.GlobalSettings.ARCH_PRECISION;

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
        programBuilder.initLocEqConst(ctx.location().getText(), new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPTXParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPTXParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), ARCH_PRECISION);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusPTXParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Proxy declarator list
    //TODO

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
    public Object visitStoreWeakConstant(LitmusPTXParser.StoreWeakConstantContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread, EventFactory.PTX.newTaggedStore(object, constant, Tag.PTX.WEAK));
    }

    @Override
    public Object visitStoreWeakRegister(LitmusPTXParser.StoreWeakRegisterContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread, EventFactory.PTX.newTaggedStore(object, register, Tag.PTX.WEAK));
    }

    @Override
    public Object visitStoreRelaxedConstant(LitmusPTXParser.StoreRelaxedConstantContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedStore(object, constant, ctx.scope().content, Tag.PTX.RLX));
    }

    @Override
    public Object visitStoreRelaxedRegister(LitmusPTXParser.StoreRelaxedRegisterContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedStore(object, register, ctx.scope().content, Tag.PTX.RLX));
    }

    @Override
    public Object visitStoreReleaseConstant(LitmusPTXParser.StoreReleaseConstantContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedStore(object, constant, ctx.scope().content, Tag.PTX.REL));
    }

    @Override
    public Object visitStoreReleaseRegister(LitmusPTXParser.StoreReleaseRegisterContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedStore(object, register, ctx.scope().content, Tag.PTX.REL));
    }

    @Override
    public Object visitLoadWeakConstant(LitmusPTXParser.LoadWeakConstantContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadWeakLocation(LitmusPTXParser.LoadWeakLocationContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        return programBuilder.addScopedChild(mainThread, EventFactory.PTX.newTaggedLoad(register, object, Tag.PTX.WEAK));
    }

    @Override
    public Object visitLoadRelaxedConstant(LitmusPTXParser.LoadRelaxedConstantContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadRelaxedLocation(LitmusPTXParser.LoadRelaxedLocationContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedLoad(register, object, ctx.scope().content, Tag.PTX.RLX));
    }

    @Override
    public Object visitLoadAcquireConstant(LitmusPTXParser.LoadAcquireConstantContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadAcquireLocation(LitmusPTXParser.LoadAcquireLocationContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedLoad(register, object, ctx.scope().content, Tag.PTX.ACQ));
    }

    @Override
    public Object visitFenceAcqRel(LitmusPTXParser.FenceAcqRelContext ctx){
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedFence(Tag.PTX.ACQ_REL, ctx.scope().content));
    }

    @Override
    public Object visitFenceSC(LitmusPTXParser.FenceSCContext ctx){
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedFence(Tag.PTX.SC, ctx.scope().content));
    }

    @Override
    public Object visitAtomRelaxedConstant(LitmusPTXParser.AtomRelaxedConstantContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedAtomOp(object, register_destination, constant, op, Tag.PTX.RLX, scope));
    }

    @Override
    public Object visitAtomRelaxedRegister(LitmusPTXParser.AtomRelaxedRegisterContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(0).getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(1).getText(), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedAtomOp(object, register_destination, register_operand, op, Tag.PTX.RLX, scope));
    }

    @Override
    public Object visitAtomAcqRelConstant(LitmusPTXParser.AtomAcqRelConstantContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedAtomOp(object, register_destination, constant, op, Tag.PTX.ACQ_REL, scope));
    }

    @Override
    public Object visitAtomAcqRelRegister(LitmusPTXParser.AtomAcqRelRegisterContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(0).getText(), ARCH_PRECISION);
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(1).getText(), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedAtomOp(object, register_destination, register_operand, op, Tag.PTX.ACQ_REL, scope));
    }

    @Override
    public Object visitRedRelaxedConstant(LitmusPTXParser.RedRelaxedConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedRedOp(object, register_destination, constant, op, Tag.PTX.RLX, scope));
    }

    @Override
    public Object visitRedRelaxedRegister(LitmusPTXParser.RedRelaxedRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedRedOp(object, register_destination, register_operand, op, Tag.PTX.RLX, scope));
    }

    @Override
    public Object visitRedAcqRelConstant(LitmusPTXParser.RedAcqRelConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedRedOp(object, register_destination, constant, op, Tag.PTX.ACQ_REL, scope));
    }

    @Override
    public Object visitRedAcqRelRegister(LitmusPTXParser.RedAcqRelRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), ARCH_PRECISION);
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String scope = ctx.scope().content;
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, ARCH_PRECISION);
        return programBuilder.addScopedChild(mainThread,
                EventFactory.PTX.newTaggedRedOp(object, register_destination, register_operand, op, Tag.PTX.ACQ_REL, scope));
    }
}