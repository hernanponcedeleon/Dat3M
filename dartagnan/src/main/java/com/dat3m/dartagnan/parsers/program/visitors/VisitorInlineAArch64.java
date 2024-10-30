package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.List;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.InlineAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.InlineAArch64Parser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;

public class VisitorInlineAArch64 extends InlineAArch64BaseVisitor<Object> {

    private List<Event> events = new ArrayList();
    private ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.AArch64,Arch.ARM8);
    //might be needed later idk
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType archType = types.getArchType();

    public VisitorInlineAArch64() {

    }

    @Override
    public Object visitAsm(InlineAArch64Parser.AsmContext ctx) {
        System.out.println("visitAsm");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAsmInstrEntries(InlineAArch64Parser.AsmInstrEntriesContext ctx) {
        System.out.println("visitInstrEntries");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAsmMetadataEntries(InlineAArch64Parser.AsmMetadataEntriesContext ctx) {
        System.out.println("visitAsmMetadataEntries");
        return visitChildren(ctx);
    }

    @Override
    public Object visitInstr(InlineAArch64Parser.InstrContext ctx) {
        System.out.println("visitInstr");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadReg(InlineAArch64Parser.LoadRegContext ctx) {
        System.out.println("Trying out to capture pieces of rules that I need...");
        System.out.println(ctx.VariableInline());
        System.out.println(ctx.ConstantInline());
        // events.add(EventFactory.newLocal())
        System.out.println("LoadReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireReg(InlineAArch64Parser.LoadAcquireRegContext ctx) {
        System.out.println("LoadAcquireReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadExclusiveReg(InlineAArch64Parser.LoadExclusiveRegContext ctx) {
        System.out.println("LoadExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireExclusiveReg(InlineAArch64Parser.LoadAcquireExclusiveRegContext ctx) {
        System.out.println("LoadAcquireExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAdd(InlineAArch64Parser.AddContext ctx) {
        System.out.println("Add");
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReg(InlineAArch64Parser.StoreRegContext ctx) {
        System.out.println("StoreReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreExclusiveRegister(InlineAArch64Parser.StoreExclusiveRegisterContext ctx) {
        System.out.println("StoreExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseExclusiveReg(InlineAArch64Parser.StoreReleaseExclusiveRegContext ctx) {
        System.out.println("StoreReleaseExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseReg(InlineAArch64Parser.StoreReleaseRegContext ctx) {
        System.out.println("StoreReleaseReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAtomicAddDoubleWordRelease(InlineAArch64Parser.AtomicAddDoubleWordReleaseContext ctx) {
        System.out.println("AtomicAddDoubleWordRelease");
        return visitChildren(ctx);
    }

    @Override
    public Object visitDataMemoryBarrier(InlineAArch64Parser.DataMemoryBarrierContext ctx) {
        System.out.println("DataMemoryBarrier");
        return visitChildren(ctx);
    }

    @Override
    public Object visitSwapWordAcquire(InlineAArch64Parser.SwapWordAcquireContext ctx) {
        System.out.println("SwapWordAcquire");
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompare(InlineAArch64Parser.CompareContext ctx) {
        System.out.println("Compare");
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareBranchNonZero(InlineAArch64Parser.CompareBranchNonZeroContext ctx) {
        System.out.println("CompareBranchNonZero");
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareAndSwap(InlineAArch64Parser.CompareAndSwapContext ctx) {
        System.out.println("CompareAndSwap");
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareAndSwapAcquire(InlineAArch64Parser.CompareAndSwapAcquireContext ctx) {
        System.out.println("CompareAndSwapAcquire");
        return visitChildren(ctx);
    }

    @Override
    public Object visitMove(InlineAArch64Parser.MoveContext ctx) {
        System.out.println("Move");
        return visitChildren(ctx);
    }

    @Override
    public Object visitBranchEqual(InlineAArch64Parser.BranchEqualContext ctx) {
        System.out.println("BranchEqual");
        return visitChildren(ctx);
    }

    @Override
    public Object visitBranchNotEqual(InlineAArch64Parser.BranchNotEqualContext ctx) {
        System.out.println("BranchNotEqual");
        return visitChildren(ctx);
    }

    @Override
    public Object visitSetEventLocally(InlineAArch64Parser.SetEventLocallyContext ctx) {
        System.out.println("SetEventlocally");
        return visitChildren(ctx);
    }

    @Override
    public Object visitWaitForEvent(InlineAArch64Parser.WaitForEventContext ctx) {
        System.out.println("WaitForEvent");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLabelDefinition(InlineAArch64Parser.LabelDefinitionContext ctx) {
        System.out.println("LabelDefinition");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAlignInline(InlineAArch64Parser.AlignInlineContext ctx) {
        System.out.println("AlignInline");
        return visitChildren(ctx);
    }

    @Override
    public Object visitPrefetchMemory(InlineAArch64Parser.PrefetchMemoryContext ctx) {
        System.out.println("PrefetchMemory");
        System.out.println("prefetch");
        return visitChildren(ctx);
    }

    @Override
    public Object visitYieldtask(InlineAArch64Parser.YieldtaskContext ctx) {
        System.out.println("YieldTask");
        return visitChildren(ctx);
    }

    @Override
    public Object visitMetaInstr(InlineAArch64Parser.MetaInstrContext ctx) {
        System.out.println("MetaInstr");
        return visitChildren(ctx);
    }

    @Override
    public Object visitMetadataInline(InlineAArch64Parser.MetadataInlineContext ctx) {
        System.out.println("MetadataInline");
        return visitChildren(ctx);
    }

    @Override
    public Object visitClobber(InlineAArch64Parser.ClobberContext ctx) {
        System.out.println("Clobber");
        return visitChildren(ctx);
    }

}
