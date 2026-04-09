package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;

import java.util.ArrayList;
import java.util.List;

public class VisitorAsmX86 extends AsmX86BaseVisitor<Object> {

    private final List<Event> asmInstructions = new ArrayList<>();

    public VisitorAsmX86(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {}

    @Override
    public List<Event> visitAsm(AsmContext ctx) {
        visitChildren(ctx);
        return new ArrayList<>(asmInstructions);
    }

    @Override
    public Object visitX86Fence(X86FenceContext ctx) {
        asmInstructions.add(EventFactory.X86.newMemoryFence(ctx.X86Fence().getText()));
        return null;
    }
}
