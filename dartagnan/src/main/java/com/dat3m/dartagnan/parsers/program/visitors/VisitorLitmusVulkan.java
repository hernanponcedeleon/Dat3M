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
import com.dat3m.dartagnan.program.event.arch.vulkan.VulkanRMW;
import com.dat3m.dartagnan.program.event.core.Event;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import java.util.Vector;

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
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String semantic = ctx.storageClassSemantic().content;
        Store store = EventFactory.newStoreWithMo(object, constant, mo);
        store.addTags(scope, semantic);
        switch (mo) {
            case Tag.Vulkan.RELEASE -> {
                store.addTags(Tag.Vulkan.ATOM);
            }
            case Tag.Vulkan.AVAILABLE -> {
                store.addTags(Tag.Vulkan.NON_PRIVATE);
            }
            case "" -> {
                if (!ctx.atomatic().content) {
                    throw new ParsingException("Store instruction doesn't have mo");
                }
                store.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE);
            }
            default -> throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        if (ctx.atomatic().content) {
            store.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE);
        }
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitStoreRegister(LitmusVulkanParser.StoreRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Register register = (Register) ctx.register().accept(this);
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String semantic = ctx.storageClassSemantic().content;
        Store store = EventFactory.newStoreWithMo(object, register, mo);
        store.addTags(scope, semantic);
        switch (mo) {
            case Tag.Vulkan.RELEASE -> {
                store.addTags(Tag.Vulkan.ATOM);
            }
            case Tag.Vulkan.AVAILABLE -> {
                store.addTags(Tag.Vulkan.NON_PRIVATE);
            }
            case "" -> {
                if (!ctx.atomatic().content) {
                    throw new ParsingException("Store instruction doesn't have mo");
                }
                store.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE);
            }
            default -> throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        if (ctx.atomatic().content) {
            store.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.AVAILABLE);
        }
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
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String semantic = ctx.storageClassSemantic().content;
        Load load = EventFactory.newLoadWithMo(register, location, mo);
        load.addTags(scope, semantic);
        switch (mo) {
            case Tag.Vulkan.ACQUIRE -> {
                load.addTags(Tag.Vulkan.ATOM);
            }
            case Tag.Vulkan.VISIBLE -> {
                load.addTags(Tag.Vulkan.NON_PRIVATE);
            }
            case "" -> {
                if (!ctx.atomatic().content) {
                    throw new ParsingException("Store instruction doesn't have mo");
                }
                load.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE);
            }
            default -> throw new ParsingException("Store instruction doesn't support mo: " + mo);
        }
        if (ctx.atomatic().content) {
            load.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.VISIBLE);
        }
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitRmwConstant(LitmusVulkanParser.RmwConstantContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IConst constant = (IConst) ctx.constant().accept(this);
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String semantic = ctx.storageClassSemantic().content;
        VulkanRMW rmw = EventFactory.Vulkan.newRMW(location, register, constant, mo, scope);
        rmw.addTags(scope, semantic);
        switch (mo) {
            case Tag.Vulkan.ACQ_REL -> {
                rmw.addTags(Tag.Vulkan.ATOM);
            }
            case Tag.Vulkan.NON_PRIVATE -> {
                rmw.addTags(Tag.Vulkan.NON_PRIVATE);
            }
            default -> throw new ParsingException("RMW instruction doesn't support mo: " + mo);
        }
        if (ctx.atomatic().content) {
            rmw.addTags(Tag.Vulkan.ATOM, Tag.Vulkan.NON_PRIVATE, Tag.Vulkan.VISIBLE);
        } else {
            throw new ParsingException("RMW must be atomic in Vulkan");
        }
        return programBuilder.addChild(mainThread, rmw);
    }

    @Override
    public Object visitMemoryBarrier(LitmusVulkanParser.MemoryBarrierContext ctx) {
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String semantic = ctx.storageClassSemantic().content;
        Event fence = EventFactory.newFence(ctx.getText().toLowerCase());
        switch (mo) {
            case Tag.Vulkan.ACQUIRE, Tag.Vulkan.RELEASE -> {
                fence.addTags(mo, scope, semantic);
            }
            default -> throw new ParsingException("Fence instruction doesn't support mo: " + mo);
        }
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitControlBarrier(LitmusVulkanParser.ControlBarrierContext ctx) {
        String mo = ctx.mo().content;
        String scope = ctx.scope().content;
        String semantic = ctx.storageClassSemantic().content;
        Expression fenceId = (Expression) ctx.barID().accept(this);
        Event fence = EventFactory.Vulkan.newFenceWithId(ctx.getText().toLowerCase(), fenceId);
        fence.addTags(mo, scope, semantic);
        return programBuilder.addChild(mainThread, fence);
    }
}