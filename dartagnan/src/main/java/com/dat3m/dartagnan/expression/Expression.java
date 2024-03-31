package com.dat3m.dartagnan.expression;

import com.dat3m.dartagnan.expression.processing.ExpressionInspector;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.memory.VirtualMemoryObject;
import com.google.common.collect.ImmutableSet;

import java.util.List;

public interface Expression {

    Type getType();
    List<Expression> getOperands();
    ExpressionKind getKind();
    <T> T accept(ExpressionVisitor<T> visitor);

    default ImmutableSet<Register> getRegs() {
        class RegisterCollector implements ExpressionInspector {
            private final ImmutableSet.Builder<Register> regs = ImmutableSet.builder();
            @Override
            public Expression visitRegister(Register reg) {
                regs.add(reg);
                return reg;
            }
        }

        final RegisterCollector collector = new RegisterCollector();
        this.accept(collector);
        return collector.regs.build();
    }

    default ImmutableSet<VirtualMemoryObject> getVirtualAddresses() {
        class VirtualAddressCollector implements ExpressionInspector {
            private final ImmutableSet.Builder<VirtualMemoryObject> objects = ImmutableSet.builder();
            @Override
            public MemoryObject visitMemoryObject(MemoryObject memObj) {
                if (memObj instanceof VirtualMemoryObject vMemObj) {
                    objects.add(vMemObj);
                }
                return memObj;
            }
        }

        final VirtualAddressCollector collector = new VirtualAddressCollector();
        this.accept(collector);
        return collector.objects.build();
    }
}
