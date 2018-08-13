package dartagnan.parsers.visitors;

import dartagnan.LitmusPPCParser;
import dartagnan.LitmusPPCVisitor;
import dartagnan.asserts.*;
import dartagnan.expression.AConst;
import dartagnan.expression.AExpr;
import dartagnan.parsers.utils.branch.BareIf;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.Utils;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.Fence;
import dartagnan.program.event.Load;
import dartagnan.program.event.Local;
import dartagnan.program.event.Store;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;

import java.util.*;

public class VisitorLitmusPPC
        extends AbstractParseTreeVisitor<Object>
        implements LitmusPPCVisitor<Object> {

    public static final int DEFAULT_LOCATION_VALUE = 0;

    private Map<String, Location> mapLocations = new HashMap<String, Location>();
    private Map<String, List<Thread>> mapThreadEvents = new HashMap<String, List<Thread>>();
    private Map<String, Map<String, Register>> mapRegisters = new HashMap<String, Map<String, Register>>();
    private Map<String, Map<String, Location>> mapRegistersLocations = new HashMap<String, Map<String, Location>>();

    private Map<String, Stack<String>> branchingStacks = new HashMap<String, Stack<String>>();
    private String effectiveThread;

    private Program program;
    private String mainThread;
    private Integer threadCount = 0;

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusPPCParser.MainContext ctx) {
        program = new Program("");

        visitThreadDeclaratorList(ctx.threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.instructionList());
        visitAssertionList(ctx.assertionList());

        // This can happen if a program contains arbitrary jumps not matching if / else structures
        if(threadCount != mapThreadEvents.size()){
            throw new ParsingException("Not supported instruction sequence");
        }

        for(String i : mapThreadEvents.keySet()) {
            program.add(Utils.listToThread(mapThreadEvents.get(i)));
        }
        return program;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Header (not used)

    @Override
    public Object visitHeader(LitmusPPCParser.HeaderContext ctx) {
        return null;
    }

    @Override
    public Object visitHeaderComment(LitmusPPCParser.HeaderCommentContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorList(LitmusPPCParser.VariableDeclaratorListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitVariableDeclarator(LitmusPPCParser.VariableDeclaratorContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusPPCParser.VariableDeclaratorLocationContext ctx) {
        Integer value = Integer.parseInt(ctx.value().getText());
        Location location = getLocation(ctx.location().getText());
        location.setIValue(value);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusPPCParser.VariableDeclaratorRegisterContext ctx) {
        String thread = threadId(ctx.thread().getText());
        Register register = getRegister(thread, ctx.r1().getText());
        Integer iValue = Integer.parseInt(ctx.value().getText());
        getThreadEvents(thread).add(new Local(register, new AConst(iValue)));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusPPCParser.VariableDeclaratorRegisterLocationContext ctx) {
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
    public Object visitThreadDeclaratorList(LitmusPPCParser.ThreadDeclaratorListContext ctx) {
        for(LitmusPPCParser.ThreadContext threadCtx : ctx.thread()){
            String thread = threadId(threadCtx.ThreadIdentifier().getText());
            mapThreadEvents.put(thread, new ArrayList<Thread>());
            mapRegisters.put(thread, new HashMap<String, Register>());
            mapRegistersLocations.put(thread, new HashMap<String, Location>());

            Stack<String> stack = new Stack<String>();
            stack.push(thread);
            branchingStacks.put(thread, stack);

            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionList(LitmusPPCParser.InstructionListContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitInstructionRow(LitmusPPCParser.InstructionRowContext ctx) {
        for(Integer i = 0; i < threadCount; i++){
            mainThread = i.toString();
            effectiveThread = effectiveThread();
            Thread thread = (Thread)visitInstruction(ctx.instruction(i));
            if(thread != null){
                getThreadEvents(effectiveThread()).add(thread);
            }
        }
        return null;
    }

    @Override
    public Object visitInstruction(LitmusPPCParser.InstructionContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitNone(LitmusPPCParser.NoneContext ctx) {
        return null;
    }

    @Override
    public Object visitLi(LitmusPPCParser.LiContext ctx) {
        Register register = getRegister(mainThread, ctx.r1().getText());
        AConst constant = new AConst(Integer.parseInt(ctx.value().getText()));
        return new Local(register, constant);
    }

    @Override
    public Object visitLwz(LitmusPPCParser.LwzContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText());
        Location location = getLocationForRegister(mainThread, ctx.r2().getText());
        return new Load(r1, location, "_rx");
    }

    @Override
    public Object visitLwzx(LitmusPPCParser.LwzxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("lwzx is not implemented");
    }

    @Override
    public Object visitStw(LitmusPPCParser.StwContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText(), true);
        Location location = getLocationForRegister(mainThread, ctx.r2().getText());
        return new Store(location, r1, "_rx");
    }

    @Override
    public Object visitStwx(LitmusPPCParser.StwxContext ctx) {
        // TODO: Implementation
        throw new ParsingException("stwx is not implemented");
    }

    @Override
    public Object visitMr(LitmusPPCParser.MrContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText());
        Register r2 = getRegister(mainThread, ctx.r2().getText());
        return new Local(r1, r2);
    }

    @Override
    public Object visitAddi(LitmusPPCParser.AddiContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText());
        Register r2 = getRegister(mainThread, ctx.r2().getText());
        AConst constant = new AConst(Integer.parseInt(ctx.value().getText()));
        return new Local(r1, new AExpr(r2, "+", constant));
    }

    @Override
    public Object visitXor(LitmusPPCParser.XorContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText());
        Register r2 = getRegister(mainThread, ctx.r2().getText());
        Register r3 = getRegister(mainThread, ctx.r3().getText());
        return new Local(r1, new AExpr(r2, "xor", r3));
    }

    @Override
    public Object visitCmpw(LitmusPPCParser.CmpwContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText());
        Register r2 = getRegister(mainThread, ctx.r2().getText());
        return new BareIf(r1, r2);
    }

    @Override
    public Object visitBeq(LitmusPPCParser.BeqContext ctx) {
        return visitBranchCondition("==", ctx.Label().getText());
    }

    @Override
    public Object visitBne(LitmusPPCParser.BneContext ctx) {
        return visitBranchCondition("!=", ctx.Label().getText());
    }

    @Override
    public Object visitBlt(LitmusPPCParser.BltContext ctx) {
        return visitBranchCondition("<", ctx.Label().getText());
    }

    @Override
    public Object visitBgt(LitmusPPCParser.BgtContext ctx) {
        return visitBranchCondition(">", ctx.Label().getText());
    }

    @Override
    public Object visitBle(LitmusPPCParser.BleContext ctx) {
        return visitBranchCondition("<=", ctx.Label().getText());
    }

    @Override
    public Object visitBge(LitmusPPCParser.BgeContext ctx) {
        return visitBranchCondition(">=", ctx.Label().getText());
    }

    private Object visitBranchCondition(String op, String label){
        Thread lastEvent = getLastEvent(effectiveThread);
        if(!(lastEvent instanceof BareIf)){
            throw new ParsingException("Invalid instruction sequence in thread " + mainThread);
        }
        ((BareIf)lastEvent).setOp(op);
        ((BareIf)lastEvent).setElseLabel(label);
        forkBranch();
        return null;
    }

    private void forkBranch(){
        String branchId = UUID.randomUUID().toString();
        branchingStacks.get(mainThread).push(branchId);
        mapThreadEvents.put(branchId, new ArrayList<Thread>());
    }

    private Thread closeBranch(){
        List<Thread> branchingThreadInstructions = mapThreadEvents.remove(effectiveThread);
        Thread branchingThread = Utils.listToThread(branchingThreadInstructions);
        branchingStacks.get(mainThread).pop();
        return branchingThread;
    }

    @Override
    public Object visitLabel(LitmusPPCParser.LabelContext ctx) {
        String label = ctx.Label().getText();
        boolean branchFound = false;

        while(true){
            String parentThreadId = parentThread();
            Thread lastEvent = getLastEvent(parentThreadId);
            List<Thread> parentThreadInstructions = getThreadEvents(parentThreadId);

            if(!(lastEvent instanceof BareIf)
                    || ((BareIf)lastEvent).getElseLabel() == null
                    || !((BareIf)lastEvent).getElseLabel().equals(label)){
                if(!branchFound){
                    throw new ParsingException("Not supported instruction sequence");
                }
                break;
            }

            branchFound = true;

            ((BareIf)lastEvent).setT2(closeBranch());
            parentThreadInstructions.remove(parentThreadInstructions.size() - 1);

            getThreadEvents(effectiveThread()).add(((BareIf)lastEvent).toIf());
            effectiveThread = effectiveThread();
        }
        return null;
    }

    @Override
    public Object visitSync(LitmusPPCParser.SyncContext ctx) {
        return new Fence("Sync");
    }

    @Override
    public Object visitLwsync(LitmusPPCParser.LwsyncContext ctx) {
        return new Fence("Lwsync");
    }

    @Override
    public Object visitIsync(LitmusPPCParser.IsyncContext ctx) {
        return new Fence("Isync");
    }

    @Override
    public Object visitEieio(LitmusPPCParser.EieioContext ctx) {
        // TODO: Implementation
        throw new ParsingException("eieio is not implemented");
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
            program.setAss(ass);
        }
        return null;
    }

    @Override
    public Object visitAssertionLocation(LitmusPPCParser.AssertionLocationContext ctx) {
        Location location = getLocation(ctx.location().getText());
        AConst value = new AConst(Integer.parseInt(ctx.value().getText()));
        return new AssertBasic(location, "==", value);
    }

    @Override
    public Object visitAssertionRegister(LitmusPPCParser.AssertionRegisterContext ctx) {
        String thread = threadId(ctx.thread().getText());
        Register register = getRegister(thread, ctx.r1().getText());
        AConst value = new AConst(Integer.parseInt(ctx.value().getText()));
        return new AssertBasic(register, "==", value);
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
    // Expected values for assertion of type final, e.g.
    //
    // final (P0:EAX = 0 /\ P1:EBX = 0);
    // with
    // tso: ~exists;
    // cc: exists;
    //
    // (not used)

    @Override
    public Object visitAssertionListExpectationList(LitmusPPCParser.AssertionListExpectationListContext ctx) {
        return null;
    }

    @Override
    public Object visitAssertionListExpectation(LitmusPPCParser.AssertionListExpectationContext ctx) {
        return null;
    }

    @Override
    public Object visitAssertionListExpectationTest(LitmusPPCParser.AssertionListExpectationTestContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Locations list, e.g., "locations [0:EAX; 1:EAX; x;]" (not used)

    @Override
    public Object visitVariableList(LitmusPPCParser.VariableListContext ctx) {
        return null;
    }

    @Override
    public Object visitVariable(LitmusPPCParser.VariableContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Auxiliary miscellaneous

    @Override
    public Object visitThread(LitmusPPCParser.ThreadContext ctx) {
        return null;
    }

    @Override
    public Object visitR1(LitmusPPCParser.R1Context ctx) {
        return null;
    }

    @Override
    public Object visitR2(LitmusPPCParser.R2Context ctx) {
        return null;
    }

    @Override
    public Object visitR3(LitmusPPCParser.R3Context ctx) {
        return null;
    }

    @Override
    public Object visitLocation(LitmusPPCParser.LocationContext ctx) {
        return null;
    }

    @Override
    public Object visitValue(LitmusPPCParser.ValueContext ctx) {
        return null;
    }

    @Override
    public Object visitOffset(LitmusPPCParser.OffsetContext ctx) {
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Private

    private String threadId(String threadId){
        return threadId.replace("P", "");
    }

    private String effectiveThread(){
        return branchingStacks.get(mainThread).peek();
    }

    private String parentThread(){
        if(effectiveThread().equals(mainThread)){
            return mainThread;
        }

        Stack<String> stack = branchingStacks.get(mainThread);
        String self = stack.pop();
        String parent = stack.peek();
        stack.push(self);
        return parent;
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
            registers.put(registerName, new Register(registerName).setPrintMainThread(threadName));
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

    private Location getLocationForRegister(String threadName, String registerName){
        if(!mapRegistersLocations.containsKey(threadName)){
            throw new ParsingException("Unknown thread " + threadName);
        }
        Map<String, Location> registerLocationMap = mapRegistersLocations.get(threadName);
        if(!registerLocationMap.containsKey(registerName)){
            throw new ParsingException("Register " + registerName + " must be initialized to a location");
        }
        return registerLocationMap.get(registerName);
    }

    private List<Thread> getThreadEvents(String threadName){
        if(!(mapThreadEvents.keySet().contains(threadName))) {
            throw new ParsingException("Unknown thread " + threadName);
        }
        return mapThreadEvents.get(threadName);
    }

    private Thread getLastEvent(String threadName){
        List<Thread> events = getThreadEvents(threadName);
        int size = events.size();
        if(size == 0){
            throw new ParsingException("Invalid instruction sequence in thread " + mainThread);
        }
        return events.get(size - 1);
    }
}
