package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

import org.antlr.v4.runtime.tree.TerminalNode;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
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
        public boolean storeSucceeded; // holds 0 if last store was successful
        public Expression zeroRegister; // used to have register with value 0

        public CompareExpression() {
            this.storeSucceeded = false;
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

        public void updateStoreSucceeded(Register register) {
            // TODO simulate always success, for now it is ok tho
            this.storeSucceeded = true;
        }
    }

    private class ArmToLlvmRegisterMapping {

        // the rule is like this 
        // $n means r0, n \in Nats to "keep an id of the function"
        // the first ${n:w}s are used to lock return values e.g. ${0:w}, ${1:w} means it is going to return 2 values in LLVM (if we're in a void fn we skip it)
        // the other ones are the remaining args
        // It should be n:w for 32 bit and n:x for 64 bit, but to make it easier I just allocate every type to be ok
        // now mapped to the real registers of llvm function
        private final List<Register> fnParameters;
        private final Register returnRegister;
        private String[] returnRegisterTypes;
        private final int returnValuesNumber;
        private final HashMap<String, Register> armToLlvmMap;
        private final int MAX_FN_CALLS = 10; // this is used to keep track of how many fn calls I am going to use -- upper bound for $N

        public ArmToLlvmRegisterMapping(Function llvmFunction, Type returnType, Register returnRegister, ArrayList<Expression> argumentsRegisterAddresses) {
            this.armToLlvmMap = new HashMap<>();
            this.returnRegister = returnRegister;
            this.fnParameters = llvmFunction.getParameterRegisters(); // these hold the original fn arguments
            // this one below is used to get the last registers allocated before "call asm"
            // Collections.reverse(argumentsRegisterAddresses); // they are usually pushed in stack in the llvm fn
            // this.fnParameters = new LinkedList<>();
            // for (Expression e : argumentsRegisterAddresses) {
            //     this.fnParameters.add((Register) e);
            // }
            this.returnValuesNumber = assignReturnValues(returnType);
            assert (this.returnValuesNumber >= 0);
            // now we have to fill our map following the llvm rule 
            // every $ is going to map to r0
            populateRegisters(armToLlvmMap);
            // System.out.println("State is " + armToLlvmMap);
        }

        public Register getLlvmRegister(String armName) {
            return this.armToLlvmMap.get(armName);
        }

        public void put(String key, Register value){
            this.armToLlvmMap.put(key, value);
        }

        public int getReturnValuesNumber() {
            return this.returnValuesNumber;
        }

        private int assignReturnValues(Type returnType) {
            if (returnType == null) { //its a void fn
                return 0;
            }
            String str = returnType.toString();
            if (str.equals("bv32") || str.equals("bv64")) {
                String[] singleton = {str};
                this.returnRegisterTypes = singleton;
                return 1;
            } else if (str.startsWith("{") && str.endsWith("}")) {
                String content = str.substring(1, str.length() - 1).trim(); // Remove curly braces
                this.returnRegisterTypes = content.split(","); // Split by commas
                return this.returnRegisterTypes.length;
            }
            return -1;
        }

        private void populateRegisters(HashMap<String, Register> llvmToArmMap) {
            for (int i = 0; i < this.MAX_FN_CALLS; i++) {
                String key = String.format("$%d", i);
                Register value = this.fnParameters.get(0);
                llvmToArmMap.put(key, value);
            }
            if (returnRegister == null) {
                // if it is a void just push the parameters in
                for (int i = 0; i < this.fnParameters.size() - 1; i++) {
                    String key = String.format("${%d:w}", i);
                    String keyLong = String.format("${%d:x}", i);
                    int j = i + 1;
                    Register value = fnParameters.get(j);
                    llvmToArmMap.put(key, value);
                    llvmToArmMap.put(keyLong, value);
                }
            } else {
                // if it is just one we're fine, otherwise we have to do some aggregation dark magic
                // no more ghost registers now.
                if (returnRegisterTypes.length == 1) {
                    // if it is just one, put it into the map
                    String key = String.format("${%d:w}", 0);
                    Type type = getTypeGivenString(this.returnRegisterTypes[0]);
                    if (type.toString().equals("bv64")) {
                        key = key.replace("w", "x");
                    }
                    llvmToArmMap.put(key, this.returnRegister);
                } else {
                    // some logic with aggregate types, I have to keep track of them and assign at the end of instruction pass...
                    // for (int i = 0; i < this.returnValuesNumber; i++) {
                    //     String key = String.format("${%d:w}", 0);
                    //     Type type = getTypeGivenString(this.returnRegisterTypes[0]);
                    //     if (type.toString().equals("bv64")) {
                    //         key = key.replace("w", "x");
                    //     }
                    //     System.out.println("actual key is " + key);
                    //     llvmToArmMap.put(key, returnRegister);
                        // String key = String.format("${%d:w}", i);
                        // Type type = getTypeGivenString(this.returnRegisterTypes[i]);
                        // if (type.toString().trim().equals("bv64")) {
                        //     key = key.replace("w", "x");
                        // }
                        // if(returnRegister.getType() instanceof AggregateType){
                        //     Expression first = expressions.makeExtract(0,returnRegister);
                        //     Expression second = expressions.makeExtract(1,returnRegister);
                        //     List<Expression> typesList = List.of(first,second);
                        //     Event e = EventFactory.newLocal(returnRegister, expressions.makeConstruct(typesList));
                        //     System.out.println("Event custom is "+ e);
                        // }
                        // Expression exp = expressions.makeExtract(i,returnRegister); // I have to use this
                        // String regName = String.format(returnRegister.getName() + "[%d]", i);
                        // Register value = llvmFunction.newRegister(regName, exp.getType());
                        // llvmToArmMap.put(key, value);
                    // }
                }
                // from where you left, continue and fill the fn parameters skipping r0 because it is already mapped
                int registerCounter = 1;
                for (int i = returnValuesNumber; i < returnValuesNumber + fnParameters.size() - 1; i++) {
                    String key = String.format("${%d:w}", i);
                    Register value = fnParameters.get(registerCounter);
                    Type type = value.getType();
                    if (type.toString().equals("bv64")) {
                        key = key.replace("w", "x");
                    }
                    registerCounter++;
                    llvmToArmMap.put(key, value);
                }
            }
        }

        private Type getTypeGivenString(String typeString) {
            Type res = integerType;
            String trimmed = typeString.trim();
            if (trimmed.equals("ptr")) {
                res = types.getPointerType();
            } else if (trimmed.equals("bv64")) {
                res = types.getIntegerType(64);
            }
            return res;
        }
    }

    private final List<Event> events = new ArrayList();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final TypeFactory types = TypeFactory.getInstance();
    private final IntegerType integerType = types.getIntegerType(32);
    private final CompareExpression comparator; // class used to use compare and set flags
    private final HashMap<String, Label> labelsDefined;
    private final ArmToLlvmRegisterMapping armToLlvmMap; // maps arm names to LLVM names
    private final HashMap<String, Register> nameToRegisterMap; // maps arm register to dummy ones
    private final List<Expression> pendingRegisters; // used to create the final aggregatetype

    public VisitorInlineAArch64(Function llvmFunction, Register returnRegister, Type returnType, ArrayList<Expression> argumentsRegisterAddresses) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.comparator = new CompareExpression();
        this.labelsDefined = new HashMap<>();
        this.nameToRegisterMap = new HashMap<>();
        this.pendingRegisters = new LinkedList<>();
        this.armToLlvmMap = new ArmToLlvmRegisterMapping(llvmFunction, returnType, returnRegister, argumentsRegisterAddresses);
    }

    public List<Event> getEvents() {
        return this.events;
    }

    private Expression getReturnRegisterUpdate() {
        int registerReturnValuesNumber = armToLlvmMap.getReturnValuesNumber();
        LinkedList<Expression> expressionList = new LinkedList<>();
        for (int i = 0; i < registerReturnValuesNumber; i++) {
            Expression exp = expressions.makeExtract(i, this.returnRegister);
            expressionList.add(exp);
        }
        return expressions.makeConstruct(expressionList);
    }

    /* given the VariableInline as String it picks up if it is a 32 or 64 bit */
    public Type getVariableSize(String variable) {
        int width = - 1;
        if (variable.length() == 2) {
            return this.armToLlvmMap.fnParameters.get(0).getType(); // get type of $n, which is fnParams(0)
            // width = 32; 
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

    // used if the return is AggregateType (size > 1)
    private boolean isPartOfReturnRegister(String registerName) {
        if (!(registerName.startsWith("${") || registerName.endsWith("}"))) {
            return false;
        }
        int number = Integer.parseInt(Character.toString(registerName.charAt(2)));
        int returnValuesNumber = this.armToLlvmMap.getReturnValuesNumber();
        return ((number < returnValuesNumber) && (returnValuesNumber > 1));
    }

    // if the label already exists return it, otherwise create it and append its event
    public Label getOrNewLabel(String labelName) {
        Label label;
        if (this.labelsDefined.containsKey(labelName)) {
            label = this.labelsDefined.get(labelName);
        } else {
            label = EventFactory.newLabel(labelName);
            this.labelsDefined.put(labelName, label);
        }
        return label;
    }

    // this function creates a new register if it does not exist
    // upon creating a new register, if it is not an aggregate type it assigns it with a local
    public Register getOrNewRegister(TerminalNode node) {
        String nodeName = node.getText();
        if (this.nameToRegisterMap.containsKey(nodeName)) {
            return this.nameToRegisterMap.get(nodeName);
        } else {
            Type type = getVariableSize(nodeName);
            Register newRegister = llvmFunction.newRegister(type);
            this.nameToRegisterMap.put(nodeName, newRegister);
            Expression assignment;
            if(isPartOfReturnRegister(nodeName)){
                System.out.println("Accessing part of ret register!!!");
                // I enter here the first time I see a register like 0:w, 1:w AND the return type is Aggregate
                this.armToLlvmMap.put(nodeName, newRegister);
                // System.out.println("New state is " + this.armToLlvmMap.armToLlvmMap);
                // now newLocal with the slice of right value
                int number = Integer.parseInt(Character.toString(nodeName.charAt(2)));
                assignment = expressions.makeExtract(number, returnRegister);
                // events.add(EventFactory.newLocal(newRegister,assignmentExp));
                this.pendingRegisters.add(newRegister);
            } else {
                assignment = this.armToLlvmMap.getLlvmRegister(nodeName);
            }
            events.add(EventFactory.newLocal(newRegister, assignment));
            return newRegister;
        }
    }

    private void updateReturnRegisterIfModified(TerminalNode node){
        Register freshReturnRegister = getOrNewRegister(node);
        String llvmRegisterName = this.armToLlvmMap.getLlvmRegister(node.getText()).getName();
        if(this.armToLlvmMap.getReturnValuesNumber() == 1 && llvmRegisterName.equals(this.returnRegister.getName())){
            System.out.println(" I am accessing the returnValue with register " + freshReturnRegister.getName() + " aka " + llvmRegisterName);
            events.add(EventFactory.newLocal(this.returnRegister,freshReturnRegister));
        }
    }

    @Override
    public Object visitLoadReg(InlineAArch64Parser.LoadRegContext ctx) {
        // this is the base example for an event with sideeffect
        Register freshReturnRegister = getOrNewRegister(ctx.VariableInline());
        Register directMemoryAccess = getOrNewRegister(ctx.ConstantInline());
        events.add(EventFactory.newLoad(freshReturnRegister, directMemoryAccess));
        updateReturnRegisterIfModified(ctx.VariableInline());
        System.out.println("Added visitLoadReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireReg(InlineAArch64Parser.LoadAcquireRegContext ctx) {
        Register freshReturnRegister = getOrNewRegister(ctx.VariableInline());
        Register directMemoryAccess = getOrNewRegister(ctx.ConstantInline());
        String mo = Tag.ARMv8.MO_ACQ;
        events.add(EventFactory.newLoadWithMo(freshReturnRegister, directMemoryAccess, mo));
        updateReturnRegisterIfModified(ctx.VariableInline());
        System.out.println("Added visitLoadAcquireReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadExclusiveReg(InlineAArch64Parser.LoadExclusiveRegContext ctx) {
        Register freshReturnRegister = getOrNewRegister(ctx.VariableInline());
        Register directMemoryAccess = getOrNewRegister(ctx.ConstantInline());
        events.add(EventFactory.newRMWLoadExclusive(freshReturnRegister, directMemoryAccess));
        updateReturnRegisterIfModified(ctx.VariableInline());
        System.out.println("Added visitLoadExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireExclusiveReg(InlineAArch64Parser.LoadAcquireExclusiveRegContext ctx) {
        Register freshReturnRegister = getOrNewRegister(ctx.VariableInline());
        Register directMemoryAccess = getOrNewRegister(ctx.ConstantInline());
        String mo = Tag.ARMv8.MO_ACQ;
        events.add(EventFactory.newRMWLoadExclusiveWithMo(freshReturnRegister, directMemoryAccess, mo));
        updateReturnRegisterIfModified(ctx.VariableInline());
        System.out.println("Added visitLoadAcquireExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAdd(InlineAArch64Parser.AddContext ctx) {
        System.out.println("Add");
        Register resultRegister = getOrNewRegister(ctx.VariableInline(0));
        Register leftRegister = getOrNewRegister(ctx.VariableInline(1));
        Register rightRegister = getOrNewRegister(ctx.VariableInline(2));
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        //An add is a local operation. Can be seen as a store in dat3m internal encoding
        updateReturnRegisterIfModified(ctx.VariableInline(0));
        events.add(EventFactory.newLocal(resultRegister, exp));
        return visitChildren(ctx);
    }
    @Override
    public Object visitStoreReg(InlineAArch64Parser.StoreRegContext ctx) {
        Register firstRegister = getOrNewRegister(ctx.VariableInline());
        Register secondRegister = getOrNewRegister(ctx.ConstantInline());
        events.add(EventFactory.newStore(secondRegister, firstRegister));
        return visitChildren(ctx);
    }
    @Override
    public Object visitStoreReleaseReg(InlineAArch64Parser.StoreReleaseRegContext ctx) {
        Register firstRegister = getOrNewRegister(ctx.VariableInline());
        Register secondRegister = getOrNewRegister(ctx.ConstantInline());
        String mo = Tag.ARMv8.MO_REL;
        events.add(EventFactory.newStoreWithMo(secondRegister, firstRegister, mo));
        return visitChildren(ctx);
    }
    @Override
    public Object visitStoreExclusiveRegister(InlineAArch64Parser.StoreExclusiveRegisterContext ctx) {
        Register freshResultRegister = getOrNewRegister(ctx.VariableInline(0)); // this register either holds 0 or 1 if the operation was successful or not
        System.out.println("My regs atm are" + this.nameToRegisterMap);
        Expression simulationAllOk = expressions.parseValue("0", integerType); // holds simulation of store going ok
        this.comparator.updateStoreSucceeded(freshResultRegister);
        // this part is used for the store
        Register firstRegister = getOrNewRegister(ctx.VariableInline(1));
        Register secondRegister = getOrNewRegister(ctx.ConstantInline());
        // events.add(EventFactory.newRMWStoreExclusive(secondRegister, firstRegister, true)); // maybe it is another store fn
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, secondRegister, firstRegister, Tag.ARMv8.MO_RX));
        // events.add(EventFactory.newLocal(freshResultRegister, simulationAllOk)); // simulate saving state into register
        return visitChildren(ctx);
    }
    @Override
    public Object visitStoreReleaseExclusiveReg(InlineAArch64Parser.StoreReleaseExclusiveRegContext ctx) {
        Register freshResultRegister = getOrNewRegister(ctx.VariableInline(0)); // this register either holds 0 or 1 if the operation was successful or not
        Expression simulationAllOk = expressions.parseValue("0", integerType); // holds simulation of store going ok
        this.comparator.updateStoreSucceeded(freshResultRegister);
        // this part is used for the store
        Register firstRegister = getOrNewRegister(ctx.VariableInline(1));
        Register secondRegister = getOrNewRegister(ctx.ConstantInline());
        String mo = Tag.ARMv8.MO_REL;
        events.add(EventFactory.Common.newExclusiveStore(freshResultRegister, secondRegister, firstRegister, mo));
        // events.add(EventFactory.newRMWStoreExclusiveWithMo(secondRegister, firstRegister, true, mo)); // maybe it is another store fn
        // events.add(EventFactory.newLocal(freshResultRegister, simulationAllOk)); // simulate saving state into register
        return visitChildren(ctx);
    }
    // @Override
    // public Object visitAtomicAddDoubleWordRelease(InlineAArch64Parser.AtomicAddDoubleWordReleaseContext ctx) {
    //     System.out.println("AtomicAddDoubleWordRelease");
    //     return visitChildren(ctx);
    // }
    @Override
    public Object visitSwapWordAcquire(InlineAArch64Parser.SwapWordAcquireContext ctx) {
        System.out.println("SwapWordAcquire");
        // dummyZero -> 1:w -> r9
        // dummyOne -> 0:w -> r1
        // dummyTwo -> $2 -> r0
        // ldaxr dummyZero, dummyTwo
        // str dummyTwo, dummyOne
        Register dummyZero = getOrNewRegister(ctx.VariableInline(1));
        Register dummyOne = getOrNewRegister(ctx.VariableInline(0));
        Register dummyTwo = getOrNewRegister(ctx.ConstantInline());
        System.out.println("Registers are " + dummyOne + " " + dummyZero + " " + dummyTwo);
        System.out.println("Registers are " + ctx.VariableInline(0) + " " + ctx.VariableInline(1) + " " + ctx.ConstantInline());
        String mo = Tag.ARMv8.MO_ACQ;
        // String newValueRegister = ctx.VariableInline(1).getText(); // is not needed because we have returnRegister. It is a corner case
        // Register newValueRegisterLlvm = this.armToLlvmMap.getLlvmRegister(newValueRegister); 
        events.add(EventFactory.newRMWLoadWithMo(dummyZero, dummyTwo, mo));
        events.add(EventFactory.newStore(dummyTwo, dummyOne)); // TODO ask why it is a null pointer for store ttaslockApple test
        events.add(EventFactory.newLocal(this.returnRegister,dummyZero));
        return visitChildren(ctx);
    }
    @Override
    public Object visitCompare(InlineAArch64Parser.CompareContext ctx) {
        Register firstRegister = getOrNewRegister(ctx.VariableInline(0));
        Register secondRegister = getOrNewRegister(ctx.VariableInline(1));
        this.comparator.updateCompareExpression(firstRegister, IntCmpOp.EQ, secondRegister);
        System.out.println("Update cmp object now it is " + this.comparator.firstRegister + this.comparator.secondRegister + this.comparator.compareExpression);
        //events.add(EventFactory.newLocal(this.comparator.boolRegister,this.comparator.cmpTmp)); no events needed, it is internal and dat3m does not need to know, as IntCmp already does this
        return visitChildren(ctx);
    }
    @Override
    public Object visitCompareBranchNonZero(InlineAArch64Parser.CompareBranchNonZeroContext ctx) {
        //we should perform both compare and branch operations
        Register registerLlvm = getOrNewRegister(ctx.VariableInline());
        this.comparator.updateCompareExpression(registerLlvm, IntCmpOp.NEQ, this.comparator.zeroRegister);
        String cleanedLabelName = ctx.LabelReference().getText().replaceAll("(\\d)[a-z]", "$1");
        Label label = getOrNewLabel(cleanedLabelName); // since it is mainly used to make loops it should always return a defined one tho
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }
    // @Override
    // public Object visitCompareAndSwap(InlineAArch64Parser.CompareAndSwapContext ctx) {
    //     System.out.println("CompareAndSwap");
    //     String toRegisterName = ctx.VariableInline(0).getText();
    //     String compareRegisterName = ctx.VariableInline(1).getText();
    //     String directMemoryAccesString = ctx.ConstantInline().getText();
    //     Register toRegister = this.armToLlvmMap.getLlvmRegister(toRegisterName);
    //     Register compareRegister = this.armToLlvmMap.getLlvmRegister(compareRegisterName);
    //     Register directMemoryAccess = this.armToLlvmMap.getLlvmRegister(directMemoryAccesString);
    //     events.add(EventFactory.newLoad(toRegister, directMemoryAccess));
    //     // simulate comparison
    //     // if toRegister != compareRegister goto 9
    //     // store()
    //     // 9 : 
    //     // rest of the code
    //     // if this goes well, then I store b into c, which means CompareRegister goes into DMA
    //     this.comparator.updateCompareExpression(toRegister, IntCmpOp.NEQ, compareRegister);
    //     Label customLabel = getOrNewLabel("customLabel");
    //     events.add(EventFactory.newJump(this.comparator.compareExpression, customLabel));
    //     events.add(EventFactory.newStore(compareRegister, directMemoryAccess));
    //     events.add(customLabel);
    //     return visitChildren(ctx);
    // }
    // @Override
    // public Object visitCompareAndSwapAcquire(InlineAArch64Parser.CompareAndSwapAcquireContext ctx) {
    //     String toRegisterName = ctx.VariableInline(0).getText();
    //     String compareRegisterName = ctx.VariableInline(1).getText();
    //     String directMemoryAccesString = ctx.ConstantInline().getText();
    //     Register toRegister = this.armToLlvmMap.getLlvmRegister(toRegisterName);
    //     Register compareRegister = this.armToLlvmMap.getLlvmRegister(compareRegisterName);
    //     Register directMemoryAccess = this.armToLlvmMap.getLlvmRegister(directMemoryAccesString);
    //     String mo = Tag.ARMv8.MO_ACQ;
    //     events.add(EventFactory.newLoadWithMo(toRegister, directMemoryAccess, mo));
    //     this.comparator.updateCompareExpression(toRegister, IntCmpOp.NEQ, compareRegister);
    //     Label customLabel = getOrNewLabel("customLabel");
    //     events.add(EventFactory.newJump(this.comparator.compareExpression, customLabel));
    //     events.add(EventFactory.newStore(compareRegister, directMemoryAccess));
    //     events.add(customLabel);
    //     return visitChildren(ctx);
    // }
    @Override
    public Object visitMove(InlineAArch64Parser.MoveContext ctx) {
        Register toRegister = getOrNewRegister(ctx.VariableInline(0));
        Register fromRegister = getOrNewRegister(ctx.VariableInline(1));
        events.add(EventFactory.newLocal(toRegister, fromRegister));
        updateReturnRegisterIfModified(ctx.VariableInline(0));
        return visitChildren(ctx);
    }
    @Override
    public Object visitBranchEqual(InlineAArch64Parser.BranchEqualContext ctx) {
        String cleanedLabelName = ctx.LabelReference().getText().replaceAll("(\\d)[a-z]", "$1");
        Label label = getOrNewLabel(cleanedLabelName);
        this.comparator.updateCompareExpressionOperator(IntCmpOp.EQ);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }
    @Override
    public Object visitBranchNotEqual(InlineAArch64Parser.BranchNotEqualContext ctx) {
        String cleanedLabelName = ctx.LabelReference().getText().replaceAll("(\\d)[a-z]", "$1");
        Label label = getOrNewLabel(cleanedLabelName);
        this.comparator.updateCompareExpressionOperator(IntCmpOp.NEQ);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }
    @Override
    public Object visitLabelDefinition(InlineAArch64Parser.LabelDefinitionContext ctx) {
        Label label = getOrNewLabel(ctx.LabelDefinition().getText().replace(":", ""));
        events.add(label);
        return visitChildren(ctx);
    }
    @Override 
    public Object visitAsmMetadataEntries(InlineAArch64Parser.AsmMetadataEntriesContext ctx) {
        // here we have to create the final mapping for the return register
        if(this.armToLlvmMap.getReturnValuesNumber() > 1 ){
            //we have pending values, so we have to finalize it!
            System.out.println("Pending Registers are " + this.pendingRegisters);
            List<Type> typesList = new LinkedList<>();
            for (Expression r : this.pendingRegisters){
                typesList.add(((Register) r).getType());
            }
            Type aggregateType = types.getAggregateType(typesList);
            Register returnRegisterMapper = llvmFunction.newRegister(aggregateType);
            Expression finalAssignExpression = expressions.makeConstruct(this.pendingRegisters);
            events.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression)); // comment this out later
            // events.add(EventFactory.newLocal(returnRegisterMapper, finalAssignExpression)); // has to be assigned to returnReg
            // events.add(EventFactory.newLocal(this.returnRegister, returnRegisterMapper)); // this should be the last expression, but atm dat3m complains because of RegisterDecomposition
        }
        return visitChildren(ctx);
    }
    // @Override
    // public Object visitMetaInstr(InlineAArch64Parser.MetaInstrContext ctx) {
    //     System.out.println("MetaInstr");
    //     return visitChildren(ctx);
    // }

    // @Override
    // public Object visitMetadataInline(InlineAArch64Parser.MetadataInlineContext ctx) {
    //     System.out.println("MetadataInline");
    //     return visitChildren(ctx);
    // }
    // @Override
    // public Object visitClobber(InlineAArch64Parser.ClobberContext ctx) {
    //     return visitChildren(ctx);
    // }
}
