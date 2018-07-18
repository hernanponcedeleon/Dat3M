package dartagnan.parsers.visitors;

import dartagnan.LitmusX86Parser;
import dartagnan.LitmusX86Visitor;
import dartagnan.asserts.*;
import dartagnan.expression.AConst;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.Utils;
import dartagnan.program.*;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Load;
import dartagnan.program.event.Local;
import dartagnan.program.event.Store;
import dartagnan.program.event.rmw.Xchg;
import dartagnan.program.Thread;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VisitorLitmusX86
        extends AbstractParseTreeVisitor<Object>
        implements LitmusX86Visitor<Object> {

    public static final int DEFAULT_LOCATION_VALUE = 0;

    private Map<String, Location> mapLocations = new HashMap<String, Location>();
    private Map<String, List<Thread>> mapThreadEvents = new HashMap<String, List<Thread>>();
    private Map<String, Map<String, Register>> mapRegisters = new HashMap<String, Map<String, Register>>();
    private Map<String, Map<String, Location>> mapRegistersLocations = new HashMap<String, Map<String, Location>>();

    private Program program;
    private String mainThread;
    private Integer threadCount = 0;

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusX86Parser.MainContext ctx) {
        program = new Program("");

        visitThreadDeclaratorList(ctx.threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.instructionList());
        visitAssertionList(ctx.assertionList());

        for(String i : mapThreadEvents.keySet()) {
            program.add(Utils.listToThread(mapThreadEvents.get(i)));
        }
        return program;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Header (not used)

    @Override
    public Object visitHeader(LitmusX86Parser.HeaderContext ctx) {
        return null;
    }

    @Override
    public Object visitHeaderComment(LitmusX86Parser.HeaderCommentContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorList(LitmusX86Parser.VariableDeclaratorListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitVariableDeclarator(LitmusX86Parser.VariableDeclaratorContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusX86Parser.VariableDeclaratorLocationContext ctx) {
        Integer value = Integer.parseInt(ctx.value().getText());
        Location location = getLocation(ctx.location().getText());
        location.setIValue(value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusX86Parser.VariableDeclaratorRegisterContext ctx) {
        String thread = threadId(ctx.thread().getText());
        Register register = getRegister(thread, ctx.r1().getText());
        Integer iValue = Integer.parseInt(ctx.value().getText());
        getThreadEvents(thread).add(new Local(register, new AConst(iValue)));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusX86Parser.VariableDeclaratorRegisterLocationContext ctx) {
        String thread = threadId(ctx.thread().getText());
        Location location = getLocation(ctx.location().getText());
        String registerName = ctx.r1().getText();
        getRegister(thread, registerName);
        getMapRegLoc(thread).put(registerName, location);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusX86Parser.ThreadDeclaratorListContext ctx) {
        for(LitmusX86Parser.ThreadContext threadCtx : ctx.thread()){
            String thread = threadId(threadCtx.ThreadIdentifier().getText());
            mapThreadEvents.put(thread, new ArrayList<Thread>());
            mapRegisters.put(thread, new HashMap<String, Register>());
            mapRegistersLocations.put(thread, new HashMap<String, Location>());
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionList(LitmusX86Parser.InstructionListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitInstructionRow(LitmusX86Parser.InstructionRowContext ctx) {
        for(Integer i = 0; i < threadCount; i++){
            mainThread = i.toString();
            Thread thread = (Thread)visitInstruction(ctx.instruction(i));
            if(thread != null){
                getThreadEvents(mainThread).add(thread);
            }
        }
        return null;
    }

    @Override
    public Object visitInstruction(LitmusX86Parser.InstructionContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitNone(LitmusX86Parser.NoneContext ctx) {
        return null;
    }

    @Override
    public Object visitLoadValueToRegister(LitmusX86Parser.LoadValueToRegisterContext ctx) {
        Register register = getRegister(mainThread, ctx.r1().getText());
        AConst constant = new AConst(Integer.parseInt(ctx.value().getText()));
        return new Local(register, constant);
    }

    @Override
    public Object visitLoadLocationToRegister(LitmusX86Parser.LoadLocationToRegisterContext ctx) {
        Register register = getRegister(mainThread, ctx.r1().getText());
        Location location = getLocation(ctx.location().getText());
        return new Load(register, location, "_rx");
    }

    @Override
    public Object visitStoreValueToLocation(LitmusX86Parser.StoreValueToLocationContext ctx) {
        Location location = getLocation(ctx.location().getText());
        AConst constant = new AConst(Integer.parseInt(ctx.value().getText()));
        return new Store(location, constant, "_rx");
    }

    @Override
    public Object visitStoreRegisterToLocation(LitmusX86Parser.StoreRegisterToLocationContext ctx) {
        Register register = getRegister(mainThread, ctx.r1().getText(), true);
        Location location = getLocation(ctx.location().getText());
        return new Store(location, register, "_rx");
    }

    @Override
    public Object visitExchangeRegisterLocation(LitmusX86Parser.ExchangeRegisterLocationContext ctx) {
        Register register = getRegister(mainThread, ctx.r1().getText(), true);
        Location location = getLocation(ctx.location().getText());
        return new Xchg(location, register, "_rx");
    }

    @Override
    public Object visitIncrementLocation(LitmusX86Parser.IncrementLocationContext ctx) {
        // TODO: Implementation
        throw new ParsingException("INC is not implemented");
    }

    @Override
    public Object visitCompareRegisterValue(LitmusX86Parser.CompareRegisterValueContext ctx) {
        // TODO: Implementation
        throw new ParsingException("CMP is not implemented");
    }

    @Override
    public Object visitCompareLocationValue(LitmusX86Parser.CompareLocationValueContext ctx) {
        // TODO: Implementation
        throw new ParsingException("CMP is not implemented");
    }

    @Override
    public Object visitAddRegisterRegister(LitmusX86Parser.AddRegisterRegisterContext ctx) {
        // TODO: Implementation
        throw new ParsingException("ADD is not implemented");
    }

    @Override
    public Object visitAddRegisterValue(LitmusX86Parser.AddRegisterValueContext ctx) {
        // TODO: Implementation
        throw new ParsingException("ADD is not implemented");
    }

    @Override
    public Object visitMfence(LitmusX86Parser.MfenceContext ctx) {
        return new Fence("mfence");
    }

    @Override
    public Object visitLfence(LitmusX86Parser.LfenceContext ctx) {
        // TODO: Implementation
        throw new ParsingException("LFENCE is not implemented");
    }

    @Override
    public Thread visitSfence(LitmusX86Parser.SfenceContext ctx) {
        // TODO: Implementation
        throw new ParsingException("SFENCE is not implemented");
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Assertions

    @Override
    public Object visitAssertionList(LitmusX86Parser.AssertionListContext ctx) {
        if(ctx != null){
            AbstractAssert ass = (AbstractAssert) visit(ctx.assertion());
            if(ctx.AssertionForall() != null){
                ass = new AssertNot(ass);
            }

            ass.setType(getAssertionType(ctx));
            program.setAss(ass);
        }
        return null;
    }

    @Override
    public Object visitAssertionLocation(LitmusX86Parser.AssertionLocationContext ctx) {
        Location location = getLocation(ctx.location().getText());
        int value = Integer.parseInt(ctx.value().getText());
        return new AssertLocation(location, value);
    }

    @Override
    public Object visitAssertionRegister(LitmusX86Parser.AssertionRegisterContext ctx) {
        String thread = threadId(ctx.thread().getText());
        Register register = getRegister(thread, ctx.r1().getText());
        int value = Integer.parseInt(ctx.value().getText());
        return new AssertRegister(thread, register, value);
    }

    @Override
    public Object visitAssertionAnd(LitmusX86Parser.AssertionAndContext ctx) {
        return new AssertCompositeAnd(
                (AbstractAssert) visit(ctx.assertion(0)),
                (AbstractAssert) visit(ctx.assertion(1))
        );
    }

    @Override
    public Object visitAssertionOr(LitmusX86Parser.AssertionOrContext ctx) {
        return new AssertCompositeOr(
                (AbstractAssert) visit(ctx.assertion(0)),
                (AbstractAssert) visit(ctx.assertion(1))
        );
    }

    @Override
    public Object visitAssertionParenthesis(LitmusX86Parser.AssertionParenthesisContext ctx) {
        return visit(ctx.assertion());
    }

    private String getAssertionType(LitmusX86Parser.AssertionListContext ctx){
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
    // Expected values for assertion of type final, e.g.
    //
    // final (P0:EAX = 0 /\ P1:EBX = 0);
    // with
    // tso: ~exists;
    // cc: exists;
    //
    // (not used)

    @Override
    public Object visitAssertionListExpectationList(LitmusX86Parser.AssertionListExpectationListContext ctx) {
        return null;
    }

    @Override
    public Object visitAssertionListExpectation(LitmusX86Parser.AssertionListExpectationContext ctx) {
        return null;
    }

    @Override
    public Object visitAssertionListExpectationTest(LitmusX86Parser.AssertionListExpectationTestContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Locations list, e.g., "locations [0:EAX; 1:EAX; x;]" (not used)

    @Override
    public Object visitVariableList(LitmusX86Parser.VariableListContext ctx) {
        return null;
    }

    @Override
    public Object visitVariable(LitmusX86Parser.VariableContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Auxiliary miscellaneous

    @Override
    public Object visitThread(LitmusX86Parser.ThreadContext ctx) {
        return null;
    }

    @Override
    public Object visitR1(LitmusX86Parser.R1Context ctx) {
        return null;
    }

    @Override
    public Object visitR2(LitmusX86Parser.R2Context ctx) {
        return null;
    }

    @Override
    public Object visitLocation(LitmusX86Parser.LocationContext ctx) {
        return null;
    }

    @Override
    public Object visitValue(LitmusX86Parser.ValueContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Private

    private String threadId(String threadId){
        return threadId.replace("P", "");
    }

    private Map<String, Location> getMapRegLoc(String threadName){
        if(!(mapRegistersLocations.keySet().contains(threadName))) {
            throw new ParsingException("Unknown thread " + threadName);
        }
        return mapRegistersLocations.get(threadName);
    }

    private Register getRegister(String threadName, String registerName, boolean failOnMissingRegister){
        if(!failOnMissingRegister){
            return getRegister(threadName, registerName);
        }

        if(!(mapRegisters.keySet().contains(threadName))) {
            throw new ParsingException("Unknown thread " + threadName);
        }
        Map<String, Register> registers = mapRegisters.get(threadName);
        if(!(registers.keySet().contains(registerName))) {
            throw new ParsingException("Register " + registerName + " must be initialised");
        }
        return registers.get(registerName);
    }

    private Register getRegister(String threadName, String registerName){
        if(!(mapRegisters.keySet().contains(threadName))) {
            throw new ParsingException("Unknown thread " + threadName);
        }
        Map<String, Register> registers = mapRegisters.get(threadName);
        if(!(registers.keySet().contains(registerName))) {
            registers.put(registerName, new Register(registerName));
        }
        return registers.get(registerName);
    }


    private Location getLocation(String locationName){
        if(!mapLocations.containsKey(locationName)){
            Location location = new Location(locationName);
            location.setIValue(DEFAULT_LOCATION_VALUE);
            mapLocations.put(locationName, location);
        }
        return mapLocations.get(locationName);
    }

    private List<Thread> getThreadEvents(String threadName){
        if(!(mapThreadEvents.keySet().contains(threadName))) {
            throw new ParsingException("Unknown thread " + threadName);
        }
        return mapThreadEvents.get(threadName);
    }
}