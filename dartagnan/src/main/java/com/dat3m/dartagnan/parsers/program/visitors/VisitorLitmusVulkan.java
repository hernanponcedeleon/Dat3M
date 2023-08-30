package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusVulkanBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusVulkanParser;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.FenceWithId;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

public class VisitorLitmusVulkan extends LitmusVulkanBaseVisitor<Object> {
    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.VULKAN);
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
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(),
                TypeFactory.getInstance().getArchType());
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
        return ExpressionFactory.getInstance().parseValue(ctx.getText(), TypeFactory.getInstance().getArchType());
    }

    @Override
    public Object visitRegister(LitmusVulkanParser.RegisterContext ctx) {
        return programBuilder.getOrNewRegister(mainThread, ctx.getText(), TypeFactory.getInstance().getArchType());
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
    public Object visitStoreConstant(LitmusVulkanParser.StoreConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        Boolean atomic = ctx.atomic().isAtomic;
        String mo = ctx.mo().content;
        String avvis = ctx.avvis().content;
        String scope = ctx.scope().content;
        String storageClass = ctx.storageClass().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        if (!mo.isEmpty() && !mo.equals(Tag.Vulkan.RELEASE) && !avvis.isEmpty() && !avvis.equals(Tag.Vulkan.AVAILABLE)) {
            throw new ParsingException("Stores must be release or available");
        }
        Store store = EventFactory.newStoreWithMo(object, constant, mo);
        tagChecker(store, atomic, mo, avvis, scope, classSemantic, avvisSemantic);
        store.addTags(storageClass);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitStoreRegister(LitmusVulkanParser.StoreRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register register = (Register) ctx.register().accept(this);
        Boolean atomic = ctx.atomic().isAtomic;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String avvis = ctx.avvis().content;
        String storageClass = ctx.storageClass().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        if (!mo.isEmpty() && !mo.equals(Tag.Vulkan.RELEASE) && !avvis.isEmpty() && !avvis.equals(Tag.Vulkan.AVAILABLE)) {
            throw new ParsingException("Stores must be release or available");
        }
        Store store = EventFactory.newStoreWithMo(object, register, mo);
        store.addTags(scope, classSemantic, avvisSemantic);
        tagChecker(store, atomic, mo, avvis, scope, classSemantic, avvisSemantic);
        store.addTags(storageClass);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitLocalConstant(LitmusVulkanParser.LocalConstantContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        IConst constant = (IConst) ctx.constant().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadLocation(LitmusVulkanParser.LoadLocationContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Boolean atomic = ctx.atomic().isAtomic;
        String mo = ctx.mo().content;
        String avvis = ctx.avvis().content;
        String scope = ctx.scope().content;
        String storageClass = ctx.storageClass().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        if (!mo.isEmpty() && !mo.equals(Tag.Vulkan.ACQUIRE) && !avvis.isEmpty() && !avvis.equals(Tag.Vulkan.VISIBLE)) {
            throw new ParsingException("Loads must be acquire or visible");
        }
        Load load = EventFactory.newLoadWithMo(register, location, mo);
        tagChecker(load, atomic, mo, avvis, scope, classSemantic, avvisSemantic);
        load.addTags(storageClass);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitRmwConstant(LitmusVulkanParser.RmwConstantContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        Boolean atomic = ctx.atomic().isAtomic;
        String mo = ctx.mo().content;
        String avvis = ctx.avvis().content;
        String scope = ctx.scope().content;
        String storageClass = ctx.storageClass().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        if (!mo.isEmpty() && !mo.equals(Tag.Vulkan.ACQ_REL)) {
            throw new ParsingException("RMW must be acq_rel");
        }
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(location, register, constant, mo, scope);
        tagChecker(rmw, atomic, mo, avvis, scope, classSemantic, avvisSemantic);
        rmw.addTags(storageClass, Tag.Vulkan.ATOM);
        return programBuilder.addChild(mainThread, rmw);
    }

    @Override
    public Object visitMemoryBarrier(LitmusVulkanParser.MemoryBarrierContext ctx) {
        String mo = ctx.mo().content;
        String avvis = ctx.avvis().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;

        if (!mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.ACQ_REL)
                && !avvis.equals(Tag.Vulkan.AVAILABLE) && !avvis.equals(Tag.Vulkan.VISIBLE)) {
            throw new ParsingException("Fences must be acquire, release, acq_rel, available or visible");
        }
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        tagChecker(fence, false, mo, avvis, scope, classSemantic, "");
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitControlBarrier(LitmusVulkanParser.ControlBarrierContext ctx) {
        String scope = ctx.scope().content;
        String mo = ctx.mo().content;
        String avvis = ctx.avvis().content;
        String classSemantic = ctx.storageClassSemantic().content;
        Expression fenceId = (Expression) ctx.barID().accept(this);
        String fenceIdString = ctx.getText().replace(fenceId.toString(), "");
        Event fence = EventFactory.newFenceWithId(fenceIdString.toLowerCase(), fenceId);
        if (!mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.ACQ_REL)) {
            fence.removeTags(Tag.FENCE);
        }
        tagChecker(fence, false, mo, avvis, scope, classSemantic, "");
        return programBuilder.addChild(mainThread, fence);
    }

    private void tagChecker(Event e, Boolean atomic, String mo, String avvis, String scope,
                            String storageClassSemantic, String avvisSemantic) {
        // ----------------------------------------------------------------------------------------------------------------
        // check tags
        // Check if nonpriv is tagged with memory access
        if (!(e instanceof Store) && !(e instanceof Load) && scope.equals(Tag.Vulkan.NON_PRIVATE)) {
                throw new ParsingException("Nonpriv is only meaningful for memory accesses");
        }

        // Check if mo is consistent with atomatic
        if (!(e.hasTag(Tag.FENCE)) && mo.equals(Tag.Vulkan.ACQUIRE) && !atomic) {
            throw new ParsingException("Acquire mo must be atomatic");
        }
        if (!(e.hasTag(Tag.FENCE)) && mo.equals(Tag.Vulkan.RELEASE) && !atomic) {
            throw new ParsingException("Release mo must be atomatic");
        }

        // Check if avvisSemantic is consistent with mo
        if (avvisSemantic.equals(Tag.Vulkan.SEM_AVAILABLE) && !mo.equals(Tag.Vulkan.RELEASE)) {
            throw new ParsingException("Available avvisSemantic must be release mo");
        }
        if (avvisSemantic.equals(Tag.Vulkan.SEM_VISIBLE) && !mo.equals(Tag.Vulkan.ACQUIRE)) {
            throw new ParsingException("Visible avvisSemantic must be acquire mo");
        }

        // All acquire/release ops have one or more semantics storage classes
        if ((mo.equals(Tag.Vulkan.ACQUIRE) || mo.equals(Tag.Vulkan.RELEASE)) && storageClassSemantic.isEmpty()) {
            throw new ParsingException("Acquire/release ops must have one or more storage classes semantics");
        }

        // ----------------------------------------------------------------------------------------------------------------
        // Add tags
        e.addTags(mo, avvis, scope, storageClassSemantic, avvisSemantic);
        if (atomic) {
            e.addTags(Tag.Vulkan.ATOM);
        }

        // ACQ_REL is both ACQ and REL
        if (mo.equals(Tag.Vulkan.ACQ_REL)) {
            e.addTags(Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE);
        }

        if (storageClassSemantic.equals(Tag.Vulkan.SEM_SC01)) {
            e.addTags(Tag.Vulkan.SEM_SC0, Tag.Vulkan.SEM_SC1);
        }

        // AV, VIS, and atomics are all implicitly nonpriv
        if (avvis.equals(Tag.Vulkan.AVAILABLE) || avvis.equals(Tag.Vulkan.VISIBLE) || atomic) {
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