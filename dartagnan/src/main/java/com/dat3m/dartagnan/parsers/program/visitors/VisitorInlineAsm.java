package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Optional;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.InlineAsmBaseVisitor;
import com.dat3m.dartagnan.parsers.InlineAsmParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import static com.google.common.base.Preconditions.checkState;

// The trickiest part of handling inline assembly is matching input and output registers on the LLVM side with the registers in the assembly.
// The matching depends on what is specified in the clobbers.

// On the LLVM side, the 	inline assembly is called as follows
//      Register = Type call asm sideeffect 'asm code', 'clobbers' ('args')
// We call "asm registers" the ones appearing inside 'asm code'.
// We call "llvm registers" the ones passed in 'args' (i.e. the function parameters) plus Register.

// The clobbers tell us how to map asm registers to LLVM ones.
// Clobbers form a list where each entry can be one of the following:
// =r or =&r means we need to map an asm register to the return register. These are called Output Clobber / output constraints
// Q, *Q or r means we need to map an LLVM register from 'args' to an asm register. These are called Input Clobbers / input constraints
// =*m it means that the register is a memory location, and is not mapped to any register
// a constant X, it means that a register from 'args' is mapped to the Xth asm register which in turn is mapped to the return register.

// Here are some examples to understand what is happening.
// We are going to use ARMV7 names for readability "$0, $1, $2, ...", but other inline asm formats follow the same pattern 

// BASE CASE
// a)  
// asm: r10 = i32 call asm "ldr $0, $1"," =r, *Q"(ptr r9) 
// Code variables: asmRegisterNames := [$0, $1] ; argsRegisters := [r9] ; clobbers := [=r, *Q]
// Logic:
//     1. the first asm register maps to the output, i.e. r10 <- $0
//     2. the first args register maps to the next asm register, i.e. $1 <- r9

// RETURN REGISTER IS AGGREGATE TYPE
// b) 
// asm: r10 = { i32, i32, i32 } asm "ldr $0, $3 ; ldr $1, $3 ; ldr $2, $3","=r, =r, =r, *Q"(ptr r9)
// Code variables asmRegisterNames := [$0, $1, $2, $3] ; argsRegisters := [r9] ; clobbers := [=r, =r, =r, *Q]
// Logic:
//     1. the first 3 asm registers map to the output, i.e.
//         - r10[0] <- $0
//         - r10[1] <- $1
//         - r10[2] <- $2
//      2. the 1st args register maps to the next asm register, i.e. $3 <- r9

// MULTIPLE ARGS
// c) 
// asm: r10 = i32 call asm "ldr $0, $1 ; ldr $0, $2 "," =r, r, *Q"(i32 r8, ptr r9)
// Code variables: asmRegisterNames := [$0, $1, $2] ; argsRegisters := [r8, r9] ; clobbers := [=r, r, *Q]
//    1. the 1st asm register maps to the output, i.e. r10 <- $0
//    2. the two args registers map to the next two asm registers, i.e.
//       - $1 <- r8
//       - $2 <- r9

// THERE IS NO RETURN REGISTER
// d) 
// asm: call void asm "stlr $0, $1", "r,*Q"(ptr r5, ptr r7)
// Code variables: asmRegisterNames := [$0, $1] ; argsRegisters := [r5, r7] ; clobbers := [r, *Q]
//    1. nothing to be done regarding output, i.e. there no return register
//    2. the two args registers map to the next two asm registers, i.e.
//       - $0 <- r5
//       - $1 <- r7

// THERE IS A MEMORY LOCATION
// e) 
// asm: r10 = i32 call asm "ldr $0, $2 ; ldr $0, $3","=&r, =*m, r, r"(ptr r7, i32 r8)
// Code variables: asmRegisterNames := [$0, $2, $3] ; argsRegisters := [r7, r8] ; clobbers := [=&r, =*m, r, r]
//    1. r10 <- $0
//    1.5 we see that =*m is a reference to a memory location, so it would be $1 -> MEM and we do nothing
//    2. the two args registers map to the next two asm registers,
//       - $2 <- r7
//       - $3 <- r8

