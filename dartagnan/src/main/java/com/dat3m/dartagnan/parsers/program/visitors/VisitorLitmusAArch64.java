package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
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
import com.dat3m.dartagnan.program.event.MemoryEvent;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.base.Preconditions;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder.replaceZeroRegisters;
import static com.dat3m.dartagnan.program.event.EventFactory.AArch64.MemoryOrder.*;
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

        final List<String> zeroRegs = Arrays.asList("XZR", "WZR");
        markLoadsIntoZeroRegisters(prog, zeroRegs);
        replaceZeroRegisters(prog, zeroRegs);
        return prog;
    }

    private void markLoadsIntoZeroRegisters(Program prog, List<String> zeroRegs) {
        for (MemoryEvent memEvent : prog.getThreadEvents(MemoryEvent.class)) {
            if (memEvent instanceof RegWriter writer && zeroRegs.contains(writer.getResultRegister().getName())) {
                memEvent.addTags(NO_RET);
                memEvent.removeTags(MO_ACQ, MO_ACQ_PC);
            }
        }
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
        programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, parseValue(ctx.constant(), i64), ctx.getStart().getLine());
        return null;
    }

    @Override
    public Object visitTypedRegisterDeclarator(TypedRegisterDeclaratorContext ctx) {
        final int typeSize = typeBytes(ctx.type());
        final IntegerType type = types.getIntegerType(8 * typeSize);
        if (ctx.constant() == null) {
            programBuilder.getOrNewRegister(ctx.threadId().id, ctx.register64().id, type);
        } else {
            programBuilder.initRegEqConst(ctx.threadId().id, ctx.register64().id, parseValue(ctx.constant(), type), ctx.getStart().getLine());
        }
        return null;
    }

    @Override
    public Object visitVariableDeclaratorRegisterLocation(VariableDeclaratorRegisterLocationContext ctx) {
        programBuilder.initRegEqLocPtr(ctx.threadId().id, ctx.register64().id, ctx.location().getText(), i64, ctx.getStart().getLine());
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
        final Register r64 = parseRegister64(ctx.r32, ctx.r64);
        final Expression expr = parseExpression(ctx.expr32(), ctx.expr64());
        return append(EventFactory.newLocal(r64, expressions.makeIntegerCast(expr, i64, false)), ctx);
    }

    @Override
    public Object visitCmp(CmpContext ctx) {
        final Register r64 = parseRegister64(ctx.r32, ctx.r64);
        final Expression comparator = parseExpression(ctx.expr32(), ctx.expr64());
        final IntegerType type = ctx.r64 != null ? i64 : i32;
        final Expression left = expressions.makeIntegerCast(r64, type, false);
        final Expression right = expressions.makeIntegerCast(comparator, type, true);
        lastCmpInstructionPerThread.put(mainThread, new CmpInstruction(left, right));
        return null;
    }

    @Override
    public Object visitArithmetic(ArithmeticContext ctx) {
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final Register operand = parseRegister64(ctx.rV32, ctx.rV64);
        final Expression expr = parseExpression(ctx.expr32(), ctx.expr64());
        final IntegerType type = ctx.rD64 != null ? i64 : i32;
        final Expression left = expressions.makeIntegerCast(operand, type, false);
        final Expression right = expressions.makeIntegerCast(expr, type, false);
        final Expression result = expressions.makeIntBinary(left, ctx.arithmeticInstruction().op, right);
        return append(EventFactory.newLocal(r64, expressions.makeIntegerCast(result, i64, false)), ctx);
    }

    @Override
    public Object visitLoad(LoadContext ctx) {
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final LoadInstructionContext inst = ctx.loadInstruction();
        final Register register = shrinkRegister(r64, ctx.rD32, inst.halfWordSize, inst.byteSize);
        final Expression address = parseAddress(ctx.address());
        final Event ld = EventFactory.AArch64.newLoad(register, address, inst.acquire ? ACQUIRE : PLAIN);
        return appendAndRegister64Update(ld, r64, register, ctx);
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
        final int lineOfCode = ctx.getStart().getLine();
        add(EventFactory.AArch64.newLoad(value0, address0, PLAIN), lineOfCode);
        add(EventFactory.AArch64.newLoad(value1, address1, PLAIN), lineOfCode);
        addRegister64Update(r064, value0, lineOfCode);
        addRegister64Update(r164, value1, lineOfCode);
        return null;
    }

    @Override
    public Object visitLoadExclusive(LoadExclusiveContext ctx) {
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final LoadExclusiveInstructionContext inst = ctx.loadExclusiveInstruction();
        final Register register = shrinkRegister(r64, ctx.rD32, inst.halfWordSize, inst.byteSize);
        final Expression address = parseAddress(ctx.address());
        final Event ldx = EventFactory.AArch64.newLoadExclusive(register, address, inst.acquire ? ACQUIRE : PLAIN);
        return appendAndRegister64Update(ldx, r64, register, ctx);
    }

    @Override
    public Object visitStore(StoreContext ctx) {
        final Register r64 = parseRegister64(ctx.rV32, ctx.rV64);
        final StoreInstructionContext inst = ctx.storeInstruction();
        final IntegerType type = type(ctx.rV32, inst.halfWordSize, inst.byteSize);
        final Expression value = expressions.makeIntegerCast(r64, type, false);
        final Expression address = parseAddress(ctx.address());
        return append(EventFactory.AArch64.newStore(address, value, inst.release ? RELEASE : PLAIN), ctx);
    }

    @Override
    public Object visitStorePair(StorePairContext ctx) {
        final boolean extended = ctx.r064 != null;
        final Register r64 = parseRegister64(ctx.r032, ctx.r064);
        final Register s64 = parseRegister64(ctx.r132, ctx.r164);
        final IntegerType type = extended ? i64 : i32;
        final Expression value0 = expressions.makeIntegerCast(r64, type, false);
        final Expression value1 = expressions.makeIntegerCast(s64, type, false);
        final Expression address0 = parseAddress(ctx.address());
        final Expression address1 = expressions.makeAdd(address0, expressions.makeValue(extended ? 8 : 4, i64));
        final int lineOfCode = ctx.getStart().getLine();
        add(EventFactory.newStore(address0, value0), lineOfCode);
        return add(EventFactory.newStore(address1, value1), lineOfCode);
    }

    @Override
    public Object visitStoreExclusive(StoreExclusiveContext ctx) {
        final Register r64 = parseRegister64(ctx.rV32, ctx.rV64);
        final StoreExclusiveInstructionContext inst = ctx.storeExclusiveInstruction();
        final IntegerType type = type(ctx.rV32, inst.halfWordSize, inst.byteSize);
        final Expression value = expressions.makeIntegerCast(r64, type, false);
        final Register status = parseRegister64(ctx.rS32);
        final Expression address = parseAddress(ctx.address());
        return append(EventFactory.AArch64.newStoreExclusive(status, address, value, inst.release ? RELEASE : PLAIN), ctx);
    }

    @Override
    public Object visitSwap(SwapContext ctx) {
        final SwapInstructionContext inst = ctx.swapInstruction();
        final boolean extended = ctx.rD64 != null;
        final Register r64 = parseRegister64(ctx.rD32, ctx.rD64);
        final Register lReg = shrinkRegister(r64, ctx.rD32, inst.halfWordSize, inst.byteSize);
        final Register sReg = parseRegister64(ctx.rS32, ctx.rS64);
        final Expression value = extended ? sReg : expressions.makeCast(sReg, lReg.getType(), false);
        final Expression address = parseAddress(ctx.address());

        final Event xchg = EventFactory.AArch64.newSwap(lReg, address, value, mo(inst.acquire, inst.release));

        return appendAndRegister64Update(xchg, r64, lReg, ctx);
    }

    @Override
    public Object visitCas(CasContext ctx) {
        final CasInstructionContext inst = ctx.casInstruction();

        final Register rs64 = parseRegister64(ctx.rS32, ctx.rS64);
        final Register rt64 = parseRegister64(ctx.rT32, ctx.rT64);

        final Register rs = shrinkRegister(rs64, ctx.rS32, inst.halfWordSize, inst.byteSize);
        final Expression cmpVal = expressions.makeCast(rs64, rs.getType(), false);
        final Expression val = expressions.makeCast(rt64, rs.getType(), false);
        final Expression address = parseAddress(ctx.address());

        final Event cas = EventFactory.AArch64.newCas(rs, address, cmpVal, val, mo(inst.acquire, inst.release));
        return appendAndRegister64Update(cas, rs64, rs, ctx);
    }

    record LDSTAmoInfo(IntBinaryOp op, boolean isHalfSize, boolean isByteSize, EventFactory.AArch64.MemoryOrder mo) {}

    // Used for LDXXX and STXXX instructions of shape
    // ST/LD - XXX/XXXX - {A, L, AL}?  - {H, B}?
    // Instr - op code  - memory order - access size
    private LDSTAmoInfo getLDSTInfoFromInstructionName(String instrName) {
        Preconditions.checkArgument(instrName.startsWith("LD") || instrName.startsWith("ST"));
        String instr = instrName.substring(2); // Skip LD/ST

        // TODO: Maybe the following logic can be implemented in the grammar without
        //  an explicit case distinction over all 96 (or more?) variants of LD (and ST)

        // Access size
        final boolean isHalfSize = instr.endsWith("H");
        final boolean isByteSize = instr.endsWith("B");
        if (isHalfSize || isByteSize) {
            instr = instr.substring(0, instr.length() - 1);
        }

        // Memory order
        final boolean release = instr.endsWith("L");
        if (release) {
            instr = instr.substring(0, instr.length() - 1);
        }
        final boolean acquire = instr.endsWith("A");
        if (acquire) {
            instr = instr.substring(0, instr.length() - 1);
        }

        // Only OpCode remains
        assert 3 <= instr.length() && instr.length() <= 4;
        // Operation
        final String opCode = instr;
        final IntBinaryOp op = switch (opCode) {
            case "ADD" -> IntBinaryOp.ADD;
            case "EOR" -> IntBinaryOp.XOR;
            case "SET" -> IntBinaryOp.OR;
            case "CLR" -> IntBinaryOp.AND; // Actually & with complement!!!
            case "SMIN" -> IntBinaryOp.SMIN;
            case "SMAX" -> IntBinaryOp.SMAX;
            case "UMIN" -> IntBinaryOp.UMIN;
            case "UMAX" -> IntBinaryOp.UMAX;
            default -> throw new ParsingException("Invalid op " + opCode + " found in " + instrName);
        };

        return new LDSTAmoInfo(op, isHalfSize, isByteSize, mo(acquire, release));
    }

    @Override
    public Object visitLoadOp(LoadOpContext ctx) {
        final String instr = ctx.loadOpInstruction().getText();
        final LDSTAmoInfo info = getLDSTInfoFromInstructionName(instr);

        final Register rs64 = parseRegister64(ctx.rS32, ctx.rS64);
        final Register rt64 = parseRegister64(ctx.rD32, ctx.rD64);
        final Register rt = shrinkRegister(rt64, ctx.rD32, info.isHalfSize, info.isByteSize);
        Expression operand = expressions.makeCast(rs64, rt.getType(), false);
        if (info.op == IntBinaryOp.AND) {
            // This was a CLR instruction
            operand = expressions.makeIntNot(operand);
        }

        final Expression address = parseAddress(ctx.address());
        final Event ldOp = EventFactory.AArch64.newLoadOp(rt, address, info.op, operand, info.mo);
        return appendAndRegister64Update(ldOp, rt64, rt, ctx);
    }

    @Override
    public Object visitStoreOp(StoreOpContext ctx) {
        final String instr = ctx.storeOpInstruction().getText();
        final LDSTAmoInfo info = getLDSTInfoFromInstructionName(instr);

        final Register rs64 = parseRegister64(ctx.rS32, ctx.rS64);
        final IntegerType type = type(ctx.rS32, info.isHalfSize, info.isByteSize);
        Expression operand = expressions.makeCast(rs64, type, false);
        if (info.op == IntBinaryOp.AND) {
            // This was a CLR instruction
            operand = expressions.makeIntNot(operand);
        }

        final Expression address = parseAddress(ctx.address());
        final Event stOp = EventFactory.AArch64.newStoreOp(address, info.op, operand, info.mo);
        return append(stOp, ctx);
    }

    @Override
    public Object visitBranch(BranchContext ctx) {
        Label label = programBuilder.getOrCreateLabel(mainThread, ctx.label().getText());
        if(ctx.branchCondition() == null){
            return append(EventFactory.newGoto(label), ctx);
        }
        CmpInstruction cmp = lastCmpInstructionPerThread.put(mainThread, null);
        if(cmp == null){
            throw new ParsingException("Invalid syntax near " + ctx.getText());
        }
        Expression expr = expressions.makeIntCmp(cmp.left, ctx.branchCondition().op, cmp.right);
        return append(EventFactory.newJump(expr, label), ctx);
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
        return append(EventFactory.newJump(expr, label), ctx);
    }

    @Override
    public Object visitBranchLabel(BranchLabelContext ctx) {
        return append(programBuilder.getOrCreateLabel(mainThread, ctx.label().getText()), ctx);
    }

    @Override
    public Object visitFence(FenceContext ctx) {
        return append(EventFactory.AArch64.newBarrier(ctx.Fence().getText(), ctx.opt), ctx);
    }

    @Override
    public Object visitReturn(ReturnContext ctx) {
        Label end = programBuilder.getEndOfThreadLabel(mainThread);
        return append(EventFactory.newGoto(end), ctx);
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

    private Register shrinkRegister(Register r64, Register32Context ctx, boolean halfWordSize, boolean byteSize) {
        checkArgument(r64.getType().equals(i64), "Non-64-bit %s", r64);
        checkArgument(!byteSize | !halfWordSize, "Inconclusive access size");
        if (byteSize) {
            return programBuilder.getOrNewRegister(mainThread, "B" + r64.getName().substring(1), i8);
        } else if (halfWordSize) {
            return programBuilder.getOrNewRegister(mainThread, "H" + r64.getName().substring(1), i16);
        } else if (ctx != null) {
            return programBuilder.getOrNewRegister(mainThread, "W" + r64.getName().substring(1), i32);
        } else {
            return r64;
        }
    }

    private IntegerType type(Register32Context ctx, boolean halfWordSize, boolean byteSize) {
        return byteSize ? i8 : halfWordSize ? i16 : ctx != null ? i32 : i64;
    }

    private EventFactory.AArch64.MemoryOrder mo(boolean acq, boolean rel) {
        return acq ? rel ? ACQ_REL : ACQUIRE : rel ? RELEASE : PLAIN;
    }

    private Void append(Event event, ParserRuleContext ctx) {
        return add(event, ctx.getStart().getLine());
    }

    private Void appendAndRegister64Update(Event event, Register r64, Register value, ParserRuleContext ctx) {
        final int lineOfCode = ctx.getStart().getLine();
        add(event, lineOfCode);
        addRegister64Update(r64, value, lineOfCode);
        return null;
    }

    private void addRegister64Update(Register r64, Register value, int lineOfCode) {
        checkArgument(r64.getType().equals(i64), "Unexpectedly-typed register %s", r64);
        if (r64 != value) {
            add(EventFactory.newLocal(r64, expressions.makeIntegerCast(value, i64, false)), lineOfCode);
        }
    }

    private Void add(Event event, int lineOfCode) {
        programBuilder.addChild(mainThread, event, lineOfCode);
        return null;
    }
}
