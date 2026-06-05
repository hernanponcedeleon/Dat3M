package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusVulkanBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusVulkanParser.*;
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

import java.util.List;

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
    public Object visitMain(MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitSswDeclaratorList(ctx.sswDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        if (ctx.sswDeclaratorList() != null) {
            for (SswDeclaratorContext sswDeclaratorContext : ctx.sswDeclaratorList().sswDeclarator()) {
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
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initVirLocEqLoc(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorProxy(VariableDeclaratorProxyContext ctx) {
        programBuilder.initVirLocEqLocAliasGen(ctx.location(0).getText(),
                ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // SSW declarator list
    @Override
    public Object visitSswDeclaratorList(SswDeclaratorListContext ctx) {
        if (ctx != null) {
            for (SswDeclaratorContext sswDeclaratorContext : ctx.sswDeclarator()) {
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
    public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
        for (ThreadScopeContext threadScopeContext : ctx.threadScope()) {
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
        return append(store, ctx);
    }

    @Override
    public Object visitLoadInstruction(LoadInstructionContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
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
        return append(load, ctx);
    }

    @Override
    public Object visitAtomicStoreInstruction(AtomicStoreInstructionContext ctx) {
        MemoryObject object = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        Expression value = (Expression) ctx.value().accept(this);
        String mo = ctx.moRel() != null ? Tag.Vulkan.RELEASE : Tag.Vulkan.ATOM;
        Event store = EventFactory.Vulkan.newStore(object, value, mo);
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
        return append(store, ctx);
    }

    @Override
    public Object visitAtomicLoadInstruction(AtomicLoadInstructionContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
        String mo = ctx.moAcq() != null ? Tag.Vulkan.ACQUIRE : Tag.Vulkan.ATOM;
        Event load = EventFactory.Vulkan.newLoad(register, location, mo);
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
        return append(load, ctx);
    }

    @Override
    public Object visitAtomicRmwInstruction(AtomicRmwInstructionContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        MemoryObject location = programBuilder.getOrNewVirtualMemoryObject(ctx.location().getText());
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
        return append(rmw, ctx);
    }

    @Override
    public Object visitMemoryBarrierInstruction(MemoryBarrierInstructionContext ctx) {
        final String mo = getMemoryOrderOrDefault(ctx, null);
        final String scope = ctx.scope().content;
        final List<String> semantics = ctx.semSc().stream().map(c -> c.content).toList();
        final boolean av = ctx.semAv() != null;
        final boolean vis = ctx.semVis() != null;
        return append(EventFactory.Vulkan.newMemoryBarrier(mo, scope, semantics, av, vis), ctx);
    }

    @Override
    public Object visitControlBarrierInstruction(ControlBarrierInstructionContext ctx) {
        String name = ctx.getText().substring(0, ctx.getText().length() - ctx.constant().getText().length());
        String instanceId = ctx.constant().getText();
        Event barrier;
        if (ctx.barrierId() == null) {
            barrier = EventFactory.newControlBarrier(name, instanceId, Tag.Vulkan.WORK_GROUP);
        } else {
            Expression id = (Expression) ctx.barrierId().accept(this);
            Expression quorum = null;
            if (ctx.barrierQuorum() != null) {
                quorum = (Expression) ctx.barrierQuorum().accept(this);
            }
            barrier = EventFactory.newNamedBarrier(name, instanceId, Tag.Vulkan.WORK_GROUP, id, quorum);
        }
        barrier.addTags(Tag.Vulkan.CBAR, ctx.scope().content);
        String mo = getMemoryOrderOrDefault(ctx, null);
        if (mo == null) {
            barrier.removeTags(Tag.FENCE);
        } else {
            barrier.addTags(mo);
            if (ctx.semAv() != null) {
                barrier.addTags(Tag.Vulkan.SEM_AVAILABLE);
            }
            if (ctx.semVis() != null) {
                barrier.addTags(Tag.Vulkan.SEM_VISIBLE);
            }
            barrier.addTags(ctx.semSc().stream().map(c -> c.content).toList());
        }
        return append(barrier, ctx);
    }

    @Override
    public Object visitLocalInstruction(LocalInstructionContext ctx) {
        Register rd = (Register) ctx.register().accept(this);
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression exp = expressions.makeIntBinary(lhs, ctx.operation().op, rhs);
        return append(EventFactory.newLocal(rd, exp), ctx);
    }

    @Override
    public Object visitLabelInstruction(LabelInstructionContext ctx) {
        return append(programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()), ctx);
    }

    @Override
    public Object visitJumpInstruction(JumpInstructionContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        return append(EventFactory.newGoto(label), ctx);
    }

    @Override
    public Object visitCondJumpInstruction(CondJumpInstructionContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText());
        Expression lhs = (Expression) ctx.value(0).accept(this);
        Expression rhs = (Expression) ctx.value(1).accept(this);
        Expression expr = expressions.makeIntCmp(lhs, ctx.cond().op, rhs);
        return append(EventFactory.newJump(expr, label), ctx);
    }

    @Override
    public Object visitDeviceOperation(DeviceOperationContext ctx) {
        Event e;
        if (ctx.getText().equalsIgnoreCase(Tag.Vulkan.AVDEVICE)) {
            e = EventFactory.Vulkan.newAvDevice();
        } else if (ctx.getText().equalsIgnoreCase(Tag.Vulkan.VISDEVICE)) {
            e = EventFactory.Vulkan.newVisDevice();
        } else {
            throw new ParsingException("Unknown device operation");
        }
        return append(e, ctx);
    }

    private String getMemoryOrderOrDefault(ParserRuleContext ctx, String defaultMo) {
        if (ctx.getRuleContext(MoAcqContext.class, 0) != null) {
            return Tag.Vulkan.ACQUIRE;
        }
        if(ctx.getRuleContext(MoRelContext.class, 0) != null) {
            return Tag.Vulkan.RELEASE;
        }
        if (ctx.getRuleContext(MoAcqRelContext.class, 0) != null) {
            return Tag.Vulkan.ACQ_REL;
        }
        return defaultMo;
    }

    private Event append(Event event, ParserRuleContext ctx) {
        return programBuilder.addChild(mainThread, event, ctx.getStart().getLine());
    }
}