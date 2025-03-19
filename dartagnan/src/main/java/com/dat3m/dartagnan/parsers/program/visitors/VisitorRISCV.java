package com.dat3m.dartagnan.parsers.program.visitors;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.ProgramProcessingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.RISCVBaseVisitor;
import com.dat3m.dartagnan.parsers.RISCVParser;
import com.dat3m.dartagnan.parsers.program.utils.AsmUtils;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import static com.google.common.base.Preconditions.checkState;
public class VisitorRISCV extends RISCVBaseVisitor<Object> {

    private final List<Local> inputAssignments = new ArrayList<>();
    private final List<Event> asmInstructions = new ArrayList<>();
    private final List<Local> outputAssignments = new ArrayList<>();
    private final Function llvmFunction;
    private final Register returnRegister;
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
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

    public VisitorRISCV(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.argsRegisters = llvmArguments;
    }


    // This function is the entrypoint of the visitor.
    // the events that are going to be generated are
    // 1) inputAssignments -- how we map llvm registers in asm to asm ones
    // 2) asmInstructions -- the events representing the asm instructions
    // 3) outputAssignments -- how we map the asm registers to the return Register
    // The visitor will first visit the asm code (which will create the events and asm registers) and then the constraints. 
    // The latter will take care of creating input and output assignments.
    @Override
    public List<Event> visitAsm(RISCVParser.AsmContext ctx) {
        visitChildren(ctx);
        List<Event> events = new ArrayList<>();
        events.addAll(inputAssignments);
        events.addAll(asmInstructions);
        events.addAll(outputAssignments);
        return events;
    }

    // Tells if a constraint is a numeric one, e.g. '3'
    private boolean isConstraintNumeric(RISCVParser.ConstraintContext constraint) {
        return constraint.overlapInOutRegister() != null;
    }

    // Tells if the constraint is an output one, e.g. '=r' or '=&r'
    private boolean isConstraintOutputConstraint(RISCVParser.ConstraintContext constraint) {
        return constraint.outputOpAssign() != null;
    }

    // Tells us if the constraint is an input one, e.g 'r' or 'A'
    private boolean isConstraintInputConstraint(RISCVParser.ConstraintContext constraint) {
        return constraint.inputOpGeneralReg() != null;
    }

    @Override
    public Object visitLoad(RISCVParser.LoadContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        expectedType = address.getType();
        Expression offset = (Expression) ctx.value().accept(this);
        Expression newAddress = expressions.makeAdd(address,offset);
        asmInstructions.add(EventFactory.newLoad(register, newAddress));
        return null;
    }

    @Override
    public Object visitLoadImmediate(RISCVParser.LoadImmediateContext ctx) {
        Register register = (Register) ctx.register().accept(this);
        expectedType = register.getType();
        Expression value = (Expression) ctx.value().accept(this);
        asmInstructions.add(EventFactory.newLocal(register, value));
        return null;
    }