// WE HAVE AN OVERLAP IN THE RETURN REGISTER AND THE ARGS
// f)
// asm: r11 = call { i32, i32, i32, i32 } asm "ldr $0, $4 ; add $1, $0, $3 ; add $2, $1, $4 ; ldr $2, $0", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
// Code variables: asmRegisterNames := [$0, $1, $2, $3, $4] ; argsRegisters := [r10, r8] ; clobbers := [=&r, =&r, =&r, =&r, *Q, 3]
//    1. we have 4 output clobbers, so we have an aggregate type for the return register
//       - r11[0] <- $0
//       - r11[1] <- $1
//       - r11[2] <- $2
//       - r11[3] <- $3
//    2. map function parameter to next asm register, i.e. $4 <- r10
//    3. the 3rd asm register is related both to the return register (already above in r11[3] <- $3) and to an args register, i.e. $3 <- r8

public class VisitorInlineAsm extends InlineAsmBaseVisitor<Object> {

    private class CmpInstruction {

        private final Expression left;
        private final Expression right;

        public CmpInstruction(Expression left, Expression right) {
            this.left = left;
            this.right = right;
        }
    }
    public class RegisterManager {
        private final List<Register> registers = new ArrayList<>();
    
        // Comparator that extracts the numeric part from "asm_<number>" and compares them.
        private final Comparator<Register> registerComparator = Comparator.comparingInt(r -> extractNumber(r.getName()));
    
        private int extractNumber(String name) {
            try {
                return Integer.parseInt(name.substring(4));
            } catch (NumberFormatException e) {
                throw new IllegalArgumentException("Register name format is invalid: " + name);
            }
        }
        // Adds a register while maintaining sorted order.
        public void add(Register newRegister) {
            // Find the insertion point using binarySearch.
            int index = Collections.binarySearch(registers, newRegister, registerComparator);
            if (index < 0) {
                // binarySearch returns (-(insertion point) - 1) if not found.
                index = -index - 1;
            }
            registers.add(index, newRegister);
        }
        public Optional<Register> find(String registerName){
            for( Register r : registers){
                if(r.getName().equals(registerName)){
                    return Optional.of(r);
                }
            }
            return Optional.empty();
        }
        public Register get(int index) {
            return registers.get(index);
        }
        public boolean isEmpty(){
            return registers.isEmpty();
        }
        public int size(){
            return registers.size();
        }
    }    

    private final List<Local> inputAssignments = new ArrayList<>();
    private final List<Event> asmInstructions = new ArrayList<>();
    private final List<Local> outputAssignments = new ArrayList<>();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final TypeFactory types = TypeFactory.getInstance();
    private CmpInstruction comparator;
    // keeps track of all the labels defined in the the asm code
    private final HashMap<String, Label> labelsDefined;
    // used to keep track of which asm register should map to the llvm return register if it is an aggregate type
    private final List<Expression> pendingRegisters;
    // holds the LLVM registers that are passed as (args) to the the asm -- asm"..." (args)
    private final List<Expression> argsRegisters;
    // holds the names of the asm registers which appear in inlineasm e.g. $0, $1...
    private final ArrayList<String> asmRegisterNames;
    // expected type of RHS of a comparison
    private Type expectedType;
    // tests
    // private RegisterManager registers = new RegisterManager();
    private HashMap<Integer, Register> registers = new HashMap<>();

    public VisitorInlineAsm(Function llvmFunction, Register returnRegister, Type returnType, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.labelsDefined = new HashMap<>();
        this.pendingRegisters = new LinkedList<>();
        this.asmRegisterNames = new ArrayList<>();
        this.argsRegisters = llvmArguments;
    }

    // helper function to determine if a string representing a register is an ARMv8 register
    private boolean isArmv8Name(String registerName) {
        return registerName.startsWith("${") && registerName.endsWith("}");
    }

    // tells if the returnRegister is an AggregateType
    private boolean isReturnRegisterAggregate() {
        return getSizeOfReturnRegister() > 1;
    }

