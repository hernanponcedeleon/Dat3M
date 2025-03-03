package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.InlineX86BaseVisitor;
import com.dat3m.dartagnan.parsers.InlineX86Parser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.core.Local;

public class VisitorInlineX86 extends InlineX86BaseVisitor<Object> {

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

    public VisitorInlineX86(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {
        this.llvmFunction = llvmFunction;
        this.returnRegister = returnRegister;
        this.argsRegisters = llvmArguments;
    }

    // Returns the size of the return register
    // null / void -> 0
    // i32 / bool -> 1
    // aggregateType -> the amount of asm registers which are referred by the return registers
    // e.g. { i32, i32 } -> 2
    private int getNumASMReturnRegisters() {
        if (this.returnRegister == null) {
            return 0;
        }
        Type returnType = this.returnRegister.getType();
        if (returnType instanceof IntegerType || returnType instanceof BooleanType) {
            return 1;
        } else if (isReturnRegisterAggregate()) {
            return ((AggregateType) returnType).getTypeOffsets().size();
        } else if (returnType instanceof VoidType) {
            return 0;
        } else {
            throw new ParsingException("Unknown inline asm return type " + returnType);
        }
    }

    // Tells if the returnRegister is an AggregateType
    private boolean isReturnRegisterAggregate() {
        Type returnRegisterType = this.returnRegister.getType();
        return returnRegisterType != null && returnRegisterType instanceof AggregateType;
    }

    // Tells if the registerID is mapped to the returnRegister
    private boolean isPartOfReturnRegister(int registerID) {
        return registerID < getNumASMReturnRegisters();
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
    // We are sure that an asm register is going to refer to a llvm one
    // by the fact that the input is well formed.
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
            registerType = argsRegisters.get(registerID - getNumASMReturnRegisters()).getType();
        }
        return registerType;
    }

    private String makeRegisterName(int registerID) {
        return "asm_" + registerID;
    }

    @Override
    public List<Event> visitAsm(InlineX86Parser.AsmContext ctx) {
        visitChildren(ctx);
        List<Event> events = new ArrayList<>();
        events.addAll(asmInstructions);
        return events;
    }

    @Override
    public Object visitX86Fence(InlineX86Parser.X86FenceContext ctx) {
        String barrier = ctx.X86Fence().getText();
        Event fence = switch (barrier) {
            case "mfence" ->
                EventFactory.X86.newMemoryFence();
            default ->
                throw new ParsingException("Barrier not implemented");
        };
        asmInstructions.add(fence);
        return null;
    }

}
