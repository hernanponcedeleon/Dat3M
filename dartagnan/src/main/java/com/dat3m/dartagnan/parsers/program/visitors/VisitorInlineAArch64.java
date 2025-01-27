package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import org.antlr.v4.runtime.tree.ParseTree;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.InlineAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.InlineAArch64Parser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;

public class VisitorInlineAArch64 extends InlineAArch64BaseVisitor<Object> {

    private class CompareExpression {

        public Expression compareExpression;
        public Register firstRegister;
        public Expression secondRegister;

        public void updateCompareExpression(Register firstRegister, IntCmpOp intCmpOp, Expression secondRegister) {
            this.firstRegister = firstRegister;
            this.secondRegister = secondRegister;
            this.compareExpression = expressions.makeIntCmp(firstRegister, intCmpOp, secondRegister);
        }

        public void updateCompareExpressionOperator(IntCmpOp intCmpOp) {
            this.compareExpression = expressions.makeIntCmp(this.firstRegister, intCmpOp, this.secondRegister);
        }

        public void updateCompareExpressionZero(Register firstRegister, IntCmpOp intCmpOp) {
            this.updateCompareExpression(firstRegister, intCmpOp, expressions.parseValue("0", (IntegerType) firstRegister.getType()));
        }

    }

    private final List<Event> events = new ArrayList<>();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final TypeFactory types = TypeFactory.getInstance();
    private final CompareExpression comparator; // class used to use compare and set flags
    private final HashMap<String, Label> labelsDefined;
    private final HashMap<String, Register> armToLlvmMap; // maps arm names to LLVM names
    private final List<Expression> pendingRegisters; // used to create the final aggregatetype
    private final LinkedList<Expression> fnParameters;
    private final int returnValuesNumber;
    LinkedList<String> registerNames;