    // returns the size of the return register
    // null / void -> 0
    // i32 / bool -> 1
    // aggregateType -> the size of the aggregate
    private int getSizeOfReturnRegister() {
        if (this.returnRegister == null) {
            return 0;
        }
        Type returnType = this.returnRegister.getType();
        if (returnType instanceof IntegerType || returnType instanceof BooleanType) {
            return 1;
        } else if (returnType instanceof AggregateType at) {
            return at.getTypeOffsets().size();
        } else if (returnType instanceof VoidType) {
            return 0;
        } else {
            throw new ParsingException("Unknown inline asm return type " + returnType);
        }
    }

    // given a register name, it extracts the index contained in the name
    // ${3:w} -> 3 (armv8 name)
    // $4 -> 4 (armv7 name)
    int extractNumberFromRegisterName(String registerAsmName) {
        int number = -1;
        String innerString = registerAsmName;
        if (registerAsmName.startsWith("r")) {
            innerString = registerAsmName.substring(1);
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

    // given a string of a label, it either creates a new label, or returns the existing one if it was already defined
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


    private String makeRegisterName(int registerID) {
        return "asm_" + registerID;
    }

    private String cleanLabel(String label) {
        return label.replaceAll("(\\d)[a-z]", "$1");
    }

    @Override
    public List<Event> visitAsm(InlineAsmParser.AsmContext ctx) {
        System.out.println(ctx.getText());
        visitChildren(ctx);
        List<Event> events = new ArrayList<>();
        // 
        events.addAll(inputAssignments);
        for (Local e : inputAssignments){
            System.out.println(e.toString());
        }
        // should also set the '3' case 
        events.addAll(asmInstructions);
        for (Event e : asmInstructions){
            System.out.println(e.toString());
        }
        // when we modified any register which was referencing the returnRegister, and if it was a aggregate register, we appended into pendingRegisters
        // now we create the aggregate Type based on those registers, and we create the event which links the inline asm registers to the return Register
        // e.g. 
        //    r$0 = load(r$3)
        //    r$1 = load(r$4)
        //    ...
        //    {0 : bv32, 1 : bv32 } r10 <- { bv32 r$0, bv32 r$1 }
        // it is put at the start of asmMetadataEntries rule, because we have to be sure that this event is created only after all the instructions have executed.
        // Moreover, we force the creation of this event here, as it needs to have the latest data AND we want to be inserted into Dat3MIR only once.
        // if (getSizeOfReturnRegister() > 1) {
        //     List<Type> pendingRegisterTypes = new LinkedList<>();
        //     System.out.println(pendingRegisters);
        //     for (Expression r : this.pendingRegisters) {
        //         pendingRegisterTypes.add(((Register) r).getType());
        //     }
        //     Type aggregateType = types.getAggregateType(pendingRegisterTypes);
        //     Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
        //     events.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
        // }
        events.addAll(outputAssignments);
        for (Local e : outputAssignments){
            System.out.println(e.toString());
        }
        return events;
    }

    // tells if clobber is a numberic clobber e.g. '3'
    private boolean isClobberNumeric(InlineAsmParser.ClobberContext clobber) {
        return clobber.OverlapInOutRegister() != null;
    }
    // tells us is the clobber is a memory location '=*m'
    private boolean isClobberMemoryLocation(InlineAsmParser.ClobberContext clobber) {
        return clobber.PointerToMemoryLocation() != null;
    }
    // tells us if the clobber is an output clobber e.g. '=r' or '=&r'
    private boolean isClobberOutputConstraint(InlineAsmParser.ClobberContext clobber) {
        return clobber.OutputOpAssign() != null;
    }
    // tells us if the clobber is an input clobber e.g. 'Q' or 'r' or '*Q'
    private boolean isClobberInputConstraint(InlineAsmParser.ClobberContext clobber) {
        return clobber.MemoryAddress() != null || clobber.InputOpGeneralReg() != null;
    }

    @Override
    public Object visitLoad(InlineAsmParser.LoadContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLoad(register, address));
        // updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadAcquire(InlineAsmParser.LoadAcquireContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLoadWithMo(register, address, Tag.ARMv8.MO_ACQ));
        // updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadExclusive(InlineAsmParser.LoadExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusive(register, address));
        // updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitLoadAcquireExclusive(InlineAsmParser.LoadAcquireExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.ARMv8.MO_ACQ));
        // updateReturnRegisterIfModified(register);
        return null;
    }

    @Override
    public Object visitAdd(InlineAsmParser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        // updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitSub(InlineAsmParser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        // updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitOr(InlineAsmParser.OrContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntOr(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        // updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitAnd(InlineAsmParser.AndContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntAnd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        // updateReturnRegisterIfModified(resultRegister);
        return null;
    }

    @Override
    public Object visitStore(InlineAsmParser.StoreContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        System.out.println("Value " + value);
        System.out.println("Address " + address);
        asmInstructions.add(EventFactory.newStore(address, value));
        return null;
    }

    @Override
    public Object visitStoreRelease(InlineAsmParser.StoreReleaseContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newStoreWithMo(address, value, Tag.ARMv8.MO_REL));
        return null;
    }

