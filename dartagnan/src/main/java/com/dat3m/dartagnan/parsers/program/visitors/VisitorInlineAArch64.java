package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

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
    private final LinkedList<Expression> fnParameters;
    private String[] returnRegisterTypes;
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
        // this.fnParameters = new LinkedList<>(llvmFunction.getParameterRegisters());
        // Collections.reverse(this.fnParameters);
        // todo set this to empty if we see something like (bv 0), as it is going to be a useless fence
        this.returnValuesNumber = initReturnValuesNumberInitReturnRegisterTypes(returnType);
        assert (this.returnValuesNumber >= 0);
        // populateRegisters(armToLlvmMap);
    }

    public List<Event> getEvents() {
        return this.events;
    }

    private boolean isArmv8Name(String registerName){
        return registerName.startsWith("${") && registerName.endsWith("}");
    } 

    private boolean isRegisterConstantValue(String nodeName){
        String innerString = nodeName;
        if (nodeName.startsWith("r")){
            innerString = nodeName.substring(1);
        }
        return innerString.equals("#0");
    }

    /* given the VariableInline as String it picks up if it is a 32 or 64 bit */
    // clean this 
    public Type getArmVariableSize(String registerArmName) {
        // int width = - 1;
        int number = extractNumberFromRegisterName(registerArmName);
        if (isPartOfAggregateReturnRegister(registerArmName)){
            Type returnRegisterProjectionType = expressions.makeExtract(number, returnRegister).getType();
            return returnRegisterProjectionType;
        }
        if (this.returnValuesNumber == 1 && number == 0){
            return this.returnRegister.getType();
        }
        return this.fnParameters.get(number - this.returnValuesNumber).getType();
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

    int extractNumberFromRegisterName(String registerArmName){
        int number = -1;
        System.out.println("registerArmName is " + registerArmName);
        String innerString = registerArmName;
        if (registerArmName.startsWith("r")){
            innerString = registerArmName.substring(1);
        }
        System.out.println("innerStriong is is " + innerString);
        if(isArmv8Name(innerString)){ // ${N:x}
            System.out.println("It is a armv8 name");
            number = Integer.parseInt(Character.toString(innerString.charAt(2)));
            System.out.println("Number here is "+ number);
        } else if (innerString.length() ==  2) { // $n
            number = Integer.parseInt(Character.toString(innerString.charAt(1)));
        } else if ( innerString.length() == 4){ // [$n]
            number = Integer.parseInt(Character.toString(innerString.charAt(2)));
        }
        return number;
    }

    // used if the return is AggregateType (size > 1)
    // has to be changed for armv7
    private boolean isPartOfAggregateReturnRegister(String registerName) {
        int number = extractNumberFromRegisterName(registerName);
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
            if (isPartOfAggregateReturnRegister(nodeName)) {
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
        System.out.println("Return register is " + this.returnRegister + " And modified one is " + register);
        int number = extractNumberFromRegisterName(registerName);
        System.out.println("Number is " + number);
        System.out.println("ReturnValues are " + this.returnValuesNumber);
        if(number == 0 && this.returnValuesNumber == 1){
            System.out.println("Modifying returnRegister");
            events.add(EventFactory.newLocal(this.returnRegister, register));
        }
    }

    @Override
    public Object visitAsm(InlineAArch64Parser.AsmContext ctx) {
        int commaPos = ctx.getText().lastIndexOf("\",\"");
        String[] instructions = ctx.getText().substring(0, commaPos).split("\\\\0A"); // Instructions part
        String[] clobbers = ctx.getText().substring(commaPos + 3, ctx.getText().length() - 1).split(","); // Clobbers part, excluding the surrounding quotes
        // we remove all of the "~{}" format flags
        ArrayList<String> filteredClobbers = Arrays.stream(clobbers).filter(s -> !s.startsWith("~")).collect(Collectors.toCollection(ArrayList::new));

        // workaround -- not really a solution!
        // if(filteredClobbers.stream().anyMatch(s -> s.matches("\\d+"))){
        //     Collections.reverse(this.fnParameters);
        // }
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
                    }
                } else if (c == '[' && i + 1 < instruction.length() && instruction.charAt(i + 1) == '$') {
                    int closeIndex = instruction.indexOf(']', i);
                    if (closeIndex != -1) {
                        String register = instruction.substring(i, closeIndex + 1);
                        if (!registerNames.contains(register)) {
                            this.registerNames.add(register);
                        }
                        i = closeIndex + 1;
                    }
                }
            }
        }

        // Collections.sort(registerNames);
        // LinkedList<String> tmp = new LinkedList<>();
        // for(int i=0; i < registerNames.size(); i++){
        //     String registerName = registerNames.get(i);
        //     int number = extractNumberFromRegisterName(registerName);
        //     tmp.add(number, registerName);
        //     if (!isArmv8Name(registerName) && !registerName.startsWith("[")) {
        //         tmp.add(registerName);
        //         registerNames.remove(i);  
        //         i--;  
        //     }
        // }
        // this has to be done only if not all names are armv8(?)
        registerNames.sort((s1, s2) -> Integer.compare(extractNumberFromRegisterName(s1), extractNumberFromRegisterName(s2)));
        // System.out.println("Tmp is " + tmp);
        System.out.println("registerNames is " + registerNames);
        // registerNames.addAll(tmp);

        if (!registerNames.isEmpty() && !this.fnParameters.isEmpty()) {
            System.out.println("RegisterNames is " + registerNames);
            System.out.println("Fn params are " + this.fnParameters);
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
                        System.out.println("Register is going to be assigned " + toBeChanged.getName() + " < - " + this.fnParameters.get(registerNameIndex - this.returnValuesNumber));
                        System.out.println("Trying to change the value via local assignment -- read a d+");
                        // for consistency change also this one to use the extractValue
                        events.add(EventFactory.newLocal(toBeChanged, this.fnParameters.get(registerNameIndex - this.returnValuesNumber)));
                    } else {
                        System.err.println("The number provided in the clobber is not a valid index for any return value");
                    }
                } else if (clobber.equals("=*m")) {
                    //if clobber is =*m it means that such pointer is a memory location, so we do not map to any register
                    // we just increase registerNameIndex as we don't want to pick it up and it has no returnValue
                    // registerNameIndex++;
                } else {
                    // System.out.println("Evaluating clobber " + clobber + " with registerNameIndex " + registerNameIndex);
                    // if it is a valid clobber create the register
                    String registerName = registerNames.get(registerNameIndex);
                    Register newRegister = getOrNewRegister(registerName);
                    armToLlvmMap.put(this.registerNames.get(registerNameIndex), newRegister);
                    int number = extractNumberFromRegisterName(registerName); // better than picking registerName -- ck case
                    if (clobber.equals("=&r") || clobber.equals("=r")) {
                        // maps to returnValue, so we just skip it and increase the registerNameIndex
                        registerNameIndex++;
                    } else if (clobber.equals("r")) {
                        // it has to be mapped to fnParams do as such
                        System.out.println("Trying to assign to " + newRegister + " expression " + this.fnParameters.get(number - this.returnValuesNumber));
                        events.add(EventFactory.newLocal(newRegister, this.fnParameters.get(number - this.returnValuesNumber)));
                        registerNameIndex++;
                    } else if (clobber.equals("Q") || clobber.equals("*Q")) {
                        // we are assured that last one is a pointer type 
                        System.out.println("Trying to assign to " + newRegister + " expression " + this.fnParameters.get(number - this.returnValuesNumber));
                        events.add(EventFactory.newLocal(newRegister, this.fnParameters.get(number - this.returnValuesNumber)));
                        registerNameIndex++;
                        // we do not increase index as we want to keep in the same fnParam -- to be checked
                    } else {
                        System.err.println("New type of clobber found, you have to add it! " + clobber);
                    }
                }
            }
        }
        System.out.println("Currently the map contains " + armToLlvmMap);
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
        if(isRegisterConstantValue(secondRegister.getName())){
            this.comparator.updateCompareExpression(firstRegister, IntCmpOp.EQ, this.comparator.zeroRegister);
        } else{
            this.comparator.updateCompareExpression(firstRegister, IntCmpOp.EQ, secondRegister);
        }
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
