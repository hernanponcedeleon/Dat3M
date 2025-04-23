package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusAArch64BaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAArch64Parser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.arch.Xchg;
import com.dat3m.dartagnan.program.event.core.Label;
import com.dat3m.dartagnan.program.event.metadata.CustomPrinting;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder.replaceZeroRegisters;
import static com.dat3m.dartagnan.program.event.Tag.ARMv8.*;
import static com.google.common.base.Preconditions.checkArgument;

public class VisitorLitmusAArch64 extends LitmusAArch64BaseVisitor<Object> {

    private record CmpInstruction(Expression left, Expression right) {}

    private final ProgramBuilder programBuilder = ProgramBuilder.forArch(Program.SourceLanguage.LITMUS, Arch.ARM8);
    private final TypeFactory types = programBuilder.getTypeFactory();
    private final IntegerType i8 = types.getIntegerType(8);
    private final IntegerType i16 = types.getIntegerType(16);
    private final IntegerType i32 = types.getIntegerType(32);
    private final IntegerType i64 = types.getIntegerType(64);
    private final ExpressionFactory expressions = programBuilder.getExpressionFactory();
    private int mainThread;
    private int threadCount = 0;
    private final Map<Integer, CmpInstruction> lastCmpInstructionPerThread = new HashMap<>();

    public VisitorLitmusAArch64() {
    }


    // ----------------------------------------------------------------------------------------------------------------
    // Entry point

    @Override
    public Object visitMain(MainContext ctx) {
        visitThreadDeclaratorList(ctx.program().threadDeclaratorList());
        visitVariableDeclaratorList(ctx.variableDeclaratorList());
        visitInstructionList(ctx.program().instructionList());
        VisitorLitmusAssertions.parseAssertions(programBuilder, ctx.assertionList(), ctx.assertionFilter());
        Program prog = programBuilder.build();
        replaceZeroRegisters(prog, Arrays.asList("XZR", "WZR"));
        return prog;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Variable declarator list, e.g., { 0:EAX=0; 1:EAX=1; x=2; }

    @Override
    public Object visitTypedVariableDeclarator(TypedVariableDeclaratorContext ctx) {
        final int typeBytes = typeBytes(ctx.type());
        if (ctx.constant() != null) {
            final IntegerType type = types.getIntegerType(8 * typeBytes);
            programBuilder.initLocEqConst(ctx.location().getText(), parseValue(ctx.constant(), type));
        } else {
            programBuilder.newMemoryObject(ctx.location().getText(), typeBytes);
        }
        return null;
    }

    @Override
    public Object visitTypedArrayDeclarator(TypedArrayDeclaratorContext ctx) {
        final int typeBytes = typeBytes(ctx.type());
        final int arraySize = toInt(ctx.constant());
        programBuilder.newMemoryObject(ctx.location().getText(), typeBytes * arraySize);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocation(VariableDeclaratorLocationContext ctx) {
        programBuilder.initLocEqConst(ctx.location().getText(), parseValue(ctx.constant(), i64));
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegister(VariableDeclaratorRegisterContext ctx) {
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, parseValue(ctx.constant(), i64));
        return null;
    }

    @Override
    public Object visitTypedRegisterDeclarator(TypedRegisterDeclaratorContext ctx) {
        final int typeSize = typeBytes(ctx.type());
        final IntegerType type = types.getIntegerType(8 * typeSize);
        if (ctx.constant() == null) {
            programBuilder.getOrNewRegister(ctx.threadId().id, ctx.register64().id, type);
        } else {
            programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, parseValue(ctx.constant(), type));
        }
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register64().id, ctx.location().getText(), i64);
        return null;
    }

