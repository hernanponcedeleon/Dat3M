package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusVulkanBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusVulkanParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMWOp;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import java.util.ArrayList;
import java.util.List;

public class VisitorLitmusVulkan extends LitmusVulkanBaseVisitor<Object> {
    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.VULKAN);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType archType = types.getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusVulkan() {
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusVulkanParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitSswDeclaratorList(ctx.sswDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        if (ctx.sswDeclaratorList() != null) {
            for (LitmusVulkanParser.SswDeclaratorContext sswDeclaratorContext : ctx.sswDeclaratorList().sswDeclarator()) {
                int threadId0 = sswDeclaratorContext.threadId(0).id;
                int threadId1 = sswDeclaratorContext.threadId(1).id;
                programBuilder.addSwwPairThreads(threadId0, threadId1);
            }
        }
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
    public Object visitVariableDeclaratorLocation(LitmusVulkanParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initVirLocEqCon(ctx.location().getText(),
                (IConst) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusVulkanParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(),
                (IConst) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusVulkanParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusVulkanParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initVirLocEqLoc(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorProxy(LitmusVulkanParser.VariableDeclaratorProxyContext ctx) {
        programBuilder.initVirLocEqLocAliasGen(ctx.location(0).getText(),
                ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // SSW declarator list
    @Override
    public Object visitSswDeclaratorList(LitmusVulkanParser.SswDeclaratorListContext ctx) {
        if (ctx != null) {
            for (LitmusVulkanParser.SswDeclaratorContext sswDeclaratorContext : ctx.sswDeclarator()) {
                int threadId0 = sswDeclaratorContext.threadId(0).id;
                int threadId1 = sswDeclaratorContext.threadId(1).id;
                programBuilder.addSwwPairThreads(threadId0, threadId1);
            }
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions)
    @Override
    public Object visitThreadDeclaratorList(LitmusVulkanParser.ThreadDeclaratorListContext ctx) {
        for (LitmusVulkanParser.ThreadScopeContext threadScopeContext : ctx.threadScope()) {
            int subgroupID = threadScopeContext.subgroupScope().scopeID().id;
            int workgroupID = threadScopeContext.workgroupScope().scopeID().id;
            int queuefamilyID = threadScopeContext.queuefamilyScope().scopeID().id;
            // NB: the order of scopeIDs is important
            programBuilder.newScopedThread(Arch.VULKAN, threadScopeContext.threadId().id,
                    queuefamilyID, workgroupID, subgroupID);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)
    @Override
    public Object visitConstant(LitmusVulkanParser.ConstantContext ctx) {
        return ExpressionFactory.getInstance().parseValue(ctx.getText(), archType);
    }

    @Override
    public Object visitRegister(LitmusVulkanParser.RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), archType);
    }

    @Override
    public Object visitStorageClassSemanticList(LitmusVulkanParser.StorageClassSemanticListContext ctx) {
        List<String> storageClassSemantics = new ArrayList<>();
        for (LitmusVulkanParser.StorageClassSemanticContext scSemantic : ctx.storageClassSemantic()) {
            storageClassSemantics.add(scSemantic.content);
        }
        return storageClassSemantics;
    }

    @Override
    public Object visitAvvisSemanticList(LitmusVulkanParser.AvvisSemanticListContext ctx) {
        List<String> avvisSemantics = new ArrayList<>();
        for (LitmusVulkanParser.AvvisSemanticContext avvisSemantic : ctx.avvisSemantic()) {
            avvisSemantics.add(avvisSemantic.content);
        }
        return avvisSemantics;
    }

    @Override
    public Object visitInstructionRow(LitmusVulkanParser.InstructionRowContext ctx) {
        for (int i = 0; i < threadCount; i++) {
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitStoreInstruction(LitmusVulkanParser.StoreInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        Boolean atomic = ctx.atomic().isAtomic;
        Store store;
        if (ctx.mo() != null) {
            store = EventFactory.newStoreWithMo(object, value, ctx.mo().content);
        } else {
            store = EventFactory.newStore(object, value);
        }
        if (ctx.avvis() != null) {
            store.addTags(ctx.avvis().content);
        }
        if (ctx.scope() != null) {
            store.addTags(ctx.scope().content);
        }
        String mo = (ctx.mo() != null) ? ctx.mo().content : "";
        String avvis = (ctx.avvis() != null) ? ctx.avvis().content : "";
        String scope = (ctx.scope() != null) ? ctx.scope().content : "";
        String storageClass = ctx.storageClass().content;
        List<String> storageClassSemantics = (List<String>) ctx.storageClassSemanticList().accept(this);
        List<String> avvisSemantics = (List<String>) ctx.avvisSemanticList().accept(this);
        if (!mo.isEmpty() && !mo.equals(Tag.Vulkan.RELEASE) && !avvis.isEmpty() && !avvis.equals(Tag.Vulkan.AVAILABLE)) {
            throw new ParsingException("Stores must be release or available");
        }
        tagControl(store, atomic, mo, avvis, scope, storageClass, storageClassSemantics, avvisSemantics);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitLocalValue(LitmusVulkanParser.LocalValueContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        Expression value = (Expression) ctx.value().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, value));
    }

    @Override
    public Object visitLocalAdd(LitmusVulkanParser.LocalAddContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeADD(lhs, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalSub(LitmusVulkanParser.LocalSubContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeSUB(lhs, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalMul(LitmusVulkanParser.LocalMulContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeMUL(lhs, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLocalDiv(LitmusVulkanParser.LocalDivContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeDIV(lhs, rhs, true);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLoadLocation(LitmusVulkanParser.LoadLocationContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Boolean atomic = ctx.atomic().isAtomic;
        Load load;
        if (ctx.mo() != null) {
            load = EventFactory.newLoadWithMo(register, location, ctx.mo().content);
        } else {
            load = EventFactory.newLoad(register, location);
        }
        if (ctx.avvis() != null) {
            load.addTags(ctx.avvis().content);
        }
        if (ctx.scope() != null) {
            load.addTags(ctx.scope().content);
        }
        String mo = (ctx.mo() != null) ? ctx.mo().content : "";
        String avvis = (ctx.avvis() != null) ? ctx.avvis().content : "";
        String scope = (ctx.scope() != null) ? ctx.scope().content : "";
        String storageClass = ctx.storageClass().content;
        List<String> storageClassSemantics = (List<String>) ctx.storageClassSemanticList().accept(this);
        List<String> avvisSemantics = (List<String>) ctx.avvisSemanticList().accept(this);
        if (!mo.isEmpty() && !mo.equals(Tag.Vulkan.ACQUIRE) && !avvis.isEmpty() && !avvis.equals(Tag.Vulkan.VISIBLE)) {
            throw new ParsingException("Loads must be acquire or visible");
        }
        tagControl(load, atomic, mo, avvis, scope, storageClass, storageClassSemantics, avvisSemantics);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitRmwValue(LitmusVulkanParser.RmwValueContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = (ctx.mo() != null) ? ctx.mo().content : "";
        String avvis = (ctx.avvis() != null) ? ctx.avvis().content : "";
        String scope = (ctx.scope() != null) ? ctx.scope().content : "";
        String storageClass = ctx.storageClass().content;
        List<String> storageClassSemantics = (List<String>) ctx.storageClassSemanticList().accept(this);
        List<String> avvisSemantics = (List<String>) ctx.avvisSemanticList().accept(this);
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(location, register, value, mo, scope);
        if (!avvis.isEmpty()) {
            rmw.addTags(avvis);
        }
        tagControl(rmw, true, mo, avvis, scope, storageClass, storageClassSemantics, avvisSemantics);
        return programBuilder.addChild(mainThread, rmw);
    }

    @Override
    public Object visitRmwOp(LitmusVulkanParser.RmwOpContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = (ctx.mo() != null) ? ctx.mo().content : "";
        String avvis = (ctx.avvis() != null) ? ctx.avvis().content : "";
        String scope = (ctx.scope() != null) ? ctx.scope().content : "";
        String storageClass = ctx.storageClass().content;
        IOpBin op = ctx.operation().op;
        List<String> storageClassSemantics = (List<String>) ctx.storageClassSemanticList().accept(this);
        List<String> avvisSemantics = (List<String>) ctx.avvisSemanticList().accept(this);
        VulkanRMWOp rmw = EventFactory.Vulkan.newRMWOp(location, register, value, op, mo, scope);
        if (!avvis.isEmpty()) {
            rmw.addTags(avvis);
        }
        tagControl(rmw, true, mo, avvis, scope, storageClass, storageClassSemantics, avvisSemantics);
        return programBuilder.addChild(mainThread, rmw);
    }

    @Override
    public Object visitMemoryBarrier(LitmusVulkanParser.MemoryBarrierContext ctx) {
        String mo = (ctx.mo() != null) ? ctx.mo().content : "";
        String avvis = (ctx.avvis() != null) ? ctx.avvis().content : "";
        String scope = (ctx.scope() != null) ? ctx.scope().content : "";
        List<String> storageClassSemantics = (List<String>) ctx.storageClassSemanticList().accept(this);
        List<String> avvisSemantics = (List<String>) ctx.avvisSemanticList().accept(this);
        if (!mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.ACQ_REL)
                && !avvis.equals(Tag.Vulkan.AVAILABLE) && !avvis.equals(Tag.Vulkan.VISIBLE)) {
            throw new ParsingException("Fences must be acquire, release, acq_rel, available or visible");
        }
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        if (!mo.isEmpty()) {
            fence.addTags(mo);
        }
        if (!avvis.isEmpty()) {
            fence.addTags(avvis);
        }
        if (!scope.isEmpty()) {
            fence.addTags(scope);
        }
        tagControl(fence, false, mo, avvis, scope, "", storageClassSemantics, avvisSemantics);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitControlBarrier(LitmusVulkanParser.ControlBarrierContext ctx) {
        String mo = (ctx.mo() != null) ? ctx.mo().content : "";
        String avvis = (ctx.avvis() != null) ? ctx.avvis().content : "";
        String scope = (ctx.scope() != null) ? ctx.scope().content : "";
        List<String> storageClassSemantics = (List<String>) ctx.storageClassSemanticList().accept(this);
        List<String> avvisSemantics = (List<String>) ctx.avvisSemanticList().accept(this);
        Expression fenceId = (Expression) ctx.value().accept(this);
        String fenceIdString = ctx.getText().replace(fenceId.toString(), "");
        Event fence = EventFactory.newFenceWithId(fenceIdString.toLowerCase(), fenceId);
        fence.addTags(Tag.Vulkan.CBAR);
        if (!mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.ACQ_REL)) {
            fence.removeTags(Tag.FENCE);
        }
        if (!mo.isEmpty()) {
            fence.addTags(mo);
        }
        if (!avvis.isEmpty()) {
            fence.addTags(avvis);
        }
        if (!scope.isEmpty()) {
            fence.addTags(scope);
        }
        tagControl(fence, false, mo, avvis, scope, "", storageClassSemantics, avvisSemantics);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitDeviceOperation(LitmusVulkanParser.DeviceOperationContext ctx) {
        Event e;
        if (ctx.getText().equalsIgnoreCase(Tag.Vulkan.AVDEVICE)) {
            e = EventFactory.PTX.newAvDevice();
        } else if (ctx.getText().equalsIgnoreCase(Tag.Vulkan.VISDEVICE)) {
            e = EventFactory.PTX.newVisDevice();
        } else {
            throw new ParsingException("Unknown device operation");
        }
        return programBuilder.addChild(mainThread, e);
    }

    @Override
    public Object visitLabel(LitmusVulkanParser.LabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
    }

    @Override
    public Object visitBranchCond(LitmusVulkanParser.BranchCondContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression expr = expressions.makeBinary(lhs, ctx.cond().op, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitJump(LitmusVulkanParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        return programBuilder.addChild(mainThread, EventFactory.newGoto(label));
    }

    private void tagControl(Event e, Boolean atomic, String mo, String avvis, String scope, String storageClass,
                            List<String> storageClassSemantics, List<String> avvisSemantics) {
        e.addTags(storageClass);
        e.addTags(storageClassSemantics);
        e.addTags(avvisSemantics);
        if (atomic) {
            e.addTags(Tag.Vulkan.ATOM);
        }

        // ACQ_REL is both ACQ and REL
        if (mo.equals(Tag.Vulkan.ACQ_REL)) {
            e.addTags(Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
        }

        // AV, VIS, and atomics M are all implicitly nonpriv
        if ((avvis.equals(Tag.Vulkan.AVAILABLE) || avvis.equals(Tag.Vulkan.VISIBLE) || atomic)
                && (e instanceof MemoryEvent)) {
            e.addTags(Tag.Vulkan.NON_PRIVATE);
        }

        // Atomics implicitly have AV/VIS ops, hence they are implicitly nonpriv
        if (atomic && e instanceof Store) {
            e.addTags(Tag.Vulkan.AVAILABLE);
            e.addTags(Tag.Vulkan.NON_PRIVATE);
        }
        if (atomic && e instanceof Load) {
            e.addTags(Tag.Vulkan.VISIBLE);
            e.addTags(Tag.Vulkan.NON_PRIVATE);
        }
    }
}