package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
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
        public Expression zeroRegister; // used to have register with value 0

        public CompareExpression() {
            this.zeroRegister = expressions.parseValue("0", integerType);
        }

        public void updateCompareExpression(Register firstRegister, IntCmpOp intCmpOp, Expression secondRegister) {
            this.firstRegister = firstRegister;
            this.secondRegister = secondRegister;
            this.compareExpression = expressions.makeIntCmp(firstRegister, intCmpOp, secondRegister);
        }

        public void updateCompareExpressionOperator(IntCmpOp intCmpOp) {
            this.compareExpression = expressions.makeIntCmp(this.firstRegister, intCmpOp, this.secondRegister);
        }

    }

    private final List<Event> events = new ArrayList<>();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final TypeFactory types = TypeFactory.getInstance();
    private final IntegerType integerType = types.getIntegerType(32);
    private final CompareExpression comparator; // class used to use compare and set flags
    private final HashMap<String, Label> labelsDefined;
    private final HashMap<String, Register> armToLlvmMap; // maps arm names to LLVM names
    private final List<Expression> pendingRegisters; // used to create the final aggregatetype
    // armtollvm part
    private final LinkedList<Register> fnParameters;
    private String[] returnRegisterTypes;
    private final int returnValuesNumber;
    private final int MAX_FN_CALLS = 10; // this is used to keep track of how many fn calls I am going to use -- upper bound for $N

    LinkedList<String> registerNames;

    public VisitorInlineAArch64(Function llvmFunction, Register returnRegister, Type returnType, ArrayList<Expression> argumentsRegisterAddresses) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.comparator = new CompareExpression();
        this.labelsDefined = new HashMap<>();
        this.pendingRegisters = new LinkedList<>();
        this.armToLlvmMap = new HashMap<>();
        this.registerNames = new LinkedList<>();
        // this.fnParameters = new LinkedList<>(argumentsRegisterAddresses);
        this.fnParameters = new LinkedList<>(llvmFunction.getParameterRegisters());
        Collections.reverse(this.fnParameters);
        // todo set this to empty if we see something like (bv 0), as it is going to be a useless fence
        this.returnValuesNumber = initReturnValuesNumberInitReturnRegisterTypes(returnType);
        assert (this.returnValuesNumber >= 0);
        // populateRegisters(armToLlvmMap);
    }

    public List<Event> getEvents() {
        return this.events;
    }

    /* given the VariableInline as String it picks up if it is a 32 or 64 bit */
    public Type getArmVariableSize(String variable) {
        int width = - 1;
        if (variable.length() == 2 || variable.length() == 4) { // can be either $n or [$n]
            return this.fnParameters.getLast().getType(); // get type of $n, which is fnParams[-1]
        } else if (variable.startsWith("${") && variable.endsWith("}")) {
            if (isPartOfReturnRegister(variable)) {
                int number = Integer.parseInt(Character.toString(variable.charAt(2)));
                Type returnRegisterProjectionType = expressions.makeExtract(number, returnRegister).getType();
                return returnRegisterProjectionType;
            }
            char letter = variable.charAt(4);
            switch (letter) {
                case 'w' ->
                    width = 32;
                case 'x' ->
                    width = 64;
                default ->
                    throw new UnsupportedOperationException("Unrecognized pattern for variable : does not fit into ${NUM:x/w}");
            }
        }
        return types.getIntegerType(width);
    }

    //these are used to populate the armToLlvmMap
    private int initReturnValuesNumberInitReturnRegisterTypes(Type returnType) {
        if (returnType instanceof IntegerType || returnType instanceof BooleanType) {
            String[] singleton = {returnType.toString()};
            this.returnRegisterTypes = singleton;
            return 1;
        } else if (returnType instanceof AggregateType at) {
            String str = at.toString();
            this.returnRegisterTypes = str.substring(1, str.length() - 1).trim().split(",");
            return at.getTypeOffsets().size();
        } else if (returnType == null) {
            return 0;
        } else {
            return -1;
        }
    }


    // used if the return is AggregateType (size > 1)
    // has to be changed for armv7
    private boolean isPartOfReturnRegister(String registerName) {
        if (!(registerName.startsWith("${") || registerName.endsWith("}"))) {
            return false;
        }
        int number = Integer.parseInt(Character.toString(registerName.charAt(2)));
        return ((number < this.returnValuesNumber) && (this.returnValuesNumber > 1));
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
            // make the new register
            Type type = getArmVariableSize(nodeName);
            String registerName = makeRegisterName(nodeName);
            Register newRegister = llvmFunction.newRegister(registerName, type);
            this.armToLlvmMap.put(nodeName, newRegister);
            if (isPartOfReturnRegister(nodeName)) {
                this.pendingRegisters.add(newRegister);
            }
            // if (this.nameToRegisterMap.containsKey(nodeName)) {
            //     return this.nameToRegisterMap.get(nodeName);
            // } else {
            //     Type type = getArmVariableSize(nodeName);
            //     String registerName = makeRegisterName(nodeName);
            //     Register newRegister = llvmFunction.newRegister(registerName, type);
            //     this.nameToRegisterMap.put(nodeName, newRegister);
            //     if (isPartOfReturnRegister(nodeName)) {
            //         this.armToLlvmMap.put(nodeName, newRegister);
            //         // int number = Integer.parseInt(Character.toString(nodeName.charAt(2)));
            //         // assignment = expressions.makeExtract(number, returnRegister); // no need to initialize returnRegister at start
            //         this.pendingRegisters.add(newRegister);
            //     } else {
            //         Expression assignment = this.armToLlvmMap.get(nodeName);
            //         if (this.returnRegister == null || !((Register) assignment).equals(this.returnRegister)) {
            //             events.add(EventFactory.newLocal(newRegister, assignment));
            //         }
            //     }
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
        if (registerName.startsWith("${") && registerName.endsWith("}")) {
            int registerId = Integer.parseInt(Character.toString(register.getName().charAt(3)));
            if (registerId == 0 && this.returnValuesNumber == 1) { // it can only match if it is 0:w/x AND return value is single -- the aggregatetype is already covered 
                System.out.println("Return register is " + this.returnRegister.getName() + " And modified one is " + register.getName());
                events.add(EventFactory.newLocal(this.returnRegister, register));
            }
        }
    }

    @Override
    public Object visitAsm(InlineAArch64Parser.AsmContext ctx) {
        int commaPos = ctx.getText().lastIndexOf("\",\"");
        String[] instructions = ctx.getText().substring(0, commaPos).split("\\\\0A"); // Instructions part
        String[] clobbers = ctx.getText().substring(commaPos + 3, ctx.getText().length() - 1).split(","); // Clobbers part, excluding the surrounding quotes
        // we remove all of the "~{}" format flags
        String[] filteredClobbers = Arrays.stream(clobbers).filter(s -> !s.startsWith("~")).toArray(String[]::new);
        boolean pointerAdded = false;
        for (String instruction : instructions) {
            System.out.println(instruction);
            int len = instruction.length();
            for (int i = 0; i < len; i++) {
                char c = instruction.charAt(i);
                if (c == '$') {
                    if (i + 1 < instruction.length() && instruction.charAt(i + 1) == '{') {
                        int closeIndex = instruction.indexOf('}', i);
                        if (closeIndex != -1) {
                            String register = instruction.substring(i, closeIndex + 1);
                            if (!registerNames.contains(register)) {
                                this.registerNames.add(register);
                            }
                            i = closeIndex + 1;
                        }
                    } else if (i + 1 < instruction.length() && Character.isDigit(instruction.charAt(i + 1))) {
                        String register = instruction.substring(i, i + 2);
                        if (!registerNames.contains(register)) {
                            this.registerNames.add(register);
                        }
                        pointerAdded = true;
                    }
                } else if (c == '[' && i + 1 < instruction.length() && instruction.charAt(i + 1) == '$') {
                    int closeIndex = instruction.indexOf(']', i);
                    if (closeIndex != -1) {
                        String register = instruction.substring(i, closeIndex + 1);
                        if (!registerNames.contains(register)) {
                            this.registerNames.add(register);
                        }

                        pointerAdded = true;
                        i = closeIndex + 1;
                    }
                }
            }
        }
        Collections.sort(registerNames);
        if (pointerAdded) { // this is used to check if the list has a $n. I want this one to be the last element in the list
            String pointerRegister = registerNames.removeFirst();
            registerNames.addLast(pointerRegister);
        }
        // for ck we have that [$2] comes before {$0:w}, so we have to put them lastly

        if (!registerNames.isEmpty() && !this.fnParameters.isEmpty()) {
            System.out.println("RegisterNames is " + registerNames);
            int registerNameIndex = 0;
            for (String clobber : filteredClobbers) {
                System.out.println("Current clobber is " + clobber);
                if (clobber.matches("\\d+")) {
                    // https://llvm.org/docs/LangRef.html#input-constraints
                    // For example, a constraint string of “=r,0” says to assign a register for output, and use that register as an input as well (it being the 0’th constraint).
                    // so we have to get the i-th return Value and map it to fnParams
                    int number = Integer.parseInt(clobber);
                    if (number >= 0 && number <= this.returnValuesNumber) {
                        String name = registerNames.get(number);
                        // Map the register to the corresponding function parameter
                        Register toBeChanged = getOrNewRegister(name);
                        System.out.println("Register is going to be assigned" + toBeChanged + " < - " + this.fnParameters.get(registerNameIndex - this.returnValuesNumber));
                        System.out.println("Trying to change the value via local assignment -- read a d+");
                        events.add(EventFactory.newLocal(toBeChanged, this.fnParameters.get(registerNameIndex - this.returnValuesNumber)));
                    } else {
                        System.err.println("The number provided in the clobber is not a valid index for any return value");
                    }
                } else if (clobber.equals("=*m")) {
                    //if clobber is =*m it means that such pointer is a memory location, so we do not map to any register, we just increase registerNameIndex as we don't want to pick it up
                    registerNameIndex++;
                } else {
                    // System.out.println("Evaluating clobber " + clobber + " with registerNameIndex " + registerNameIndex);
                    // if it is a valid clobber create the register
                    String registerName = registerNames.get(registerNameIndex);
                    Register newRegister = getOrNewRegister(registerName);
                    armToLlvmMap.put(this.registerNames.get(registerNameIndex), newRegister);
                    if (clobber.equals("=&r") || clobber.equals("=r")) {
                        // maps to returnValue, so we just skip it and increase the registerNameIndex
                        registerNameIndex++;
                    } else if (clobber.equals("r")) {
                        // it has to be mapped to fnParams do as such
                        System.out.println("Trying to assign to " + newRegister + " expression " + this.fnParameters.get(registerNameIndex - this.returnValuesNumber));
                        events.add(EventFactory.newLocal(newRegister, this.fnParameters.get(registerNameIndex - this.returnValuesNumber)));
                        registerNameIndex++;
                    } else if (clobber.equals("Q")){
                        // we are assured that last one is the pointer needed
                        events.add(EventFactory.newLocal(newRegister, this.fnParameters.getLast()));
                        // we do not increase index as we want to keep in the same fnParam
                    } 
                    else {
                        System.out.println("New type of clobber found, you have to add it! " + clobber);
                    }
                }
            }
        }
        // System.out.println("Currently the map contains " + armToLlvmMap);
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadReg(InlineAArch64Parser.LoadRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLoad(register, address));
        updateReturnRegisterIfModified(register);
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireReg(InlineAArch64Parser.LoadAcquireRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLoadWithMo(register, address, Tag.ARMv8.MO_ACQ));
        updateReturnRegisterIfModified(register);
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadExclusiveReg(InlineAArch64Parser.LoadExclusiveRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newRMWLoadExclusive(register, address));
        updateReturnRegisterIfModified(register);
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireExclusiveReg(InlineAArch64Parser.LoadAcquireExclusiveRegContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.ARMv8.MO_ACQ));
        updateReturnRegisterIfModified(register);
        return visitChildren(ctx);
    }

    @Override
    public Object visitAdd(InlineAArch64Parser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return visitChildren(ctx);
    }

    @Override
    public Object visitSub(InlineAArch64Parser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return visitChildren(ctx);
    }

    @Override
    public Object visitOr(InlineAArch64Parser.OrContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntOr(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return visitChildren(ctx);
    }

    @Override
    public Object visitAnd(InlineAArch64Parser.AndContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntAnd(leftRegister, rightRegister);
        updateReturnRegisterIfModified(resultRegister);
        events.add(EventFactory.newLocal(resultRegister, exp));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReg(InlineAArch64Parser.StoreRegContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newStore(address, value));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseReg(InlineAArch64Parser.StoreReleaseRegContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newStoreWithMo(address, value, Tag.ARMv8.MO_REL));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreExclusiveRegister(InlineAArch64Parser.StoreExclusiveRegisterContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_RX));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseExclusiveReg(InlineAArch64Parser.StoreReleaseExclusiveRegContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_REL));
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompare(InlineAArch64Parser.CompareContext ctx) {
        Register firstRegister = (Register) ctx.register(0).accept(this);
        Register secondRegister = (Register) ctx.register(1).accept(this);
        this.comparator.updateCompareExpression(firstRegister, IntCmpOp.EQ, secondRegister);
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareBranchNonZero(InlineAArch64Parser.CompareBranchNonZeroContext ctx) {
        Register registerLlvm = (Register) ctx.register().accept(this);
        this.comparator.updateCompareExpression(registerLlvm, IntCmpOp.NEQ, this.comparator.zeroRegister);
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }

    @Override
    public Object visitMove(InlineAArch64Parser.MoveContext ctx) {
        Register toRegister = (Register) ctx.register(0).accept(this);
        Register fromRegister = (Register) ctx.register(1).accept(this);
        events.add(EventFactory.newLocal(toRegister, fromRegister));
        updateReturnRegisterIfModified(toRegister);
        return visitChildren(ctx);
    }

    @Override
    public Object visitBranchEqual(InlineAArch64Parser.BranchEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        this.comparator.updateCompareExpressionOperator(IntCmpOp.EQ);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }

    @Override
    public Object visitBranchNotEqual(InlineAArch64Parser.BranchNotEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        this.comparator.updateCompareExpressionOperator(IntCmpOp.NEQ);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }

    @Override
    public Object visitLabelDefinition(InlineAArch64Parser.LabelDefinitionContext ctx) {
        String labelDefinitionNoColumn = ctx.LabelDefinition().getText().replace(":", "");
        Label label = getOrNewLabel(labelDefinitionNoColumn);
        events.add(label);
        return visitChildren(ctx);
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
        return visitChildren(ctx);
    }

    @Override
    public Object visitRegister(InlineAArch64Parser.RegisterContext ctx) {
        return getOrNewRegister(ctx.Register().getText());
    }
}