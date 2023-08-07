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
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanFenceWithId;
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.core.AbstractEvent;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.google.common.base.Preconditions;
import org.antlr.v4.runtime.misc.Interval;

import java.util.Vector;

import static com.google.common.base.Preconditions.checkArgument;

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

    // ----------------------------------------------------------------------------------------------------------------
    // SSW declarator list
    @Override
    public Object visitSswDeclaratorList(LitmusVulkanParser.SswDeclaratorListContext ctx) {
        for (LitmusVulkanParser.SswDeclaratorContext sswDeclaratorContext : ctx.sswDeclarator()) {
            int threadId0 = sswDeclaratorContext.threadId(0).id;
            int threadId1 = sswDeclaratorContext.threadId(1).id;
            programBuilder.addSwwPairThreads(threadId0, threadId1);
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
        Boolean atomatic = ctx.atomatic().isAtomic;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        Store store = EventFactory.newStoreWithMo(object, constant, mo);
        tagChecker(store, atomatic, mo, avvisSemantic);
        store.addTags(scope, classSemantic);
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitStoreRegister(LitmusVulkanParser.StoreRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register register = (Register) ctx.register().accept(this);
        Boolean atomatic = ctx.atomatic().isAtomic;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        Store store = EventFactory.newStoreWithMo(object, register, mo);
        store.addTags(scope, classSemantic, avvisSemantic);
        tagChecker(store, atomatic, mo, avvisSemantic);
        store.addTags(scope, classSemantic);
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
        Boolean atomatic = ctx.atomatic().isAtomic;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        Load load = EventFactory.newLoadWithMo(register, location, mo);
        tagChecker(load, atomatic, mo, avvisSemantic);
        load.addTags(scope, classSemantic);
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitRmwConstant(LitmusVulkanParser.RmwConstantContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        Boolean atomatic = ctx.atomatic().isAtomic;
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;
        String avvisSemantic = ctx.avvisSemantic().content;
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(location, register, constant, mo, scope);
        rmw.addTags(scope, classSemantic, avvisSemantic);
        tagChecker(rmw, atomatic, mo, avvisSemantic);
        rmw.addTags(scope, classSemantic);
        return programBuilder.addChild(mainThread, rmw);
    }

    @Override
    public Object visitMemoryBarrier(LitmusVulkanParser.MemoryBarrierContext ctx) {
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        tagChecker(fence, false, mo, "");
        fence.addTags(scope, classSemantic);
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitControlBarrier(LitmusVulkanParser.ControlBarrierContext ctx) {
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String classSemantic = ctx.storageClassSemantic().content;
        Expression fenceId = (Expression) ctx.barID().accept(this);
        Event fence = EventFactory.Vulkan.newFenceWithId(ctx.getText().toLowerCase(), fenceId);
        tagChecker(fence, false, mo, "");
        fence.addTags(scope, classSemantic);
        return programBuilder.addChild(mainThread, fence);
    }

    private void tagChecker(Event e, Boolean atomatic, String mo, String avvisSemantic) {
        // Check if the event is tagged with the right mo
        if (e instanceof Store) {
            if (!mo.equals(Tag.Vulkan.PRIVATE) && !mo.equals(Tag.Vulkan.NON_PRIVATE) &&
                    !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.AVAILABLE)) {
                throw new ParsingException("Stores must private or non_private or release or available");
            }
        } else if (e instanceof Load) {
            if (!mo.equals(Tag.Vulkan.PRIVATE) && !mo.equals(Tag.Vulkan.NON_PRIVATE) &&
                    !mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.VISIBLE)) {
                throw new ParsingException("Loads must private or non_private or acquire or visible");
            }
        } else if (e.hasTag(Tag.FENCE) && !(e instanceof VulkanFenceWithId)) {
            if (!mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.ACQ_REL)) {
                throw new ParsingException("Fences must release or acquire or acq_rel");
            }
        } else if (e instanceof VulkanFenceWithId) {
            if (!mo.equals(Tag.Vulkan.ACQUIRE) && !mo.equals(Tag.Vulkan.RELEASE) && !mo.equals(Tag.Vulkan.ACQ_REL) &&
                    !mo.equals(Tag.Vulkan.NON_PRIVATE)) { // use non_private when no mo is specified
                throw new ParsingException("VulkanFenceWithId must release or acquire or acq_rel or non_private");
            }
        } else if (e instanceof VulkanRMW) {
            if (!mo.equals(Tag.Vulkan.NON_PRIVATE) && !mo.equals(Tag.Vulkan.ACQ_REL)) {
                throw new ParsingException("RMW must non_private or acq_rel");
            }
        } else {
            throw new ParsingException("Event type not supported: " + e.getClass().getSimpleName());
        }

        // Check if mo is consistent with atomatic
        if (mo.equals(Tag.Vulkan.ACQUIRE) && !atomatic) {
            throw new ParsingException("Acquire mo must be atomatic");
        }
        if (mo.equals(Tag.Vulkan.RELEASE) && !atomatic) {
            throw new ParsingException("Release mo must be atomatic");
        }

        // Check if avvisSemantic is consistent with mo
        if (avvisSemantic.equals(Tag.Vulkan.SEM_AVAILABLE) && !mo.equals(Tag.Vulkan.RELEASE)) {
            throw new ParsingException("Available avvisSemantic must be release mo");
        }
        if (avvisSemantic.equals(Tag.Vulkan.SEM_VISIBLE) && !mo.equals(Tag.Vulkan.ACQUIRE)) {
            throw new ParsingException("Visible avvisSemantic must be acquire mo");
        }

        // Add tags
        e.addTags(mo, avvisSemantic);
        if (atomatic) {
            e.addTags(Tag.Vulkan.ATOM);
        }
    }
}