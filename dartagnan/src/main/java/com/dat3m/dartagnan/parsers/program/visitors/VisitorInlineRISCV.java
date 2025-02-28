package com.dat3m.dartagnan.parsers.program.visitors;

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
import com.dat3m.dartagnan.parsers.InlineRISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.InlineRISCVParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

// The trickiest part of handling inline assembly is matching input and output registers on the LLVM side with the registers in the assembly.
// The matching depends on what is specified in the constraints.
// On the LLVM side, the inline assembly is called as follows
//      Register = Type call asm sideeffect 'asm code', 'constraints, clobbers' ('args')
// We call "asm registers" the ones appearing inside 'asm code'.
// We call "llvm registers" the ones passed in 'args' (i.e. the function parameters) plus Register.
// The "clobbers" helps the compiler understand if the inline asm code is going to set conditional flags, perform memory operation and so on.
// Examples are ~{memory}, ~{flags}, ...
// The constraints tell us how to map asm registers to LLVM ones.
// Constraints form a list where each entry can be one of the following:
// =r or =&r means we need to map an asm register to the return register. These are called Output constraints
// Q, *Q or r means we need to map an LLVM register from 'args' to an asm register. These are called Input constraints
// =*m means that the register is a memory location, and is not mapped to any register. These are called Indirect constraints.
// a constant X means that a register from 'args' is mapped to the Xth asm register which in turn is mapped to the return register.
// Here are some examples to understand what is happening.
// We are going to use ARMV7 names for readability "$0, $1, $2, ...", but other inline asm formats follow the same pattern 
// a) BASE CASE
// asm: r10 = i32 call asm "ldr $0, $1"," =r, *Q"(ptr r9) 
// Code variables: asmRegisters := [asm_0, asm_1] ; argsRegisters := [r9] ; constraints := [=r, *Q]
// Logic:
//     1. the first asm register maps to the output, i.e. r10 <- asm_0
//     2. the first args register maps to the next asm register, i.e. asm_1 <- r9
// b) RETURN REGISTER IS AGGREGATE TYPE
// asm: r10 = { i32, i32, i32 } asm "ldr $0, $3 ; ldr $1, $3 ; ldr $2, $3","=r, =r, =r, *Q"(ptr r9)
// Code variables asmRegisters := [asm_0, asm_1, asm_2, asm_3] ; argsRegisters := [r9] ; constraints := [=r, =r, =r, *Q]
// Logic:
//     1. the first 3 asm registers map to the output, i.e.
//         - r10[0] <- asm_0
//         - r10[1] <- asm_1
//         - r10[2] <- asm_2
//      2. the first args register maps to the next asm register, i.e. asm_3 <- r9
// c) MULTIPLE ARGS
// asm: r10 = i32 call asm "ldr $0, $1 ; ldr $0, $2 "," =r, r, *Q"(i32 r8, ptr r9)
// Code variables: asmRegisters := [asm_0, asm_1, asm_2] ; argsRegisters := [r8, r9] ; constraints := [=r, r, *Q]
//    1. the first asm register maps to the output, i.e. r10 <- asm_0
//    2. the two args registers map to the next two asm registers, i.e.
//       - asm_1 <- r8
//       - asm_2 <- r9
// THERE IS NO RETURN REGISTER
// d) 
// asm: call void asm "stlr $0, $1", "r,*Q"(ptr r5, ptr r7)
// Code variables: asmRegisters := [asm_0, asm_1] ; argsRegisters := [r5, r7] ; constraints := [r, *Q]
//    1. nothing to be done regarding output, i.e. there is no return register
//    2. the two args registers map to the next two asm registers, i.e.
//       - asm_0 <- r5
//       - asm_1 <- r7
// e) THERE IS A MEMORY LOCATION
// asm: r10 = i32 call asm "ldr $0, $2 ; ldr $0, $3","=&r, =*m, r, r"(ptr r7, i32 r8)
// Code variables: asmRegisters := [asm_0, asm_2, asm_3] ; argsRegisters := [r7, r8] ; constraints := [=&r, =*m, r, r]
//    1. r10 <- asm_0
//    2. we see that =*m is a reference to a memory location, so it would be asm_1 -> MEM and we do nothing
//    3. the two args registers map to the next two asm registers,
//       - asm_2 <- r7
//       - asm_3 <- r8
// f) WE HAVE AN OVERLAP IN THE RETURN REGISTER AND THE ARGS
// asm: r11 = call { i32, i32, i32, i32 } asm "ldr $0, $4 ; add $1, $0, $3 ; add $2, $1, $4 ; ldr $2, $0", "=&r,=&r,=&r,=&r,*Q,3"(ptr r10, i32 r8)
// Code variables: asmRegisters := [asm_0, asm_1, asm_2, asm_3, asm_4] ; argsRegisters := [r10, r8] ; constraints := [=&r, =&r, =&r, =&r, *Q, 3]
//    1. we have 4 output constraints, so we have an aggregate type for the return register
//       - r11[0] <- asm_0
//       - r11[1] <- asm_1
//       - r11[2] <- asm_2
//       - r11[3] <- asm_3
//    2. map function parameter to next asm register, i.e. asm_4 <- r10
//    3. the third asm register is related both to the return register (already above in r11[3] <- asm_3) and to an args register, i.e. asm_3 <- r8
public class VisitorInlineRISCV extends InlineRISCVBaseVisitor<Object> {