    @Override
    public Object visitStoreExclusive(InlineAsmParser.StoreExclusiveContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        asmInstructions.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_RX));
        return null;
    }

    @Override
    public Object visitStoreReleaseExclusive(InlineAsmParser.StoreReleaseExclusiveContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        asmInstructions.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.ARMv8.MO_REL));
        return null;
    }

    @Override
    public Object visitCompare(InlineAsmParser.CompareContext ctx) {
        Register firstRegister = (Register) ctx.register().accept(this);
        expectedType = firstRegister.getType();
        Expression secondRegister = (Expression) ctx.expr().accept(this);
        this.comparator = new CmpInstruction(firstRegister, secondRegister);
        return null;
    }

    @Override
    public Object visitCompareBranchNonZero(InlineAsmParser.CompareBranchNonZeroContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        Register firstRegister = (Register) ctx.register().accept(this);
        Expression zero = expressions.makeZero((IntegerType) firstRegister.getType());
        Expression expr = expressions.makeIntCmp(firstRegister, IntCmpOp.NEQ, zero);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitMove(InlineAsmParser.MoveContext ctx) {
        Register toRegister = (Register) ctx.register(0).accept(this);
        Register fromRegister = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLocal(toRegister, fromRegister));
        // updateReturnRegisterIfModified(toRegister);
        return null;
    }

    @Override
    public Object visitBranchEqual(InlineAsmParser.BranchEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        Expression expr = expressions.makeIntCmp(comparator.left, IntCmpOp.EQ, comparator.right);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchNotEqual(InlineAsmParser.BranchNotEqualContext ctx) {
        String cleanedLabelName = cleanLabel(ctx.LabelReference().getText());
        Label label = getOrNewLabel(cleanedLabelName);
        Expression expr = expressions.makeIntCmp(comparator.left, IntCmpOp.NEQ, comparator.right);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitLabelDefinition(InlineAsmParser.LabelDefinitionContext ctx) {
        String labelDefinitionNoColon = ctx.LabelDefinition().getText().replace(":", "");
        Label label = getOrNewLabel(labelDefinitionNoColon);
        asmInstructions.add(label);
        return null;
    }

    @Override
    public Object visitExpr(InlineAsmParser.ExprContext ctx) {
        return ctx.getChild(0).accept(this);
    }

    @Override
    public Object visitRegister(InlineAsmParser.RegisterContext ctx) {
        // TODO DO NOT USE extractNumberFromRegister -- make grammar work properly 
        String registerName = ctx.Register().getText();
        int registerID = extractNumberFromRegisterName(registerName);
        if(registers.containsKey(registerID)){
            return registers.get(registerID);
        } else {
            Type registerType;
            if (registerID < getSizeOfReturnRegister()){
                if(returnRegister.getType() instanceof AggregateType at){
                    registerType = at.getFields().get(registerID);
                } else {
                    registerType = returnRegister.getType();
                }
            } else {
                registerType = argsRegisters.get(registerID - getSizeOfReturnRegister()).getType();
            }
            Register newRegister = this.llvmFunction.getOrNewRegister(makeRegisterName(registerID), registerType);
            if(registerID < getSizeOfReturnRegister() && isReturnRegisterAggregate()){
                this.pendingRegisters.add(newRegister);
            }
            registers.put(registerID, newRegister);
            return newRegister;
        }
    }
    
    @Override 
    public Object visitAsmMetadataEntries(InlineAsmParser.AsmMetadataEntriesContext ctx) { 
        List<InlineAsmParser.ClobberContext> clobbers = ctx.clobber();
        // we already have all of the registers from LHS of the context call (asmInstrEntries)
        // now it is time to generate the input and output assignments to let Dat3M understand the llvm to asm registers mapping
        boolean outputRegistersInitialized = returnRegister == null;
        for(int i = 0; i < clobbers.size(); i++){
                InlineAsmParser.ClobberContext clobber = clobbers.get(i);
                System.out.println("Evaluating " + clobber.getText() + " with index " + i);
                if(isClobberMemoryLocation(clobber)){
                    // the register that should be used as a returnRegister refers to a memory location
                    // and therefore we are sure that it does not contain any returnRegister
                    // therefore should avoid creating output assignments.
                    outputRegistersInitialized = true;
                    continue;
                }
                if(isClobberOutputConstraint(clobber)){
                    continue;
                }
                if (!outputRegistersInitialized){
                outputRegistersInitialized = true;
                if (i == 1){
                    outputAssignments.add(EventFactory.newLocal(returnRegister, registers.get(0)));
                } else{
                    // create the aggregate assignment and assign it to the returnRegister
                        Type aggregateType = types.getAggregateType(((AggregateType) returnRegister.getType()).getFields());
                        System.out.println("Creating aggregate type " + aggregateType);
                        System.out.println("Pending registers " + pendingRegisters);
                        Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
                        outputAssignments.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
                    }
                }
                if(isClobberInputConstraint(clobber)){
                    Register asmRegister = registers.get(i);
                    if(asmRegister == null){
                        // we are referencing a register that is not present in the asm code
                        // we can safely skip it as we are not going to assign it to anything
                        // this can happen if :
                        // 1) call void "dmb ish", "r"(i32 0) -- "r" clobber refers to llvmRegister containing i32 0, but it is not present in the asm code
                        // 2) call void "str ${2:w}, [$1]", "=*m,r,r"(ptr %5, ptr %6, i32 %7)"
                        //      in this case =*m refers to a memory location which should be $0, but it is not present in the asm code.
                        continue;
                    }
                    Expression llvmRegister = argsRegisters.get(i - getSizeOfReturnRegister());
                    System.out.println("Assigning "+ asmRegister + " to llvm one " + llvmRegister);
                    inputAssignments.add(EventFactory.newLocal(asmRegister, llvmRegister));
                } 
                if (isClobberNumeric(clobber)){
                    // https://llvm.org/docs/LangRef.html#input-constraints
                    // e.g. 
                    // r11 = call { i32, i32, i32, i32 } asm "...", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
                    // we know from the number contained in the clobber that $3 has to be mapped to an argsRegisters. 
                    // Since the value of asmRegisterNameIndex in this case is 5, we shift it by 4 (the number of return values) and we get 1
                    // we can therefore access argsRegisters[1], which gives us the correct index for the arg Register.
                    int clobberValue = Integer.parseInt(clobber.getText());
                    inputAssignments.add(EventFactory.newLocal(registers.get(clobberValue), argsRegisters.get(i - getSizeOfReturnRegister())));
                }
            }
            return null;
        }
    
    @Override
    public Object visitValue(InlineAsmParser.ValueContext ctx) {
        String valueString = ctx.ConstantValue().getText().substring(1);
        BigInteger value = new BigInteger(valueString, 10);
        checkState(expectedType instanceof IntegerType, "Expected type is not an integer type");
        return expressions.makeValue(value, (IntegerType) expectedType);
    }

    @Override
    public Object visitArmFence(InlineAsmParser.ArmFenceContext ctx) {
        // check which type of fence it is : DataMemoryBarrier or DataSynchronizationBarrier
        String type = ctx.DataMemoryBarrier() == null ? ctx.DataSynchronizationBarrier().getText() : ctx.DataMemoryBarrier().getText();
        String option = ctx.FenceArmOpt().getText();
        String barrier = type + " " + option;
        switch (barrier) {
            case "dmb ish" ->
                asmInstructions.add(EventFactory.AArch64.DMB.newISHBarrier());
            case "dmb ishld" ->
                asmInstructions.add(EventFactory.AArch64.DMB.newISHLDBarrier());
            case "dmb sy" ->
                asmInstructions.add(EventFactory.AArch64.DMB.newSYBarrier());
            case "dmb st" ->
                asmInstructions.add(EventFactory.AArch64.DMB.newSTBarrier());
            case "dmb ishst" ->
                asmInstructions.add(EventFactory.AArch64.DMB.newISHSTBarrier());
            case "dsb ish" ->
                asmInstructions.add(EventFactory.AArch64.DSB.newISHBarrier());
            case "dsb ishld" ->
                asmInstructions.add(EventFactory.AArch64.DSB.newISHLDBarrier());
            case "dsb sy" ->
                asmInstructions.add(EventFactory.AArch64.DSB.newSYBarrier());
            case "dsb ishst" ->
                asmInstructions.add(EventFactory.AArch64.DSB.newISHSTBarrier());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return null;
    }

    @Override
    public Object visitRiscvFence(InlineAsmParser.RiscvFenceContext ctx) {
        String type = ctx.RISCVFence().getText();
        String firstOption = ctx.FenceRISCVOpt(0).getText();
        String secondOption = ctx.FenceRISCVOpt(1) == null ? "" : ctx.FenceRISCVOpt(1).getText();
        String barrier = type + " " + firstOption + " " + secondOption;
        switch (barrier) {
            case "fence r r" ->
                asmInstructions.add(EventFactory.RISCV.newRRFence());
            case "fence r w" ->
                asmInstructions.add(EventFactory.RISCV.newRWFence());
            case "fence r rw" ->
                asmInstructions.add(EventFactory.RISCV.newRRWFence());
            case "fence w r" ->
                asmInstructions.add(EventFactory.RISCV.newWRFence());
            case "fence w w" ->
                asmInstructions.add(EventFactory.RISCV.newWWFence());
            case "fence w rw" ->
                asmInstructions.add(EventFactory.RISCV.newWRWFence());
            case "fence rw r" ->
                asmInstructions.add(EventFactory.RISCV.newRWRFence());
            case "fence rw w" ->
                asmInstructions.add(EventFactory.RISCV.newRWWFence());
            case "fence rw rw" ->
                asmInstructions.add(EventFactory.RISCV.newRWRWFence());
            case "fence tso" ->
                asmInstructions.add(EventFactory.RISCV.newTsoFence());
            case "fence i" ->
                asmInstructions.add(EventFactory.RISCV.newSynchronizeFence());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return visitChildren(ctx);
    }

    @Override
    public Object visitX86Fence(InlineAsmParser.X86FenceContext ctx) {
        String barrier = ctx.X86Fence().getText();
        switch (barrier) {
            case "mfence" ->
                asmInstructions.add(EventFactory.X86.newMemoryFence());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return visitChildren(ctx);
    }

    @Override
    public Object visitPpcFence(InlineAsmParser.PpcFenceContext ctx) {
        String barrier = ctx.PPCFence().getText();
        switch (barrier) {
            case "sync" ->
                asmInstructions.add(EventFactory.Power.newSyncBarrier());
            case "isync" ->
                asmInstructions.add(EventFactory.Power.newISyncBarrier());
            case "lwsync" ->
                asmInstructions.add(EventFactory.Power.newLwSyncBarrier());
            default ->
                throw new ParsingException("Barrier not implemented");
        }
        return visitChildren(ctx);
    }
}
