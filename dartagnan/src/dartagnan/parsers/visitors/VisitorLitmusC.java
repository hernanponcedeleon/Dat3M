package dartagnan.parsers.visitors;

import dartagnan.LitmusCBaseVisitor;
import dartagnan.LitmusCVisitor;
import dartagnan.LitmusCParser;
import dartagnan.asserts.*;
import dartagnan.expression.*;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.Utils;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.filter.FilterUtils;
import dartagnan.program.event.lock.RCULock;
import dartagnan.program.event.lock.RCUUnlock;
import dartagnan.program.event.rmw.*;
import dartagnan.program.event.rmw.cond.FenceCond;
import dartagnan.program.event.rmw.cond.RMWReadCondCmp;
import dartagnan.program.event.rmw.cond.RMWReadCondUnless;
import dartagnan.program.event.rmw.cond.RMWStoreCond;
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
    private Stack<ExprInterface> returnStack = new Stack<>();
    private Stack<RCULock> rcuLockStack = new Stack<>();
    private String currentThread;
    private Program program = new Program("");

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusCParser.MainContext ctx) {
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitThreadList(ctx.threadList());
        visitAssertionFilter(ctx.assertionFilter());
        visitAssertionList(ctx.assertionList());
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
        Register register = visitThreadVariable(ctx.threadVariable());
        int value = DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constantValue().getText());
        }
        getThreadEvents(register.getPrintMainThread()).add(new Local(register, new AConst(value)));
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
        Register register = visitThreadVariable(ctx.threadVariable());
        Location location = getOrCreateLocation(visitVariable(ctx.variable()));
        getMapRegLoc(register.getPrintMainThread()).put(register.getName(), location);
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
        if(!rcuLockStack.empty()){
            throw new ParsingException("Unbalanced RCU lock in thread " + currentThread);
        }
        if (!(initEvents.isEmpty())) {
            result = new Seq(Utils.listToThread(false, initEvents), result);
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
        Thread t1 = visitExpressionSequence(ctx);
        Thread t2 = ctx.elseExpression() == null ? new Skip() : visitExpressionSequence(ctx.elseExpression());
        Thread result = new If(returnStack.pop(), t1, t2);
        return Utils.arrayToThread(false, evalThread, result);
    }

    @Override
    public Thread visitSeqDeclarationReturnExpression(LitmusCParser.SeqDeclarationReturnExpressionContext ctx){
        String varName = visitVariable(ctx.variable());
        if(getRegister(currentThread, varName) != null){
            throw new ParsingException("Local variable " + currentThread + ":" + varName + " has been already initialised");
        }
        Register register = getOrCreateRegister(currentThread, varName);

        if(ctx.returnExpression() != null){
            Thread t = (Thread)ctx.returnExpression().accept(this);
            Thread result = new Local(register, returnStack.pop());
            return Utils.arrayToThread(false, t, result);
        }
        return null;
    }

    public Thread visitSeqReturnExpression(LitmusCParser.SeqReturnExpressionContext ctx){
        Thread t = (Thread)ctx.returnExpression().accept(this);
        String varName = visitVariable(ctx.variable());
        Thread result = null;

        Register register = getRegister(currentThread, varName);
        if(register == null){
            Location location = getLocation(varName);
            if(location != null){
                result = new Write(location, returnStack.pop(), "_rx");
            }
        }

        if(result == null){
            if(register == null){
                register = getOrCreateRegister(currentThread, varName);
            }
            result = new Local(register, returnStack.pop());
        }

        return Utils.arrayToThread(false, t, result);
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
        return Utils.listToThread(true, events);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (all other return expressions are reduced to these ones)

    // TODO: A separate class for this event (for compilation to other architectures)
    private Thread visitAtomicOpReturn(LitmusCParser.VariableContext varCtx, ExprInterface value, String op, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new ParsingException("Uninitialized location " + varName);
        }

        Register register1 = getOrCreateRegister(currentThread, null);
        Register register2 = getOrCreateRegister(currentThread, null);

        String loadMO = memoryOrder.equals("_acq") ? "_acq" : "_rx";
        Load load = new Load(register1, location, loadMO);
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        Local local = new Local(register2, new AExpr(register1, op, value));

        String storeMO = memoryOrder.equals("_rel") ? "_rel" : "_rx";
        RMWStore store = new RMWStore(load, location, register2, storeMO);
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        returnStack.push(register2);

        if(memoryOrder.equals("_sc")){
            return Utils.arrayToThread(false, new Fence("Mb"), load, local, store, new Fence("Mb"));
        }
        return Utils.arrayToThread(false, load, local, store);
    }

    // TODO: A separate class for this event (for compilation to other architectures)
    private Thread visitAtomicFetchOp(LitmusCParser.VariableContext varCtx, ExprInterface value, String op, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new ParsingException("Uninitialized location " + varName);
        }

        Register register1 = getOrCreateRegister(currentThread, null);
        Register register2 = getOrCreateRegister(currentThread, null);

        String loadMO = memoryOrder.equals("_acq") ? "_acq" : "_rx";
        Load load = new Load(register1, location, loadMO);
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        Local local = new Local(register2, new AExpr(register1, op, value));

        String storeMO = memoryOrder.equals("_rel") ? "_rel" : "_rx";
        RMWStore store = new RMWStore(load, location, register2, storeMO);
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        returnStack.push(register1);

        if(memoryOrder.equals("_sc")){
            return Utils.arrayToThread(false, new Fence("Mb"), load, local, store, new Fence("Mb"));
        }
        return Utils.arrayToThread(false, load, local, store);
    }

    // TODO: A separate class for this event (for compilation to other architectures)
    private Thread visitAtomicXchg(LitmusCParser.VariableContext varCtx, ExprInterface value, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new ParsingException("Uninitialized location " + varName);
        }

        Register register = getOrCreateRegister(currentThread, null);

        String loadMO = memoryOrder.equals("_acq") ? "_acq" : "_rx";
        Load load = new Load(register, location, loadMO);
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        String storeMO = memoryOrder.equals("_rel") ? "_rel" : "_rx";
        RMWStore store = new RMWStore(load, location, value, storeMO);
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        returnStack.push(register);

        if(memoryOrder.equals("_sc")){
            return Utils.arrayToThread(false, new Fence("Mb"), load, store, new Fence("Mb"));
        }
        return Utils.arrayToThread(false, load, store);
    }

    // TODO: A separate class for this event (for compilation to other architectures)
    private Thread visitAtomicCmpxchg(LitmusCParser.VariableContext varCtx, ExprInterface cmp, ExprInterface value, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new ParsingException("Uninitialized location " + varName);
        }

        Register register = getOrCreateRegister(currentThread, null);

        String loadMO = memoryOrder.equals("_acq") ? "_acq" : "_rx";
        RMWReadCondCmp load = new RMWReadCondCmp(register, cmp, location, loadMO);
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        String storeMO = memoryOrder.equals("_rel") ? "_rel" : "_rx";
        RMWStoreCond store = new RMWStoreCond(load, location, value, storeMO);
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        returnStack.push(register);

        if(memoryOrder.equals("_sc")){
            return Utils.arrayToThread(false, new FenceCond(load, "Mb"), load, store, new FenceCond(load, "Mb"));
        }
        return Utils.arrayToThread(false, load, store);
    }

    // TODO: A separate class for this event (for compilation to other architectures)
    private Thread visitAtomicOpAndTest(LitmusCParser.VariableContext varCtx, ExprInterface value, String op){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            throw new ParsingException("Uninitialized location " + varName);
        }

        Register register = getOrCreateRegister(currentThread, null);
        Load load = new Load(register, location, "_rx");
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);
        Local local = new Local(register, new AExpr(register, op, value));
        RMWStore store = new RMWStore(load, location, register, "_rx");
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);
        returnStack.push(new Atom(register, "==", new AConst(0)));
        return Utils.arrayToThread(false, new Fence("Mb"), load, local, store, new Fence("Mb"));
    }

    private Thread visitAtomicRead(LitmusCParser.VariableContext varCtx, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            throw new ParsingException("Uninitialized location " + varName);
        }
        Register register = getOrCreateRegister(currentThread, null);
        returnStack.push(register);
        return new Read(register, location, memoryOrder);
    }

    @Override
    public Thread visitReAtomicAddUnless(LitmusCParser.ReAtomicAddUnlessContext ctx){
        String varName = visitVariable(ctx.variable());
        Location location = getLocation(varName);
        if(location == null){
            throw new ParsingException("Uninitialized location " + varName);
        }

        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface value = returnStack.pop();

        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface cmp = returnStack.pop();

        Register register1 = getOrCreateRegister(currentThread, null);
        RMWReadCondUnless load = new RMWReadCondUnless(register1, cmp, location, "_rx");
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);
        RMWStoreCond store = new RMWStoreCond(load, location, new AExpr(register1, "+", value), "_rx");
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE);

        // Non-zero if was not equal (i.e. operation happened), zero otherwise
        returnStack.push(new Atom(register1, "!=", cmp));
        return Utils.arrayToThread(false, t1, t2, new FenceCond(load, "Mb"), load, store, new FenceCond(load, "Mb"));
    }

    @Override
    public Thread visitReSpinTryLock(LitmusCParser.ReSpinTryLockContext ctx){
        // TODO: Implementation
        throw new ParsingException("visitReSpinTryLock not implemented");
    }

    @Override
    public Thread visitReSpinIsLocked(LitmusCParser.ReSpinIsLockedContext ctx){
        // TODO: Implementation
        throw new ParsingException("visitReSpinIsLocked not implemented");
    }

    @Override
    public Thread visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new Atom(v1, ctx.opCompare().getText(), v2));
        return Utils.arrayToThread(false, t1, t2);
    }

    @Override
    public Thread visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new AExpr(v1, ctx.opArith().getText(), v2));
        return Utils.arrayToThread(false, t1, t2);
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
            throw new ParsingException("Variable " + varName + " has not been initialized");
        }

        register = getOrCreateRegister(currentThread, null);
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

    // TODO: A separate class for this event (for compilation to other architectures)
    private Thread visitAtomicOp(LitmusCParser.VariableContext varCtx, ExprInterface value, String op){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            // TODO: In general, it can be also a local variable (register)
            throw new ParsingException("Uninitialized location " + varName);
        }

        Register register1 = getOrCreateRegister(currentThread, null);
        Load load = new Load(register1, location, "_rx");
        load.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE, FilterUtils.EVENT_TYPE_RMW_NORETURN);
        RMWStore store = new RMWStore(load, location, new AExpr(register1, op, value), "_rx");
        store.addFilters(FilterUtils.EVENT_TYPE_ATOMIC, FilterUtils.EVENT_TYPE_READ_MODIFY_WRITE, FilterUtils.EVENT_TYPE_RMW_NORETURN);
        return Utils.arrayToThread(false, load, store);
    }

    private Thread visitAtomicWrite(LitmusCParser.VariableContext varCtx, ExprInterface value, String memoryOrder){
        String varName = visitVariable(varCtx);
        Location location = getLocation(varName);
        if(location == null){
            throw new ParsingException("Atomic write is not implemented for register");
        }
        return new Write(location, value, memoryOrder);
    }

    private Thread visitFenceExpression(String fenceName){
        return new Fence(fenceName);
    }

    @Override
    public Thread visitNreSpinLock(LitmusCParser.NreSpinLockContext ctx){
        // TODO: Implementation
        throw new ParsingException("visitNreSpinLock is not implemented");
    }

    @Override
    public Thread visitNreSpinUnlock(LitmusCParser.NreSpinUnlockContext ctx){
        // TODO: Implementation
        throw new ParsingException("visitNreSpinUnlock is not implemented");
    }

    @Override
    public Thread visitNreSpinUnlockWait(LitmusCParser.NreSpinUnlockWaitContext ctx){
        // TODO: Implementation
        throw new ParsingException("visitNreSpinUnlockWait is not implemented");
    }

    @Override
    public Thread visitNreRcuReadLock(LitmusCParser.NreRcuReadLockContext ctx){
        RCULock lock = new RCULock();
        rcuLockStack.push(lock);
        return lock;
    }

    @Override
    public Thread visitNreRcuReadUnlock(LitmusCParser.NreRcuReadUnlockContext ctx){
        try {
            RCULock lock = rcuLockStack.pop();
            return new RCUUnlock(lock);
        } catch (EmptyStackException e){
            throw new ParsingException("Unbalanced RCU unlock in thread " + currentThread);
        }
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
    // Assertions

    @Override
    public Object visitAssertionFilter(LitmusCParser.AssertionFilterContext ctx) {
        if(ctx != null){
            program.setAssFilter((AbstractAssert)visit(ctx.assertion()));
        }
        return null;
    }


    @Override
    public Object visitAssertionList(LitmusCParser.AssertionListContext ctx) {
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
    public Object visitAssertionParenthesis(LitmusCParser.AssertionParenthesisContext ctx) {
        return visit(ctx.assertion());
    }


    @Override
    public Object visitAssertionAnd(LitmusCParser.AssertionAndContext ctx) {
        return new AssertCompositeAnd(
                (AbstractAssert) visit(ctx.assertion(0)),
                (AbstractAssert) visit(ctx.assertion(1))
        );
    }

    @Override
    public Object visitAssertionOr(LitmusCParser.AssertionOrContext ctx) {
        return new AssertCompositeOr(
                (AbstractAssert) visit(ctx.assertion(0)),
                (AbstractAssert) visit(ctx.assertion(1))
        );
    }

    @Override
    public Object visitAssertionNot(LitmusCParser.AssertionNotContext ctx) {
        return new AssertNot((AbstractAssert) visit(ctx.assertion()));
    }

    @Override
    public Object visitAssertionLocation(LitmusCParser.AssertionLocationContext ctx) {
        Location location = getOrCreateLocation(visitVariable(ctx.variable()));
        AConst value = new AConst(Integer.parseInt(ctx.constantValue().getText()));
        return new AssertBasic(location, (String)ctx.assertionOp().accept(this), value);
    }

    @Override
    public Object visitAssertionLocationRegister(LitmusCParser.AssertionLocationRegisterContext ctx) {
        Register register = visitThreadVariable(ctx.threadVariable());
        Location location = getOrCreateLocation(visitVariable(ctx.variable()));
        return new AssertBasic(location, (String)ctx.assertionOp().accept(this), register);
    }

    @Override
    public Object visitAssertionLocationLocation(LitmusCParser.AssertionLocationLocationContext ctx) {
        Location location1 = getOrCreateLocation(visitVariable(ctx.variable(0)));
        Location location2 = getOrCreateLocation(visitVariable(ctx.variable(1)));
        return new AssertBasic(location1, (String)ctx.assertionOp().accept(this), location2);
    }

    @Override
    public Object visitAssertionRegister(LitmusCParser.AssertionRegisterContext ctx) {
        Register register = visitThreadVariable(ctx.threadVariable());
        AConst value = new AConst(Integer.parseInt(ctx.constantValue().getText()));
        return new AssertBasic(register, (String)ctx.assertionOp().accept(this), value);
    }

    @Override
    public Object visitAssertionRegisterRegister(LitmusCParser.AssertionRegisterRegisterContext ctx) {
        Register register1 = visitThreadVariable(ctx.threadVariable(0));
        Register register2 = visitThreadVariable(ctx.threadVariable(1));
        return new AssertBasic(register1, (String)ctx.assertionOp().accept(this), register2);
    }

    @Override
    public Object visitAssertionRegisterLocation(LitmusCParser.AssertionRegisterLocationContext ctx) {
        Register register = visitThreadVariable(ctx.threadVariable());
        Location location = getOrCreateLocation(visitVariable(ctx.variable()));
        return new AssertBasic(location, (String)ctx.assertionOp().accept(this), register);
    }

    @Override
    public String visitAssertionOpEqual(LitmusCParser.AssertionOpEqualContext ctx){
        return "==";
    }

    @Override
    public String visitAssertionOpNotEqual(LitmusCParser.AssertionOpNotEqualContext ctx){
        return "!=";
    }

    private String getAssertionType(LitmusCParser.AssertionListContext ctx){
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
    // Utils

    @Override
    // Here we know that it is thread local variable (register)
    public Register visitThreadVariable(LitmusCParser.ThreadVariableContext ctx) {
        if(ctx.threadIdentifier() != null && ctx.Identifier() != null){
            String thread = threadId(ctx.threadIdentifier().getText());
            String variableName = ctx.Identifier().getText();
            return getOrCreateRegister(thread, variableName);
        }
        return visitThreadVariable(ctx.threadVariable());
    }

    @Override
    // Here we do not know if it is a local (register) or a global (location) variable,
    // the calling method must decide it and instantiate a correct class
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
        if(registerName == null || !(registers.keySet().contains(registerName))) {
            registers.put(registerName, new Register(registerName).setPrintMainThread(threadName));
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
        throw new ParsingException("visitNreSmpMbAfterSpinlock is not implemented");
        //return visitFenceExpression("After-spinlock");
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Converting returnExpression to ExprInterface

    private Thread visitAtomicOpReturn(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicOpReturn(varCtx, returnStack.pop(), op, memoryOrder);
        return Utils.arrayToThread(false, t, result);
    }

    private Thread visitAtomicFetchOp(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicFetchOp(varCtx, returnStack.pop(), op, memoryOrder);
        return Utils.arrayToThread(false, t, result);
    }

    private Thread visitAtomicXchg(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicXchg(varCtx, returnStack.pop(), memoryOrder);
        return Utils.arrayToThread(false, t, result);
    }

    private Thread visitAtomicCmpxchg(
            LitmusCParser.VariableContext varCtx,
            LitmusCParser.ReturnExpressionContext re1Ctx,
            LitmusCParser.ReturnExpressionContext re2Ctx,
            String memoryOrder
    ){
        Thread t1 = (Thread)re1Ctx.accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)re2Ctx.accept(this);
        ExprInterface v2 = returnStack.pop();
        Thread result = visitAtomicCmpxchg(varCtx, v1, v2, memoryOrder);
        return Utils.arrayToThread(false, t1, t2, result);
    }

    private Thread visitAtomicOpAndTest(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicOpAndTest(varCtx, returnStack.pop(), op);
        return Utils.arrayToThread(false, t, result);
    }

    private Thread visitAtomicOp(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String op){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicOp(varCtx, returnStack.pop(), op);
        return Utils.arrayToThread(false, t, result);
    }

    private Thread visitAtomicWrite(LitmusCParser.VariableContext varCtx, LitmusCParser.ReturnExpressionContext reCtx, String memoryOrder){
        Thread t = (Thread)reCtx.accept(this);
        Thread result = visitAtomicWrite(varCtx, returnStack.pop(), memoryOrder);
        return Utils.arrayToThread(false, t, result);
    }
}