    private class CmpInstruction {

        private final Expression left;
        private final Expression right;

        private CmpInstruction(Expression left, Expression right) {
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
    private final List<Register> pendingRegisters = new ArrayList<>();
    // holds the LLVM registers that are passed (as args) to the the asm side
    private final List<Expression> argsRegisters;
    // expected type of RHS of a comparison.
    private Type expectedType;
    // map from RegisterID to the corresponding asm register
    private final HashMap<Integer, Register> asmRegisters = new HashMap<>();

    public VisitorInlineRISCV(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.argsRegisters = llvmArguments;
    }

    // Returns the size of the return register
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

    // Tells if the returnRegister is an AggregateType
    private boolean isReturnRegisterAggregate() {
        return getSizeOfReturnRegister() > 1;
    }

    // Tells if the registerID is mapped to the returnRegister
    private boolean isPartOfReturnRegister(int registerID) {
        return registerID < getSizeOfReturnRegister();
    }

    // Given a string of a label, it either creates a new label, or returns the existing one if it was already defined
    private Label getOrNewLabel(String labelName) {
        if (!this.labelsDefined.containsKey(labelName)) {
            this.labelsDefined.put(labelName, EventFactory.newLabel(labelName));
        }
        return this.labelsDefined.get(labelName);
    }

    // This function lets us know which type we need to assign to the created asm register.
    // In order to do so, we have to understand which llvm register it is going to be mapped to.
    // Given the registerID of the register e.g. $2 -> registerID = 2
    // returns the type of the llvm register it is mapped to by the clobbers
    // if it is referencing the return register, return its type.
    private Type getLlvmRegisterTypeGivenAsmRegisterID(int registerID) {
        Type registerType;
        if (isPartOfReturnRegister(registerID)) {
            if (returnRegister.getType() instanceof AggregateType at) {
                // get the type from the corresponding field
                registerType = at.getFields().get(registerID);
            } else {
                // returnRegister is not an aggregate, we just get that type
                registerType = returnRegister.getType();
            }
        } else {
            // registerID is mapped to a register in args. To get the correct position in args we need to shift the id by the size of the return register
            registerType = argsRegisters.get(registerID - getSizeOfReturnRegister()).getType();
        }
        return registerType;
    }

    private String makeRegisterName(int registerID) {
        return "asm_" + registerID;
    }

    // This function is the entrypoint of the visitor.
    // the events that are going to be generated are
    // 1) inputAssignments -- how we map llvm registers in asm to asm ones
    // 2) asmInstructions -- the events representing the asm instructions
    // 3) outputAssignments -- how we map the asm registers to the return Register
    // The visitor will first visit the asm code (which will create the events and asm registers) and then the constraints. 
    // The latter will take care of creating input and output assignments.
    @Override
    public List<Event> visitAsm(InlineRISCVParser.AsmContext ctx) {
        System.out.println(ctx.getText());
        visitChildren(ctx);
        List<Event> events = new ArrayList<>();
        events.addAll(inputAssignments);
        events.addAll(asmInstructions);
        events.addAll(outputAssignments);
        return events;
    }

    // // Tells if the constraint is a memory location '=*m'
    // private boolean isConstraintMemoryLocation(InlineRISCVParser.ConstraintContext constraint) {
    //     return constraint.pointerToMemoryLocation() != null;
    // }

    // Tells if the constraint is an output one, e.g. '=r' or '=&r'
    private boolean isConstraintOutputConstraint(InlineRISCVParser.ConstraintContext constraint) {
        return constraint.outputOpAssign() != null;
    }

    // Tells us if the constraint is an input one, e.g. 'Q' or '*Q' or 'r' 
    private boolean isConstraintInputConstraint(InlineRISCVParser.ConstraintContext constraint) {
        return constraint.inputOpGeneralReg() != null;
    }

    @Override
    public Object visitLoad(InlineRISCVParser.LoadContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLoad(register, address));
        return null;
    }

