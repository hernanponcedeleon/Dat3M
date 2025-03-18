package com.dat3m.dartagnan.parsers.program.utils;

import java.util.HashMap;
import java.util.List;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.BooleanType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;

// this class contains common functions which are independent from the grammar for inline assembly
public class AsmUtils {

    // Returns the size of the return register
    // null / void -> 0
    // i32 / bool -> 1
    // aggregateType -> the amount of asm registers which are referred by the return registers
    // e.g. { i32, i32 } -> 2
    public static int getNumASMReturnRegisters(Register returnRegister) {
        if (returnRegister == null) {
            return 0;
        }
        Type returnType = returnRegister.getType();
        if (returnType instanceof IntegerType || returnType instanceof BooleanType) {
            return 1;
        } else if (isReturnRegisterAggregate(returnRegister)) {
            return ((AggregateType) returnType).getFields().size();
        } else if (returnType instanceof VoidType) {
            return 0;
        } else {
            throw new ParsingException("Unknown inline asm return type " + returnType);
        }
    }

    // Tells if the returnRegister is an AggregateType
    public static boolean isReturnRegisterAggregate(Register returnRegister) {
        Type returnRegisterType = returnRegister.getType();
        return returnRegisterType != null && returnRegisterType instanceof AggregateType;
    }

    // Tells if the registerID is mapped to the returnRegister
    public static boolean isPartOfReturnRegister(Register returnRegister,int registerID) {
        return registerID < getNumASMReturnRegisters(returnRegister);
    }

    // Given a string of a label, it either creates a new label, or returns the existing one if it was already defined
    public static Label getOrNewLabel(HashMap<String, Label> labelsDefined, String labelName) {
        if (!labelsDefined.containsKey(labelName)) {
            labelsDefined.put(labelName, EventFactory.newLabel(labelName));
        }
        return labelsDefined.get(labelName);
    }

    // This function lets us know which type we need to assign to the created asm register.
    // In order to do so, we have to understand which llvm register it is going to be mapped to.
    // Given the registerID of the register e.g. $2 -> registerID = 2
    // returns the type of the llvm register it is mapped to by the clobbers
    // if it is referencing the return register, return its type.
    // As said in the introduction, we are sure that an asm register is going to refer to a llvm one
    // by the fact that the input is well formed.
    public static Type getLlvmRegisterTypeGivenAsmRegisterID(List<Expression> argsRegisters, Register returnRegister, int registerID) {
        Type registerType;
        if (isPartOfReturnRegister(returnRegister, registerID)) {
            if (returnRegister.getType() instanceof AggregateType at) {
                // get the type from the corresponding field
                registerType = at.getFields().get(registerID).type();
            } else {
                // returnRegister is not an aggregate, we just get that type
                registerType = returnRegister.getType();
            }
        } else {
            // registerID is mapped to a register in args. To get the correct position in args we need to shift the id by the size of the return register
            registerType = argsRegisters.get(registerID - getNumASMReturnRegisters(returnRegister)).getType();
        }
        return registerType;
    }

    public static String makeRegisterName(int registerID) {
        return "asm_" + registerID;
    }

}
