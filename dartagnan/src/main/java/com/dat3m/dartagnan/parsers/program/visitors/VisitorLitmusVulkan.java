package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusVulkanBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusVulkanParser;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.common.SingleAccessMemoryEvent;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.ParserRuleContext;


public class VisitorLitmusVulkan extends LitmusVulkanBaseVisitor<Object> {
    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.VULKAN);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType archType = types.getArchType();
    private int mainThread;
    private int threadCount = 0;

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
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list
    @Override
    public Object visitVariableDeclaratorLocation(LitmusVulkanParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initVirLocEqCon(ctx.location().getText(),
                (IntLiteral) ctx.constant().accept(this));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusVulkanParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(),
                (IntLiteral) ctx.constant().accept(this));
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
        Store store = EventFactory.newStore(object, value);
        store.addTags(ctx.sc().content);
        if (ctx.nonpriv() != null) {
            store.addTags(Tag.Vulkan.NON_PRIVATE);
        }
        if (ctx.av() != null) {
            store.addTags(Tag.Vulkan.NON_PRIVATE);
            store.addTags(Tag.Vulkan.AVAILABLE);
            store.addTags(ctx.scope().content);
        }
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitLoadInstruction(LitmusVulkanParser.LoadInstructionContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Load load = EventFactory.newLoad(register, location);
        load.addTags(ctx.sc().content);
        if (ctx.nonpriv() != null) {
            load.addTags(Tag.Vulkan.NON_PRIVATE);
        }
        if (ctx.vis() != null) {
            load.addTags(Tag.Vulkan.NON_PRIVATE);
            load.addTags(Tag.Vulkan.VISIBLE);
            load.addTags(ctx.scope().content);
        }
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitAtomicStoreInstruction(LitmusVulkanParser.AtomicStoreInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = ctx.moRel() != null ? Tag.Vulkan.RELEASE : Tag.Vulkan.ATOM;
        Store store = EventFactory.newStoreWithMo(object, value, mo);
        store.addTags(
                Tag.Vulkan.ATOM,
                Tag.Vulkan.NON_PRIVATE,
                Tag.Vulkan.AVAILABLE,
                ctx.scope().content,
                ctx.sc().content
        );
        if (ctx.semAv() != null) {
            store.addTags(Tag.Vulkan.SEM_AVAILABLE);
        }
        store.addTags(ctx.semSc().stream().map(c -> c.content).toList());
        return programBuilder.addChild(mainThread, store);
    }

    @Override
    public Object visitAtomicLoadInstruction(LitmusVulkanParser.AtomicLoadInstructionContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        String mo = ctx.moAcq() != null ? Tag.Vulkan.ACQUIRE : Tag.Vulkan.ATOM;
        Load load = EventFactory.newLoadWithMo(register, location, mo);
        load.addTags(
                Tag.Vulkan.ATOM,
                Tag.Vulkan.NON_PRIVATE,
                Tag.Vulkan.VISIBLE,
                ctx.scope().content,
                ctx.sc().content
        );
        if (ctx.semVis() != null) {
            load.addTags(Tag.Vulkan.SEM_VISIBLE);
        }
        load.addTags(ctx.semSc().stream().map(c -> c.content).toList());
        return programBuilder.addChild(mainThread, load);
    }

    @Override
    public Object visitAtomicRmwInstruction(LitmusVulkanParser.AtomicRmwInstructionContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = getMemoryOrderOrDefault(ctx, Tag.Vulkan.ATOM);
        SingleAccessMemoryEvent rmw = ctx.operation() != null
                ? EventFactory.Vulkan.newRMWOp(location, register, value, ctx.operation().op, mo, ctx.scope().content)
                : EventFactory.Vulkan.newRMW(location, register, value, mo, ctx.scope().content);
        rmw.addTags(
                Tag.Vulkan.NON_PRIVATE,
                Tag.Vulkan.AVAILABLE,
                Tag.Vulkan.VISIBLE,
                ctx.sc().content
        );
        if (ctx.semAv() != null) {
            rmw.addTags(Tag.Vulkan.SEM_AVAILABLE);
        }
        if (ctx.semVis() != null) {
            rmw.addTags(Tag.Vulkan.SEM_VISIBLE);
        }
        rmw.addTags(ctx.semSc().stream().map(c -> c.content).toList());
        return programBuilder.addChild(mainThread, rmw);
    }

    @Override
    public Object visitMemoryBarrierInstruction(LitmusVulkanParser.MemoryBarrierInstructionContext ctx) {
        Event fence = EventFactory.newFence(Tag.FENCE);
        String mo = getMemoryOrderOrDefault(ctx, null);
        if (mo != null) {
            fence.addTags(mo);
        }
        fence.addTags(ctx.scope().content);
        if (ctx.semAv() != null) {
            fence.addTags(Tag.Vulkan.SEM_AVAILABLE);
        }
        if (ctx.semVis() != null) {
            fence.addTags(Tag.Vulkan.SEM_VISIBLE);
        }
        fence.addTags(ctx.semSc().stream().map(c -> c.content).toList());
        return programBuilder.addChild(mainThread, fence);
    }

    @Override
    public Object visitControlBarrierInstruction(LitmusVulkanParser.ControlBarrierInstructionContext ctx) {
        Expression barrierId = (Expression) ctx.value().accept(this);
        String barrierIdString = ctx.getText().replace(barrierId.toString(), "");
        Event barrier = EventFactory.newControlBarrier(barrierIdString.toLowerCase(), barrierId);
        barrier.addTags(Tag.Vulkan.CBAR, ctx.scope().content);
        String mo = getMemoryOrderOrDefault(ctx, null);
        if (mo != null) {
            barrier.addTags(mo);
        } else {
            barrier.removeTags(Tag.FENCE);
        }
        if (ctx.semAv() != null) {
            barrier.addTags(Tag.Vulkan.SEM_AVAILABLE);
        }
        if (ctx.semVis() != null) {
            barrier.addTags(Tag.Vulkan.SEM_VISIBLE);
        }
        barrier.addTags(ctx.semSc().stream().map(c -> c.content).toList());
        return programBuilder.addChild(mainThread, barrier);
    }

    @Override
    public Object visitLocalInstruction(LitmusVulkanParser.LocalInstructionContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeIntBinary(lhs, ctx.operation().op, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(rd, exp));
    }

    @Override
    public Object visitLabelInstruction(LitmusVulkanParser.LabelInstructionContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
    }

    @Override
    public Object visitJumpInstruction(LitmusVulkanParser.JumpInstructionContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        return programBuilder.addChild(mainThread, EventFactory.newGoto(label));
    }

    @Override
    public Object visitCondJumpInstruction(LitmusVulkanParser.CondJumpInstructionContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression expr = expressions.makeIntCmp(lhs, ctx.cond().op, rhs);
        return programBuilder.addChild(mainThread, EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitDeviceOperation(LitmusVulkanParser.DeviceOperationContext ctx) {
        Event e;
        if (ctx.getText().equalsIgnoreCase(Tag.Vulkan.AVDEVICE)) {
            e = EventFactory.Vulkan.newAvDevice();
        } else if (ctx.getText().equalsIgnoreCase(Tag.Vulkan.VISDEVICE)) {
            e = EventFactory.Vulkan.newVisDevice();
        } else {
            throw new ParsingException("Unknown device operation");
        }
        return programBuilder.addChild(mainThread, e);
    }

    private String getMemoryOrderOrDefault(ParserRuleContext ctx, String defaultMo) {
        if (ctx.getRuleContext(LitmusVulkanParser.MoAcqContext.class, 0) != null) {
            return Tag.Vulkan.ACQUIRE;
        }
        if(ctx.getRuleContext(LitmusVulkanParser.MoRelContext.class, 0) != null) {
            return Tag.Vulkan.RELEASE;
        }
        if (ctx.getRuleContext(LitmusVulkanParser.MoAcqRelContext.class, 0) != null) {
            return Tag.Vulkan.ACQ_REL;
        }
        return defaultMo;
    }
}