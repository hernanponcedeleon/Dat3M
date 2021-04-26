package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.*;
import com.dat3m.dartagnan.expression.op.BOpUn;
import com.dat3m.dartagnan.parsers.LitmusCBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusCParser;
import com.dat3m.dartagnan.parsers.LitmusCVisitor;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.arch.linux.event.*;
import com.dat3m.dartagnan.program.event.*;
import com.dat3m.dartagnan.program.memory.Address;
import com.dat3m.dartagnan.program.memory.Location;
import org.antlr.v4.runtime.misc.Interval;

import java.math.BigInteger;
import java.util.*;

public class VisitorLitmusC
        extends LitmusCBaseVisitor<Object>
        implements LitmusCVisitor<Object> {

    private final ProgramBuilder programBuilder;
    private int currentThread;
    private int scope;
    private Register returnRegister;

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
    	BigInteger value = Location.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = new BigInteger(ctx.initConstantValue().constant().getText());
        }
        programBuilder.initLocEqConst(ctx.varName().getText(), new IConst(value, -1));
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegister(LitmusCParser.GlobalDeclaratorRegisterContext ctx) {
        BigInteger value = Location.DEFAULT_INIT_VALUE;
        if (ctx.initConstantValue() != null) {
            value = new BigInteger(ctx.initConstantValue().constant().getText());
        }
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.varName().getText(), new IConst(value, -1));
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorLocationLocation(LitmusCParser.GlobalDeclaratorLocationLocationContext ctx) {
        if(ctx.Ast() == null){
            programBuilder.initLocEqLocPtr(ctx.varName(0).getText(), ctx.varName(1).getText(), -1);
        } else {
            String rightName = ctx.varName(1).getText();
            Address address = programBuilder.getPointer(rightName);
            if(address != null){
                programBuilder.initLocEqConst(ctx.varName(0).getText(), address);
            } else {
                programBuilder.initLocEqLocVal(ctx.varName(0).getText(), ctx.varName(1).getText(), -1);
            }
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorRegisterLocation(LitmusCParser.GlobalDeclaratorRegisterLocationContext ctx) {
        if(ctx.Ast() == null){
            programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), -1);
        } else {
            String rightName = ctx.varName(1).getText();
            Address address = programBuilder.getPointer(rightName);
            if(address != null){
                programBuilder.initRegEqConst(ctx.threadId().id, ctx.varName(0).getText(), address);
            } else {
                programBuilder.initRegEqLocVal(ctx.threadId().id, ctx.varName(0).getText(), ctx.varName(1).getText(), -1);
            }
        }
        return null;
    }

    @Override
    public Object visitGlobalDeclaratorArray(LitmusCParser.GlobalDeclaratorArrayContext ctx) {
        String name = ctx.varName().getText();
        Integer size = ctx.DigitSequence() != null ? Integer.parseInt(ctx.DigitSequence().getText()) : null;

        if(ctx.initArray() == null && size != null && size > 0){
            programBuilder.addDeclarationArray(name, Collections.nCopies(size, new IConst(BigInteger.ZERO, -1)));
            return null;
        }
        if(ctx.initArray() != null){
            if(size == null || ctx.initArray().arrayElement().size() == size){
                List<IConst> values = new ArrayList<>();
                for(LitmusCParser.ArrayElementContext elCtx : ctx.initArray().arrayElement()){
                    if(elCtx.constant() != null){
                        values.add(new IConst(new BigInteger(elCtx.constant().getText()), -1));
                    } else {
                        String varName = elCtx.varName().getText();
                        Address address = programBuilder.getPointer(varName);
                        if(address != null){
                            values.add(address);
                        } else {
                            address = programBuilder.getOrCreateLocation(varName, -1).getAddress();
                            values.add(elCtx.Ast() == null ? address : programBuilder.getInitValue(address));
                        }
                    }
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

        scope = currentThread = -1;
        return null;
    }

    @Override
    public Object visitThreadArguments(LitmusCParser.ThreadArgumentsContext ctx){
        if(ctx != null){
            for(LitmusCParser.VarNameContext varName : ctx.varName()){
                String name = varName.getText();
                Address pointer = programBuilder.getPointer(name);
                if(pointer != null){
                    Register register = programBuilder.getOrCreateRegister(scope, name, -1);
                    programBuilder.addChild(currentThread, new Local(register, pointer));
                } else {
                    Location location = programBuilder.getOrCreateLocation(varName.getText(), -1);
                    Register register = programBuilder.getOrCreateRegister(scope, varName.getText(), -1);
                    programBuilder.addChild(currentThread, new Local(register, location.getAddress()));
                }
            }
        }
        return null;
    }

    @Override
    public Object visitWhileExpression(LitmusCParser.WhileExpressionContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.re().accept(this);
        Skip exitEvent = new Skip();
        While whileEvent = new While(expr, exitEvent);
        programBuilder.addChild(currentThread, whileEvent);

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);

        return programBuilder.addChild(currentThread, exitEvent);
    }

    @Override
    public Object visitIfExpression(LitmusCParser.IfExpressionContext ctx) {
        ExprInterface expr = (ExprInterface) ctx.re().accept(this);
        Skip exitMainBranch = new Skip();
        Skip exitElseBranch = new Skip();
        If ifEvent = new If(expr, exitMainBranch, exitElseBranch);
        programBuilder.addChild(currentThread, ifEvent);

        for(LitmusCParser.ExpressionContext expressionContext : ctx.expression())
            expressionContext.accept(this);
        programBuilder.addChild(currentThread, exitMainBranch);

        if(ctx.elseExpression() != null){
            ctx.elseExpression().accept(this);
        }
        programBuilder.addChild(currentThread, exitElseBranch);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Return expressions (memory reads, must have register for return value)

    // Returns new value (the value after computation)
    @Override
    public IExpr visitReAtomicOpReturn(LitmusCParser.ReAtomicOpReturnContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = new RMWOpReturn(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    // Returns old value (the value before computation)
    @Override
    public IExpr visitReAtomicFetchOp(LitmusCParser.ReAtomicFetchOpContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = new RMWFetchOp(getAddress(ctx.address), register, value, ctx.op, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReAtomicOpAndTest(LitmusCParser.ReAtomicOpAndTestContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Event event = new RMWOpAndTest(getAddress(ctx.address), register, value, ctx.op);
        programBuilder.addChild(currentThread, event);
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
        Event event = new RMWXchg(getAddress(ctx.address), register, value, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReCmpXchg(LitmusCParser.ReCmpXchgContext ctx){
        Register register = getReturnRegister(true);
        ExprInterface cmp = (ExprInterface)ctx.cmp.accept(this);
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Event event = new RMWCmpXchg(getAddress(ctx.address), register, cmp, value, ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReLoad(LitmusCParser.ReLoadContext ctx){
        Register register = getReturnRegister(true);
        Event event = new Load(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReReadOnce(LitmusCParser.ReReadOnceContext ctx){
        Register register = getReturnRegister(true);
        Event event = new Load(register, getAddress(ctx.address), ctx.mo);
        programBuilder.addChild(currentThread, event);
        return register;
    }

    @Override
    public IExpr visitReReadNa(LitmusCParser.ReReadNaContext ctx){
        Register register = getReturnRegister(true);
        Event event = new Load(register, getAddress(ctx.address), "NA");
        programBuilder.addChild(currentThread, event);
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
    public ExprInterface visitReBoolConst(LitmusCParser.ReBoolConstContext ctx){
        return new BConst(ctx.boolConst().value);
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
        IConst result = new IConst(new BigInteger(ctx.getText()), -1);
        return assignToReturnRegister(register, result);
    }


    // ----------------------------------------------------------------------------------------------------------------
    // NonReturn expressions (all other return expressions are reduced to these ones)

    @Override
    public Object visitNreAtomicOp(LitmusCParser.NreAtomicOpContext ctx){
        ExprInterface value = returnExpressionOrDefault(ctx.value, BigInteger.ONE);
        Register register = programBuilder.getOrCreateRegister(scope, null, -1);
        Event event = new RMWOp(getAddress(ctx.address), register, value, ctx.op);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreStore(LitmusCParser.NreStoreContext ctx){
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        if(ctx.mo.equals("Mb")){
            Event event = new Store(getAddress(ctx.address), value, "Relaxed");
            programBuilder.addChild(currentThread, event);
            return programBuilder.addChild(currentThread, new Fence("Mb"));
        }
        Event event = new Store(getAddress(ctx.address), value, ctx.mo);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreWriteOnce(LitmusCParser.NreWriteOnceContext ctx){
        ExprInterface value = (ExprInterface)ctx.value.accept(this);
        Event event = new Store(getAddress(ctx.address), value, ctx.mo);
        return programBuilder.addChild(currentThread, event);
    }

    @Override
    public Object visitNreAssignment(LitmusCParser.NreAssignmentContext ctx){
        ExprInterface variable = (ExprInterface)ctx.varName().accept(this);
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
            Event event = new Store((IExpr) variable, value, "NA");
            return programBuilder.addChild(currentThread, event);
        }
        throw new ParsingException("Invalid syntax near " + ctx.getText());
    }

    @Override
    public Object visitNreRegDeclaration(LitmusCParser.NreRegDeclarationContext ctx){
        Register register = programBuilder.getRegister(scope, ctx.varName().getText());
        if(register == null){
            register = programBuilder.getOrCreateRegister(scope, ctx.varName().getText(), -1);
            if(ctx.re() != null){
                returnRegister = register;
                ctx.re().accept(this);
            }
            return null;
        }
        throw new ParsingException("Register " + ctx.varName().getText() + " is already initialised");
    }

    @Override
    public Object visitNreFence(LitmusCParser.NreFenceContext ctx){
        return programBuilder.addChild(currentThread, new Fence(ctx.name));
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Utils

    @Override
    public IExpr visitVarName(LitmusCParser.VarNameContext ctx){
        if(scope > -1){
            Register register = programBuilder.getRegister(scope, ctx.getText());
            if(register != null){
                return register;
            }
            Location location = programBuilder.getLocation(ctx.getText());
            if(location != null){
                register = programBuilder.getOrCreateRegister(scope, null, -1);
                programBuilder.addChild(currentThread, new Load(register, location.getAddress(), "NA"));
                return register;
            }
            return programBuilder.getOrCreateRegister(scope, ctx.getText(), -1);
        }
        Location location = programBuilder.getOrCreateLocation(ctx.getText(), -1);
        Register register = programBuilder.getOrCreateRegister(scope, null, -1);
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

    private ExprInterface returnExpressionOrDefault(LitmusCParser.ReContext ctx, BigInteger defaultValue){
        return ctx != null ? (ExprInterface)ctx.accept(this) : new IConst(defaultValue, -1);
    }

    private Register getReturnRegister(boolean createOnNull){
        Register register = returnRegister;
        if(register == null && createOnNull){
            return programBuilder.getOrCreateRegister(scope, null, -1);
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
}
