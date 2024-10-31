package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.List;

import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.InlineAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.InlineAArch64Parser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;


public class VisitorInlineAArch64 extends InlineAArch64BaseVisitor<Object> {

    private enum MemoryOrder {
        RELAXED("RLX"),
        ACQUIRE("ACQ"),
        RELEASE("REL"),
        SEQUENTIAL("SEQ");
    
        private final String value;
    
        MemoryOrder(String value) {
            this.value = value;
        }
    
        public String getValue() {
            return value;
        }
    }
    
    private final List<Event> events = new ArrayList();
    private final Function llvmFunction;
    private final Type archType = TypeFactory.getInstance().getIntegerType(64);

    public VisitorInlineAArch64(Function llvmFunction) {
        this.llvmFunction = llvmFunction;
    }

    public List<Event> getEvents(){
        return this.events;
    }
    
    /* given the VariableInline as String it picks up if it is a 32 or 64 bit */
    public Type getMemoryOrderGivenVariable(String variable){
        int width = - 1;
        if (variable.startsWith("${") && variable.endsWith("}")){
            char letter = variable.charAt(4);
            switch (letter) {
                case 'w' -> width = 32;
                case 'x' -> width = 64;
                default -> throw new UnsupportedOperationException("Unrecognized pattern for variable : does not fit into ${NUM:x/w}");
            }
        } else if (variable.length() == 2){
            width = 32; // assuming that $1,$2 are 32 bit
        }
        return TypeFactory.getInstance().getIntegerType(width);
    }

    @Override
    public Object visitLoadReg(InlineAArch64Parser.LoadRegContext ctx) {
        String regString = ctx.VariableInline().getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.RELAXED;
        events.add(EventFactory.newLoadWithMo(register,address,mo.getValue()));
        System.out.println("Added " + events.toString());
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireReg(InlineAArch64Parser.LoadAcquireRegContext ctx) {
        String regString = ctx.VariableInline().getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.ACQUIRE;
        events.add(EventFactory.newLoadWithMo(register,address,mo.getValue()));
        System.out.println("Added " + events.toString());
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadExclusiveReg(InlineAArch64Parser.LoadExclusiveRegContext ctx) {
        // for now LDR and LDXR are the same from Memory Ordering point of view
        // as in Libvsync source code there is no generation with Exclusive mode 
        String regString = ctx.VariableInline().getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.RELAXED;
        events.add(EventFactory.newLoadWithMo(register,address,mo.getValue()));
        System.out.println("Added " + events.toString());
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireExclusiveReg(InlineAArch64Parser.LoadAcquireExclusiveRegContext ctx) {
        String regString = ctx.VariableInline().getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.ACQUIRE;
        events.add(EventFactory.newLoadWithMo(register,address,mo.getValue()));
        System.out.println("Added " + events.toString());
        return visitChildren(ctx);
    }

    @Override
    public Object visitAdd(InlineAArch64Parser.AddContext ctx) {
        System.out.println("Add");
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReg(InlineAArch64Parser.StoreRegContext ctx) {
        String regString = ctx.VariableInline().getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.RELAXED;
        events.add(EventFactory.newStoreWithMo(register,address,mo.getValue()));
        return visitChildren(ctx);
    }


    @Override
    public Object visitStoreExclusiveRegister(InlineAArch64Parser.StoreExclusiveRegisterContext ctx) {
        String result = ctx.VariableInline(0).getText(); // this register either holds 0 or 1 if the operation was successful or not, for now I'm collecting it but it is not needed
        String regString = ctx.VariableInline(1).getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.RELAXED;
        events.add(EventFactory.newStoreWithMo(register,address,mo.getValue()));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseExclusiveReg(InlineAArch64Parser.StoreReleaseExclusiveRegContext ctx) {
        String result = ctx.VariableInline(0).getText();
        String regString = ctx.VariableInline(1).getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.RELEASE;
        events.add(EventFactory.newStoreWithMo(register,address,mo.getValue()));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseReg(InlineAArch64Parser.StoreReleaseRegContext ctx) {
        // this one breaks apparently randomly.. or I did not get how to make events
        // reference run ttaslock.ll (write_rel function) and hclhlock.ll and see that...
        String regString = ctx.VariableInline().getText();
        String addrString = ctx.ConstantInline().getText();
        Register register = llvmFunction.getOrNewRegister(regString, getMemoryOrderGivenVariable(regString));
        Register address = llvmFunction.getOrNewRegister(addrString, getMemoryOrderGivenVariable(addrString));
        MemoryOrder mo = MemoryOrder.RELEASE;
        events.add(EventFactory.newStore(register, address));
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