    @Override
    public Object visitLoadExclusive(RISCVParser.LoadExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusive(register, address));
        return null;
    }

    @Override
    public Object visitLoadAcquireExclusive(RISCVParser.LoadAcquireExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.RISCV.MO_ACQ));
        return null;
    }

    @Override
    public Object visitLoadAcquireReleaseExclusive(RISCVParser.LoadAcquireReleaseExclusiveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newRMWLoadExclusiveWithMo(register, address, Tag.RISCV.MO_ACQ_REL));
        return null;
    }

    @Override
    public Object visitAdd(RISCVParser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitSub(RISCVParser.SubContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }

    @Override
    public Object visitStore(RISCVParser.StoreContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        expectedType = address.getType();
        Expression offset = (Expression) ctx.value().accept(this);
        Expression newAddress = expressions.makeAdd(address,offset);
        asmInstructions.add(EventFactory.newStore(newAddress, value));
        return null;
    }


    @Override
    public Object visitStoreConditional(RISCVParser.StoreConditionalContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        asmInstructions.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.RISCV.STCOND));
        return null;
    }

    @Override
    public Object visitStoreConditionalRelease(RISCVParser.StoreConditionalReleaseContext ctx) {
        Register freshResultRegister = (Register) ctx.register(0).accept(this);
        Register value = (Register) ctx.register(1).accept(this);
        Register address = (Register) ctx.register(2).accept(this);
        asmInstructions.add(EventFactory.Common.newExclusiveStore(freshResultRegister, address, value, Tag.RISCV.MO_REL));
        return null;
    }

    @Override
    public Object visitMove(RISCVParser.MoveContext ctx) {
        Register toRegister = (Register) ctx.register(0).accept(this);
        Register fromRegister = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLocal(toRegister, fromRegister));
        return null;
    }

    @Override
    public Object visitBranchNotEqual(RISCVParser.BranchNotEqualContext ctx) {
        Label label = AsmUtils.getOrNewLabel(labelsDefined, ctx.Numbers().getText());
        Register firstRegister = (Register) ctx.register(0).accept(this);
        Register secondRegister = (Register) ctx.register(1).accept(this);
        Expression expr = expressions.makeIntCmp(firstRegister, IntCmpOp.NEQ, secondRegister);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitBranchNotEqualZero(RISCVParser.BranchNotEqualZeroContext ctx) {
        Label label = AsmUtils.getOrNewLabel(labelsDefined, ctx.Numbers().getText());
        Register firstRegister = (Register) ctx.register().accept(this);
        Expression zero = expressions.makeZero((IntegerType) firstRegister.getType());
        Expression expr = expressions.makeIntCmp(firstRegister, IntCmpOp.NEQ, zero);
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitLabelDefinition(RISCVParser.LabelDefinitionContext ctx) {
        String labelID = ctx.Numbers().getText();
        Label label = AsmUtils.getOrNewLabel(labelsDefined, labelID);
        asmInstructions.add(label);
        return null;
    }

    @Override
    public Object visitNegate(RISCVParser.NegateContext ctx){
        // neg $0 $1 -> sub $0, #0, $1
        Register destinationRegister = (Register) ctx.register(0).accept(this);
        Register sourceRegister = (Register) ctx.register(1).accept(this);
        Expression zero = expressions.makeZero((IntegerType) sourceRegister.getType());
        Expression exp = expressions.makeSub(zero, sourceRegister);
        asmInstructions.add(EventFactory.newLocal(destinationRegister,exp));
        return null;
    }

    @Override
    public Object visitAtomicAdd(RISCVParser.AtomicAddContext ctx){
        throw new ProgramProcessingException(ctx.AtomicAdd().getText());
    }
    @Override
    public Object visitAtomicAddRelease(RISCVParser.AtomicAddReleaseContext ctx){
        throw new ProgramProcessingException(ctx.AtomicAddRelease().getText());
    }
    @Override
    public Object visitAtomicAddAcquireRelease(RISCVParser.AtomicAddAcquireReleaseContext ctx){
        throw new ProgramProcessingException(ctx.AtomicAddAcquireRelease().getText());
    }
    // If the register with that ID was already defined, we simply return it
    // otherwise, we create and return the new register.
    // Each time we call this visitor, it picks up the ID of the register -- e.g. $3 -> ID = 3.
    // if we created a register which will be mapped to the return Register, we have to add to "pendingRegisters", 
    // as we are going to need it while visiting the metadata to create the output assignment
    @Override
    public Object visitRegister(RISCVParser.RegisterContext ctx) {
        String registerNumber = ctx.Numbers().getText();
        int registerID = Integer.parseInt(registerNumber);
        if (asmRegisters.containsKey(registerID)) {
            return asmRegisters.get(registerID);
        } else {
            // Pick up the correct type and create the new Register
            Type registerType = AsmUtils.getLlvmRegisterTypeGivenAsmRegisterID(this.argsRegisters,this.returnRegister,registerID);
            String newRegisterName = AsmUtils.makeRegisterName(registerID);
            Register newRegister = this.llvmFunction.getOrNewRegister(newRegisterName, registerType);
            if (AsmUtils.isPartOfReturnRegister(this.returnRegister, registerID) && AsmUtils.isReturnRegisterAggregate(this.returnRegister)) {
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
    public Object visitAsmMetadataEntries(RISCVParser.AsmMetadataEntriesContext ctx) {
        List<RISCVParser.ConstraintContext> constraints = ctx.constraint();
        boolean isOutputRegistersInitialized = returnRegister == null;
        // We iterate until we find the first non-output constraint. Then we immediately initialize the return register
        // (the right-hand side of the assignment will be either a single register or an aggregate type depending on how many output constraints we processed). 
        // We then map args registers to asm registers (we need to shift the register ID to find the corresponding args position of the matching register).
        for (int i = 0; i < constraints.size(); i++) {
            RISCVParser.ConstraintContext constraint = constraints.get(i);
            if (isConstraintOutputConstraint(constraint)) {
                continue;
            }
            if (!isOutputRegistersInitialized) {
                isOutputRegistersInitialized = true;
                if (i == 1) {
                    outputAssignments.add(EventFactory.newLocal(returnRegister, asmRegisters.get(0)));
                } else {
                    Type aggregateType = returnRegister.getType();
                    // %16 = call { ptr, i32, i64 } asm sideeffect "asm code", "=&r,=&r,=r,r,r,2,~{memory}"(ptr %13, i64 %15, i64 %12)
                    // args are not passed in order, sorting solves it
                    // we can do it only once here where we create the output assignment
                    this.pendingRegisters.sort(Comparator.comparing(Register::getName));
                    Expression finalAssignExpression = expressions.makeConstruct(aggregateType, this.pendingRegisters);
                    outputAssignments.add(EventFactory.newLocal(this.returnRegister, finalAssignExpression));
                }
            }
            if (isConstraintInputConstraint(constraint)) {
                Register asmRegister = asmRegisters.get(i);
                if (asmRegister == null) {
                    continue;
                }
                Expression llvmRegister = argsRegisters.get(i - AsmUtils.getNumASMReturnRegisters(this.returnRegister));
                inputAssignments.add(EventFactory.newLocal(asmRegister, llvmRegister));
            }
            if (isConstraintNumeric(constraint)) {
                int constraintValue = Integer.parseInt(constraint.getText());
                inputAssignments.add(EventFactory.newLocal(asmRegisters.get(constraintValue), argsRegisters.get(i - AsmUtils.getNumASMReturnRegisters(this.returnRegister))));
            }
        }
        return null;
    }

    @Override
    public Object visitRiscvFence(RISCVParser.RiscvFenceContext ctx) {
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

    @Override
    public Object visitValue(RISCVParser.ValueContext ctx) {
        checkState(expectedType instanceof IntegerType, "Expected type is not an integer type");
        String valueString = ctx.Numbers().getText();
        BigInteger value = new BigInteger(valueString);
        return expressions.makeValue(value, (IntegerType) expectedType);
    }

}
