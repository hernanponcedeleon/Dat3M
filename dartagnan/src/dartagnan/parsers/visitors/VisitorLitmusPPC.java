package dartagnan.parsers.visitors;

import dartagnan.program.Thread;
import dartagnan.program.*;
import dartagnan.expression.*;
import dartagnan.asserts.*;
import dartagnan.LitmusPPCParser;
import dartagnan.LitmusPPCVisitor;
import dartagnan.parsers.utils.Utils;
import dartagnan.parsers.utils.Branch.BareIf;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.RuleNode;

import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Stack;
import java.util.UUID;

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
    private boolean allowEmptyAssertFlag = false;

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusPPCParser.MainContext ctx) {
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
        return new Load(r1, location);
    }

    @Override
    public Object visitLwzx(LitmusPPCParser.LwzxContext ctx) {
        // TODO: Implementation
        throw new RuntimeException("lwzx is not implemented");
    }

    @Override
    public Object visitStw(LitmusPPCParser.StwContext ctx) {
        Register r1 = getRegister(mainThread, ctx.r1().getText(), true);
        Location location = getLocationForRegister(mainThread, ctx.r2().getText());
        return new Store(location, r1);
    }

    @Override
    public Object visitStwx(LitmusPPCParser.StwxContext ctx) {
        // TODO: Implementation
        throw new RuntimeException("stwx is not implemented");
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
        Thread lastEvent = getLastEvent(mainThread);
        if(!(lastEvent instanceof BareIf)){
            error("Invalid instruction sequence in thread " + mainThread);
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
        Thread lastEvent = getLastEvent(mainThread);
        if(!(lastEvent instanceof BareIf)){
            error("Invalid instruction sequence in thread " + mainThread);
        }

        String label = ctx.Label().getText();
        List<Thread> mainThreadInstructions = getThreadEvents(mainThread);
        if(((BareIf)lastEvent).getEndLabel() != null
                && ((BareIf)lastEvent).getEndLabel().equals(label)){

            ((BareIf) lastEvent).setT1(closeBranch());
            mainThreadInstructions.remove(mainThreadInstructions.size() - 1);
            return ((BareIf) lastEvent).toIf();
        }

        if(((BareIf)lastEvent).getElseLabel() != null
                && ((BareIf)lastEvent).getElseLabel().equals(label)){

            if(((BareIf)lastEvent).getEndLabel() == null){
                ((BareIf)lastEvent).setT2(closeBranch());
                mainThreadInstructions.remove(mainThreadInstructions.size() - 1);
                return ((BareIf)lastEvent).toIf();

            } else {
                forkBranch();
            }
        }
        return null;
    }

    @Override
    public Object visitB(LitmusPPCParser.BContext ctx) {
        Thread lastEvent = getLastEvent(mainThread);
        if(!(lastEvent instanceof BareIf) || ((BareIf) lastEvent).getEndLabel() != null){
            error("Invalid instruction sequence in thread " + mainThread);
        }
        String label = ctx.Label().getText();
        ((BareIf) lastEvent).setEndLabel(label);
        ((BareIf) lastEvent).setT2(closeBranch());
        return null;
    }

    @Override
    public Object visitSync(LitmusPPCParser.SyncContext ctx) {
        return new Sync();
    }

    @Override
    public Object visitLwsync(LitmusPPCParser.LwsyncContext ctx) {
        return new Lwsync();
    }

    @Override
    public Object visitIsync(LitmusPPCParser.IsyncContext ctx) {
        return new Isync();
    }

    @Override
    public Object visitEieio(LitmusPPCParser.EieioContext ctx) {
        // TODO: Implementation
        throw new RuntimeException("eieio is not implemented");
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Assertions

    @Override
    public Object visitAssertionList(LitmusPPCParser.AssertionListContext ctx) {
        if(ctx == null){
            if(!allowEmptyAssertFlag){
                error("Missing assertion");
            }
            program.setAss(new AssertDummy());
            return null;
        }

        Assert ass = null;
        int n = ctx.getChildCount();
        for(int i = 0; i < n; ++i) {
            Object childResult = ctx.getChild(i).accept(this);
            if(childResult instanceof AssertInterface){
                ass = (Assert) childResult;
                break;
            }
        }

        if(ass == null){
            error("Failed to parse assertion");
        }

        if(ctx.AssertionExistsNot() != null){
            ass = new AssertNot((AssertInterface)ass);
        }

        program.setAss(ass);
        return null;
    }

    @Override
    public Object visitAssertionClauseOr(LitmusPPCParser.AssertionClauseOrContext ctx) {
        return visitAssertionClauseComposite(ctx, new AssertCompositeOr());
    }

    @Override
    public Object visitAssertionClauseAnd(LitmusPPCParser.AssertionClauseAndContext ctx) {
        return visitAssertionClauseComposite(ctx, new AssertCompositeAnd());
    }

    @Override
    public Object visitAssertionClauseOrWithParenthesis(LitmusPPCParser.AssertionClauseOrWithParenthesisContext ctx) {
        return visitAssertionClauseComposite(ctx, new AssertCompositeOr());
    }

    private Object visitAssertionClauseComposite(RuleNode ctx, AssertCompositeInterface ass){
        int n = ctx.getChildCount();
        for(int i = 0; i < n; i++) {
            Object child = ctx.getChild(i).accept(this);
            if(child instanceof AssertInterface){
                ass.addChild((AssertInterface) child);
            }
        }
        return ass;
    }

    @Override
    public Object visitAssertion(LitmusPPCParser.AssertionContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public Object visitVariableAssertionLocation(LitmusPPCParser.VariableAssertionLocationContext ctx) {
        Location location = getLocation(ctx.location().getText());
        int value = Integer.parseInt(ctx.value().getText());
        return new AssertLocation(location, value);
    }

    @Override
    public Object visitVariableAssertionRegister(LitmusPPCParser.VariableAssertionRegisterContext ctx) {
        Register register = getRegister(threadId(ctx.thread().getText()), ctx.r1().getText());
        int value = Integer.parseInt(ctx.value().getText());
        return new AssertRegister(register, value);
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

    public void setAllowEmptyAssertFlag(boolean flag){
        allowEmptyAssertFlag = flag;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Private

    private String threadId(String threadId){
        return threadId.replace("P", "");
    }

    private String effectiveThread(){
        return branchingStacks.get(mainThread).peek();
    }

    private Map<String, Location> getMapRegLoc(String threadName){
        if(!(mapRegistersLocations.keySet().contains(threadName))) {
            error("Unknown thread " + threadName);
        }
        return mapRegistersLocations.get(threadName);
    }

    private Register getRegister(String threadName, String registerName, boolean failOnMissingRegister){
        if(!failOnMissingRegister){
            return getRegister(threadName, registerName);
        }

        if(!(mapRegisters.keySet().contains(threadName))) {
            error("Unknown thread " + threadName);
        }
        Map<String, Register> registers = mapRegisters.get(threadName);
        if(!(registers.keySet().contains(registerName))) {
            error("Register " + registerName + " must be initialised");
        }
        return registers.get(registerName);
    }

    private Register getRegister(String threadName, String registerName){
        if(!(mapRegisters.keySet().contains(threadName))) {
            error("Unknown thread " + threadName);
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

    private Location getLocationForRegister(String threadName, String registerName){
        if(!mapRegistersLocations.containsKey(threadName)){
            error("Unknown thread " + threadName);
        }
        Map<String, Location> registerLocationMap = mapRegistersLocations.get(threadName);
        if(!registerLocationMap.containsKey(registerName)){
            error("Register " + registerName + " must be initialized to a location");
        }
        return registerLocationMap.get(registerName);
    }

    private List<Thread> getThreadEvents(String threadName){
        if(!(mapThreadEvents.keySet().contains(threadName))) {
            error("Unknown thread " + threadName);
        }
        return mapThreadEvents.get(threadName);
    }

    private Thread getLastEvent(String threadName){
        List<Thread> events = getThreadEvents(threadName);
        int size = events.size();
        if(size == 0){
            error("Invalid instruction sequence in thread " + mainThread);
        }
        return events.get(size - 1);
    }

    private void error(String msg){
        // TODO: Own type of exception
        throw new RuntimeException("Parser : " + msg);
    }
}