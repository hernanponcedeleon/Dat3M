package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.IValue;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.*;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import static com.dat3m.dartagnan.GlobalSettings.getArchPrecision;

import com.dat3m.dartagnan.program.event.core.Fence;
import com.dat3m.dartagnan.program.event.core.Load;
import com.dat3m.dartagnan.program.event.core.Store;
import com.dat3m.dartagnan.program.event.lang.linux.RMWFetchOp;
import com.dat3m.dartagnan.program.event.lang.linux.RMWOp;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;

public class VisitorLitmusPTX
        extends LitmusPTXBaseVisitor<Object> {
    private final ProgramBuilder programBuilder;
    private int mainThread;
    private int threadCount = 0;

    private HashMap<String, HashSet<String>> proxyMap = new HashMap<>();
    // key: variable name, value: proxy types. Add values as filters to relevant load

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
        programBuilder.initLocEqConst(ctx.location().getText(),
                new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision()));
        proxyMap.putIfAbsent(ctx.location().getText(), new HashSet<>(Arrays.asList(Tag.PTX.GEN)));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPTXParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPTXParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), getArchPrecision());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusPTXParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Proxy declarator list
    @Override
    public Object visitVariableDeclaratorProxy(LitmusPTXParser.VariableDeclaratorProxyContext ctx) {
        if (ctx.proxyType().content.equals(Tag.PTX.GEN)) {
            programBuilder.initLocEqLocAliasGen(ctx.location(0).getText(),
                    ctx.location(1).getText());
        } else {
            programBuilder.initLocEqLocAliasProxy(ctx.location(0).getText(),
                    ctx.location(1).getText());
        }
        proxyMap.putIfAbsent(ctx.location(0).getText(),
                new HashSet<>(Arrays.asList(ctx.proxyType().content)));
        return null;
    }

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
    public Object visitStoreConstant(LitmusPTXParser.StoreConstantContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Store instruction doesn't support sem: " + ctx.sem().content);
        }
        Store store = EventFactory.PTX.newTaggedStore(object, constant, sem, scope);
        store.addFilters(ctx.store().storeProxy);
        store.addFilters(Tag.PTX.CON);
        if (proxyMap.containsKey(ctx.location().getText())) {
            HashSet<String> proxies = proxyMap.get(ctx.location().getText());
            proxies.add(Tag.PTX.CON);
            store.addFilters(proxies);
        } else {
            HashSet<String> proxies = new HashSet<>(Arrays.asList(Tag.PTX.CON));
            proxyMap.put(ctx.location().getText(), proxies);
        }
        return programBuilder.addScopedChild(mainThread, store);
    }

    @Override
    public Object visitStoreRegister(LitmusPTXParser.StoreRegisterContext ctx){
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak store instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Store instruction doesn't support sem: " + ctx.sem().content);
        }
        Store store = EventFactory.PTX.newTaggedStore(object, register, sem, scope);
        store.addFilters(ctx.store().storeProxy);
        if (proxyMap.containsKey(ctx.location().getText())) {
            HashSet<String> proxies = proxyMap.get(ctx.location().getText());
            proxies.add(ctx.store().storeProxy);
            store.addFilters(proxies);
        } else {
            HashSet<String> proxies = new HashSet<>(Arrays.asList(ctx.store().storeProxy));
            proxyMap.put(ctx.location().getText(), proxies);
        }
        return programBuilder.addScopedChild(mainThread, store);
    }

    @Override
    public Object visitLoadConstant(LitmusPTXParser.LoadConstantContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.ACQ) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Load instruction doesn't support sem: " + ctx.sem().content);
        }
        return programBuilder.addChild(mainThread, EventFactory.newLocal(register, constant));
    }

    @Override
    public Object visitLoadLocation(LitmusPTXParser.LoadLocationContext ctx){
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        MemoryObject location = programBuilder.getOrNewObject(ctx.location().getText());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.WEAK)) {
            if (ctx.scope() != null) {
                throw new ParsingException("Weak load instruction doesn't need scope: " + ctx.scope().content);
            }
            scope = Tag.PTX.SYS;
        } else if (sem.equals(Tag.PTX.ACQ) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Load instruction doesn't support sem: " + ctx.sem().content);
        }
        Load load = EventFactory.PTX.newTaggedLoad(register, location, sem, scope);
        load.addFilters(ctx.load().loadProxy);
        if (proxyMap.containsKey(ctx.location().getText())) {
            load.addFilters(proxyMap.get(ctx.location().getText()));
        }
        return programBuilder.addScopedChild(mainThread, load);
    }

    @Override
    public Object visitAtomConstant(LitmusPTXParser.AtomConstantContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Atom instruction doesn't support sem: " + ctx.sem().content);
        }
        RMWFetchOp atom = EventFactory.PTX.newTaggedAtomOp(object, register_destination, constant, op, sem, scope);
        atom.addFilters(ctx.atom().atomProxy);
        if (proxyMap.containsKey(ctx.location().getText())) {
            HashSet<String> proxies = proxyMap.get(ctx.location().getText());
            proxies.add(ctx.atom().atomProxy);
            atom.addFilters(proxies);
        } else {
            HashSet<String> proxies = new HashSet<>(Arrays.asList(ctx.atom().atomProxy));
            proxyMap.put(ctx.location().getText(), proxies);
        }
        return programBuilder.addScopedChild(mainThread, atom);
    }

    @Override
    public Object visitAtomRegister(LitmusPTXParser.AtomRegisterContext ctx) {
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(0).getText(), getArchPrecision());
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().get(1).getText(), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Atom instruction doesn't support sem: " + ctx.sem().content);
        }
        RMWFetchOp atom = EventFactory.PTX.newTaggedAtomOp(object, register_destination, register_operand, op, sem, scope);
        atom.addFilters(ctx.atom().atomProxy);
        if (proxyMap.containsKey(ctx.location().getText())) {
            HashSet<String> proxies = proxyMap.get(ctx.location().getText());
            proxies.add(ctx.atom().atomProxy);
            atom.addFilters(proxies);
        } else {
            HashSet<String> proxies = new HashSet<>(Arrays.asList(ctx.atom().atomProxy));
            proxyMap.put(ctx.location().getText(), proxies);
        }
        return programBuilder.addScopedChild(mainThread, atom);
    }

    @Override
    public Object visitRedConstant(LitmusPTXParser.RedConstantContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        IValue constant = new IValue(new BigInteger(ctx.constant().getText()), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Red instruction doesn't support sem: " + ctx.sem().content);
        }
        RMWOp red = EventFactory.PTX.newTaggedRedOp(object, register_destination, constant, op, sem, scope);
        red.addFilters(ctx.red().redProxy);
        if (proxyMap.containsKey(ctx.location().getText())) {
            HashSet<String> proxies = proxyMap.get(ctx.location().getText());
            proxies.add(ctx.red().redProxy);
            red.addFilters(proxies);
        } else {
            HashSet<String> proxies = new HashSet<>(Arrays.asList(ctx.red().redProxy));
            proxyMap.put(ctx.location().getText(), proxies);
        }
        return programBuilder.addScopedChild(mainThread, red);
    }

    @Override
    public Object visitRedRegister(LitmusPTXParser.RedRegisterContext ctx) {
        MemoryObject object = programBuilder.getOrNewObject(ctx.location().getText());
        Register register_operand = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), getArchPrecision());
        IOpBin op = IOpBin.valueOf(ctx.operation().content);
        Register register_destination = programBuilder.getOrCreateRegister(mainThread, null, getArchPrecision());
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.RLX)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Red instruction doesn't support sem: " + ctx.sem().content);
        }
        RMWOp red = EventFactory.PTX.newTaggedRedOp(object, register_destination, register_operand, op, sem, scope);
        red.addFilters(ctx.red().redProxy);
        if (proxyMap.containsKey(ctx.location().getText())) {
            HashSet<String> proxies = proxyMap.get(ctx.location().getText());
            proxies.add(ctx.red().redProxy);
            red.addFilters(proxies);
        } else {
            HashSet<String> proxies = new HashSet<>(Arrays.asList(ctx.red().redProxy));
            proxyMap.put(ctx.location().getText(), proxies);
        }
        return programBuilder.addScopedChild(mainThread,red);
    }

    @Override
    public Object visitFencePhysic(LitmusPTXParser.FencePhysicContext ctx){
        String sem = ctx.sem().content;
        String scope;
        if (sem.equals(Tag.PTX.ACQ_REL) || sem.equals(Tag.PTX.SC)) {
            scope = ctx.scope().content;
        } else {
            throw new ParsingException("Fence instruction doesn't support sem: " + ctx.sem().content);
        }
        Fence fence = EventFactory.PTX.newTaggedFence(sem, scope);
        return programBuilder.addScopedChild(mainThread, fence);
    }

    @Override
    public Object visitFenceProxy(LitmusPTXParser.FenceProxyContext ctx) {
        Fence fence = EventFactory.newFence(Tag.PTX.PROXY);
        fence.addFilters(ctx.proxyType().content);
        return programBuilder.addScopedChild(mainThread, fence);
    }

    @Override
    public Object visitFenceAlias(LitmusPTXParser.FenceAliasContext ctx) {
        Fence fence = EventFactory.newFence(Tag.PTX.PROXY);
        fence.addFilters(Tag.PTX.GEN);
        fence.addFilters(Tag.PTX.ALIAS);
        return programBuilder.addScopedChild(mainThread, fence);
    }
}