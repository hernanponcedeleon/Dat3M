package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

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
// The matching depends on what is specified in the constraints.
// On the LLVM side, the 	inline assembly is called as follows
//      Register = Type call asm sideeffect 'asm code', 'constraints, clobbers' ('args')
// We call "asm registers" the ones appearing inside 'asm code'.
// We call "llvm registers" the ones passed in 'args' (i.e. the function parameters) plus Register.
// The "clobbers" helps the compiler understand if the inline asm code is going to set conditional flags, perform memory operation and so on
// Examples are ~{memory}, ~{flags},...
// The constraints tell us how to map asm registers to LLVM ones.
// constraints form a list where each entry can be one of the following:
// =r or =&r means we need to map an asm register to the return register. These are called Output constraints
// Q, *Q or r means we need to map an LLVM register from 'args' to an asm register. These are called Input constraints
// =*m it means that the register is a memory location, and is not mapped to any register. These are called Indirect constraints.
// a constant X, it means that a register from 'args' is mapped to the Xth asm register which in turn is mapped to the return register.
// Here are some examples to understand what is happening.
// We are going to use ARMV7 names for readability "$0, $1, $2, ...", but other inline asm formats follow the same pattern 
// BASE CASE
// a)  
// asm: r10 = i32 call asm "ldr $0, $1"," =r, *Q"(ptr r9) 
// Code variables: asmRegisterNames := [$0, $1] ; argsRegisters := [r9] ; constraints := [=r, *Q]
// Logic:
//     1. the first asm register maps to the output, i.e. r10 <- $0
//     2. the first args register maps to the next asm register, i.e. $1 <- r9
// RETURN REGISTER IS AGGREGATE TYPE
// b) 
// asm: r10 = { i32, i32, i32 } asm "ldr $0, $3 ; ldr $1, $3 ; ldr $2, $3","=r, =r, =r, *Q"(ptr r9)
// Code variables asmRegisterNames := [$0, $1, $2, $3] ; argsRegisters := [r9] ; constraints := [=r, =r, =r, *Q]
// Logic:
//     1. the first 3 asm registers map to the output, i.e.
//         - r10[0] <- $0
//         - r10[1] <- $1
//         - r10[2] <- $2
//      2. the 1st args register maps to the next asm register, i.e. $3 <- r9
// MULTIPLE ARGS
// c) 
// asm: r10 = i32 call asm "ldr $0, $1 ; ldr $0, $2 "," =r, r, *Q"(i32 r8, ptr r9)
// Code variables: asmRegisterNames := [$0, $1, $2] ; argsRegisters := [r8, r9] ; constraints := [=r, r, *Q]
//    1. the 1st asm register maps to the output, i.e. r10 <- $0
//    2. the two args registers map to the next two asm registers, i.e.
//       - $1 <- r8
//       - $2 <- r9
// THERE IS NO RETURN REGISTER
// d) 
// asm: call void asm "stlr $0, $1", "r,*Q"(ptr r5, ptr r7)
// Code variables: asmRegisterNames := [$0, $1] ; argsRegisters := [r5, r7] ; constraints := [r, *Q]
//    1. nothing to be done regarding output, i.e. there no return register
//    2. the two args registers map to the next two asm registers, i.e.
//       - $0 <- r5
//       - $1 <- r7
// THERE IS A MEMORY LOCATION
// e) 
// asm: r10 = i32 call asm "ldr $0, $2 ; ldr $0, $3","=&r, =*m, r, r"(ptr r7, i32 r8)
// Code variables: asmRegisterNames := [$0, $2, $3] ; argsRegisters := [r7, r8] ; constraints := [=&r, =*m, r, r]
//    1. r10 <- $0
//    1.5 we see that =*m is a reference to a memory location, so it would be $1 -> MEM and we do nothing
//    2. the two args registers map to the next two asm registers,
//       - $2 <- r7
//       - $3 <- r8
// WE HAVE AN OVERLAP IN THE RETURN REGISTER AND THE ARGS
// f)
// asm: r11 = call { i32, i32, i32, i32 } asm "ldr $0, $4 ; add $1, $0, $3 ; add $2, $1, $4 ; ldr $2, $0", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
// Code variables: asmRegisterNames := [$0, $1, $2, $3, $4] ; argsRegisters := [r10, r8] ; constraints := [=&r, =&r, =&r, =&r, *Q, 3]
//    1. we have 4 output constraints, so we have an aggregate type for the return register
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

    private final List<Local> inputAssignments = new ArrayList<>();
    private final List<Event> asmInstructions = new ArrayList<>();
    private final List<Local> outputAssignments = new ArrayList<>();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private CmpInstruction comparator;
    // keeps track of all the labels defined in the the asm code
    private final HashMap<String, Label> labelsDefined = new HashMap<>();
    // used to keep track of which asm register should map to the llvm return register if it is an aggregate type
    private final List<Expression> pendingRegisters = new ArrayList<>();
    // holds the LLVM registers that are passed as (args) to the the asm -- asm"..." (args)
    private final List<Expression> argsRegisters;
    // expected type of RHS of a comparison.
    private Type expectedType;
    // map which holds, given the RegisterID, the register representing the asmRegister
    private final HashMap<Integer, Register> asmRegisters = new HashMap<>();

    public VisitorInlineAsm(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.argsRegisters = llvmArguments;
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

    // tells if the returnRegister is an AggregateType
    private boolean isReturnRegisterAggregate() {
        return getSizeOfReturnRegister() > 1;
    }

    // tells if the registerID is part of the returnRegister
    private boolean isPartOfReturnRegister(int registerID) {
        return registerID < getSizeOfReturnRegister();
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

    // This function lets us know which type we need to assign to the created asm register.
    // In order to do so, we have to understand which llvm register it is going to refer to.
    // given the registerID of the register e.g. $2 -> registerID = 2
    // return the type of the llvm register it is referencing
    // if it is referencing the return register, return its type
    private Type getLlvmRegisterTypeGivenAsmRegisterID(int registerID) {
        Type registerType;
        if (isPartOfReturnRegister(registerID)) {
            if (returnRegister.getType() instanceof AggregateType at) {
                // e.g. returnRegisterType = { i32, i32 } "... $1", "=&r, =&r, r" (i32 r5) 
                //  w.h. registerID = 1, we have to access returnRegister[1].getType()
                registerType = at.getFields().get(registerID);
            } else {
                // returnRegister is not an aggregate, we just get that type
                registerType = returnRegister.getType();
            }
        } else {
            // in this case we have an index which is higher than the size of the return Register
            // this means that, like in visitAsmMetadataEntries, we have to "shift" the value by the size of returnRegister type's size
            // Same example as visitAsmMetadataEntries:
            // e.g. returnRegisterType = { i32, i32 } "... $2", "=&r, =&r, r" (i32 r5)
            // we have registerID 2, we have returnRegisterType size = 2, so we have to perform 2-2 = 0, which is the right index
            // to get argsRegisters[2-2] = argsRegisters[0] = r5.
            registerType = argsRegisters.get(registerID - getSizeOfReturnRegister()).getType();
        }
        return registerType;
    }

    private String makeRegisterName(int registerID) {
        return "asm_" + registerID;
    }

    // this function is the entrypoint of the visitor.
    // the events that are going to be generated are
    // 1) inputAssignments -- how we map llvm registers to asm ones
    // 2) asmInstructions -- the events representing the asm instructions
    // 3) outputAssignments -- how we map the asm registers to the return Register
    @Override
    public List<Event> visitAsm(InlineAsmParser.AsmContext ctx) {
        // Given this format 
        //      Register = Type call asm sideeffect 'asm code', 'constraints, clobbers' ('args')
        // the visitor pattern is going to take care of first visiting all the 'asm code'
        // which is going to populate all of the 'asmInstructions' and creating the asmRegisters.
        // Then, by reading the constraints, we are going to be able to understand which asmRegister
        // maps to which llvmRegister.
        visitChildren(ctx);
        // We have created the asmInstructions first by visiting "asmInstrEntries"
        // and then the inputAssignments and outputAssignments by visiting "asmMetadataEntries"
        List<Event> events = new ArrayList<>();
        // this is going to define how the input operands (argsRegisters from llvm) should be mapped to the asm ones
        events.addAll(inputAssignments);
        // this is going to generate all of the events related to the asm code (load, store, cmp, jmp,...)
        events.addAll(asmInstructions);
        // this has to be the last thing that we do, and it is going to map the asm registers to the returnRegister
        // it is put as last so that we are sure that we are reading the latest data that was written to the register
        events.addAll(outputAssignments);
        return events;
    }

    // tells if constraint is a numberic constraint e.g. '3'
    private boolean isConstraintNumeric(InlineAsmParser.ConstraintContext constraint) {
        return constraint.overlapInOutRegister() != null;
    }

    // tells us is the constraint is a memory location '=*m'
    private boolean isConstraintMemoryLocation(InlineAsmParser.ConstraintContext constraint) {
        return constraint.pointerToMemoryLocation() != null;
    }

    // tells us if the constraint is an output constraint e.g. '=r' or '=&r'
    private boolean isConstraintOutputConstraint(InlineAsmParser.ConstraintContext constraint) {
        return constraint.outputOpAssign() != null;
    }

    // tells us if the constraint is an input constraint e.g. 'Q' or '*Q' or 'r' 
    private boolean isConstraintInputConstraint(InlineAsmParser.ConstraintContext constraint) {
        return constraint.memoryAddress() != null || constraint.inputOpGeneralReg() != null;
    }

    @Override
    public Object visitLoad(InlineAsmParser.LoadContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLoad(register, address));
        return null;
    }

    @Override
    public Object visitLoadAcquire(InlineAsmParser.LoadAcquireContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLoadWithMo(register, address, Tag.ARMv8.MO_ACQ));
        return null;
    }

    @Override
    public Object visitLoadExclusive(InlineAsmParser.LoadExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusive(register, address));
        return null;
    }

    @Override
    public Object visitLoadAcquireExclusive(InlineAsmParser.LoadAcquireExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.ARMv8.MO_ACQ));
        return null;
    }

    @Override
    public Object visitAdd(InlineAsmParser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitSub(InlineAsmParser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitOr(InlineAsmParser.OrContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntOr(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitAnd(InlineAsmParser.AndContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeIntAnd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitStore(InlineAsmParser.StoreContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
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
        Label label = getOrNewLabel(ctx.NumbersInline().getText());
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
        return null;
    }

    @Override
    public Object visitBranchEqual(InlineAsmParser.BranchEqualContext ctx) {
        Label label = getOrNewLabel(ctx.NumbersInline().getText());
        Expression expr = expressions.makeIntCmp(comparator.left, IntCmpOp.EQ, comparator.right);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchNotEqual(InlineAsmParser.BranchNotEqualContext ctx) {
        Label label = getOrNewLabel(ctx.NumbersInline().getText());
        Expression expr = expressions.makeIntCmp(comparator.left, IntCmpOp.NEQ, comparator.right);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitLabelDefinition(InlineAsmParser.LabelDefinitionContext ctx) {
        String labelID = ctx.NumbersInline().getText();
        Label label = getOrNewLabel(labelID);
        asmInstructions.add(label);
        return null;
    }

    @Override
    public Object visitExpr(InlineAsmParser.ExprContext ctx) {
        return ctx.getChild(0).accept(this);
    }

    // If the register with that ID was already defined, we simply return it
    // otherwise, we create and return the new register.
    // each time we call this visitor, it picks up the ID of the register -- e.g. $3 -> ID = 3.
    // if we created a register which refers to the return Register, we have to add to "pendingRegisters", 
    // as we are going to need it during visitMetadata part
    @Override
    public Object visitRegister(InlineAsmParser.RegisterContext ctx) {
        String registerName = ctx.NumbersInline().getText();
        int registerID = Integer.parseInt(registerName);
        // if w.h. the register, return it
        if (asmRegisters.containsKey(registerID)) {
            return asmRegisters.get(registerID);
        } else {
            // otherwise, pick up the correct type and create the new Register
            Type registerType = getLlvmRegisterTypeGivenAsmRegisterID(registerID);
            Register newRegister = this.llvmFunction.getOrNewRegister(makeRegisterName(registerID), registerType);
            // if the register is part of the return register, we have to register it for the final assignment for the output
            // as we are going to do it later when we have enough information in visitAsmMetadata when visiting the constraints.
            if (isPartOfReturnRegister(registerID) && isReturnRegisterAggregate()) {
                this.pendingRegisters.add(newRegister);
            }
            asmRegisters.put(registerID, newRegister);
            return newRegister;
        }
    }

    // This visitor generates the last two kind of events: 
    // 1) inputAssignments -> how to map llvm registers (args) to asm ones used in the instructions
    // 2) outputAssignments -> how to map asm registers to the return register
    // when we reach this point we have already defined all of the asmInstructions events
    // which means that we already have created all of the asm registers
    // we just have to read the constraints, and based on their type, understand if they are going to map
    // to the (args) llvm registers or to the llvm return Register.
    @Override
    public Object visitAsmMetadataEntries(InlineAsmParser.AsmMetadataEntriesContext ctx) {
        List<InlineAsmParser.ConstraintContext> constraints = ctx.constraint();
        // we already have all of the registers from LHS of the context call (asmInstrEntries)
        // now it is time to generate the input and output assignments to let Dat3M understand the llvm to asm registers mapping
        boolean outputRegistersInitialized = returnRegister == null;
        for (int i = 0; i < constraints.size(); i++) {
            InlineAsmParser.ConstraintContext constraint = constraints.get(i);
            if (isConstraintMemoryLocation(constraint)) {
                // the register that should be used as a returnRegister refers to a memory location
                // and therefore we are sure that it does not contain any returnRegister
                // therefore should avoid creating output assignments.
                outputRegistersInitialized = true;
                continue;
            }
            if (isConstraintOutputConstraint(constraint)) {
                continue;
            }
            if (!outputRegistersInitialized) {
                // Here we create the outputAssignment as we're here we're at the 1st input constraint found
                // since we know that all of the output constraints come before the input one
                outputRegistersInitialized = true;
                // if we are at index 1 we only read a single output constraint e.g. "=&r, r" and we are at "r" now.
                if (i == 1) {
                    outputAssignments.add(EventFactory.newLocal(returnRegister, asmRegisters.get(0)));
                } else {
                    // we know that the type of the returnRegister is something like { i32, i32 } or { i32, i32, i32} ...
                    // so we have to slice from 0 to i-1 to get the aggregateType
                    // create the aggregate assignment and assign it to the returnRegister
                    Type aggregateType = TypeFactory.getInstance().getAggregateType(((AggregateType) returnRegister.getType()).getFields());
                    Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
                    outputAssignments.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
                }
            }
            // from here onwards we only generate inputAssignments
            if (isConstraintInputConstraint(constraint)) {
                // here we have already passed all of the output constraints and we are looking at the input ones.
                // e.g. { i32, i32 } "... $2", "=&r, =&r, r" (i32 r5)
                // we know that $0, $1 refers to the returnRegister
                // this means that, once we got the asmRegister $2, we have to assign it to the llvmRegister r5
                // in order to do so, we simply shift the index by the size of the returnRegister
                Register asmRegister = asmRegisters.get(i);
                if (asmRegister == null) {
                    // we are referencing a register that is not present in the asm code
                    // we can safely skip it as we are not going to assign it to anything
                    // this can happen if :
                    // 1) call void "dmb ish", "r"(i32 0) -- "r" constraint refers to llvmRegister containing i32 0, but it is not present in the asm code
                    // 2) call void "str ${2:w}, [$1]", "=*m,r,r"(ptr %5, ptr %6, i32 %7)"
                    //      in this case =*m refers to a memory location which should be $0, but it is not present in the asm code.
                    continue;
                }
                Expression llvmRegister = argsRegisters.get(i - getSizeOfReturnRegister());
                inputAssignments.add(EventFactory.newLocal(asmRegister, llvmRegister));
            }
            if (isConstraintNumeric(constraint)) {
                // https://llvm.org/docs/LangRef.html#input-constraints
                // e.g. r11 = call { i32, i32, i32, i32 } asm "...", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
                // we know from the number contained in the constraint that $3 has to be mapped to an argsRegisters. 
                // Since the value of asmRegisterNameIndex in this case is 5, we shift it by 4 (the number of return values) and we get 1
                // we can therefore access argsRegisters[1], which gives us the correct index for the arg Register.
                int constraintValue = Integer.parseInt(constraint.getText());
                inputAssignments.add(EventFactory.newLocal(asmRegisters.get(constraintValue), argsRegisters.get(i - getSizeOfReturnRegister())));
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
