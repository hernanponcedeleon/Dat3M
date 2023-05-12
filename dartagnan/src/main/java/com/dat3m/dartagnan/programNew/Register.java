package com.dat3m.dartagnan.programNew;


import com.dat3m.dartagnan.expr.Expression;
import com.dat3m.dartagnan.expr.ExpressionKind;
import com.dat3m.dartagnan.expr.ExpressionVisitor;
import com.dat3m.dartagnan.expr.Type;
import com.dat3m.dartagnan.expr.helper.LeafExpressionBase;
import com.dat3m.dartagnan.programNew.event.Event;

import java.util.Set;

public class Register extends LeafExpressionBase<Type, ExpressionKind.Leaf> {

    private final String name;
    private final Function owner;

    protected Register(Type type, String name, Function owner) {
        super(type, ExpressionKind.Leaf.REGISTER);
        this.name = name;
        this.owner = owner;
    }

    public static Register create(Type type, String name, Function owner) {
        return new Register(type, name, owner);
    }

    public static void collectRegisterReads(Expression expr, UsageType depType, Set<Read> collector) {
        if (expr instanceof Register reg) {
            collector.add(new Read(reg, depType));
        } else {
            for (Expression child : expr.getOperands()) {
                collectRegisterReads(child, depType, collector);
            }
        }
    }

    public String getName() {
        return name;
    }
    public Function getOwner() { return owner; }

    @Override
    public String toString() { return name; }

    @Override
    public int hashCode() {
        return name.hashCode() + owner.hashCode();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        } else if (obj == null || getClass() != obj.getClass()) {
            return false;
        }

        Register rObj = (Register) obj;
        return name.equals(rObj.name) && owner == rObj.owner;
    }

    @Override
    public <TRet> TRet accept(ExpressionVisitor<TRet> visitor) {
        return visitor.visitRegister(this);
    }


    // ==========================================================================
    // ==========================================================================
    // ============================== Inner classes =============================
    // ==========================================================================
    // ==========================================================================

    public enum UsageType {
        CTRL, DATA, ADDR, // The register value is used to determine control, data, or addr.
        OTHER;            // The register value is used for a different purpose.
    }

    /*
        Describes for what purpose a register was read.
    */
    public record Read(Register register, UsageType usageType) { }

    /*
            Any event that can read register values needs to implement this interface.
            Any such read is associated with a usage (ctrl, data, addr) that tells for what purpose the register value is used.

            NOTES:
                - Only branching events should return ctrl-usages
                - Only memory events should return addr-usages
                - Only (local) assignments and (shared) stores should return data-usages.
                - EXCEPTIONS: Special events like "assume" can be made to return arbitrary dependencies.
    */
    public interface Reader extends Event {
        Set<Read> getRegisterReads();
    }

    /*
            All events that modify register values must implement this interface.
            Complex events whose compilation/lowering introduce (invisible) intermediary registers,
            are not considered RegisterWriter.
            For example:
              - MemCpy is no RegisterWriter
              - RMWCAS is a RegisterWriter because it returns the CAS result, not because it uses intermediary dummy registers.

            NOTE: For any RegisterWriter, the type of value it produces is supposed to match the type of the register.
            In particular, a Load to a register R always loads a value from memory that matches R's type.
    */
    public interface Writer extends Event {
        Register getResultRegister(); //TODO: Maybe a List<Register> ? Is there any use-case for this?
    }
}
