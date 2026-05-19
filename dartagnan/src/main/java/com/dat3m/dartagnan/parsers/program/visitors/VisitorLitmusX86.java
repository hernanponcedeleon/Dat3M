package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusX86BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusX86Parser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.ParserRuleContext;

public class VisitorLitmusX86 extends LitmusX86BaseVisitor<Object> {

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.TSO);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private final IntegerType archType = types.getArchType();
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusX86(){
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initLocEqConst(ctx.location().getText(), value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        IntLiteral value = expressions.parseValue(ctx.constant().getText(), archType);
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), value, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), archType, ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
        for(ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitLoadValueToRegister(LoadValueToRegisterContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newLocal(register, constant), ctx);
    }

    @Override
    public Object visitLoadLocationToRegister(LoadLocationToRegisterContext ctx) {
        Register register = programBuilder.getOrNewRegister(mainThread, ctx.register().getText(), archType);
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        return append(EventFactory.newLoad(register, object), ctx);
    }

    @Override
    public Object visitStoreValueToLocation(StoreValueToLocationContext ctx) {
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        IntLiteral constant = expressions.parseValue(ctx.constant().getText(), archType);
        return append(EventFactory.newStore(object, constant), ctx);
    }

    @Override
    public Object visitStoreRegisterToLocation(StoreRegisterToLocationContext ctx) {
        Register register = programBuilder.getOrErrorRegister(mainThread, ctx.register().getText());
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        return append(EventFactory.newStore(object, register), ctx);
    }

    @Override
    public Object visitExchangeRegisterLocation(ExchangeRegisterLocationContext ctx) {
        Register register = programBuilder.getOrErrorRegister(mainThread, ctx.register().getText());
        MemoryObject object = programBuilder.getOrNewMemoryObject(ctx.location().getText());
        return append(EventFactory.X86.newExchange(object, register), ctx);
    }

    @Override
    public Object visitIncrementLocation(IncrementLocationContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("INC is not implemented");
    }

    @Override
    public Object visitCompareRegisterValue(CompareRegisterValueContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("CMP is not implemented");
    }

    @Override
    public Object visitCompareLocationValue(CompareLocationValueContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("CMP is not implemented");
    }

    @Override
    public Object visitAddRegisterRegister(AddRegisterRegisterContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("ADD is not implemented");
    }

    @Override
    public Object visitAddRegisterValue(AddRegisterValueContext ctx) {
        // TODO: Implementation
        throw new UnsupportedOperationException("ADD is not implemented");
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        return append(EventFactory.X86.newMemoryFence(ctx.getText().toLowerCase()), ctx);
    }

    private Event append(Event event, ParserRuleContext ctx) {
        return programBuilder.addChild(mainThread, event, ctx.getStart().getLine());
    }
}