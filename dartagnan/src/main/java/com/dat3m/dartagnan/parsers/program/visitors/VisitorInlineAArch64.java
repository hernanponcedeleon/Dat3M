package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

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
            // TODO simulate always success
            // should do something else with this register but for now it is ok
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
        private final int MAX_FN_CALLS = 10; // this is used to keep track of how many fn calls I am going to use

        public ArmToLlvmRegisterMapping(Function llvmFunction, Type returnType, Register returnRegister, ArrayList<Expression> argumentsRegisterAddresses) {
            this.armToLlvmMap = new HashMap<>();
            this.returnRegister = returnRegister;
            // this.fnParameters = llvmFunction.getParameterRegisters(); these hold the original fn arguments
            Collections.reverse(argumentsRegisterAddresses); // they are usually pushed in stack in the llvm fn
            this.fnParameters = new LinkedList<>();
            for (Expression e : argumentsRegisterAddresses) {
                this.fnParameters.add((Register) e);
            }
            this.returnValuesNumber = assignReturnValues(returnType);
            System.out.println(returnValuesNumber);
            assert (this.returnValuesNumber >= 0);
            // now we have to fill our map following the llvm rule 
            // every $ is going to map to r0
            populateRegisters(armToLlvmMap);
            System.out.println("State is " + armToLlvmMap);
        }

        public Register getLlvmRegister(String armName) {
            return this.armToLlvmMap.get(armName);
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
                    // List<Type> aggregateTypes = new ArrayList<>();
                    // for(String s : this.returnRegisterTypes){
                    //     aggregateTypes.add(types.getIntegerType(Integer.parseInt(s.replace("bv","").trim())));
                    // }
                    // AggregateType test;
                    // test = types.getAggregateType(aggregateTypes);
                    // Register mock = llvmFunction.getOrNewRegister("tmp", test);
                    // System.out.println("Here it is " + mock);
                    // if(returnRegister.getType() instanceof AggregateType){
                    //     System.out.println("Types are aggregate and are " + returnRegister.getType());
                    // }
                    for (int i = 0; i < this.returnValuesNumber; i++) {
                        String key = String.format("${%d:w}", i);
                        Type type = getTypeGivenString(this.returnRegisterTypes[i]);
                        System.out.println("Type here is " + type.toString());
                        if (type.toString().trim().equals("bv64")) {
                            key = key.replace("w", "x");
                        }
                        // Expression exp = expressions.makeExtract(i,returnRegister); // pretty much useless
                        // System.out.println("Extract is "+ exp);
                        String regName = String.format(returnRegister.getName() + "[%d]", i);
                        Register value = llvmFunction.newRegister(regName, type);
                        llvmToArmMap.put(key, value);
                    }
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
    private final ArmToLlvmRegisterMapping armToLlvmMap; // keeps track of all mappings

    public VisitorInlineAArch64(Function llvmFunction, Register returnRegister, Type returnType, ArrayList<Expression> argumentsRegisterAddresses) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.comparator = new CompareExpression();
        this.labelsDefined = new HashMap<>();
        this.armToLlvmMap = new ArmToLlvmRegisterMapping(llvmFunction, returnType, returnRegister, argumentsRegisterAddresses);
    }

    public List<Event> getEvents() {
        return this.events;
    }

    /* given the VariableInline as String it picks up if it is a 32 or 64 bit */
    public Type getVariableSize(String variable) {
        int width = - 1;
        if (variable.startsWith("${") && variable.endsWith("}")) {
            char letter = variable.charAt(4);
            switch (letter) {
                case 'w' ->
                    width = 32;
                case 'x' ->
                    width = 64;
                default ->
                    throw new UnsupportedOperationException("Unrecognized pattern for variable : does not fit into ${NUM:x/w}");
            }
        } else if (variable.length() == 2) {
            width = 32; // assuming that $1,$2 are 32 bit
        }
        return TypeFactory.getInstance().getIntegerType(width);
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

    @Override
    public Object visitLoadReg(InlineAArch64Parser.LoadRegContext ctx) {
        // this is the base example for an event with sideeffect
        String returnRegisterName = ctx.VariableInline().getText();
        String directMemoryAccess = ctx.ConstantInline().getText();
        Register returnRegisterLlvm = this.armToLlvmMap.getLlvmRegister(returnRegisterName);
        Register valueToLoadLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        events.add(EventFactory.newLoad(returnRegisterLlvm, valueToLoadLlvm)); // we add to returnRegister because it is sideeffect
        System.out.println("Added visitLoadReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireReg(InlineAArch64Parser.LoadAcquireRegContext ctx) {
        String returnRegisterName = ctx.VariableInline().getText();
        String directMemoryAccess = ctx.ConstantInline().getText();
        Register returnRegisterLlvm = this.armToLlvmMap.getLlvmRegister(returnRegisterName);
        Register valueToLoadLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        String mo = Tag.ARMv8.MO_ACQ;
        events.add(EventFactory.newLoadWithMo(returnRegisterLlvm, valueToLoadLlvm, mo));
        System.out.println("Added visitLoadAcquireReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadExclusiveReg(InlineAArch64Parser.LoadExclusiveRegContext ctx) {
        // LDR and LDXR are the same from Memory Ordering point of view
        String returnRegisterName = ctx.VariableInline().getText();
        String directMemoryAccess = ctx.ConstantInline().getText();
        Register returnRegisterLlvm = this.armToLlvmMap.getLlvmRegister(returnRegisterName);
        Register valueToLoadLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        events.add(EventFactory.newLoad(returnRegisterLlvm, valueToLoadLlvm));
        System.out.println("Added visitLoadExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitLoadAcquireExclusiveReg(InlineAArch64Parser.LoadAcquireExclusiveRegContext ctx) {
        String returnRegisterName = ctx.VariableInline().getText();
        String directMemoryAccess = ctx.ConstantInline().getText();
        Register returnRegisterLlvm = this.armToLlvmMap.getLlvmRegister(returnRegisterName);
        Register valueToLoadLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        String mo = Tag.ARMv8.MO_ACQ;
        events.add(EventFactory.newLoadWithMo(returnRegisterLlvm, valueToLoadLlvm, mo));
        System.out.println("Added visitLoadAcquireExclusiveReg");
        return visitChildren(ctx);
    }

    @Override
    public Object visitAdd(InlineAArch64Parser.AddContext ctx) {
        System.out.println("Add");
        String resultRegisterName = ctx.VariableInline(0).getText();
        String leftRegName = ctx.VariableInline(1).getText();
        String rightRegName = ctx.VariableInline(2).getText();
        Register resultRegister = this.armToLlvmMap.getLlvmRegister(resultRegisterName);
        Register leftRegister = this.armToLlvmMap.getLlvmRegister(leftRegName);
        Register rightRegister = this.armToLlvmMap.getLlvmRegister(rightRegName);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        //An add is a local operation. Can be seen as a store in dat3m internal encoding
        events.add(EventFactory.newLocal(resultRegister, exp));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReg(InlineAArch64Parser.StoreRegContext ctx) {
        String directMemoryAccess = ctx.VariableInline().getText();
        String valueToStore = ctx.ConstantInline().getText();
        Register valueToStoreLlvm = this.armToLlvmMap.getLlvmRegister(valueToStore);
        Register registerToStoreLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        events.add(EventFactory.newStore(valueToStoreLlvm, registerToStoreLlvm));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreExclusiveRegister(InlineAArch64Parser.StoreExclusiveRegisterContext ctx) {
        String resultRegisterName = ctx.VariableInline(0).getText(); // this register either holds 0 or 1 if the operation was successful or not
        Register resultRegister = this.armToLlvmMap.getLlvmRegister(resultRegisterName);
        Expression simulationAllOk = expressions.parseValue("0", integerType); // holds simulation of store going ok
        this.comparator.updateStoreSucceeded(resultRegister);
        // this part is used for the store
        String directMemoryAccess = ctx.VariableInline(1).getText();
        String valueToStore = ctx.ConstantInline().getText();
        Register valueToStoreLlvm = this.armToLlvmMap.getLlvmRegister(valueToStore);
        Register registerToStoreLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        events.add(EventFactory.newStore(valueToStoreLlvm, registerToStoreLlvm));
        events.add(EventFactory.newLocal(resultRegister, simulationAllOk)); // simulate saving state into register
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseExclusiveReg(InlineAArch64Parser.StoreReleaseExclusiveRegContext ctx) {
        String resultRegisterName = ctx.VariableInline(0).getText(); // this register either holds 0 or 1 if the operation was successful or not
        Register resultRegister = this.armToLlvmMap.getLlvmRegister(resultRegisterName);
        Expression simulationAllOk = expressions.parseValue("0", integerType); // holds simulation of store going ok
        this.comparator.updateStoreSucceeded(resultRegister);
        // this part is used for the store
        String directMemoryAccess = ctx.VariableInline(1).getText();
        String valueToStore = ctx.ConstantInline().getText();
        Register valueToStoreLlvm = this.armToLlvmMap.getLlvmRegister(valueToStore);
        Register registerToStoreLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        String mo = Tag.ARMv8.MO_REL;
        events.add(EventFactory.newStoreWithMo(valueToStoreLlvm, registerToStoreLlvm, mo));
        events.add(EventFactory.newLocal(resultRegister, simulationAllOk));
        return visitChildren(ctx);
    }

    @Override
    public Object visitStoreReleaseReg(InlineAArch64Parser.StoreReleaseRegContext ctx) {
        String directMemoryAccess = ctx.VariableInline().getText();
        String valueToStore = ctx.ConstantInline().getText();
        Register valueToStoreLlvm = this.armToLlvmMap.getLlvmRegister(valueToStore);
        Register registerToStoreLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        String mo = Tag.ARMv8.MO_REL;
        events.add(EventFactory.newStoreWithMo(valueToStoreLlvm, registerToStoreLlvm, mo));
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
        // write constant into newValueR and return to resultRegister the oldValueR
        String oldValueRegister = ctx.VariableInline(0).getText();
        String directMemoryAccess = ctx.ConstantInline().getText();
        Register oldValueRegisterLlvm = this.armToLlvmMap.getLlvmRegister(oldValueRegister);
        Register directMemoryAccessLlvm = this.armToLlvmMap.getLlvmRegister(directMemoryAccess);
        String mo = Tag.ARMv8.MO_ACQ;
        // String newValueRegister = ctx.VariableInline(1).getText(); // is not needed because we have returnRegister. It is a corner case
        // Register newValueRegisterLlvm = this.armToLlvmMap.getLlvmRegister(newValueRegister); 
        events.add(EventFactory.newLoadWithMo(oldValueRegisterLlvm, directMemoryAccessLlvm, mo));
        events.add(EventFactory.newStore(this.returnRegister, directMemoryAccessLlvm));
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompare(InlineAArch64Parser.CompareContext ctx) {
        String firstRegisterName = ctx.VariableInline(0).getText();
        String secondRegisterName = ctx.VariableInline(1).getText();
        Register firstRegister = this.armToLlvmMap.getLlvmRegister(firstRegisterName);
        Register secondRegister = this.armToLlvmMap.getLlvmRegister(secondRegisterName);
        this.comparator.updateCompareExpression(firstRegister, IntCmpOp.EQ, secondRegister);
        System.out.println("Update cmp object now it is " + this.comparator.firstRegister + this.comparator.secondRegister + this.comparator.compareExpression);
        //events.add(EventFactory.newLocal(this.comparator.boolRegister,this.comparator.cmpTmp)); no events needed, it is internal and dat3m does not need to know, as IntCmp already does this
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareBranchNonZero(InlineAArch64Parser.CompareBranchNonZeroContext ctx) {
        //we should perform both compare and branch operations
        String registerName = ctx.VariableInline().getText();
        Register registerLlvm = this.armToLlvmMap.getLlvmRegister(registerName);
        this.comparator.updateCompareExpression(registerLlvm, IntCmpOp.NEQ, this.comparator.zeroRegister);
        String cleanedLabelName = ctx.LabelReference().getText().replaceAll("(\\d)[a-z]", "$1");
        Label label = getOrNewLabel(cleanedLabelName);
        events.add(EventFactory.newJump(this.comparator.compareExpression, label));
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareAndSwap(InlineAArch64Parser.CompareAndSwapContext ctx) {
        System.out.println("CompareAndSwap");
        String toRegisterName = ctx.VariableInline(0).getText();
        String compareRegisterName = ctx.VariableInline(1).getText();
        String directMemoryAccesString = ctx.ConstantInline().getText();
        Register toRegister = this.armToLlvmMap.getLlvmRegister(toRegisterName);
        Register compareRegister = this.armToLlvmMap.getLlvmRegister(compareRegisterName);
        Register directMemoryAccess = this.armToLlvmMap.getLlvmRegister(directMemoryAccesString);
        events.add(EventFactory.newLoad(toRegister, directMemoryAccess));
        // simulate comparison
        // if toRegister != compareRegister goto 9
        // store()
        // 9 : 
        // rest of the code
        // if this goes well, then I store b into c, which means CompareRegister goes into DMA
        this.comparator.updateCompareExpression(toRegister, IntCmpOp.NEQ, compareRegister);
        Label customLabel = getOrNewLabel("customLabel");
        events.add(EventFactory.newJump(this.comparator.compareExpression, customLabel));
        events.add(EventFactory.newStore(compareRegister, directMemoryAccess));
        events.add(customLabel);
        return visitChildren(ctx);
    }

    @Override
    public Object visitCompareAndSwapAcquire(InlineAArch64Parser.CompareAndSwapAcquireContext ctx) {
        String toRegisterName = ctx.VariableInline(0).getText();
        String compareRegisterName = ctx.VariableInline(1).getText();
        String directMemoryAccesString = ctx.ConstantInline().getText();
        Register toRegister = this.armToLlvmMap.getLlvmRegister(toRegisterName);
        Register compareRegister = this.armToLlvmMap.getLlvmRegister(compareRegisterName);
        Register directMemoryAccess = this.armToLlvmMap.getLlvmRegister(directMemoryAccesString);
        String mo = Tag.ARMv8.MO_ACQ;
        events.add(EventFactory.newLoadWithMo(toRegister, directMemoryAccess, mo));
        this.comparator.updateCompareExpression(toRegister, IntCmpOp.NEQ, compareRegister);
        Label customLabel = getOrNewLabel("customLabel");
        events.add(EventFactory.newJump(this.comparator.compareExpression, customLabel));
        events.add(EventFactory.newStore(compareRegister, directMemoryAccess));
        events.add(customLabel);
        return visitChildren(ctx);
    }

    @Override
    public Object visitMove(InlineAArch64Parser.MoveContext ctx) {
        String toRegisterName = ctx.VariableInline(0).getText();
        String fromRegisterName = ctx.VariableInline(1).getText();
        Register toRegister = this.armToLlvmMap.getLlvmRegister(toRegisterName);
        Register fromRegister = this.armToLlvmMap.getLlvmRegister(fromRegisterName);
        events.add(EventFactory.newLocal(toRegister, fromRegister));
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
