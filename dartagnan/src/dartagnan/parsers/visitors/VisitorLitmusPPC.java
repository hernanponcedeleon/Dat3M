package dartagnan.parsers.visitors;

import dartagnan.LitmusPPCBaseVisitor;
import dartagnan.LitmusPPCParser;
import dartagnan.LitmusPPCVisitor;
import dartagnan.asserts.*;
import dartagnan.expression.AConst;
import dartagnan.expression.AExpr;
import dartagnan.parsers.utils.*;
import dartagnan.parsers.utils.branch.Cmp;
import dartagnan.parsers.utils.branch.CondJump;
import dartagnan.program.*;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Load;
import dartagnan.program.event.Local;
import dartagnan.program.event.Store;

import java.util.*;

public class VisitorLitmusPPC
        extends LitmusPPCBaseVisitor<Object>
        implements LitmusPPCVisitor<Object> {

    private final static Set<String> fences = new HashSet<>(Arrays.asList("Sync", "Lwsync", "Isync"));

    private ProgramBuilder programBuilder = new ProgramBuilder();
    private String mainThread;
    private Integer threadCount = 0;


    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusPPCParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        visitAssertionList(ctx.assertionList());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusPPCParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.addDeclarationLocImm(ctx.location().getText(), Integer.parseInt(ctx.value().getText()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPPCParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.addDeclarationRegImm(threadId(ctx.threadId().getText()), ctx.register().getText(), Integer.parseInt(ctx.value().getText()));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPPCParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.addDeclarationRegLoc(threadId(ctx.threadId().getText()), ctx.register().getText(), ctx.location().getText());
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusPPCParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.addDeclarationLocLoc(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusPPCParser.ThreadDeclaratorListContext ctx) {
        for(LitmusPPCParser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.initThread(threadId(threadCtx.ThreadIdentifier().getText()));
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusPPCParser.InstructionRowContext ctx) {
        for(Integer i = 0; i < threadCount; i++){
            mainThread = i.toString();
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitNone(LitmusPPCParser.NoneContext ctx) {
        return null;
    }

    @Override
    public Object visitLi(LitmusPPCParser.LiContext ctx) {
        Register register = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText());
        AConst constant = new AConst(Integer.parseInt(ctx.value().getText()));
        return programBuilder.addChild(mainThread, new Local(register, constant));
    }

    @Override
    public Object visitLwz(LitmusPPCParser.LwzContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText());
        Location location = programBuilder.getLocForReg(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, new Load(r1, location, "_rx"));
    }

    @Override
    public Object visitLwzx(LitmusPPCParser.LwzxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("lwzx is not implemented");
    }

    @Override
    public Object visitStw(LitmusPPCParser.StwContext ctx) {
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.register(0).getText());
        Location location = programBuilder.getLocForReg(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, new Store(location, r1, "_rx"));
    }

    @Override
    public Object visitStwx(LitmusPPCParser.StwxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("stwx is not implemented");
    }

    @Override
    public Object visitMr(LitmusPPCParser.MrContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText());
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, new Local(r1, r2));
    }

    @Override
    public Object visitAddi(LitmusPPCParser.AddiContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText());
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        AConst constant = new AConst(Integer.parseInt(ctx.value().getText()));
        return programBuilder.addChild(mainThread, new Local(r1, new AExpr(r2, "+", constant)));
    }

    @Override
    public Object visitXor(LitmusPPCParser.XorContext ctx) {
        Register r1 = programBuilder.getOrCreateRegister(mainThread, ctx.register(0).getText());
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        Register r3 = programBuilder.getOrErrorRegister(mainThread, ctx.register(2).getText());
        return programBuilder.addChild(mainThread, new Local(r1, new AExpr(r2, "xor", r3)));
    }

    @Override
    public Object visitCmpw(LitmusPPCParser.CmpwContext ctx) {
        Register r1 = programBuilder.getOrErrorRegister(mainThread, ctx.register(0).getText());
        Register r2 = programBuilder.getOrErrorRegister(mainThread, ctx.register(1).getText());
        return programBuilder.addChild(mainThread, new Cmp(r1, r2));
    }

    @Override
    public Object visitBranchCond(LitmusPPCParser.BranchCondContext ctx) {
        return programBuilder.addChild(mainThread, new CondJump(
                ctx.BranchCondInstruction().getText(),
                programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText())
        ));
    }

    @Override
    public Object visitLabel(LitmusPPCParser.LabelContext ctx) {
        return programBuilder.addChild(mainThread, programBuilder.getOrCreateLabel(mainThread, ctx.Label().getText()));
    }

    @Override
    public Object visitFence(LitmusPPCParser.FenceContext ctx) {
        String name = ctx.getText().toLowerCase();
        name = name.substring(0, 1).toUpperCase() + name.substring(1);
        if(fences.contains(name)){
            return programBuilder.addChild(mainThread, new Fence(name));
        }
        throw new ParsingException("Unrecognised fence " + name);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Assertions

    @Override
    public Object visitAssertionList(LitmusPPCParser.AssertionListContext ctx) {
        if(ctx != null){
            AbstractAssert ass = (AbstractAssert) visit(ctx.assertion());
            if(ctx.AssertionForall() != null){
                ass = new AssertNot(ass);
            }

            ass.setType(getAssertionType(ctx));
            programBuilder.setAssert(ass);
        }
        return null;
    }

    @Override
    public Object visitAssertionBasic(LitmusPPCParser.AssertionBasicContext ctx){
        Object arg1 = ctx.assertionValue(0).accept(this);
        Object arg2 = ctx.assertionValue(1).accept(this);
        return new AssertBasic(
                arg1 instanceof Location ? (Location)arg1 : arg1 instanceof Register ? (Register)arg1 : (AConst)arg1,
                assOp(ctx.assertionCompare().getText()),
                arg2 instanceof Location ? (Location)arg2 : arg2 instanceof Register ? (Register)arg2 : (AConst)arg2);
    }

    @Override
    public Object visitAssertionValue(LitmusPPCParser.AssertionValueContext ctx){
        if(ctx.location() != null){
            return programBuilder.getOrErrorLocation(ctx.location().getText());
        }
        if(ctx.register() != null){
            return programBuilder.getOrErrorRegister(threadId(ctx.threadId().getText()), ctx.register().getText());
        }
        return new AConst(Integer.parseInt(ctx.value().getText()));
    }

    @Override
    public Object visitAssertionAnd(LitmusPPCParser.AssertionAndContext ctx) {
        return new AssertCompositeAnd(
                (AbstractAssert) visit(ctx.assertion(0)),
                (AbstractAssert) visit(ctx.assertion(1))
        );
    }

    @Override
    public Object visitAssertionOr(LitmusPPCParser.AssertionOrContext ctx) {
        return new AssertCompositeOr(
                (AbstractAssert) visit(ctx.assertion(0)),
                (AbstractAssert) visit(ctx.assertion(1))
        );
    }

    @Override
    public Object visitAssertionNot(LitmusPPCParser.AssertionNotContext ctx) {
        return new AssertNot((AbstractAssert) visit(ctx.assertion()));
    }

    @Override
    public Object visitAssertionParenthesis(LitmusPPCParser.AssertionParenthesisContext ctx) {
        return visit(ctx.assertion());
    }

    private String getAssertionType(LitmusPPCParser.AssertionListContext ctx){
        if(ctx.AssertionExists() != null){
            return AbstractAssert.ASSERT_TYPE_EXISTS;
        }

        if(ctx.AssertionExistsNot() != null){
            return AbstractAssert.ASSERT_TYPE_NOT_EXISTS;
        }

        if(ctx.AssertionFinal() != null){
            return AbstractAssert.ASSERT_TYPE_FINAL;
        }

        if(ctx.AssertionForall() != null){
            return AbstractAssert.ASSERT_TYPE_FORALL;
        }

        throw new ParsingException("Unknown type of assertion clause");
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Private

    private String threadId(String threadId){
        return threadId.replace("P", "");
    }

    private String assOp(String op){
        return op.equals("=") ? "==" : op;
    }
}
