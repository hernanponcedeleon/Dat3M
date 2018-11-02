package dartagnan.parsers.visitors;

import dartagnan.parsers.LitmusCBaseVisitor;
import dartagnan.parsers.LitmusCParser;
import dartagnan.parsers.LitmusCVisitor;
import dartagnan.expression.*;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.program.*;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.linux.rcu.RCUReadLock;
import dartagnan.program.event.linux.rcu.RCUReadUnlock;
import dartagnan.program.event.linux.rcu.RCUSync;
import dartagnan.program.event.linux.rmw.*;
import dartagnan.utils.Pair;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.*;

public class VisitorLitmusC
        extends LitmusCBaseVisitor<Object>
        implements LitmusCVisitor<Object> {

    private ProgramBuilder programBuilder;
    private Stack<ExprInterface> returnStack = new Stack<>();
    private Stack<RCUReadLock> rcuLockStack = new Stack<>();
    private String currentThread;

    public VisitorLitmusC(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusCParser.MainContext ctx) {
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitProgram(ctx.program());
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(LitmusCParser.GlobalDeclaratorLocationContext ctx) {
        int value = ProgramBuilder.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constantValue().getText());
        }
        programBuilder.addDeclarationLocImm(visitVariable(ctx.variable()), value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        Register register = visitThreadVariable(ctx.threadVariable());
        int value = ProgramBuilder.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constantValue().getText());
        }
        programBuilder.addDeclarationRegImm(register.getPrintMainThreadId(), register.getName(), value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
        programBuilder.addDeclarationLocLoc(visitVariable(ctx.variable(0)), visitVariable(ctx.variable(1)));
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        throw new ParsingException("Pointer assignment is not implemented");
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Threads (the program itself)

    @Override
    public Object visitThread(LitmusCParser.ThreadContext ctx) {
        visitThreadArguments(ctx.threadArguments());
        currentThread = ctx.threadId().id;
        programBuilder.initThread(currentThread);
        Thread result = visitExpressionSequence(ctx);

        // TODO: A separate lock stack for each branch
        if(!rcuLockStack.empty()){
            throw new ParsingException("Unbalanced RCU lock in thread " + currentThread);
        }
        return programBuilder.addChild(currentThread, result);
    }

    @Override
    public Object visitThreadArguments(LitmusCParser.ThreadArgumentsContext ctx){
        int n = ctx.getChildCount();
        for (int i = 0; i < n; ++i) {
            ParseTree child = ctx.getChild(i);
            if (child instanceof LitmusCParser.VariableDeclaratorContext) {
                programBuilder.getOrCreateLocation(visitVariable(((LitmusCParser.VariableDeclaratorContext) child).variable()));
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
        return Thread.fromArray(false, evalThread, result);
    }

    @Override
    public Thread visitSeqDeclarationReturnExpression(LitmusCParser.SeqDeclarationReturnExpressionContext ctx){
        String varName = visitVariable(ctx.variable());
        Register register = programBuilder.getOrCreateRegister(currentThread, varName);
        if(ctx.returnExpression() != null){
            Thread t = (Thread)ctx.returnExpression().accept(this);
            Thread result = new Local(register, returnStack.pop());
            return Thread.fromArray(false, t, result);
        }
        return null;
    }

    @Override
    public Thread visitSeqReturnExpression(LitmusCParser.SeqReturnExpressionContext ctx){
        Thread t = (Thread)ctx.returnExpression().accept(this);
        String varName = visitVariable(ctx.variable());
        Thread result = null;

        Register register = programBuilder.getRegister(currentThread, varName);
        if(register == null){
            Location location = programBuilder.getLocation(varName);
            if(location != null){
                result = new Write(location, returnStack.pop(), "Relaxed");
            }
        }

        if(result == null){
            if(register == null){
                register = programBuilder.getOrCreateRegister(currentThread, varName);
            }
            result = new Local(register, returnStack.pop());
        }

        return Thread.fromArray(false, t, result);
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
        return Thread.fromList(true, events);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions

    // Returns new value (the value after computation)
    @Override
    public Thread visitReAtomicOpReturn(LitmusCParser.ReAtomicOpReturnContext ctx){
        Pair<Thread, ExprInterface> pair = acceptRetValue(ctx.returnExpression());
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWOpReturn(location, register, pair.getSecond(), ctx.op, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    // Returns old value (the value before computation)
    @Override
    public Thread visitReAtomicFetchOp(LitmusCParser.ReAtomicFetchOpContext ctx){
        Pair<Thread, ExprInterface> pair = acceptRetValue(ctx.returnExpression());
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWFetchOp(location, register, pair.getSecond(), ctx.op, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    @Override
    public Thread visitReAtomicOpAndTest(LitmusCParser.ReAtomicOpAndTestContext ctx){
        Pair<Thread, ExprInterface> pair = acceptRetValue(ctx.returnExpression());
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWOpAndTest(location, register, pair.getSecond(), ctx.op);
        returnStack.push(register);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public Thread visitReAtomicAddUnless(LitmusCParser.ReAtomicAddUnlessContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface value = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface cmp = returnStack.pop();
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWAddUnless(location, register,cmp, value);
        returnStack.push(register);
        return Thread.fromArray(false, t1, t2, t);
    }

    @Override
    public Thread visitReLoad(LitmusCParser.ReLoadContext ctx){
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        returnStack.push(register);
        return new Read(register, location, ctx.mo);
    }

    @Override
    public Thread visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new Atom(v1, ctx.opCompare().getText(), v2));
        return Thread.fromArray(false, t1, t2);
    }

    @Override
    public Thread visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new AExpr(v1, ctx.opArith().getText(), v2));
        return Thread.fromArray(false, t1, t2);
    }

    @Override
    public Thread visitReOpBool(LitmusCParser.ReOpBoolContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        String op = ctx.opBool().getText().equals("&&") ? "and" : "or";
        returnStack.push(new BExpr(v1, op, v2));
        return Thread.fromArray(false, t1, t2);
    }

    @Override
    public Thread visitReOpBoolNot(LitmusCParser.ReOpBoolNotContext ctx){
        Thread t = (Thread)ctx.returnExpression().accept(this);
        ExprInterface v = returnStack.pop();
        returnStack.push(new BExpr(v, "not", null));
        return t;
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
        Register register = programBuilder.getRegister(currentThread, varName);
        if(register != null){
            returnStack.push(register);
            return null;
        }

        Location location = programBuilder.getLocation(varName);
        if(location == null){
            throw new ParsingException("Variable " + varName + " has not been initialized");
        }

        register = programBuilder.getOrCreateRegister(currentThread, null);
        returnStack.push(register);
        return new Read(register, location, "Relaxed");
    }

    @Override
    public Thread visitReConst(LitmusCParser.ReConstContext ctx){
        returnStack.push(new AConst(Integer.parseInt(ctx.getText())));
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Thread visitNreAtomicOp(LitmusCParser.NreAtomicOpContext ctx){
        Pair<Thread, ExprInterface> pair = acceptRetValue(ctx.returnExpression());
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Thread t = new RMWOp(location, pair.getSecond(), ctx.op);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    @Override
    public Thread visitReXchg(LitmusCParser.ReXchgContext ctx){
        Thread t1 = (Thread)ctx.returnExpression().accept(this);
        ExprInterface value = returnStack.pop();
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWXchg(location, register, value, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, t1, t);
    }

    @Override
    public Thread visitReCmpXchg(LitmusCParser.ReCmpXchgContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface cmp = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface value = returnStack.pop();
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWCmpXchg(location, register, cmp, value, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, t1, t2, t);
    }

    @Override
    public Thread visitNreStore(LitmusCParser.NreStoreContext ctx){
        Thread t1 = (Thread)ctx.returnExpression().accept(this);
        Location location = programBuilder.getOrErrorLocation(visitVariable(ctx.variable()));
        if(ctx.mo.equals("Mb")){
            Thread t = new Write(location, returnStack.pop(), "Relaxed");
            return Thread.fromArray(false, t1, t, new Fence("Mb"));
        }
        Thread t = new Write(location, returnStack.pop(), ctx.mo);
        return Thread.fromArray(false, t1, t);
    }

    @Override
    public Thread visitNreRcuReadLock(LitmusCParser.NreRcuReadLockContext ctx){
        RCUReadLock lock = new RCUReadLock();
        rcuLockStack.push(lock);
        return lock;
    }

    @Override
    public Thread visitNreRcuReadUnlock(LitmusCParser.NreRcuReadUnlockContext ctx){
        try {
            RCUReadLock lock = rcuLockStack.pop();
            return new RCUReadUnlock(lock);
        } catch (EmptyStackException e){
            throw new ParsingException("Unbalanced RCU unlock in thread " + currentThread);
        }
    }

    @Override
    public Thread visitNreSynchronizeRcu(LitmusCParser.NreSynchronizeRcuContext ctx){
        return new RCUSync();
    }

    @Override
    public Thread visitNreFence(LitmusCParser.NreFenceContext ctx){
        return new Fence(ctx.name);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    // Here we know that it is thread local variable (register)
    public Register visitThreadVariable(LitmusCParser.ThreadVariableContext ctx) {
        if(ctx.threadId() != null && ctx.varName() != null){
            String variableName = ctx.varName().getText();
            return programBuilder.getOrCreateRegister(ctx.threadId().id, variableName);
        }
        return visitThreadVariable(ctx.threadVariable());
    }

    @Override
    // Here we do not know if it is a local (register) or a global (location) variable,
    // the calling method must decide it and instantiate a correct class
    public String visitVariable(LitmusCParser.VariableContext ctx) {
        if(ctx.varName() != null){
            return ctx.varName().getText();
        }
        return visitVariable(ctx.variable());
    }

    private Pair<Thread, ExprInterface> acceptRetValue(LitmusCParser.ReturnExpressionContext ctx){
        Thread t = null;
        ExprInterface v = new AConst(1);
        if(ctx != null){
            t = (Thread)ctx.accept(this);
            v = returnStack.pop();
        }
        return new Pair<>(t, v);
    }
}
