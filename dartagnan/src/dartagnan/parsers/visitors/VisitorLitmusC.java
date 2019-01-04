package dartagnan.parsers.visitors;

import dartagnan.expression.*;
import dartagnan.expression.op.BOpUn;
import dartagnan.parsers.*;
import dartagnan.parsers.utils.AssertionHelper;
import dartagnan.parsers.utils.ParsingException;
import dartagnan.parsers.utils.ProgramBuilder;
import dartagnan.program.Program;
import dartagnan.program.Register;
import dartagnan.program.Thread;
import dartagnan.program.event.*;
import dartagnan.program.event.linux.rcu.RCUReadLock;
import dartagnan.program.event.linux.rcu.RCUReadUnlock;
import dartagnan.program.event.linux.rcu.RCUSync;
import dartagnan.program.event.linux.rmw.*;
import dartagnan.program.memory.Address;
import dartagnan.program.memory.Location;
import org.antlr.v4.runtime.misc.Interval;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.*;

public class VisitorLitmusC
        extends LitmusCBaseVisitor<Object>
        implements LitmusCVisitor<Object> {

    private ProgramBuilder programBuilder;
    private Stack<RCUReadLock> rcuLockStack = new Stack<>();
    private String currentThread;
    private String scope;
    private Register returnRegister;
    private int innerThreadIndex = 0;

    public VisitorLitmusC(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Program visitMain(LitmusCParser.MainContext ctx) {
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitProgram(ctx.program());
        if(ctx.assertionList() != null){
            int a = ctx.assertionList().getStart().getStartIndex();
            int b = ctx.assertionList().getStop().getStopIndex();
            String raw = ctx.assertionList().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssert(AssertionHelper.parseAssertionList(programBuilder, raw));
        }
        if(ctx.assertionFilter() != null){
            int a = ctx.assertionFilter().getStart().getStartIndex();
            int b = ctx.assertionFilter().getStop().getStopIndex();
            String raw = ctx.assertionFilter().getStart().getInputStream().getText(new Interval(a, b));
            programBuilder.setAssertFilter(AssertionHelper.parseAssertionFilter(programBuilder, raw));
        }
        return programBuilder.build();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { int 0:a=0; int 1:b=1; int x=2; }

    @Override
    public Object visitGlobalDeclaratorLocation(LitmusCParser.GlobalDeclaratorLocationContext ctx) {
        int value = Location.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constant().getText());
        }
        programBuilder.initLocEqConst(ctx.varName().getText(), value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        int value = Location.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = Integer.parseInt(ctx.initConstantValue().constant().getText());
        }
        programBuilder.initRegEqConst(ctx.threadId().getText(), ctx.varName().getText(), value);
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.varName(0).getText(), ctx.varName(1).getText());
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().getText(), ctx.varName(0).getText(), ctx.varName(1).getText());
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorArray(LitmusCParser.GlobalDeclaratorArrayContext ctx) {
        String name = ctx.varName().getText();
        Integer size = ctx.DigitSequence() != null ? Integer.parseInt(ctx.DigitSequence().getText()) : null;

        if(ctx.initArray() == null && size != null && size > 0){
            programBuilder.addDeclarationArray(name, Collections.nCopies(size, 0));
            return null;
        }
        if(ctx.initArray() != null){
            if(size == null || ctx.initArray().DigitSequence().size() == size){
                List<Integer> values = new ArrayList<>();
                for(TerminalNode raw : ctx.initArray().DigitSequence()){
                    values.add(Integer.parseInt(raw.getText()));
                }
                programBuilder.addDeclarationArray(name, values);
                return null;
            }
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Threads (the program itself)

    @Override
    public Object visitThread(LitmusCParser.ThreadContext ctx) {
        scope = currentThread = ctx.threadId().id;
        programBuilder.initThread(currentThread);
        visitThreadArguments(ctx.threadArguments());

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);

        // TODO: A separate lock stack for each branch
        if(!rcuLockStack.empty()){
            throw new ParsingException("Unbalanced RCU lock in thread " + currentThread);
        }
        scope = currentThread = null;
        return null;
    }

    @Override
    public Object visitThreadArguments(LitmusCParser.ThreadArgumentsContext ctx){
        if(ctx != null){
            for(LitmusCParser.VarNameContext varName : ctx.varName()){
                String name = varName.getText();
                Address pointer = programBuilder.getPointer(name);
                if(pointer != null){
                    Register register = programBuilder.getOrCreateRegister(scope, name);
                    programBuilder.addChild(currentThread, new Local(register, pointer));
                } else {
                    Location location = programBuilder.getOrCreateLocation(varName.getText());
                    Register register = programBuilder.getOrCreateRegister(scope, varName.getText());
                    programBuilder.addChild(currentThread, new Local(register, location.getAddress()));
                }
            }
        }
        return null;
    }

    @Override
    public Object visitWhileExpression(LitmusCParser.WhileExpressionContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.re().accept(this);
        programBuilder.addChild(currentThread, new While(expr, visitInnerThread(ctx.expression())));
        return null;
    }

    @Override
    public Object visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.re().accept(this);
        Thread t1 = visitInnerThread(ctx.expression());
        Thread t2 = ctx.elseExpression() == null ? new Skip() : visitInnerThread(ctx.elseExpression().expression());
        programBuilder.addChild(currentThread, new If(expr, t1, t2));
        return null;
    }

    private Thread visitInnerThread(Collection<LitmusCParser.ExpressionContext> ctx){
        if(ctx != null){
            String origThread = currentThread;
            String tName = newInnerThreadIndex();
            currentThread = tName;
            programBuilder.initThread(tName);
            for(LitmusCParser.ExpressionContext expressionContext : ctx)
                expressionContext.accept(this);
            currentThread = origThread;
            return programBuilder.removeChild(tName);
        }
        return new Skip();
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (memory reads, must have register for return value)

    // Returns new value (the value after computation)
    @Override
    public IExpr visitReAtomicOpReturn(LitmusCParser.ReAtomicOpReturnContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = returnExpressionOrDefault(ctx.value, 1);
        Thread thread = new RMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, thread);
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public IExpr visitReAtomicFetchOp(LitmusCParser.ReAtomicFetchOpContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = returnExpressionOrDefault(ctx.value, 1);
        Thread thread = new RMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, thread);
        return register;
    }

    @Override
    public IExpr visitReAtomicOpAndTest(LitmusCParser.ReAtomicOpAndTestContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = returnExpressionOrDefault(ctx.value, 1);
        Thread thread = new RMWOpAndTest(getAddress(ctx.address), register, value, ctx.op);
        programBuilder.addChild(currentThread, thread);
        return register;
    }

    // Returns non-zero if the addition was executed, zero otherwise
    @Override
    public IExpr visitReAtomicAddUnless(LitmusCParser.ReAtomicAddUnlessContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        ExprInterface cmp = (ExprInterface)ctx.cmp.accept(this);
        programBuilder.addChild(currentThread, new RMWAddUnless(getAddress(ctx.address), register, cmp, value));
        return register;
    }

    @Override
    public IExpr visitReXchg(LitmusCParser.ReXchgContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Thread t = new RMWXchg(getAddress(ctx.address), register, value, ctx.mo);
        programBuilder.addChild(currentThread, t);
        return register;
    }

    @Override
    public IExpr visitReCmpXchg(LitmusCParser.ReCmpXchgContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface cmp = (ExprInterface)ctx.cmp.accept(this);
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Thread t = new RMWCmpXchg(getAddress(ctx.address), register, cmp, value, ctx.mo);
        programBuilder.addChild(currentThread, t);
        return register;
    }

    @Override
    public IExpr visitReLoad(LitmusCParser.ReLoadContext ctx){
        Register register = getReturnRegister(true);
        Thread t = new Load(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, t);
        return register;
    }

    @Override
    public IExpr visitReReadOnce(LitmusCParser.ReReadOnceContext ctx){
        Register register = getReturnRegister(true);
        Thread t = new Load(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, t);
        return register;
    }

    @Override
    public IExpr visitReReadNa(LitmusCParser.ReReadNaContext ctx){
        Register register = getReturnRegister(true);
        Thread t = new Load(register, getAddress(ctx.address), "NA");
        programBuilder.addChild(currentThread, t);
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (register for return value is optional)

    @Override
    public ExprInterface visitReOpCompare(LitmusCParser.ReOpCompareContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface)ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface)ctx.re(1).accept(this);
        Atom result = new Atom(v1, ctx.opCompare().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpArith(LitmusCParser.ReOpArithContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface)ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface)ctx.re(1).accept(this);
        IExpr result = new IExprBin(v1, ctx.opArith().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpBool(LitmusCParser.ReOpBoolContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v1 = (ExprInterface)ctx.re(0).accept(this);
        ExprInterface v2 = (ExprInterface)ctx.re(1).accept(this);
        BExprBin result = new BExprBin(v1, ctx.opBool().op, v2);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReOpBoolNot(LitmusCParser.ReOpBoolNotContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface v = (ExprInterface)ctx.re().accept(this);
        BExprUn result = new BExprUn(BOpUn.NOT, v);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReParenthesis(LitmusCParser.ReParenthesisContext ctx){
        return (ExprInterface)ctx.re().accept(this);
    }

    @Override
    public ExprInterface visitReCast(LitmusCParser.ReCastContext ctx){
        Register register = getReturnRegister(false);
        ExprInterface result = (ExprInterface)ctx.re().accept(this);
        return assignToReturnRegister(register, result);
    }

    @Override
    public ExprInterface visitReVarName(LitmusCParser.ReVarNameContext ctx){
        Register register = getReturnRegister(false);
        IExpr variable = visitVarName(ctx.varName());
        if(variable instanceof Register){
            Register result = (Register)variable;
            return assignToReturnRegister(register, result);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public ExprInterface visitReConst(LitmusCParser.ReConstContext ctx){
        Register register = getReturnRegister(false);
        IConst result = new IConst(Integer.parseInt(ctx.getText()));
        return assignToReturnRegister(register, result);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(LitmusCParser.NreAtomicOpContext ctx){
        ExprInterface value = returnExpressionOrDefault(ctx.value, 1);
        Thread t = new RMWOp(getAddress(ctx.address), value, ctx.op);
        programBuilder.addChild(currentThread, t);
        return null;
    }

    @Override
    public Object visitNreStore(LitmusCParser.NreStoreContext ctx){
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        if(ctx.mo.equals("Mb")){
            Thread t = new Store(getAddress(ctx.address), value, "Relaxed");
            t = Thread.fromArray(false, t, new Fence("Mb"));
            programBuilder.addChild(currentThread, t);
            return null;
        }
        Thread t = new Store(getAddress(ctx.address), value, ctx.mo);
        programBuilder.addChild(currentThread, t);
        return null;
    }

    @Override
    public Object visitNreWriteOnce(LitmusCParser.NreWriteOnceContext ctx){
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Thread t = new Store(getAddress(ctx.address), value, ctx.mo);
        programBuilder.addChild(currentThread, t);
        return null;
    }

    @Override
    public Object visitNreAssignment(LitmusCParser.NreAssignmentContext ctx){
        IntExprInterface variable = (IntExprInterface)ctx.varName().accept(this);
        if(ctx.Ast() == null){
            if(variable instanceof Register){
                returnRegister = (Register)variable;
                ctx.re().accept(this);
                return null;
            }
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }

        ExprInterface value = (ExprInterface)ctx.re().accept(this);
        if(variable instanceof Address || variable instanceof Register){
            Thread result = new Store((IExpr) variable, value, "NA");
            programBuilder.addChild(currentThread, result);
            return null;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(LitmusCParser.NreRegDeclarationContext ctx){
        Register register = programBuilder.getRegister(scope, ctx.varName().getText());
        if(register == null){
            register = programBuilder.getOrCreateRegister(scope, ctx.varName().getText());
            if(ctx.re() != null){
                returnRegister = register;
                ctx.re().accept(this);
            }
            return null;
        }
        throw new ParsingException("Register " + ctx.varName().getText() + " is already initialised");
    }

    @Override
    public Object visitNreRcuReadLock(LitmusCParser.NreRcuReadLockContext ctx){
        RCUReadLock lock = new RCUReadLock();
        programBuilder.addChild(currentThread, lock);
        rcuLockStack.push(lock);
        return null;
    }

    @Override
    public Object visitNreRcuReadUnlock(LitmusCParser.NreRcuReadUnlockContext ctx){
        try {
            RCUReadLock lock = rcuLockStack.pop();
            programBuilder.addChild(currentThread, new RCUReadUnlock(lock));
            return null;
        } catch (EmptyStackException e){
            throw new ParsingException("Unbalanced RCU unlock in thread " + currentThread);
        }
    }

    @Override
    public Object visitNreSynchronizeRcu(LitmusCParser.NreSynchronizeRcuContext ctx){
        programBuilder.addChild(currentThread, new RCUSync());
        return null;
    }

    @Override
    public Object visitNreFence(LitmusCParser.NreFenceContext ctx){
        programBuilder.addChild(currentThread, new Fence(ctx.name));
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public IExpr visitVarName(LitmusCParser.VarNameContext ctx){
        if(scope != null){
            Register register = programBuilder.getRegister(scope, ctx.getText());
            if(register != null){
                return register;
            }
            Location location = programBuilder.getLocation(ctx.getText());
            if(location != null){
                register = programBuilder.getOrCreateRegister(scope, null);
                programBuilder.addChild(currentThread, new Load(register, location.getAddress(), "NA"));
                return register;
            }
            return programBuilder.getOrCreateRegister(scope, ctx.getText());
        }
        Location location = programBuilder.getOrCreateLocation(ctx.getText());
        Register register = programBuilder.getOrCreateRegister(scope, null);
        programBuilder.addChild(currentThread, new Load(register, location.getAddress(), "NA"));
        return register;
    }

    private IExpr getAddress(LitmusCParser.ReContext ctx){
        ExprInterface address = (ExprInterface)ctx.accept(this);
        if(address instanceof IExpr){
           return (IExpr)address;
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    private ExprInterface returnExpressionOrDefault(LitmusCParser.ReContext ctx, int defaultValue){
        return ctx != null ? (ExprInterface)ctx.accept(this) : new IConst(defaultValue);
    }

    private Register getReturnRegister(boolean createOnNull){
        Register register = returnRegister;
        if(register == null && createOnNull){
            return programBuilder.getOrCreateRegister(scope, null);
        }
        returnRegister = null;
        return register;
    }

    private ExprInterface assignToReturnRegister(Register register, ExprInterface value){
        if(register != null){
            programBuilder.addChild(currentThread, new Local(register, value));
        }
        return value;
    }

    private String newInnerThreadIndex(){
        return "inner_" + innerThreadIndex++;
    }
}
