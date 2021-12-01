package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.expression.Atom;
import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.expression.IExprBin;
import com.dat3m.dartagnan.expression.op.COpBin;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.parsers.LitmusLISABaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusLISAParser;
import com.dat3m.dartagnan.parsers.LitmusLISAVisitor;
import com.dat3m.dartagnan.parsers.program.utils.AssertionHelper;
import com.dat3m.dartagnan.parsers.program.utils.ParsingException;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.EventFactory;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Fence;
import com.dat3m.dartagnan.program.event.Label;
import com.dat3m.dartagnan.program.memory.Location;
import org.antlr.v4.runtime.misc.Interval;
import static com.dat3m.dartagnan.program.arch.linux.utils.EType.*;
import static com.dat3m.dartagnan.program.arch.linux.utils.Mo.*;

import java.math.BigInteger;

public class VisitorLitmusLISA
        extends LitmusLISABaseVisitor<Object>
        implements LitmusLISAVisitor<Object> {

    private final ProgramBuilder programBuilder;
    private int mainThread;
    private int threadCount = 0;

    public VisitorLitmusLISA(ProgramBuilder pb){
        this.programBuilder = pb;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(LitmusLISAParser.MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
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
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitVariableDeclaratorLocation(LitmusLISAParser.VariableDeclaratorLocationContext ctx) {
        programBuilder.initLocEqConst(ctx.location().getText(), new IConst(new BigInteger(ctx.constant().getText()), -1));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(LitmusLISAParser.VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register().getText(), new IConst(new BigInteger(ctx.constant().getText()), -1));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(LitmusLISAParser.VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register().getText(), ctx.location().getText(), -1);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(LitmusLISAParser.VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText(), -1);
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(LitmusLISAParser.ThreadDeclaratorListContext ctx) {
        for(LitmusLISAParser.ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.initThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(LitmusLISAParser.InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

	@Override
	public Object visitLoad(LitmusLISAParser.LoadContext ctx) {
        Register reg = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), -1);
        Location loc = programBuilder.getOrCreateLocation(ctx.location().getText(), -1);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "NA";
        switch(mo) {
        	case "acquire":
        		mo = ACQUIRE;
        		break;
        	case "deref":
        		mo = RELAXED;
        		break;
        	case "once":
        		mo = "Once";
        		break;
        	default:
        		throw new ParsingException(String.format("Store ordering %s not recognized", mo));
        }
        return programBuilder.addChild(mainThread, EventFactory.newLoad(reg, loc.getAddress(), mo));
	}

	@Override
	public Object visitLocal(LitmusLISAParser.LocalContext ctx) {
        Register reg = programBuilder.getOrCreateRegister(mainThread, ctx.register().getText(), -1);
		ExprInterface e = (ExprInterface) ctx.expression().accept(this);
        return programBuilder.addChild(mainThread, EventFactory.newLocal(reg, e));
	}

	@Override
	public Object visitStore(LitmusLISAParser.StoreContext ctx) {
		IExpr value = (IExpr) ctx.value().accept(this);
        Location loc = programBuilder.getOrCreateLocation(ctx.location().getText(), -1);
        String mo = ctx.mo() != null ? ctx.mo().getText() : "NA";
        switch(mo) {
        	case "release":
        	case "assign":
        		mo = RELEASE;
        		break;
        	case "once":
        		mo = "Once";
        		break;
        	default:
        		throw new ParsingException(String.format("Store ordering %s not recognized", mo));
        }
        return programBuilder.addChild(mainThread, EventFactory.newStore(loc.getAddress(), value, mo));
	}
	
	@Override
	public Object visitFence(LitmusLISAParser.FenceContext ctx) {
        String name = ctx.mofence().getText();
		Fence child = EventFactory.newFence(name);
		switch(name) {
			case "mb":
				child = EventFactory.Linux.newMemoryBarrier();
				break;
			case "rcu_read_lock":
				child = EventFactory.newFence(RCU_LOCK);
				break;
			case "rcu_read_unlock":
				child = EventFactory.newFence(RCU_UNLOCK);
				break;
			case "sync":
				child = EventFactory.newFence(RCU_SYNC);
				break;
			default:
				throw new ParsingException(String.format("Fence %s not recognized", name));
		}
        return programBuilder.addChild(mainThread, child);
	}
	
	@Override
	public Object visitLabel(LitmusLISAParser.LabelContext ctx) {
		String name = ctx.getText();
        Label label = programBuilder.getOrCreateLabel(name.substring(0, name.length()-1));
		return programBuilder.addChild(mainThread, label);
	}

	@Override
	public Object visitJump(LitmusLISAParser.JumpContext ctx) {
        Label label = programBuilder.getOrCreateLabel(ctx.Label().getText());
        Register reg = (Register) ctx.register().accept(this);
        // TODO check if this is the semantics
        Atom cond = new Atom(reg, COpBin.EQ, IConst.ZERO);
		return programBuilder.addChild(mainThread, EventFactory.newJump(cond, label));
	}

	// Other
	
	@Override
	public Object visitRegister(LitmusLISAParser.RegisterContext ctx) {
		return programBuilder.getOrCreateRegister(mainThread, ctx.getText(), -1);
	}

	@Override
	public Object visitConstant(LitmusLISAParser.ConstantContext ctx) {
		return new IConst(ctx.getText(), -1);
	}

	@Override
	public Object visitAdd(LitmusLISAParser.AddContext ctx) {
		ExprInterface e1 = (ExprInterface) ctx.expression(0).accept(this);
		ExprInterface e2 = (ExprInterface) ctx.expression(1).accept(this);
		return new IExprBin(e1, IOpBin.PLUS, e2);
	}

	@Override
	public Object visitXor(LitmusLISAParser.XorContext ctx) {
		ExprInterface e1 = (ExprInterface) ctx.expression(0).accept(this);
		ExprInterface e2 = (ExprInterface) ctx.expression(1).accept(this);
		return new IExprBin(e1, IOpBin.XOR, e2);
	}

	@Override
	public Object visitEq(LitmusLISAParser.EqContext ctx) {
		ExprInterface e1 = (ExprInterface) ctx.expression(0).accept(this);
		ExprInterface e2 = (ExprInterface) ctx.expression(1).accept(this);
		return new Atom(e1, COpBin.EQ, e2);
	}

	@Override
	public Object visitNeq(LitmusLISAParser.NeqContext ctx) {
		ExprInterface e1 = (ExprInterface) ctx.expression(0).accept(this);
		ExprInterface e2 = (ExprInterface) ctx.expression(1).accept(this);
		return new Atom(e1, COpBin.EQ, e2);
	}
}