    @Override
    public Object visitLoadExclusive(InlineRISCVParser.LoadExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusive(register, address));
        return null;
    }

    @Override
    public Object visitLoadAcquireExclusive(InlineRISCVParser.LoadAcquireExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.RISCV.MO_ACQ));
        return null;
    }

    @Override
    public Object visitLoadAcquireReleaseExclusive(InlineRISCVParser.LoadAcquireReleaseExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.RISCV.MO_ACQ_REL));
        return null;
    }

    @Override
    public Object visitAdd(InlineRISCVParser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitSub(InlineRISCVParser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitStore(InlineRISCVParser.StoreContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newStore(address, value));
        return null;
    }


    @Override
    public Object visitStoreConditional(InlineRISCVParser.StoreConditionalContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        asmInstructions.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.RISCV.MO_REL)); // for now I put Release semantics
        return null;
    }

    @Override
    public Object visitStoreConditionalRelease(InlineRISCVParser.StoreConditionalReleaseContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        asmInstructions.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.RISCV.MO_REL));
        return null;
    }

    @Override
    public Object visitMove(InlineRISCVParser.MoveContext ctx) {
        Register toRegister = (Register) ctx.register(0).accept(this);
        Register fromRegister = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLocal(toRegister, fromRegister));
        return null;
    }

    @Override
    public Object visitBranchNotEqual(InlineRISCVParser.BranchNotEqualContext ctx) {
        Label label = getOrNewLabel(ctx.NumbersInline().getText());
        Register firstRegister = (Register) ctx.register(0).accept(this);
        Register secondRegister = (Register) ctx.register(1).accept(this);
        Expression expr = expressions.makeIntCmp(firstRegister, IntCmpOp.NEQ, secondRegister);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchNotEqualZero(InlineRISCVParser.BranchNotEqualZeroContext ctx) {
        Label label = getOrNewLabel(ctx.NumbersInline().getText());
        Register firstRegister = (Register) ctx.register().accept(this);
        Expression zero = expressions.makeZero((IntegerType) firstRegister.getType());
        Expression expr = expressions.makeIntCmp(firstRegister, IntCmpOp.NEQ, zero);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitLabelDefinition(InlineRISCVParser.LabelDefinitionContext ctx) {
        String labelID = ctx.NumbersInline().getText();
        Label label = getOrNewLabel(labelID);
        asmInstructions.add(label);
        return null;
    }

    @Override
    public Object visitNegate(InlineRISCVParser.NegateContext ctx){
        System.out.println("Reading" + ctx.getText());
        // neg $0 $1 -> sub $0, #0, $1
        Register destinationRegister = (Register) ctx.register(0).accept(this);
        Register sourceRegister = (Register) ctx.register(1).accept(this);
        Expression zero = expressions.makeZero((IntegerType) sourceRegister.getType());
        Expression exp = expressions.makeSub(zero, sourceRegister);
        asmInstructions.add(EventFactory.newLocal(destinationRegister,exp));
        return null;
    }

    @Override
    public Object visitAtomicAdd(InlineRISCVParser.AtomicAddContext ctx){
        System.out.println("Reading" + ctx.getText());
        return null;
    }
    @Override
    public Object visitAtomicAddRelease(InlineRISCVParser.AtomicAddReleaseContext ctx){
        System.out.println("Reading" + ctx.getText());
        return null;
    }
    @Override
    public Object visitAtomicAddAcquireRelease(InlineRISCVParser.AtomicAddAcquireReleaseContext ctx){
        System.out.println("Reading" + ctx.getText());
        return null;
    }
    // If the register with that ID was already defined, we simply return it
    // otherwise, we create and return the new register.
    // Each time we call this visitor, it picks up the ID of the register -- e.g. $3 -> ID = 3.
    // if we created a register which will be mapped to the return Register, we have to add to "pendingRegisters", 
    // as we are going to need it while visiting the metadata to create the output assignment
    @Override
    public Object visitRegister(InlineRISCVParser.RegisterContext ctx) {
        String registerName = ctx.NumbersInline().getText();
        int registerID = Integer.parseInt(registerName);
        if (asmRegisters.containsKey(registerID)) {
            return asmRegisters.get(registerID);
        } else {
            // Pick up the correct type and create the new Register
            Type registerType = getLlvmRegisterTypeGivenAsmRegisterID(registerID);
            Register newRegister = this.llvmFunction.getOrNewRegister(makeRegisterName(registerID), registerType);
            if (isPartOfReturnRegister(registerID) && isReturnRegisterAggregate()) {
                this.pendingRegisters.add(newRegister);
            }
            asmRegisters.put(registerID, newRegister);
            return newRegister;
        }
    }

    // This visitor generates two sets of events: 
    // 1) inputAssignments -> how to map llvm registers from args to asm registers used in the asm instructions
    // 2) outputAssignments -> how to map asm registers to the return register
    // When this visitor is called, we have already created all of the asm registers.
    // We just have to read the constraints, and based on their type, understand if they are going to be mapped
    // to the args registers or to the return register.
    @Override
    public Object visitAsmMetadataEntries(InlineRISCVParser.AsmMetadataEntriesContext ctx) {
        List<InlineRISCVParser.ConstraintContext> constraints = ctx.constraint();
        boolean isOutputRegistersInitialized = returnRegister == null;
        // We iterate until we find the first non-output constraint. Then we immediately initialize the return register
        // (the right-hand side of the assignment will be either a single register or an aggregate type depending on how many output constraints we processed). 
        // We then map args registers to asm registers (we need to shift the register ID to find the corresponding args position of the matching register).
        for (int i = 0; i < constraints.size(); i++) {
            InlineRISCVParser.ConstraintContext constraint = constraints.get(i);
            if (isConstraintOutputConstraint(constraint)) {
                continue;
            }
            if (!isOutputRegistersInitialized) {
                isOutputRegistersInitialized = true;
                if (i == 1) {
                    outputAssignments.add(EventFactory.newLocal(returnRegister, asmRegisters.get(0)));
                } else {
                    Type aggregateType = TypeFactory.getInstance().getAggregateType(((AggregateType) returnRegister.getType()).getFields());
                    Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
                    outputAssignments.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
                }
            }
            if (isConstraintInputConstraint(constraint)) {
                Register asmRegister = asmRegisters.get(i);
                if (asmRegister == null) {
                    continue;
                }
                Expression llvmRegister = argsRegisters.get(i - getSizeOfReturnRegister());
                inputAssignments.add(EventFactory.newLocal(asmRegister, llvmRegister));
            }
        }
        return null;
    }

    @Override
    public Object visitRiscvFence(InlineRISCVParser.RiscvFenceContext ctx) {
        String mo = ctx.fenceOptions().mode;
        Event fence = switch(mo) {
            case "r r" -> EventFactory.RISCV.newRRFence();
            case "r w" -> EventFactory.RISCV.newRWFence();
            case "r rw" -> EventFactory.RISCV.newRRWFence();
            case "w r" -> EventFactory.RISCV.newWRFence();
            case "w w" -> EventFactory.RISCV.newWWFence();
            case "w rw" -> EventFactory.RISCV.newWRWFence();
            case "rw r" -> EventFactory.RISCV.newRWRFence();
            case "rw w" -> EventFactory.RISCV.newRWWFence();
            case "rw rw" -> EventFactory.RISCV.newRWRWFence();
            case "tso" -> EventFactory.RISCV.newTsoFence();
            case "i" -> EventFactory.RISCV.newSynchronizeFence();
            default -> throw new ParsingException("Barrier not implemented");
        };
        asmInstructions.add(fence);
        return null;
    }

}
