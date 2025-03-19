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
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.PPCBaseVisitor;
import com.dat3m.dartagnan.parsers.PPCParser;
import com.dat3m.dartagnan.parsers.program.utils.AsmUtils;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;
import static com.google.common.base.Preconditions.checkState;

public class VisitorPPC extends PPCBaseVisitor<Object> {

    private record CmpInstruction(Expression left, Expression right) {};

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

    public VisitorPPC(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.argsRegisters = llvmArguments;
    }

    // Tells if a constraint is a numeric one, e.g. '3'
    private boolean isConstraintNumeric(PPCParser.ConstraintContext constraint) {
        return constraint.overlapInOutRegister() != null;
    }
    
    // Tells if the constraint is an output one, e.g. '=r' or '=&r'
    private boolean isConstraintOutputConstraint(PPCParser.ConstraintContext constraint) {
        return constraint.outputOpAssign() != null;
    }

    // Tells us if the constraint is an input one, e.g. 'r' or '*m'
    private boolean isConstraintInputConstraint(PPCParser.ConstraintContext constraint) {
        return constraint.inputOpGeneralReg() != null;
    }

    @Override
    public List<Event> visitAsm(PPCParser.AsmContext ctx) {
        visitChildren(ctx);
        List<Event> events = new ArrayList<>();
        events.addAll(inputAssignments);
        events.addAll(asmInstructions);
        events.addAll(outputAssignments);
        return events;
    }

    @Override
    public Object visitLoad(PPCParser.LoadContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newLoad(register, address));
        return null;
    }

    @Override
    public Object visitLoadReserve(PPCParser.LoadReserveContext ctx) {
        Register register = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        expectedType = address.getType();
        Expression offset = (Expression) ctx.value().accept(this);
        Expression newAddress = expressions.makeAdd(address,offset);
        asmInstructions.add(EventFactory.newRMWLoadExclusive(register, newAddress));
        return null;
    }

    @Override
    public Object visitStore(PPCParser.StoreContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        asmInstructions.add(EventFactory.newStore(address, value));
        return null;
    }

    @Override
    public Object visitStoreConditional(PPCParser.StoreConditionalContext ctx) {
        Register value = (Register) ctx.register(0).accept(this);
        Register address = (Register) ctx.register(1).accept(this);
        expectedType = address.getType();
        Expression offset = (Expression) ctx.value().accept(this);
        Expression newAddress = expressions.makeAdd(address,offset);
        Register resultRegister = llvmFunction.getOrNewRegister("CondStoreResult", value.getType());
        this.comparator = new CmpInstruction(resultRegister,expressions.makeZero((IntegerType) value.getType()));
        asmInstructions.add(EventFactory.Common.newExclusiveStore(resultRegister, newAddress, value, ""));
        return null;
    }

    @Override
    public Object visitCompare(PPCParser.CompareContext ctx) {
        Register firstRegister = (Register) ctx.register(0).accept(this);
        expectedType = firstRegister.getType();
        Expression secondRegister = (Expression) ctx.register(1).accept(this);
        this.comparator = new CmpInstruction(firstRegister, secondRegister);
        return null;
    }

    @Override
    public Object visitBranchNotEqual(PPCParser.BranchNotEqualContext ctx) {
        Label label = AsmUtils.getOrNewLabel(labelsDefined, ctx.Numbers().getText());
        Expression expr = expressions.makeIntCmp(comparator.left(), IntCmpOp.NEQ, comparator.right());
        asmInstructions.add(EventFactory.newJump(expr, label));
        return null;
    }

    @Override
    public Object visitNop(PPCParser.NopContext ctx) {
        // or 1, 1, 1 is a nop, so we do not perform anything.
        return null;
    }

    @Override
    public Object visitAdd(PPCParser.AddContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeAdd(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }
    
    @Override
    public Object visitAddImmediateCarry(PPCParser.AddImmediateCarryContext ctx) {
        // It also sets the Carry bit of fixed-point exception register in HW
        // https://www.ibm.com/docs/sv/aix/7.2?topic=set-addic-ai-add-immediate-carrying-instruction
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register registerToSum = (Register) ctx.register(1).accept(this);
        expectedType = registerToSum.getType();
        Expression value = (Expression) ctx.value().accept(this);
        Expression exp = expressions.makeAdd(registerToSum, value);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }
    
    @Override
    public Object visitSubtractFrom(PPCParser.SubtractFromContext ctx) {
        Register resultRegister = (Register) ctx.register(0).accept(this);
        Register leftRegister = (Register) ctx.register(1).accept(this);
        Register rightRegister = (Register) ctx.register(2).accept(this);
        Expression exp = expressions.makeSub(leftRegister, rightRegister);
        asmInstructions.add(EventFactory.newLocal(resultRegister, exp));
        return null;
    }


    @Override
    public Object visitLabelDefinition(PPCParser.LabelDefinitionContext ctx) {
        String labelID = ctx.Numbers().getText();
        Label label = AsmUtils.getOrNewLabel(labelsDefined, labelID);
        asmInstructions.add(label);
        return null;
    }

    @Override
    public Object visitValue(PPCParser.ValueContext ctx) {
        checkState(expectedType instanceof IntegerType, "Expected type is not an integer type");
        String valueString = ctx.Numbers().getText();
        BigInteger value = new BigInteger(valueString);
        return expressions.makeValue(value, (IntegerType) expectedType);
    }
    

    // If the register with that ID was already defined, we simply return it
    // otherwise, we create and return the new register.
    // Each time we call this visitor, it picks up the ID of the register -- e.g. $3 -> ID = 3.
    // if we created a register which will be mapped to the return Register, we have to add to "pendingRegisters", 
    // as we are going to need it while visiting the metadata to create the output assignment
    @Override
    public Object visitRegister(PPCParser.RegisterContext ctx) {
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
    public Object visitAsmMetadataEntries(PPCParser.AsmMetadataEntriesContext ctx) {
        List<PPCParser.ConstraintContext> constraints = ctx.constraint();
        boolean isOutputRegistersInitialized = returnRegister == null;
        // We iterate until we find the first non-output constraint. Then we immediately initialize the return register
        // (the right-hand side of the assignment will be either a single register or an aggregate type depending on how many output constraints we processed). 
        // We then map args registers to asm registers (we need to shift the register ID to find the corresponding args position of the matching register).
        // Numeric constraint just map the registerID with the corresponding numeric position. (https://llvm.org/docs/LangRef.html#input-constraints)
        for (int i = 0; i < constraints.size(); i++) {
            PPCParser.ConstraintContext constraint = constraints.get(i);
            if (isConstraintOutputConstraint(constraint)) {
                continue;
            }
            if (!isOutputRegistersInitialized) {
                isOutputRegistersInitialized = true;
                if (i == 1) {
                    outputAssignments.add(EventFactory.newLocal(returnRegister, asmRegisters.get(0)));
                } else {
                    Type aggregateType = returnRegister.getType();
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
    public Object visitPpcFence(PPCParser.PpcFenceContext ctx) {
        String barrier = ctx.PPCFence().getText();
        Event fence = switch (barrier) {
            case "sync" ->
                EventFactory.Power.newSyncBarrier();
            case "isync" ->
                EventFactory.Power.newISyncBarrier();
            case "lwsync" ->
                EventFactory.Power.newLwSyncBarrier();
            default ->
                throw new ParsingException("Barrier not implemented");
        };
        asmInstructions.add(fence);
        return null;
    }

}
