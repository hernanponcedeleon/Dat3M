package dartagnan.parsers.visitors;

import dartagnan.expression.*;
import dartagnan.expression.op.BOpUn;
import dartagnan.parsers.LitmusCBaseVisitor;
import dartagnan.parsers.LitmusCParser;
import dartagnan.parsers.LitmusCVisitor;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.linux.rcu.RCUReadLock;
import dartagnan.program.event.linux.rcu.RCUReadUnlock;
import dartagnan.program.event.linux.rcu.RCUSync;
import dartagnan.program.event.linux.rmw.*;
import dartagnan.program.memory.Address;
import dartagnan.program.memory.Location;
import dartagnan.utils.Pair;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.tree.ParseTree;

import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.List;
import java.util.Stack;

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
        int value = Location.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constantValue().getText());
        }
        programBuilder.addDeclarationLocImm(ctx.varName().getText(), value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        int value = Location.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constantValue().getText());
        }
        programBuilder.addDeclarationRegImm(ctx.threadId().getText(), ctx.varName().getText(), value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
        programBuilder.addDeclarationLocLoc(ctx.varName(0).getText(), ctx.varName(1).getText());
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        programBuilder.addDeclarationRegLoc(ctx.threadId().getText(), ctx.varName(0).getText(), ctx.varName(1).getText());
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Threads (the program itself)

    @Override
    public Object visitThread(LitmusCParser.ThreadContext ctx) {
        currentThread = ctx.threadId().id;
        programBuilder.initThread(currentThread);
        visitThreadArguments(ctx.threadArguments());
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
            if (child instanceof LitmusCParser.VarNameContext) {
                programBuilder.getOrCreateLocation(child.getText());
            }
        }
        return null;
    }

    @Override
    public Thread visitExpression(LitmusCParser.ExpressionContext ctx) {
        if (ctx.ifExpression() != null) {
            return visitIfExpression(ctx.ifExpression());
        }
        return (Thread) ctx.nonReturnExpression().accept(this);
    }

    @Override
    public Thread visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
        Thread evalThread = (Thread)ctx.returnExpression().accept(this);
        Thread t1 = visitExpressionSequence(ctx);
        Thread t2 = ctx.elseExpression() == null ? new Skip() : visitExpressionSequence(ctx.elseExpression());
        Thread result = new If(returnStack.pop(), t1, t2);
        return Thread.fromArray(false, evalThread, result);
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
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWOpReturn(getAddress(ctx.variable()), register, pair.getSecond(), ctx.op, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    // Returns old value (the value before computation)
    @Override
    public Thread visitReAtomicFetchOp(LitmusCParser.ReAtomicFetchOpContext ctx){
        Pair<Thread, ExprInterface> pair = acceptRetValue(ctx.returnExpression());
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWFetchOp(getAddress(ctx.variable()), register, pair.getSecond(), ctx.op, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    @Override
    public Thread visitReAtomicOpAndTest(LitmusCParser.ReAtomicOpAndTestContext ctx){
        Pair<Thread, ExprInterface> pair = acceptRetValue(ctx.returnExpression());
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWOpAndTest(getAddress(ctx.variable()), register, pair.getSecond(), ctx.op);
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
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWAddUnless(getAddress(ctx.variable()), register,cmp, value);
        returnStack.push(register);
        return Thread.fromArray(false, t1, t2, t);
    }

    @Override
    public Thread visitReLoad(LitmusCParser.ReLoadContext ctx){
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        returnStack.push(register);
        return new Load(register, getAddress(ctx.variable()), ctx.mo);
    }

    @Override
    public Thread visitReReadOnce(LitmusCParser.ReReadOnceContext ctx){
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        returnStack.push(register);
        AExpr address = getAddress(ctx.variable());
        return new Load(register, address, ctx.mo);
    }

    @Override
    public Thread visitReReadNa(LitmusCParser.ReReadNaContext ctx){
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        returnStack.push(register);
        AExpr address = (AExpr)ctx.variable().accept(this);
        return new Load(register, address, "NA");
    }

    @Override
    public Thread visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new Atom(v1, ctx.opCompare().op, v2));
        return Thread.fromArray(false, t1, t2);
    }

    @Override
    public Thread visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new AExpr(v1, ctx.opArith().op, v2));
        return Thread.fromArray(false, t1, t2);
    }

    @Override
    public Thread visitReOpBool(LitmusCParser.ReOpBoolContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface v1 = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface v2 = returnStack.pop();
        returnStack.push(new BExprBin(v1, ctx.opBool().op, v2));
        return Thread.fromArray(false, t1, t2);
    }

    @Override
    public Thread visitReOpBoolNot(LitmusCParser.ReOpBoolNotContext ctx){
        Thread t = (Thread)ctx.returnExpression().accept(this);
        ExprInterface v = returnStack.pop();
        returnStack.push(new BExprUn(BOpUn.NOT, v));
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
        IntExprInterface variable = (IntExprInterface)ctx.variable().accept(this);
        if(variable instanceof Register){
            returnStack.push((Register) variable);
            return null;
        }
        if(variable instanceof Address){
            returnStack.push((Address) variable);
            return null;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
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
        Thread t = new RMWOp(getAddress(ctx.variable()), pair.getSecond(), ctx.op);
        return Thread.fromArray(false, pair.getFirst(), t);
    }

    @Override
    public Thread visitReXchg(LitmusCParser.ReXchgContext ctx){
        Thread t1 = (Thread)ctx.returnExpression().accept(this);
        ExprInterface value = returnStack.pop();
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWXchg(getAddress(ctx.variable()), register, value, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, t1, t);
    }

    @Override
    public Thread visitReCmpXchg(LitmusCParser.ReCmpXchgContext ctx){
        Thread t1 = (Thread)ctx.returnExpression(0).accept(this);
        ExprInterface cmp = returnStack.pop();
        Thread t2 = (Thread)ctx.returnExpression(1).accept(this);
        ExprInterface value = returnStack.pop();
        Register register = programBuilder.getOrCreateRegister(currentThread, null);
        Thread t = new RMWCmpXchg(getAddress(ctx.variable()), register, cmp, value, ctx.mo);
        returnStack.push(register);
        return Thread.fromArray(false, t1, t2, t);
    }

    @Override
    public Thread visitNreStore(LitmusCParser.NreStoreContext ctx){
        Thread t1 = (Thread)ctx.returnExpression().accept(this);
        AExpr address = getAddress(ctx.variable());
        if(ctx.mo.equals("Mb")){
            Thread t = new Store(address, returnStack.pop(), "Relaxed");
            return Thread.fromArray(false, t1, t, new Fence("Mb"));
        }
        Thread t = new Store(address, returnStack.pop(), ctx.mo);
        return Thread.fromArray(false, t1, t);
    }

    @Override
    public Thread visitNreWriteOnce(LitmusCParser.NreWriteOnceContext ctx){
        Thread t1 = (Thread)ctx.returnExpression().accept(this);
        AExpr address = getAddress(ctx.variable());
        Thread t = new Store(address, returnStack.pop(), ctx.mo);
        return Thread.fromArray(false, t1, t);
    }

    @Override
    public Thread visitNreAssignment(LitmusCParser.NreAssignmentContext ctx){
        Thread t = (Thread)ctx.returnExpression().accept(this);
        IntExprInterface variable = (IntExprInterface)ctx.varName().accept(this);

        if(ctx.Ast() == null){
            if(variable instanceof Register){
                Thread result = new Local((Register) variable, returnStack.pop());
                return Thread.fromArray(false, t, result);
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        if(variable instanceof Address || variable instanceof Register){
            Thread result = new Store((AExpr) variable, returnStack.pop(), "NA");
            return Thread.fromArray(false, t, result);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Thread visitNreRegDeclaration(LitmusCParser.NreRegDeclarationContext ctx){
        Register register = programBuilder.getOrCreateRegister(currentThread, ctx.varName().getText());
        if(ctx.returnExpression() != null){
            Thread t = (Thread)ctx.returnExpression().accept(this);
            Thread result = new Local(register, returnStack.pop());
            return Thread.fromArray(false, t, result);
        }
        return null;
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
    public Register visitThreadVariable(LitmusCParser.ThreadVariableContext ctx) {
        String variableName = ctx.varName().getText();
        return programBuilder.getOrCreateRegister(ctx.threadId().id, variableName);
    }

    @Override
    public IntExprInterface visitVariable(LitmusCParser.VariableContext ctx){
        if(ctx.variable() != null){
            return (IntExprInterface)ctx.variable().accept(this);
        }
        return (IntExprInterface)ctx.varName().accept(this);
    }

    @Override
    public IntExprInterface visitVarName(LitmusCParser.VarNameContext ctx){
        Register register = programBuilder.getRegister(currentThread, ctx.getText());
        if(register != null){
            return register;
        }
        Location location = programBuilder.getLocation(ctx.getText());
        if(location != null){
            return location.getAddress();
        }
        return programBuilder.getOrCreateRegister(currentThread, ctx.getText());
    }

    private AExpr getAddress(LitmusCParser.VariableContext ctx){
        Object address = ctx.accept(this);
        if(address instanceof Address || address instanceof Register){
            return (AExpr) address;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
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