    public VisitorInlineAArch64(Function llvmFunction, Register returnRegister, Type returnType, ArrayList<Expression> argumentsRegisterAddresses) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.comparator = new CompareExpression();
        this.labelsDefined = new HashMap<>();
        this.pendingRegisters = new LinkedList<>();
        this.armToLlvmMap = new HashMap<>();
        this.registerNames = new LinkedList<>();
        this.fnParameters = new LinkedList<>(argumentsRegisterAddresses);
        this.returnValuesNumber = initReturnValuesNumber(returnType);
        assert (this.returnValuesNumber >= 0);
    }

    public List<Event> getEvents() {
        return this.events;
    }

    private boolean isArmv8Name(String registerName) {
        return registerName.startsWith("${") && registerName.endsWith("}");
    }

    private boolean isRegisterConstantValue(String nodeName) {
        String innerString = nodeName;
        if (nodeName.startsWith("r")) {
            innerString = nodeName.substring(1);
        }
        return innerString.startsWith("#");
    }

    public Type getArmVariableSize(String registerArmName) {
        int number = extractNumberFromRegisterName(registerArmName);
        if (isPartOfReturnRegister(registerArmName)) {
            if (isReturnRegisterAggregate()) {
                Type returnRegisterProjectionType = expressions.makeExtract(number, returnRegister).getType();
                return returnRegisterProjectionType;
            }
            return this.returnRegister.getType();
        }
        return this.fnParameters.get(number - this.returnValuesNumber).getType();
    }

    private boolean isPartOfReturnRegister(String registerArmName) {
        int number = extractNumberFromRegisterName(registerArmName);
        return (number < this.returnValuesNumber);
    }

    private boolean isReturnRegisterAggregate() {
        return this.returnValuesNumber > 1;
    }

    //these are used to populate the armToLlvmMap
    private int initReturnValuesNumber(Type returnType) {
        if (returnType instanceof IntegerType || returnType instanceof BooleanType) {
            return 1;
        } else if (returnType instanceof AggregateType at) {
            return at.getTypeOffsets().size();
        } else if (returnType instanceof VoidType) {
            return 0;
        } else {
            System.err.println("Unknown inline asm return type " + returnType);
            return -1;
        }
    }

    int extractNumberFromRegisterName(String registerArmName) {
        int number = -1;
        String innerString = registerArmName;
        if (registerArmName.startsWith("r")) {
            innerString = registerArmName.substring(1);
        }
        if (isArmv8Name(innerString)) { // ${N:x}
            number = Integer.parseInt(Character.toString(innerString.charAt(2)));
        } else if (innerString.length() == 2) { // $n
            number = Integer.parseInt(Character.toString(innerString.charAt(1)));
        } else if (innerString.length() == 4) { // [$n]
            number = Integer.parseInt(Character.toString(innerString.charAt(2)));
        }
        return number;
    }

    private Label getOrNewLabel(String labelName) {
        Label label;
        if (this.labelsDefined.containsKey(labelName)) {
            label = this.labelsDefined.get(labelName);
        } else {
            label = EventFactory.newLabel(labelName);
            this.labelsDefined.put(labelName, label);
        }
        return label;
    }

    private Register getOrNewRegister(String nodeName) {
        // if it is not in armToLlvmMap create the new register
        if (this.armToLlvmMap.containsKey(nodeName)) {
            return this.armToLlvmMap.get(nodeName);
        } else {
            Type type = getArmVariableSize(nodeName);
            String registerName = makeRegisterName(nodeName);
            Register newRegister = llvmFunction.newRegister(registerName, type);
            this.armToLlvmMap.put(nodeName, newRegister);
            if (isPartOfReturnRegister(nodeName) && isReturnRegisterAggregate() && !isRegisterConstantValue(nodeName)) {
                this.pendingRegisters.add(newRegister);
            }
            return newRegister;
        }
    }

    private String makeRegisterName(String nodeName) {
        return "r" + nodeName;
    }

    private String cleanLabel(String label) {
        return label.replaceAll("(\\d)[a-z]", "$1");
    }

    private void updateReturnRegisterIfModified(Register register) {
        String registerName = register.getName();
        if (isPartOfReturnRegister(registerName) && !isReturnRegisterAggregate()) {
            events.add(EventFactory.newLocal(this.returnRegister, register));
        }
    }

    @Override
    public List<Event> visitAsm(InlineAArch64Parser.AsmContext ctx) {
        List<InlineAArch64Parser.AsmInstrEntriesContext> instructions = ctx.asmInstrEntries();
        // TODO when adding new architecture it has to be a little bit different --instr := aarch | x86 | riscv | ppc
        for (InlineAArch64Parser.AsmInstrEntriesContext instruction : instructions) {
            InlineAArch64Parser.ArmInstrContext instrCtx = instruction.armInstr();
            if (instrCtx != null) {
                collectRegisters(instrCtx);
            }
        }
        registerNames.sort((s1, s2) -> Integer.compare(extractNumberFromRegisterName(s1), extractNumberFromRegisterName(s2)));

        ArrayList<String> clobbers = new ArrayList<>();
        List<InlineAArch64Parser.AsmMetadataEntriesContext> metadataEntries = ctx.asmMetadataEntries();
        for (InlineAArch64Parser.AsmMetadataEntriesContext metadataEntry : metadataEntries) {
            List<InlineAArch64Parser.MetaInstrContext> metaInstrs = metadataEntry.metaInstr();
            for (InlineAArch64Parser.MetaInstrContext metaInstr : metaInstrs) {
                if (metaInstr.clobber() != null) {
                    clobbers.add(metaInstr.clobber().getText());
                }
            }
        }
        if (!registerNames.isEmpty() && !this.fnParameters.isEmpty()) {
            // System.out.println("RegisterNames is " + registerNames);
            // System.out.println("Fn params are " + this.fnParameters);
            // System.out.println("Clobbers are " + clobbers);
            int registerNameIndex = 0;
            for (String clobber : clobbers) {
                System.out.println("Current clobber is " + clobber);
                if (clobber.matches("\\d+")) {
                    processNumericClobber(clobber, registerNameIndex);
                    registerNameIndex++;
                } else if (clobber.equals("=*m")) {
                    //if clobber is =*m it means that such pointer is a memory location, so we do not map to any register
                } else {
                    processGeneralPurposeClobber(clobber, registerNameIndex);
                    registerNameIndex++;
                }
            }
        }
        visitChildren(ctx);
        return this.events;
    }

    private void collectRegisters(ParseTree node) {
        if (node == null) {
            return;
        } else if (node instanceof InlineAArch64Parser.RegisterContext) {
            String registerName = node.getText();
            if (registerName != null && !registerNames.contains(registerName) && !isRegisterConstantValue(registerName)) {
                registerNames.add(registerName);
            }
        }
        for (int i = 0; i < node.getChildCount(); i++) {
            collectRegisters(node.getChild(i));
        }
    }

    private void processNumericClobber(String clobber, int registerNameIndex) {
        // https://llvm.org/docs/LangRef.html#input-constraints
        // For example, a constraint string of “=r,1” says to assign a register for output, and use that register as an input as well (it being the 1st constraint).
        // so we have to get the i-th return Value and map it to fnParams
        int number = Integer.parseInt(clobber);
        if (number < 0 || number > this.returnValuesNumber) {
            System.err.println("The number provided in the clobber is not a valid index for any return value");
            return;
        }
        String name = registerNames.get(number);
        Register toBeChanged = getOrNewRegister(name);
        System.out.println("Register is going to be assigned " + toBeChanged.getName() + " < - " + this.fnParameters.get(registerNameIndex - this.returnValuesNumber));
        events.add(EventFactory.newLocal(toBeChanged, this.fnParameters.get(registerNameIndex - this.returnValuesNumber)));
    }

    private void processGeneralPurposeClobber(String clobber, int registerNameIndex) {
        String registerName = registerNames.get(registerNameIndex);
        Register newRegister = getOrNewRegister(registerName);
        armToLlvmMap.put(registerName, newRegister);
        if (clobber.equals("=&r") || clobber.equals("=r")) {
            // Clobber maps to returnValue, we just skip it as we are assigning them later
        } else if (clobber.equals("r") || clobber.equals("Q") || clobber.equals("*Q")) {
            int number = extractNumberFromRegisterName(registerName);
            System.out.println("Trying to assign to " + newRegister + " expression " + this.fnParameters.get(number - this.returnValuesNumber));
            events.add(EventFactory.newLocal(newRegister, this.fnParameters.get(number - this.returnValuesNumber)));
        } else {
            System.err.println("New type of clobber found, you have to add it! " + clobber);
        }
    }

    @Override
    public Object visitLoadReg(InlineAArch64Parser.LoadRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLoad(register, address));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadAcquireReg(InlineAArch64Parser.LoadAcquireRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLoadWithMo(register, address, Tag.ARMv8.MO_ACQ));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadExclusiveReg(InlineAArch64Parser.LoadExclusiveRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newRMWLoadExclusive(register, address));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadAcquireExclusiveReg(InlineAArch64Parser.LoadAcquireExclusiveRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.ARMv8.MO_ACQ));
        updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitAdd(InlineAArch64Parser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitSub(InlineAArch64Parser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitOr(InlineAArch64Parser.OrContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntOr(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitAnd(InlineAArch64Parser.AndContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntAnd(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitStoreReg(InlineAArch64Parser.StoreRegContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newStore(address, value));
        return null;
    }

    @Override
    public Object visitStoreReleaseReg(InlineAArch64Parser.StoreReleaseRegContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newStoreWithMo(address, value, Tag.ARMv8.MO_REL));
        return null;
    }

    @Override
    public Object visitStoreExclusiveRegister(InlineAArch64Parser.StoreExclusiveRegisterContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_RX));
        return null;
    }

    @Override
    public Object visitStoreReleaseExclusiveReg(InlineAArch64Parser.StoreReleaseExclusiveRegContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_REL));
        return null;
    }

    @Override
    public Object visitCompare(InlineAArch64Parser.CompareContext ctx) {
        Register firstRegister = (Register) ctx.register(0).accept(this);
        Register secondRegister = (Register) ctx.register(1).accept(this);
        if (isRegisterConstantValue(secondRegister.getName())) {
            this.comparator.updateCompareExpressionZero(firstRegister, IntCmpOp.EQ);
        } else {
            this.comparator.updateCompareExpression(firstRegister, IntCmpOp.EQ, secondRegister);
        }
        return null;
    }

    @Override
    public Object visitCompareBranchNonZero(InlineAArch64Parser.CompareBranchNonZeroContext ctx) {
        Register registerLlvm = (Register) ctx.register().accept(this);
        this.comparator.updateCompareExpressionZero(registerLlvm, IntCmpOp.NEQ);
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return null;
    }

    @Override
    public Object visitMove(InlineAArch64Parser.MoveContext ctx) {
        Register toRegister = (Register) ctx.register(0).accept(this);
        Register fromRegister = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLocal(toRegister, fromRegister));
        updateReturnRegisterIfModified(toRegister);
        return null;
    }

    @Override
    public Object visitBranchEqual(InlineAArch64Parser.BranchEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        this.comparator.updateCompareExpressionOperator(IntCmpOp.EQ);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return null;
    }

    @Override
    public Object visitBranchNotEqual(InlineAArch64Parser.BranchNotEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        this.comparator.updateCompareExpressionOperator(IntCmpOp.NEQ);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return null;
    }

    @Override
    public Object visitLabelDefinition(InlineAArch64Parser.LabelDefinitionContext ctx) {
        String labelDefinitionNoColumn = ctx.LabelDefinition().getText().replace(":", "");
        Label label = getOrNewLabel(labelDefinitionNoColumn);
        events.add(label);
        return null;
    }

    @Override
    public Object visitAsmMetadataEntries(InlineAArch64Parser.AsmMetadataEntriesContext ctx) {
        if (this.returnValuesNumber > 1) {
            List<Type> typesList = new LinkedList<>();
            for (Expression r : this.pendingRegisters) {
                typesList.add(((Register) r).getType());
            }
            Type aggregateType = types.getAggregateType(typesList);
            Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
            events.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
        }
        return null;
    }

    @Override
    public Object visitRegister(InlineAArch64Parser.RegisterContext ctx) {
        return getOrNewRegister(ctx.Register().getText());
    }

    @Override
    public Object visitAsmFence(InlineAArch64Parser.AsmFenceContext ctx) {
        System.out.println("Fence is " + ctx.getText());
        // check which type of fence it is : DataMemoryBarrier or DataSynchronizationBarrier
        String type = ctx.DataMemoryBarrier() == null ? ctx.DataSynchronizationBarrier().getText() : ctx.DataMemoryBarrier().getText();
        String option = ctx.FenceArmOpt().getText();
        String barrier = type + " " + option;
        switch (barrier) {
            case "dmb ish" ->
                events.add(EventFactory.AArch64.DMB.newISHBarrier());
            case "dmb ishld" ->
                events.add(EventFactory.AArch64.DMB.newISHLDBarrier());
            case "dmb sy" ->
                events.add(EventFactory.AArch64.DMB.newSYBarrier());
            case "dmb st" -> 
                events.add(EventFactory.AArch64.DMB.newSTBarrier());
            case "dmb ishst" ->
                events.add(EventFactory.AArch64.DMB.newISHSTBarrier());
            case "dsb ish" ->
                events.add(EventFactory.AArch64.DSB.newISHBarrier());
            case "dsb ishld" ->
                events.add(EventFactory.AArch64.DSB.newISHLDBarrier());
            case "dsb sy" ->
                events.add(EventFactory.AArch64.DSB.newSYBarrier());
            case "dsb ishst" ->
                events.add(EventFactory.AArch64.DSB.newISHSTBarrier());
            default ->
                System.err.println("Barrier not implemented");
        }
        return null;
    }

    @Override
    public Object visitRiscvFence(InlineAArch64Parser.RiscvFenceContext ctx) {
        String type = ctx.RISCVFence().getText();
        String firstOption = ctx.FenceRISCVOpt(0).getText();
        String secondOption = ctx.FenceRISCVOpt(1) == null ? "" : ctx.FenceRISCVOpt(1).getText();
        String barrier = type + " " + firstOption + " " + secondOption;
        switch (barrier) {
            case "fence r r" ->
                events.add(EventFactory.RISCV.newRRFence());
            case "fence r w" ->
                events.add(EventFactory.RISCV.newRWFence());
            case "fence r rw" ->
                events.add(EventFactory.RISCV.newRRWFence());
            case "fence w r" ->
                events.add(EventFactory.RISCV.newWRFence());
            case "fence w w" ->
                events.add(EventFactory.RISCV.newWWFence());
            case "fence w rw" ->
                events.add(EventFactory.RISCV.newWRWFence());
            case "fence rw r" ->
                events.add(EventFactory.RISCV.newRWRFence());
            case "fence rw w" ->
                events.add(EventFactory.RISCV.newRWWFence());
            case "fence rw rw" ->
                events.add(EventFactory.RISCV.newRWRWFence());
            case "fence tso" ->
                events.add(EventFactory.RISCV.newTsoFence());
            case "fence i" ->
                events.add(EventFactory.RISCV.newSynchronizeFence());
            default ->
                System.err.println("Barrier not implemented");
        }
        return visitChildren(ctx);
    }

    @Override
    public Object visitX86Fence(InlineAArch64Parser.X86FenceContext ctx) {
        String barrier = ctx.X86Fence().getText();
        switch (barrier) {
            case "mfence" ->
                events.add(EventFactory.X86.newMemoryFence());
            default ->
                System.err.println("Barrier not implemented");
        }
        return visitChildren(ctx);
    }

    @Override
    public Object visitPpcFence(InlineAArch64Parser.PpcFenceContext ctx) {
        String barrier = ctx.PPCFence().getText();
        switch (barrier) {
            case "sync" ->
                events.add(EventFactory.Power.newSyncBarrier());
            case "isync" ->
                events.add(EventFactory.Power.newISyncBarrier());
            case "lwsync" ->
                events.add(EventFactory.Power.newLwSyncBarrier());
            default ->
                System.err.println("Barrier not implemented");
        }
        return visitChildren(ctx);
    }
}
