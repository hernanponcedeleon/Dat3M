package com.dat3m.dartagnan.parsers.program.visitors;

import java.util.ArrayList;
import java.util.List;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;

public class VisitorAsmX86 extends AsmX86BaseVisitor<Object> {

    private final List<Event> asmInstructions = new ArrayList<>();

    public VisitorAsmX86(Function llvmFunction, Register returnRegister, List<Expression> llvmArguments) {}

    @Override
    public List<Event> visitAsm(AsmX86Parser.AsmContext ctx) {
        visitChildren(ctx);
        List<Event> events = new ArrayList<>();
        events.addAll(asmInstructions);
        return events;
    }

    @Override
    public Object visitX86Fence(AsmX86Parser.X86FenceContext ctx) {
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
