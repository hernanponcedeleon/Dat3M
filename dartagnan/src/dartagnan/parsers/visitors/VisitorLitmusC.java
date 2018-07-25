package dartagnan.parsers.visitors;

import dartagnan.LitmusCBaseVisitor;
import dartagnan.LitmusCVisitor;
import dartagnan.LitmusCParser;
import dartagnan.expression.*;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.Utils;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.rmw.RMWStore;
import javafx.util.Pair;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.*;

public class VisitorLitmusC
        extends LitmusCBaseVisitor<Object>
        implements LitmusCVisitor<Object> {

    public static final int DEFAULT_INIT_VALUE = 0;

    private Map<String, Location> mapLocations = new HashMap<String, Location>();
    private Map<String, List<Thread>> mapThreadEvents = new HashMap<String, List<Thread>>();
    private Map<String, Map<String, Register>> mapRegisters = new HashMap<String, Map<String, Register>>();
    private Map<String, Map<String, Location>> mapRegistersLocations = new HashMap<String, Map<String, Location>>();
    private Stack<AExpr> returnStack = new Stack<>();
    private String currentThread;
    private Program program = new Program("");

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusCParser.MainContext ctx) {
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitThreadList(ctx.threadList());

        // TODO: Implementation
        //visitAssertionFilter(ctx.assertionFilter());
        //visitAssertionList(ctx.assertionList());

        //System.out.println("\n\n" + ctx.getText());
        //System.out.println(program);
        return program;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(LitmusCParser.GlobalDeclaratorLocationContext ctx) {
        Location location = getOrCreateLocation(visitVariable(ctx.variable()));
        if (ctx.initConstantValue() != null) {
            location.setIValue(Integer.parseInt(ctx.initConstantValue().constantValue().getText()));
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        Pair<String, String> data = visitThreadVariable(ctx.threadVariable());
        String thread = data.getKey();
        Register register = getOrCreateRegister(thread, data.getValue());

        int value = DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constantValue().getText());
        }
        getThreadEvents(thread).add(new Local(register, new AConst(value)));
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
        Location left = getOrCreateLocation(visitVariable(ctx.variable(0)));
        Location right = getOrCreateLocation(visitVariable(ctx.variable(1)));
        left.setIValue(right.getIValue());
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        Pair<String, String> data = visitThreadVariable(ctx.threadVariable());
        String thread = data.getKey();
        String registerName = data.getValue();
        getOrCreateRegister(thread, registerName);
        Location location = getOrCreateLocation(visitVariable(ctx.variable()));
        getMapRegLoc(thread).put(registerName, location);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Threads (the program itself)

    @Override
    public Object visitThread(LitmusCParser.ThreadContext ctx) {
        visitThreadArguments(ctx.threadArguments());
        currentThread = threadId(ctx.threadIdentifier().getText());
        initThread(currentThread);
        List<Thread> initEvents = getThreadEvents(currentThread);
        Thread result = visitExpressionSequence(ctx);
        if (!(initEvents.isEmpty())) {
            result = new Seq(Utils.listToThread(initEvents), result);
        }
        program.add(result);
        return null;
    }

    @Override
    public Object visitThreadArguments(LitmusCParser.ThreadArgumentsContext ctx){
        int n = ctx.getChildCount();
        for (int i = 0; i < n; ++i) {
            ParseTree child = ctx.getChild(i);
            if (child instanceof LitmusCParser.VariableDeclaratorContext) {
                getOrCreateLocation(visitVariable(((LitmusCParser.VariableDeclaratorContext) child).variable()));
            }
        }
        return null;
    }

    @Override
    public Thread visitExpression(LitmusCParser.ExpressionContext ctx) {
        if (ctx.ifExpression() != null) {
            return visitIfExpression(ctx.ifExpression());
        }
        return (Thread) ctx.seqExpression().accept(this);
    }

    @Override
    public Thread visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
        Thread evalThread = (Thread)ctx.returnExpression().accept(this);

        // TODO: AExpr to BExpr conversion
        //------
        AExpr temp = returnStack.pop();
        BExpr boolExp = new BConst(true);
        //------

        Thread t1 = visitExpressionSequence(ctx);
        Thread t2 = ctx.elseExpression() == null ? new Skip() : visitExpressionSequence(ctx.elseExpression());
        Thread result = new If(boolExp, t1, t2);
        if(evalThread != null){
            result = new Seq(evalThread, result);
        }
        return result;
    }

    @Override
    public Thread visitSeqDeclarationReturnExpression(LitmusCParser.SeqDeclarationReturnExpressionContext ctx){
        String varName = visitVariable(ctx.variable());
        if(getRegister(currentThread, varName) != null){
            throw new RuntimeException("Local variable " + currentThread + ":" + varName + " has been already initialised");
        }
        Register register = getOrCreateRegister(currentThread, varName);

        if(ctx.returnExpression() != null){
            Thread t = (Thread)ctx.returnExpression().accept(this);
            Thread result = new Local(register, returnStack.pop());
            if(t != null){
                result = new Seq(t, result);
            }
            return result;
        }
        return null;
    }

    public Thread visitSeqReturnExpression(LitmusCParser.SeqReturnExpressionContext ctx){
        String varName = visitVariable(ctx.variable());

        Register register = getRegister(currentThread, varName);
        if(register != null){
            Thread t = (Thread)ctx.returnExpression().accept(this);
            Thread result = new Local(register, returnStack.pop());
            if(t != null){
                result = new Seq(t, result);
            }
            return result;
        }

        Location location = getLocation(varName);
        if(location != null){
            Thread t = (Thread)ctx.returnExpression().accept(this);
            Thread result;

            // TODO: Constructor for class Write with AExpr ----------
            AExpr retValue = returnStack.pop();
            if(retValue instanceof Register){
                result = new Write(location, (Register)retValue, "_rx");
            } else if(retValue instanceof AConst){
                result = new Write(location, (AConst) retValue, "_rx");
            } else {
                throw new RuntimeException("Check retValue");
            }
            // ---------------------------------------------

            if(t != null){
                result = new Seq(t, result);
            }
            return result;
        }

        register = getOrCreateRegister(currentThread, varName);
        Thread t = (Thread)ctx.returnExpression().accept(this);
        Thread result = new Local(register, returnStack.pop());
        if(t != null) {
            result = new Seq(t, result);
        }
        return result;
    }

    private Thread visitExpressionSequence(RuleContext ctx) {
        List<Thread> events = new ArrayList<>();
        int n = ctx.getChildCount();
        for (int i = 0; i < n; ++i) {
            ParseTree child = ctx.getChild(i);
            if (child instanceof LitmusCParser.ExpressionContext) {
                Thread t = visitExpression((LitmusCParser.ExpressionContext) child);
                if(t != null){
                    events.add(t);
                }
            }
        }
        return Utils.listToThread(events);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (all other return expressions are reduced to these ones)

    // TODO: Draft, review required, add filters to RMW events, create a clonable RMW class for this RMW
    private Thread visitAtomicOpReturn(LitmusCParser.VariableContext varCtx, AExpr value, String op, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new RuntimeException("Uninitialized location " + varName);
        }

        Register register1 = getOrCreateRegister(currentThread,"DUMMY_REG_" + hashCode());
        Register register2 = getOrCreateRegister(currentThread, "DUMMY_REG_" + hashCode());

        Load load = new Load(register1, location, memoryOrder);
        Local local = new Local(register2, new AExpr(register1, op, value));
        RMWStore store = new RMWStore(load, location, register2, memoryOrder);

        returnStack.push(register2);
        return new Seq(load, new Seq(local, store));
    }

    // TODO: Draft, review required, add filters to RMW events, create a clonable RMW class for this RMW
    private Thread visitAtomicFetchOp(LitmusCParser.VariableContext varCtx, AExpr value, String op, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new RuntimeException("Uninitialized location " + varName);
        }

        Register register1 = getOrCreateRegister(currentThread,"DUMMY_REG_" + hashCode());
        Register register2 = getOrCreateRegister(currentThread, "DUMMY_REG_" + hashCode());

        Load load = new Load(register1, location, memoryOrder);
        Local local = new Local(register2, new AExpr(register1, op, value));
        RMWStore store = new RMWStore(load, location, register2, memoryOrder);

        returnStack.push(register1);
        return new Seq(load, new Seq(local, store));
    }

    private Thread visitAtomicXchg(LitmusCParser.VariableContext varCtx, AExpr value, String memoryOrder){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    private Thread visitAtomicCmpxchg(LitmusCParser.VariableContext varCtx, AExpr cmp, AExpr value, String memoryOrder){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    private Thread visitAtomicOpAndTest(LitmusCParser.VariableContext varCtx, AExpr value, String op){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    private Thread visitAtomicRead(LitmusCParser.VariableContext varCtx, String memoryOrder){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    @Override
    public Thread visitReAtomicAddUnless(LitmusCParser.ReAtomicAddUnlessContext ctx){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    @Override
    public Thread visitReSpinTryLock(LitmusCParser.ReSpinTryLockContext ctx){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    @Override
    public Thread visitReSpinIsLocked(LitmusCParser.ReSpinIsLockedContext ctx){
        // TODO: Implementation
        returnStack.push(new AConst(1));
        return new Skip();
    }

    @Override
    public Thread visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        AExpr v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        AExpr v2 = returnStack.pop();

        // TODO: Conversion between BExpr and AExpr
        //returnStack.push(new Atom(v1, ctx.opCompare().getText(), v2));
        returnStack.push(new AConst(1));

        if(t1 != null){
            if(t2 != null){
                return new Seq(t1, t2);
            }
            return t1;
        }
        return t2;
    }

    @Override
    public Thread visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        AExpr v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        AExpr v2 = returnStack.pop();
        returnStack.push(new AExpr(v1, ctx.opArith().getText(), v2));

        if(t1 != null){
            if(t2 != null){
                return new Seq(t1, t2);
            }
            return t1;
        }
        return t2;
    }

    @Override
    public Thread visitReParenthesis(LitmusCParser.ReParenthesisContext ctx){
        return (Thread)ctx.returnExpression().accept(this);
    }

    @Override
    public Thread visitReCast(LitmusCParser.ReCastContext ctx){
        return (Thread)ctx.returnExpression().accept(this);
    }

    @Override
    public Thread visitReVariable(LitmusCParser.ReVariableContext ctx){
        String varName = visitVariable(ctx.variable());
        Register register = getRegister(currentThread, varName);
        if(register != null){
            returnStack.push(register);
            return null;
        }

        Location location = getLocation(varName);
        if(location == null){
            throw new RuntimeException("Variable " + varName + " has not been initialized");
        }

        register = new Register("DUMMY_REG_" + hashCode());
        returnStack.push(register);
        return new Read(register, location, "_rx");
    }

    @Override
    public Thread visitReConst(LitmusCParser.ReConstContext ctx){
        returnStack.push(new AConst(Integer.parseInt(ctx.getText())));
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    private Thread visitAtomicOp(LitmusCParser.VariableContext varCtx, AExpr value, String op){
        // TODO: Implementation
        return new Skip();
    }

    private Thread visitAtomicWrite(LitmusCParser.VariableContext varCtx, AExpr value, String memoryOrder){
        // TODO: Implementation
        return new Skip();
    }

    private Thread visitFenceExpression(String fenceName){
        return new Fence(fenceName);
    }

    @Override
    public Thread visitNreSpinLock(LitmusCParser.NreSpinLockContext ctx){
        // TODO: Implementation
        return new Skip();
    }

    @Override
    public Thread visitNreSpinUnlock(LitmusCParser.NreSpinUnlockContext ctx){
        // TODO: Implementation
        return new Skip();
    }

    @Override
    public Thread visitNreSpinUnlockWait(LitmusCParser.NreSpinUnlockWaitContext ctx){
        // TODO: Implementation
        return new Skip();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public Pair<String, String> visitThreadVariable(LitmusCParser.ThreadVariableContext ctx) {
        if(ctx.threadIdentifier() != null && ctx.Identifier() != null){
            // TODO: Can we return a register instead of a Pair in all cases?
            String thread = threadId(ctx.threadIdentifier().getText());
            String variableName = ctx.Identifier().getText();
            return new Pair<String, String>(thread, variableName);
        }
        return visitThreadVariable(ctx.threadVariable());
    }

    @Override
    public String visitVariable(LitmusCParser.VariableContext ctx) {
        if(ctx.Identifier() != null){
            return ctx.Identifier().getText();
        }
        return visitVariable(ctx.variable());
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Private

    private String threadId(String threadId){
        return threadId.replace("P", "");
    }

    private Register getRegister(String threadName, String registerName){
        if(mapRegisters.keySet().contains(threadName)) {
            return mapRegisters.get(threadName).get(registerName);
        }
        return null;
    }

    private Register getOrCreateRegister(String threadName, String registerName){
        if(!(mapRegisters.keySet().contains(threadName))) {
            initThread(threadName);
        }
        Map<String, Register> registers = mapRegisters.get(threadName);
        if(!(registers.keySet().contains(registerName))) {
            registers.put(registerName, new Register(registerName));
        }
        return registers.get(registerName);
    }

    private Location getLocation(String locationName){
        if(mapLocations.containsKey(locationName)){
            return mapLocations.get(locationName);
        }
        return null;
    }

    private Location getOrCreateLocation(String locationName){
        if(!mapLocations.containsKey(locationName)){
            Location location = new Location(locationName);
            location.setIValue(DEFAULT_INIT_VALUE);
            mapLocations.put(locationName, location);
        }
        return mapLocations.get(locationName);
    }

    private Location getLocationForRegister(String threadName, String registerName){
        if(!mapRegistersLocations.containsKey(threadName)){
            initThread(threadName);
        }
        Map<String, Location> registerLocationMap = mapRegistersLocations.get(threadName);
        if(!registerLocationMap.containsKey(registerName)){
            throw new ParsingException("Register " + registerName + " must be initialized to a location");
        }
        return registerLocationMap.get(registerName);
    }

    private Map<String, Location> getMapRegLoc(String threadName){
        if(!(mapRegistersLocations.keySet().contains(threadName))) {
            initThread(threadName);
        }
        return mapRegistersLocations.get(threadName);
    }

    private List<Thread> getThreadEvents(String threadName){
        if(!(mapThreadEvents.keySet().contains(threadName))) {
            initThread(threadName);
        }
        return mapThreadEvents.get(threadName);
    }

    private void initThread(String thread){
        if(!(mapThreadEvents.containsKey(thread))){
            mapThreadEvents.put(thread, new ArrayList<Thread>());
        }
        if(!(mapRegisters.containsKey(thread))){
            mapRegisters.put(thread, new HashMap<String, Register>());
        }
        if(!(mapRegistersLocations.containsKey(thread))){
            mapRegistersLocations.put(thread, new HashMap<String, Location>());
        }
    }


    // ----------------------------------------------------------------------------------------------------------------
    // ReturnExpression (reducing)

    @Override
    public Thread visitReAtomicAddReturn(LitmusCParser.ReAtomicAddReturnContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_sc");
    }

    @Override
    public Thread visitReAtomicAddReturnRelaxed(LitmusCParser.ReAtomicAddReturnRelaxedContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_rx");
    }

    @Override
    public Thread visitReAtomicAddReturnAcquire(LitmusCParser.ReAtomicAddReturnAcquireContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_acq");
    }

    @Override
    public Thread visitReAtomicAddReturnRelease(LitmusCParser.ReAtomicAddReturnReleaseContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_rel");
    }

    @Override
    public Thread visitReAtomicSubReturn(LitmusCParser.ReAtomicSubReturnContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_sc");
    }

    @Override
    public Thread visitReAtomicSubReturnRelaxed(LitmusCParser.ReAtomicSubReturnRelaxedContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_rx");
    }

    @Override
    public Thread visitReAtomicSubReturnAcquire(LitmusCParser.ReAtomicSubReturnAcquireContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_acq");
    }

    @Override
    public Thread visitReAtomicSubReturnRelease(LitmusCParser.ReAtomicSubReturnReleaseContext ctx){
        return visitAtomicOpReturn(ctx.variable(), ctx.returnExpression(), "-", "_rel");
    }

    @Override
    public Thread visitReAtomicIncReturn(LitmusCParser.ReAtomicIncReturnContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "+", "_sc");
    }

    @Override
    public Thread visitReAtomicIncReturnRelaxed(LitmusCParser.ReAtomicIncReturnRelaxedContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "+", "_rx");
    }

    @Override
    public Thread visitReAtomicIncReturnAcquire(LitmusCParser.ReAtomicIncReturnAcquireContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "+", "_acq");
    }

    @Override
    public Thread visitReAtomicIncReturnRelease(LitmusCParser.ReAtomicIncReturnReleaseContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "+", "_rel");
    }

    @Override
    public Thread visitReAtomicDecReturn(LitmusCParser.ReAtomicDecReturnContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "-", "_sc");
    }

    @Override
    public Thread visitReAtomicDecReturnRelaxed(LitmusCParser.ReAtomicDecReturnRelaxedContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "-", "_rx");
    }

    @Override
    public Thread visitReAtomicDecReturnAcquire(LitmusCParser.ReAtomicDecReturnAcquireContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "-", "_acq");
    }

    @Override
    public Thread visitReAtomicDecReturnRelease(LitmusCParser.ReAtomicDecReturnReleaseContext ctx){
        return visitAtomicOpReturn(ctx.variable(), new AConst(1), "-", "_rel");
    }

    @Override
    public Thread visitReAtomicFetchAdd(LitmusCParser.ReAtomicFetchAddContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "+", "_sc");
    }

    @Override
    public Thread visitReAtomicFetchAddRelaxed(LitmusCParser.ReAtomicFetchAddRelaxedContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "+", "_rx");
    }

    @Override
    public Thread visitReAtomicFetchAddAcquire(LitmusCParser.ReAtomicFetchAddAcquireContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "+", "_acq");
    }

    @Override
    public Thread visitReAtomicFetchAddRelease(LitmusCParser.ReAtomicFetchAddReleaseContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "+", "_rel");
    }

    @Override
    public Thread visitReAtomicFetchSub(LitmusCParser.ReAtomicFetchSubContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "-", "_sc");
    }

    @Override
    public Thread visitReAtomicFetchSubRelaxed(LitmusCParser.ReAtomicFetchSubRelaxedContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "-", "_rx");
    }

    @Override
    public Thread visitReAtomicFetchSubAcquire(LitmusCParser.ReAtomicFetchSubAcquireContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "-", "_acq");
    }

    @Override
    public Thread visitReAtomicFetchSubRelease(LitmusCParser.ReAtomicFetchSubReleaseContext ctx){
        return visitAtomicFetchOp(ctx.variable(), ctx.returnExpression(), "-", "_rel");
    }

    @Override
    public Thread visitReAtomicFetchInc(LitmusCParser.ReAtomicFetchIncContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "+", "_sc");
    }

    @Override
    public Thread visitReAtomicFetchIncRelaxed(LitmusCParser.ReAtomicFetchIncRelaxedContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "+", "_rx");
    }

    @Override
    public Thread visitReAtomicFetchIncAcquire(LitmusCParser.ReAtomicFetchIncAcquireContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "+", "_acq");
    }

    @Override
    public Thread visitReAtomicFetchIncRelease(LitmusCParser.ReAtomicFetchIncReleaseContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "+", "_rel");
    }

    @Override
    public Thread visitReAtomicFetchDec(LitmusCParser.ReAtomicFetchDecContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "-", "_sc");
    }

    @Override
    public Thread visitReAtomicFetchDecRelaxed(LitmusCParser.ReAtomicFetchDecRelaxedContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "-", "_rx");
    }

    @Override
    public Thread visitReAtomicFetchDecAcquire(LitmusCParser.ReAtomicFetchDecAcquireContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "-", "_acq");
    }

    @Override
    public Thread visitReAtomicFetchDecRelease(LitmusCParser.ReAtomicFetchDecReleaseContext ctx){
        return visitAtomicFetchOp(ctx.variable(), new AConst(1), "-", "_rel");
    }

    @Override
    public Thread visitReAtomicXchg(LitmusCParser.ReAtomicXchgContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_sc");
    }

    @Override
    public Thread visitReAtomicXchgRelaxed(LitmusCParser.ReAtomicXchgRelaxedContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_rx");
    }

    @Override
    public Thread visitReAtomicXchgAcquire(LitmusCParser.ReAtomicXchgAcquireContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_scq");
    }

    @Override
    public Thread visitReAtomicXchgRelease(LitmusCParser.ReAtomicXchgReleaseContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_rel");
    }

    @Override
    public Thread visitReXchg(LitmusCParser.ReXchgContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_sc");
    }

    @Override
    public Thread visitReXchgRelaxed(LitmusCParser.ReXchgRelaxedContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_rx");
    }

    @Override
    public Thread visitReXchgAcquire(LitmusCParser.ReXchgAcquireContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_acq");
    }

    @Override
    public Thread visitReXchgRelease(LitmusCParser.ReXchgReleaseContext ctx){
        return visitAtomicXchg(ctx.variable(), ctx.returnExpression(), "_rel");
    }

    @Override
    public Thread visitReAtomicCmpxchg(LitmusCParser.ReAtomicCmpxchgContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_sc");
    }

    @Override
    public Thread visitReAtomicCmpxchgRelaxed(LitmusCParser.ReAtomicCmpxchgRelaxedContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_rx");
    }

    @Override
    public Thread visitReAtomicCmpxchgAcquire(LitmusCParser.ReAtomicCmpxchgAcquireContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_acq");
    }

    @Override
    public Thread visitReAtomicCmpxchgRelease(LitmusCParser.ReAtomicCmpxchgReleaseContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_rel");
    }

    @Override
    public Thread visitReCmpxchg(LitmusCParser.ReCmpxchgContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_sc");
    }

    @Override
    public Thread visitReCmpxchgRelaxed(LitmusCParser.ReCmpxchgRelaxedContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_rx");
    }

    @Override
    public Thread visitReCmpxchgAcquire(LitmusCParser.ReCmpxchgAcquireContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_acq");
    }

    @Override
    public Thread visitReCmpxchgRelease(LitmusCParser.ReCmpxchgReleaseContext ctx){
        return visitAtomicCmpxchg(ctx.variable(), ctx.returnExpression(0), ctx.returnExpression(1), "_rel");
    }

    @Override
    public Thread visitReAtomicSubAndTest(LitmusCParser.ReAtomicSubAndTestContext ctx){
        return visitAtomicOpAndTest(ctx.variable(), ctx.returnExpression(), "-");
    }

    @Override
    public Thread visitReAtomicIncAndTest(LitmusCParser.ReAtomicIncAndTestContext ctx){
        return visitAtomicOpAndTest(ctx.variable(), new AConst(1), "+");
    }

    @Override
    public Thread visitReAtomicDecAndTest(LitmusCParser.ReAtomicDecAndTestContext ctx){
        return visitAtomicOpAndTest(ctx.variable(), new AConst(1), "-");
    }

    @Override
    public Thread visitReReadOnce(LitmusCParser.ReReadOnceContext ctx){
        return visitAtomicRead(ctx.variable(), "_rx");
    }

    @Override
    public Thread visitReAtomicRead(LitmusCParser.ReAtomicReadContext ctx){
        return visitAtomicRead(ctx.variable(), "_rx");
    }

    @Override
    public Thread visitReRcuDerefence(LitmusCParser.ReRcuDerefenceContext ctx){
        return visitAtomicRead(ctx.variable(), "_rx");
    }

    @Override
    public Thread visitReSmpLoadAcquire(LitmusCParser.ReSmpLoadAcquireContext ctx){
        return visitAtomicRead(ctx.variable(), "_acq");
    }

    @Override
    public Thread visitReAtomicReadAcquire(LitmusCParser.ReAtomicReadAcquireContext ctx){
        return visitAtomicRead(ctx.variable(), "_acq");
    }

    // ----------------------------------------------------------------------------------------------------------------
    // NonReturnExpression (reducing)

    @Override
    public Thread visitNreAtomicAdd(LitmusCParser.NreAtomicAddContext ctx){
        return visitAtomicOp(ctx.variable(), ctx.returnExpression(), "+");
    }

    @Override
    public Thread visitNreAtomicSub(LitmusCParser.NreAtomicSubContext ctx){
        return visitAtomicOp(ctx.variable(), ctx.returnExpression(), "-");
    }

    @Override
    public Thread visitNreAtomicInc(LitmusCParser.NreAtomicIncContext ctx){
        return visitAtomicOp(ctx.variable(), new AConst(1), "+");
    }

    @Override
    public Thread visitNreAtomicDec(LitmusCParser.NreAtomicDecContext ctx){
        return visitAtomicOp(ctx.variable(), new AConst(1), "-");
    }

    @Override
    public Thread visitNreWriteOnce(LitmusCParser.NreWriteOnceContext ctx){
        return visitAtomicWrite(ctx.variable(), ctx.returnExpression(), "_rx");
    }

    @Override
    public Thread visitNreAtomicSet(LitmusCParser.NreAtomicSetContext ctx){
        return visitAtomicWrite(ctx.variable(), ctx.returnExpression(), "_rx");
    }

    @Override
    public Thread visitNreSmpStoreRelease(LitmusCParser.NreSmpStoreReleaseContext ctx){
        return visitAtomicWrite(ctx.variable(), ctx.returnExpression(), "_rel");
    }

    @Override
    public Thread visitNreAtomicSetRelease(LitmusCParser.NreAtomicSetReleaseContext ctx){
        return visitAtomicWrite(ctx.variable(), ctx.returnExpression(), "_rel");
    }

    @Override
    public Thread visitNreRcuAssignPointer(LitmusCParser.NreRcuAssignPointerContext ctx){
        return visitAtomicWrite(ctx.variable(), ctx.returnExpression(), "_rel");
    }

    @Override
    public Thread visitNreSmpStoreMb(LitmusCParser.NreSmpStoreMbContext ctx){
        return visitAtomicWrite(ctx.variable(), ctx.returnExpression(), "_sc");
    }

    @Override
    public Thread visitNreSmpMb(LitmusCParser.NreSmpMbContext ctx){
        return visitFenceExpression("Mb");
    }

    @Override
    public Thread visitNreSmpRmb(LitmusCParser.NreSmpRmbContext ctx){
        return visitFenceExpression("Rmb");
    }

    @Override
    public Thread visitNreSmpWmb(LitmusCParser.NreSmpWmbContext ctx){
        return visitFenceExpression("Wmb");
    }

    @Override
    public Thread visitNreSmpMbBeforeAtomic(LitmusCParser.NreSmpMbBeforeAtomicContext ctx){
        return visitFenceExpression("Before-atomic");
    }

    @Override
    public Thread visitNreSmpMbAfterAtomic(LitmusCParser.NreSmpMbAfterAtomicContext ctx){
        return visitFenceExpression("After-atomic");
    }

    @Override
    public Thread visitNreSmpMbAfterSpinlock(LitmusCParser.NreSmpMbAfterSpinlockContext ctx){
        return visitFenceExpression("After-spinlock");
    }

    @Override
    public Thread visitNreRcuReadLock(LitmusCParser.NreRcuReadLockContext ctx){
        return visitFenceExpression("Rcu-lock");
    }

    @Override
    public Thread visitNreRcuReadUnlock(LitmusCParser.NreRcuReadUnlockContext ctx){
        return visitFenceExpression("Rcu-unlock");
    }

    @Override
    public Thread visitNreSynchronizeRcu(LitmusCParser.NreSynchronizeRcuContext ctx){
        return visitFenceExpression("Sync-rcu");
    }

    @Override
    public Thread visitNreSynchronizeRcuExpedited(LitmusCParser.NreSynchronizeRcuExpeditedContext ctx){
        return visitFenceExpression("Sync-rcu");
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Converting returnExpression to AExpr

    private Thread visitAtomicOpReturn(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicOpReturn(varCtx, returnStack.pop(), op, memoryOrder);
        return t == null ? result : new Seq(t, result);
    }

    private Thread visitAtomicFetchOp(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicFetchOp(varCtx, returnStack.pop(), op, memoryOrder);
        return t == null ? result : new Seq(t, result);
    }

    private Thread visitAtomicXchg(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicXchg(varCtx, returnStack.pop(), memoryOrder);
        return t == null ? result : new Seq(t, result);
    }

    private Thread visitAtomicCmpxchg(
            LitmusCParser.VariableContext varCtx,
            LitmusCParser.ReturnExpressionContext re1Ctx,
            LitmusCParser.ReturnExpressionContext re2Ctx,
            String memoryOrder
    ){
        Thread t1 = (Thread)re1Ctx.accept(this);
        AExpr v1 = returnStack.pop();
        Thread t2 = (Thread)re2Ctx.accept(this);
        AExpr v2 = returnStack.pop();

        Thread result = visitAtomicCmpxchg(varCtx, v1, v2, memoryOrder);
        if(t2 != null){
            result = new Seq(t2, result);
        }
        if(t1 != null){
            result = new Seq(t1, result);
        }
        return result;
    }

    private Thread visitAtomicOpAndTest(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicOpAndTest(varCtx, returnStack.pop(), op);
        return t == null ? result : new Seq(t, result);
    }

    private Thread visitAtomicOp(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicOp(varCtx, returnStack.pop(), op);
        return t == null ? result : new Seq(t, result);
    }

    private Thread visitAtomicWrite(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicWrite(varCtx, returnStack.pop(), memoryOrder);
        return t == null ? result : new Seq(t, result);
    }
}