    @Override
    public Object visitVariableDeclaratorLocationLocation(VariableDeclaratorLocationLocationContext ctx) {
        programBuilder.initLocEqLocPtr(ctx.location(0).getText(), ctx.location(1).getText());
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Thread declarator list (on top of instructions), e.g. " P0  |   P1  |   P2  ;"

    @Override
    public Object visitThreadDeclaratorList(ThreadDeclaratorListContext ctx) {
        for(ThreadIdContext threadCtx : ctx.threadId()){
            programBuilder.newThread(threadCtx.id);
            threadCount++;
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instruction list (the program itself)

    @Override
    public Object visitInstructionRow(InstructionRowContext ctx) {
        for(int i = 0; i < threadCount; i++){
            mainThread = i;
            visitInstruction(ctx.instruction(i));
        }
        return null;
    }

    @Override
    public Object visitMov(MovContext ctx) {
        Register register = parseRegister64(ctx.r32, ctx.r64);
        Expression expr = parseExpression(ctx.expr32(), ctx.expr64());
        return add(EventFactory.newLocal(register, expressions.makeCast(expr, register.getType())));
    }

    @Override
    public Object visitCmp(CmpContext ctx) {
        Register register = parseRegister64(ctx.r32, ctx.r64);
        Expression expr = parseExpression(ctx.expr32(), ctx.expr64());
        lastCmpInstructionPerThread.put(mainThread, new CmpInstruction(register, expr));
        return null;
    }

    @Override
    public Object visitArithmetic(ArithmeticContext ctx) {
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final Register register = shrinkRegister(r64, ctx.rD32, false, false);
        final Register operand = parseRegister64(ctx.rV32, ctx.rV64);
        final Expression expr = parseExpression(ctx.expr32(), ctx.expr64());
        final Expression fittedOperand = expressions.makeCast(operand, expr.getType());
        final Expression result = expressions.makeIntBinary(fittedOperand, ctx.arithmeticInstruction().op, expr);
        add(EventFactory.newLocal(register, expressions.makeCast(result, register.getType())));
        addRegister64Update(r64, register);
        return null;
    }

    @Override
    public Object visitLoad(LoadContext ctx) {
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final LoadInstructionContext inst = ctx.loadInstruction();
        final Register register = shrinkRegister(r64, ctx.rD32, inst.halfWordSize, inst.byteSize);
        final Expression address = parseAddress(ctx.address());
        final String mo = inst.acquire ? MO_ACQ : MO_RX;
        add(EventFactory.newLoadWithMo(register, address, mo));
        addRegister64Update(r64, register);
        return null;
    }

    @Override
    public Object visitLoadPair(LoadPairContext ctx) {
        final boolean extended = ctx.rD064 != null;
        final Register r064 = parseRegister64(ctx.rD032, ctx.rD064);
        final Register r164 = parseRegister64(ctx.rD132, ctx.rD164);
        final Register value0 = extended ? r064 : shrinkRegister(r064, ctx.rD032, false, false);
        final Register value1 = extended ? r164 : shrinkRegister(r164, ctx.rD132, false, false);
        final Expression address0 = parseAddress(ctx.address());
        final Expression address1 = expressions.makeAdd(address0, expressions.makeValue(extended ? 8 : 4, i64));
        add(EventFactory.newLoad(value0, address0));
        add(EventFactory.newLoad(value1, address1));
        addRegister64Update(r064, value0);
        addRegister64Update(r164, value1);
        return null;
    }

    @Override
    public Object visitLoadExclusive(LoadExclusiveContext ctx) {
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final LoadExclusiveInstructionContext inst = ctx.loadExclusiveInstruction();
        final Register register = shrinkRegister(r64, ctx.rD32, inst.halfWordSize, inst.byteSize);
        final Expression address = parseAddress(ctx.address());
        final String mo = inst.acquire ? MO_ACQ : MO_RX;
        add(EventFactory.newRMWLoadExclusiveWithMo(register, address, mo));
        addRegister64Update(r64, register);
        return null;
    }

    @Override
    public Object visitStore(StoreContext ctx) {
        final Register r64 = parseRegister64(ctx.rV32, ctx.rV64);
        final StoreInstructionContext inst = ctx.storeInstruction();
        final IntegerType type = inst.byteSize ? i8 : inst.halfWordSize ? i16 : i32;
        final Expression value = ctx.rV64 != null ? r64 : expressions.makeIntegerCast(r64, type, false);
        final Expression address = parseAddress(ctx.address());
        final String mo = ctx.storeInstruction().release ? MO_REL : MO_RX;
        return add(EventFactory.newStoreWithMo(address, value, mo));
    }

    @Override
    public Object visitStorePair(StorePairContext ctx) {
        final boolean extended = ctx.r064 != null;
        final Register r64 = parseRegister64(ctx.r032, ctx.r064);
        final Register s64 = parseRegister64(ctx.r132, ctx.r164);
        final Expression value0 = extended ? r64 : expressions.makeIntegerCast(r64, i32, false);
        final Expression value1 = extended ? s64 : expressions.makeIntegerCast(s64, i32, false);
        final Expression address0 = parseAddress(ctx.address());
        final Expression address1 = expressions.makeAdd(address0, expressions.makeValue(extended ? 8 : 4, i64));
        add(EventFactory.newStore(address0, value0));
        return add(EventFactory.newStore(address1, value1));
    }

    @Override
    public Object visitStoreExclusive(StoreExclusiveContext ctx) {
        final Register r64 = parseRegister64(ctx.rV32, ctx.rV64);
        final StoreExclusiveInstructionContext inst = ctx.storeExclusiveInstruction();
        final IntegerType type = inst.byteSize ? i8 : inst.halfWordSize ? i16 : i32;
        final Expression value = ctx.rV64 != null ? r64 : expressions.makeIntegerCast(r64, type, false);
        final Register status = parseRegister64(ctx.rS32);
        final Expression address = parseAddress(ctx.address());
        final String mo = ctx.storeExclusiveInstruction().release ? MO_REL : MO_RX;
        return add(EventFactory.Common.newExclusiveStore(status, address, value, mo));
    }

    private static final CustomPrinting SWP_PRINTER = e -> {
        if (!(e instanceof Xchg xchg)) {
            return Optional.empty();
        }
        final String acq = e.hasTag(MO_ACQ) ? "A" : "";
        final String rel = e.hasTag(MO_REL) ? "L" : "";
        final Expression value = xchg.getValue();
        final Register loadReg = xchg.getResultRegister();
        final Expression address = xchg.getAddress();

        return Optional.of(String.format("SWP%s%s %s, %s, [%s]", acq, rel, value, loadReg, address));
    };

    // FIXME: SWP into a zero register (WZR or XZR) acts like a store, in particular SWPA(L) does not give
    //  acquire semantics then.
    @Override
    public Object visitSwap(SwapContext ctx) {
        final SwapInstructionContext inst = ctx.swapInstruction();
        final boolean extended = ctx.rD64 != null;
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final Register lReg = shrinkRegister(r64, ctx.rD32, inst.halfWordSize, inst.byteSize);
        final Register sReg = parseRegister64(ctx.rS32, ctx.rS64);
        final Expression value = extended ? sReg : expressions.makeCast(sReg, lReg.getType(), false);
        final Expression address = parseAddress(ctx.address());

        final List<String> mo = new ArrayList<>();
        if (inst.acquire) {
            mo.add(MO_ACQ);
        }
        if (inst.release) {
            mo.add(MO_REL);
        }

        // TODO: Can lReg and sReg match? If so, we get a problem here.
        final Xchg xchg = EventFactory.Common.newXchg(lReg, address, value);
        xchg.addTags(mo);
        xchg.setMetadata(SWP_PRINTER);

        add(xchg);
        addRegister64Update(r64, lReg);
        return null;
    }


    @Override
    public Object visitBranch(BranchContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        if(ctx.branchCondition() == null){
            return add(EventFactory.newGoto(label));
        }
        CmpInstruction cmp = lastCmpInstructionPerThread.put(mainThread, null);
        if(cmp == null){
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }
        Expression expr = expressions.makeIntCmp(cmp.left, ctx.branchCondition().op, cmp.right);
        return add(EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitBranchRegister(BranchRegisterContext ctx) {
        Register register = programBuilder.getOrErrorRegister(mainThread, ctx.rV);
        if (!(register.getType() instanceof IntegerType integerType)) {
            throw new ParsingException("Comparing non-integer register.");
        }
        IntLiteral zero = expressions.makeZero(integerType);
        Expression expr = expressions.makeIntCmp(register, ctx.branchRegInstruction().op, zero);
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        return add(EventFactory.newJump(expr, label));
    }

    @Override
    public Object visitBranchLabel(BranchLabelContext ctx) {
        return add(programBuilder.getOrCreateLabel(mainThread, ctx.label().getText()));
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        return add(EventFactory.newFenceOpt(ctx.Fence().getText(), ctx.opt));
    }

    @Override
    public Object visitReturn(ReturnContext ctx) {
        Label end = programBuilder.getEndOfThreadLabel(mainThread);
        return add(EventFactory.newGoto(end));
    }

    @Override
    public Expression visitExpressionRegister64(ExpressionRegister64Context ctx) {
        Expression expr = programBuilder.getOrNewRegister(mainThread, ctx.register64().id, i64);
        if(ctx.shift() != null){
            IntLiteral val = parseValue(ctx.shift().immediate().constant(), i64);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionRegister32(ExpressionRegister32Context ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.register32().id, i64);
        final Expression expr = expressions.makeIntExtract(r64, 0, 31);
        if (ctx.shift() == null) {
            return expr;
        }
        final IntLiteral val = parseValue(ctx.shift().immediate().constant(), i64);
        return expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
    }

    @Override
    public Expression visitExpressionImmediate(ExpressionImmediateContext ctx) {
        Expression expr = parseValue(ctx.immediate().constant(), i64);
        if(ctx.shift() != null){
            IntLiteral val = parseValue(ctx.shift().immediate().constant(), i64);
            expr = expressions.makeIntBinary(expr, ctx.shift().shiftOperator().op, val);
        }
        return expr;
    }

    @Override
    public Expression visitExpressionConversion(ExpressionConversionContext ctx) {
        final Register r64 = programBuilder.getOrNewRegister(mainThread, ctx.register32().id, i64);
        return expressions.makeIntegerCast(expressions.makeIntExtract(r64, 0, 31), i64, ctx.signed);
    }

    @Override
    public Expression visitImmediate(ImmediateContext ctx) {
        final int radix = ctx.Hexa() != null ? 16 : 10;
        BigInteger value = new BigInteger(ctx.constant().getText(), radix);
        return expressions.makeValue(value, i64);
    }

    private Expression parseExpression(Expr32Context x32, Expr64Context x64) {
        return (Expression) (x32 != null ? x32 : x64).accept(this);
    }

    private Expression parseAddress(AddressContext ctx) {
        final Register base = programBuilder.getOrErrorRegister(mainThread, ctx.register64().id);
        if (ctx.offset() == null) {
            return base;
        }
        final ExpressionConversionContext conversion = ctx.offset().expressionConversion();
        final Register32Context register32 = conversion == null ? null : conversion.register32();
        final Register64Context register64 = ctx.offset().register64();
        final ImmediateContext imm = ctx.offset().immediate();
        final Expression offset = imm == null ? parseRegister64(register32, register64) : parseValue(imm.constant(), i64);
        return expressions.makeAdd(base, offset);
    }

    private Register parseRegister64(Register32Context w) {
        return programBuilder.getOrNewRegister(mainThread, w.id, i64);
    }

    private Register parseRegister64(Register64Context x) {
        return programBuilder.getOrNewRegister(mainThread, x.id, i64);
    }

    private Register parseRegister64(Register32Context w, Register64Context x) {
        checkArgument((w == null) != (x == null), "Expected exactly one register, got [%s, %s]", w, x);
        return w == null ? parseRegister64(x) : parseRegister64(w);
    }

    private int toInt(ConstantContext ctx) {
        final int radix = ctx.hex == null ? 10 : 16;
        final TerminalNode node = ctx.hex == null ? ctx.DigitSequence() : ctx.HexDigitSequence();
        return Integer.parseInt(node.getText(), radix);
    }

    private int typeBytes(TypeContext ignore) {
        //defaults to 64 bits
        return 8;
    }

    private IntLiteral parseValue(ConstantContext ctx, IntegerType type) {
        if (ctx.hex != null) {
            return expressions.makeValue(new BigInteger(ctx.hex.getText().substring(2), 16), type);
        }
        return expressions.parseValue(ctx.getText(), type);
    }

    private Register shrinkRegister(Register other, Register32Context ctx, boolean halfWordSize, boolean byteSize) {
        checkArgument(other.getType().equals(i64), "Non-64-bit %s", other);
        checkArgument(!byteSize | !halfWordSize, "Inconclusive access size");
        if (byteSize) {
            return programBuilder.getOrNewRegister(mainThread, "B" + other.getName().substring(1), i8);
        }
        if (halfWordSize) {
            return programBuilder.getOrNewRegister(mainThread, "H" + other.getName().substring(1), i16);
        }
        return ctx == null ? other : programBuilder.getOrNewRegister(mainThread, ctx.getText(), i32);
    }

    private void addRegister64Update(Register r64, Register value) {
        checkArgument(r64.getType().equals(i64), "Unexpectedly-typed register %s", r64);
        if (r64 != value) {
            add(EventFactory.newLocal(r64, expressions.makeIntegerCast(value, i64, false)));
        }
    }

    private Void add(Event event) {
        programBuilder.addChild(mainThread, event);
        return null;
    }
}
