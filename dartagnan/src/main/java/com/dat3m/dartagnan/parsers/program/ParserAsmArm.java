package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.AsmArmParser;
import com.dat3m.dartagnan.parsers.AsmArmParser.*;
import com.dat3m.dartagnan.parsers.AsmArmBaseVisitor;
import com.dat3m.dartagnan.parsers.AsmArmLexer;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.RegWriter;
import com.dat3m.dartagnan.program.event.core.Label;
import com.google.common.collect.ImmutableSet;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.*;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.AArch64.MemoryOrder.*;
import static com.dat3m.dartagnan.program.event.Tag.ARMv8.*;

public class ParserAsmArm extends ParserAsm {

    private DirectiveContext instruction;
    private IntegerType typeHint = i64;
    private Comparison comparison;
    private final List<Event> postInstructionEvents = new ArrayList<>();

    public ParserAsmArm(Function llvmFunction) {
        super(llvmFunction);
    }

    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException, UnsupportedOperationException {
        final var lexer = new AsmArmLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        final var tokenStream = new CommonTokenStream(lexer);
        final var parser = new AsmArmParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        parseLines(parser.lines());
        markLoadsIntoZeroRegisters();
        return events;
    }

    @Override
    public Register formatLlvmRegister(int index, char constraintCode) {
        return function.getOrNewRegister("X" + index, i64);
    }

    @Override
    public String formatArgument(int index, char constraintCode, String modifier) {
        final String prefix = switch (modifier) {
            case "", "x" -> "X";
            case "w" -> "W";
            default -> parsingException("Unknown modifier ${%d:%s}", index, modifier);
        };
        return switch (constraintCode) {
            case 'm', 'Q' -> "[" + prefix + index + "]";
            case 'r' -> prefix + index;
            default -> parsingException("Unknown constraint code '%s'", constraintCode);
        };
    }

    private void parseLines(LinesContext lines) {
        for (LineContext line : lines.line()) {
            appendLabel(line.Label());
            handleInstruction(line.directive());
        }
        validate();
    }

    private void markLoadsIntoZeroRegisters() {
        final Set<Register> zeroRegisters = Stream.of("XZR", "WZR", "HZR", "BZR")
                .map(function::getRegister)
                .filter(Objects::nonNull)
                .collect(ImmutableSet.toImmutableSet());
        for (Event memEvent : events) {
            if (memEvent instanceof RegWriter writer && zeroRegisters.contains(writer.getResultRegister())) {
                memEvent.addTags(NO_RET);
                memEvent.removeTags(MO_ACQ, MO_ACQ_PC);
            }
        }
    }

    private void handleInstruction(DirectiveContext directive) {
        if (directive == null) {
            return;
        }
        instruction = directive;
        final String mnemonic = directive.mnemonic.getText().toLowerCase();
        final boolean b = mnemonic.endsWith("b");
        final boolean h = mnemonic.endsWith("h");
        typeHint = b ? i8 : h ? i16 : anyWordOperand() ? i32 : i64;
        final String stem = b || h ? mnemonic.substring(0, mnemonic.length() - 1) : mnemonic;
        switch (stem) {
            case "mov" -> visitMov();
            case "cmp" -> visitCmp();
            //TODO adds, subs, adc, adcs, sbc, sbcs, bic, orn, eon
            case "add" -> visitOp(IntBinaryOp.ADD);
            case "su", "sub" -> {
                typeHint = stem.equals("su") ? anyWordOperand() ? i32 : i64 : typeHint;
                visitOp(IntBinaryOp.SUB);
            }
            case "and" -> visitOp(IntBinaryOp.AND);
            case "orr" -> visitOp(IntBinaryOp.OR);
            case "eor" -> visitOp(IntBinaryOp.XOR);
            case "" -> visitB();
            //TODO cs,hs,cc,lo,mi,pl,vs,vc,hi,ls,al
            case "b.eq" -> visitB(IntCmpOp.EQ);
            case "b.ne" -> visitB(IntCmpOp.NEQ);
            case "b.ge" -> visitB(IntCmpOp.GTE);
            case "b.le" -> visitB(IntCmpOp.LTE);
            case "b.gt" -> visitB(IntCmpOp.GT);
            case "b.lt" -> visitB(IntCmpOp.LT);
            case "cbz" -> visitCbz(false);
            case "cbnz" -> visitCbz(true);
            case "ret" -> visitRet();
            case "nop" -> visitNop();
            case "ldr" -> visitLdr(PLAIN);
            case "ldar" -> visitLdr(ACQUIRE);
            case "ldxr", "ldrex" -> visitLdx(PLAIN);
            case "ldaxr" -> visitLdx(ACQUIRE);
            case "ldp" -> visitLdp();
            case "ldadd" -> visitLdop(IntBinaryOp.ADD, PLAIN);
            case "ldadda" -> visitLdop(IntBinaryOp.ADD, ACQUIRE);
            case "ldaddl" -> visitLdop(IntBinaryOp.ADD, RELEASE);
            case "ldaddal" -> visitLdop(IntBinaryOp.ADD, ACQ_REL);
            case "ldset" -> visitLdop(IntBinaryOp.OR, PLAIN);
            case "ldseta" -> visitLdop(IntBinaryOp.OR, ACQUIRE);
            case "ldsetl" -> visitLdop(IntBinaryOp.OR, RELEASE);
            case "ldsetal" -> visitLdop(IntBinaryOp.OR, ACQ_REL);
            case "ldclr" -> visitLdop(IntBinaryOp.AND, PLAIN);
            case "ldclra" -> visitLdop(IntBinaryOp.AND, ACQUIRE);
            case "ldclrl" -> visitLdop(IntBinaryOp.AND, RELEASE);
            case "ldclral" -> visitLdop(IntBinaryOp.AND, ACQ_REL);
            case "ldeor" -> visitLdop(IntBinaryOp.XOR, PLAIN);
            case "ldeora" -> visitLdop(IntBinaryOp.XOR, ACQUIRE);
            case "ldeorl" -> visitLdop(IntBinaryOp.XOR, RELEASE);
            case "ldeoral" -> visitLdop(IntBinaryOp.XOR, ACQ_REL);
            case "ldsub" -> visitLdop(IntBinaryOp.SUB, PLAIN);
            case "ldsuba" -> visitLdop(IntBinaryOp.SUB, ACQUIRE);
            case "ldsubl" -> visitLdop(IntBinaryOp.SUB, RELEASE);
            case "ldsubal" -> visitLdop(IntBinaryOp.SUB, ACQ_REL);
            case "ldsmax" -> visitLdop(IntBinaryOp.SMAX, PLAIN);
            case "ldsmaxa" -> visitLdop(IntBinaryOp.SMAX, ACQUIRE);
            case "ldsmaxl" -> visitLdop(IntBinaryOp.SMAX, RELEASE);
            case "ldsmaxal" -> visitLdop(IntBinaryOp.SMAX, ACQ_REL);
            case "ldsmin" -> visitLdop(IntBinaryOp.SMIN, PLAIN);
            case "ldsmina" -> visitLdop(IntBinaryOp.SMIN, ACQUIRE);
            case "ldsminl" -> visitLdop(IntBinaryOp.SMIN, RELEASE);
            case "ldsminal" -> visitLdop(IntBinaryOp.SMIN, ACQ_REL);
            case "ldumax" -> visitLdop(IntBinaryOp.UMAX, PLAIN);
            case "ldumaxa" -> visitLdop(IntBinaryOp.UMAX, ACQUIRE);
            case "ldumaxl" -> visitLdop(IntBinaryOp.UMAX, RELEASE);
            case "ldumaxal" -> visitLdop(IntBinaryOp.UMAX, ACQ_REL);
            case "ldumin" -> visitLdop(IntBinaryOp.UMIN, PLAIN);
            case "ldumina" -> visitLdop(IntBinaryOp.UMIN, ACQUIRE);
            case "lduminl" -> visitLdop(IntBinaryOp.UMIN, RELEASE);
            case "lduminal" -> visitLdop(IntBinaryOp.UMIN, ACQ_REL);
            case "str" -> visitStr(PLAIN);
            case "stlr" -> visitStr(RELEASE);
            case "stxr", "strex" -> visitStx(PLAIN);
            case "stlxr" -> visitStx(RELEASE);
            case "stp" -> visitStp();
            case "stadd" -> visitStop(IntBinaryOp.ADD, PLAIN);
            case "stadda" -> visitStop(IntBinaryOp.ADD, ACQUIRE);
            case "staddl" -> visitStop(IntBinaryOp.ADD, RELEASE);
            case "staddal" -> visitStop(IntBinaryOp.ADD, ACQ_REL);
            case "stset" -> visitStop(IntBinaryOp.OR, PLAIN);
            case "stseta" -> visitStop(IntBinaryOp.OR, ACQUIRE);
            case "stsetl" -> visitStop(IntBinaryOp.OR, RELEASE);
            case "stsetal" -> visitStop(IntBinaryOp.OR, ACQ_REL);
            case "stclr" -> visitStop(IntBinaryOp.AND, PLAIN);
            case "stclra" -> visitStop(IntBinaryOp.AND, ACQUIRE);
            case "stclrl" -> visitStop(IntBinaryOp.AND, RELEASE);
            case "stclral" -> visitStop(IntBinaryOp.AND, ACQ_REL);
            case "steor" -> visitStop(IntBinaryOp.XOR, PLAIN);
            case "steora" -> visitStop(IntBinaryOp.XOR, ACQUIRE);
            case "steorl" -> visitStop(IntBinaryOp.XOR, RELEASE);
            case "steoral" -> visitStop(IntBinaryOp.XOR, ACQ_REL);
            case "stsub" -> visitStop(IntBinaryOp.SUB, PLAIN);
            case "stsuba" -> visitStop(IntBinaryOp.SUB, ACQUIRE);
            case "stsubl" -> visitStop(IntBinaryOp.SUB, RELEASE);
            case "stsubal" -> visitStop(IntBinaryOp.SUB, ACQ_REL);
            case "stsmax" -> visitStop(IntBinaryOp.SMAX, PLAIN);
            case "stsmaxa" -> visitStop(IntBinaryOp.SMAX, ACQUIRE);
            case "stsmaxl" -> visitStop(IntBinaryOp.SMAX, RELEASE);
            case "stsmaxal" -> visitStop(IntBinaryOp.SMAX, ACQ_REL);
            case "stsmin" -> visitStop(IntBinaryOp.SMIN, PLAIN);
            case "stsmina" -> visitStop(IntBinaryOp.SMIN, ACQUIRE);
            case "stsminl" -> visitStop(IntBinaryOp.SMIN, RELEASE);
            case "stsminal" -> visitStop(IntBinaryOp.SMIN, ACQ_REL);
            case "stumax" -> visitStop(IntBinaryOp.UMAX, PLAIN);
            case "stumaxa" -> visitStop(IntBinaryOp.UMAX, ACQUIRE);
            case "stumaxl" -> visitStop(IntBinaryOp.UMAX, RELEASE);
            case "stumaxal" -> visitStop(IntBinaryOp.UMAX, ACQ_REL);
            case "stumin" -> visitStop(IntBinaryOp.UMIN, PLAIN);
            case "stumina" -> visitStop(IntBinaryOp.UMIN, ACQUIRE);
            case "stuminl" -> visitStop(IntBinaryOp.UMIN, RELEASE);
            case "stuminal" -> visitStop(IntBinaryOp.UMIN, ACQ_REL);
            case "swp" -> visitSwp(PLAIN);
            case "swpa" -> visitSwp(ACQUIRE);
            case "swpl" -> visitSwp(RELEASE);
            case "swpal" -> visitSwp(ACQ_REL);
            case "cas" -> visitCas(PLAIN);
            case "casa" -> visitCas(ACQUIRE);
            case "casl" -> visitCas(RELEASE);
            case "casal" -> visitCas(ACQ_REL);
            case "dm" -> visitBarrier("DMB");
            case "ds" -> visitBarrier("DSB");
            case "is" -> visitBarrier("ISB");
            case ".align", "prfm", "sevl", "wfe", "yield" -> {}
            default -> parsingException("Unknown mnemonics '%s'", mnemonic);
        }
        events.addAll(postInstructionEvents);
        postInstructionEvents.clear();
    }

    private boolean anyWordOperand() {
        return instruction.operand().stream().anyMatch(Register32Context.class::isInstance);
    }

    private void visitMov() {
        checkOperands(2, 2);
        events.add(newLocal(parseRegister(0), parseExpression(1)));
    }

    private void visitCmp() {
        checkOperands(2, 2);
        comparison = new Comparison(parseExpression(0), parseExpression(1));
    }

    private void visitOp(IntBinaryOp op) {
        checkOperands(3, 3);
        final Expression result = expressions.makeIntBinary(parseExpression(1), op, parseExpression(2));
        events.add(newLocal(parseRegister(0), result));
    }

    private void visitB() {
        // Matched the 'b' suffix.
        check(typeHint == i8, "Invalid mnemonics");
        checkOperands(1, 1);
        events.add(newGoto(parseLabel(0)));
    }

    private void visitB(IntCmpOp op) {
        checkOperands64(1);
        check(comparison != null, "Branch comparison is missing");
        events.add(newJump(expressions.makeCompare(comparison.lhs, op, comparison.rhs), parseLabel(0)));
    }

    private void visitCbz(boolean negate) {
        checkOperands(2, 2);
        final Expression operand = parseExpression(0);
        final Expression zero = expressions.makeZero(typeHint);
        final Expression condition = negate ? expressions.makeNEQ(operand, zero) : expressions.makeEQ(operand, zero);
        events.add(newJump(condition, parseLabel(1)));
    }

    private void visitRet() {
        checkOperands64(0);
    }

    private void visitNop() {
        checkOperands64(0);
    }

    private void visitLdr(AArch64.MemoryOrder mo) {
        checkOperands(2, 2);
        events.add(AArch64.newLoad(parseRegister(0), parseAddress(1), mo));
    }

    private void visitLdx(AArch64.MemoryOrder mo) {
        checkOperands(2, 2);
        events.add(AArch64.newLoadExclusive(parseRegister(0), parseAddress(1), mo));
    }

    private void visitLdp() {
        checkOperands(3, 3);
        final Expression address0 = parseAddress(2);
        final Expression address1 = expressions.makeAdd(address0, expressions.makeValue(8, i64));
        events.add(AArch64.newLoad(parseRegister(0), address0, PLAIN));
        events.add(AArch64.newLoad(parseRegister(1), address1, PLAIN));
    }

    private void visitLdop(IntBinaryOp op, AArch64.MemoryOrder mo) {
        checkOperands(3, 3);
        events.add(AArch64.newLoadOp(parseRegister(1), parseAddress(2), op, parseExpression(0), mo));
    }

    private void visitStr(AArch64.MemoryOrder mo) {
        checkOperands(2, 2);
        events.add(AArch64.newStore(parseAddress(1), parseExpression(0), mo));
    }

    private void visitStx(AArch64.MemoryOrder mo) {
        checkOperands(3, 3);
        events.add(AArch64.newStoreExclusive(parseRegister(0), parseAddress(2), parseExpression(1), mo));
    }

    private void visitStp() {
        checkOperands(3, 3);
        final Expression address0 = parseAddress(2);
        final Expression address1 = expressions.makeAdd(address0, expressions.makeValue(8, i64));
        events.add(AArch64.newStore(address0, parseExpression(0), PLAIN));
        events.add(AArch64.newStore(address1, parseExpression(1), PLAIN));
    }

    private void visitStop(IntBinaryOp op, AArch64.MemoryOrder mo) {
        checkOperands(2, 2);
        events.add(AArch64.newStoreOp(parseAddress(1), op, parseExpression(0), mo));
    }

    private void visitSwp(AArch64.MemoryOrder mo) {
        checkOperands(3, 3);
        events.add(AArch64.newSwap(parseRegister(1), parseAddress(2), parseExpression(0), mo));
    }

    private void visitCas(AArch64.MemoryOrder mo) {
        checkOperands(3, 3);
        events.add(AArch64.newCas(parseRegister(0), parseAddress(2), parseExpression(0), parseExpression(1), mo));
    }

    private void visitBarrier(String type) {
        // Matched the 'b' suffix.
        check(typeHint == i8, "Invalid mnemonics");
        checkOperands(0, 1);
        final OperandContext optionContext = instruction.operand(0);
        final String optionName = optionContext instanceof LabelContext l ? l.getText().toUpperCase() : null;
        final BigInteger optionIndex = optionContext instanceof ImmediateContext i ? parseImmediate(i.Immediate()) : null;
        check(optionContext == null || optionName != null || optionIndex != null, "Invalid barrier option");
        final String option = optionContext == null ? "SY" : optionName != null ? optionName
                : switch (optionIndex.intValueExact()) {
            case 1 -> "NSHLD";
            case 2 -> "NSHST";
            case 3 -> "NSH";
            case 5 -> "OSHLD";
            case 6 -> "OSHST";
            case 7 -> "OSH";
            case 9 -> "ISHLD";
            case 10 -> "ISHST";
            case 11 -> "ISH";
            case 13 -> "LD";
            case 14 -> "ST";
            case 15 -> "SY";
            default -> parsingException("Invalid barrier index %s", optionIndex);
        };
        events.add(AArch64.newBarrier(type, option));
    }

    private record Comparison(Expression lhs, Expression rhs) {}

    private void appendLabel(TerminalNode node) {
        if (node == null) {
            return;
        }
        final String text = node.getText();
        check(!text.isEmpty() && text.charAt(text.length() - 1) == ':', "Invalid label declaration");
        final String name = text.substring(0, text.length() - 1);
        appendLabel(name);
    }

    private Label parseLabel(int index) {
        final OperandContext ctx = instruction.operand(index);
        check(ctx instanceof LabelContext, "Non-label");
        final String text = ctx.getText();
        if (!text.matches("[0-9]+[bf]")) {
            return declareLabel(text);
        }
        final boolean forward = text.charAt(text.length() - 1) == 'f';
        final String name = text.substring(0, text.length() - 1);
        return declareLabel(name, forward);
    }

    private Register parseRegister(int index) {
        final OperandContext ctx = instruction.operand(index);
        final Register32Context r32 = ctx instanceof Register32Context c ? c : null;
        final Register64Context r64 = ctx instanceof Register64Context c ? c : null;
        check((r32 == null) != (r64 == null), "Unknown register");
        final String name = (r32 != null ? r32.Register32() : r64.Register64()).getText();
        if (typeHint == i64 && r32 == null) {
            return function.getOrNewRegister(name.toUpperCase(), i64);
        }
        final String suffix = name.substring(1);
        final Register register64 = function.getOrNewRegister("X" + suffix, i64);
        // FIXME we use unofficial names B<N> and H<N> for smaller registers besides W<N> and X<N>.
        final String prefix = switch (typeHint.getBitWidth()) {
            case 8 -> "B";
            case 16 -> "H";
            case 32 -> "W";
            default -> parsingException("Unnamed data type", typeHint);
        };
        final Register register = function.getOrNewRegister(prefix + suffix, typeHint);
        postInstructionEvents.add(newLocal(register64, expressions.makeIntegerCast(register, i64, false)));
        return register;
    }

    private Expression parseAddress(int index) {
        final var address = (AddressContext) instruction.operand(index);
        final Expression base = parseRegister64(address.Register64());
        final OffsetContext offset = address.offset();
        final Expression offsetExpression = offset == null ? null : offset.accept(new OffsetVisitor());
        check(offset == null || offsetExpression != null, "Unrecognized offset");
        return offsetExpression == null ? base : expressions.makeAdd(base, offsetExpression);
    }

    private Expression parseExpression(int index) {
        final Expression expression = instruction.operand(index).accept(new ExpressionVisitor());
        check(expression != null, "Expression not implemented");
        return expression;
    }

    private void checkOperands(int minCount, int maxCount) {
        final int actualCount = instruction.operand().size();
        check(minCount <= actualCount, "Missing operands");
        check(actualCount <= maxCount, "Extra operands");
    }

    private void checkOperands64(int expectedCount) {
        final int actualCount = instruction.operand().size();
        check(expectedCount <= actualCount, "Missing operands");
        check(expectedCount >= actualCount, "Extra operands");
        check(typeHint == i64, "Unexpected operation data type");
    }

    private final class OffsetVisitor extends AsmArmBaseVisitor<Expression> {

        @Override
        public Expression visitOffsetImmediate(OffsetImmediateContext offset) {
            return expressions.makeValue(parseImmediate(offset.Immediate()), i64);
        }

        @Override
        public Expression visitOffsetRegister(OffsetRegisterContext offset) {
            return parseRegister64(offset.Register64());
        }

        @Override
        public Expression visitOffsetConversion(OffsetConversionContext offset) {
            final boolean signed = offset.Sxtw() != null;
            final Expression operand = parseRegister64(offset.Register32());
            return expressions.makeIntegerCast(expressions.makeIntegerCast(operand, i32, false), i64, signed);
        }
    }

    private final class ExpressionVisitor extends AsmArmBaseVisitor<Expression> {

        private ExpressionVisitor() { }

        @Override
        public Expression visitRegister64(Register64Context expression) {
            final Expression register = parseRegister64(expression.Register64());
            return shift(expressions.makeIntegerCast(register, typeHint, false), expression.shift());
        }

        @Override
        public Expression visitRegister32(Register32Context expression) {
            final Expression register = parseRegister64(expression.Register32());
            return shift(expressions.makeIntegerCast(register, typeHint, false), expression.shift());
        }

        @Override
        public Expression visitImmediate(ImmediateContext expression) {
            return shift(expressions.makeValue(parseImmediate(expression.Immediate()), typeHint), expression.shift());
        }

        @Override
        public Expression visitConversion(ConversionContext expression) {
            final boolean signed = expression.Sxtw() != null;
            final Expression operand = parseRegister64(expression.Register32());
            return expressions.makeIntegerCast(expressions.makeIntegerCast(operand, i32, false), i64, signed);
        }

        private Expression shift(Expression lhs, ShiftContext shift) {
            if (shift == null) {
                return lhs;
            }
            final IntBinaryOp op = shift.Lsl() != null ? IntBinaryOp.LSHIFT
                    : shift.Lsr() != null ? IntBinaryOp.RSHIFT : IntBinaryOp.ARSHIFT;
            final Expression rhs = expressions.makeValue(parseImmediate(shift.Immediate()), i64);
            return expressions.makeIntBinary(lhs, op, rhs);
        }
    }

    private Expression parseRegister64(TerminalNode register64) {
        final String name = register64.getText().substring(1);
        return name.equalsIgnoreCase("zr") ? expressions.makeZero(i64) : function.getOrNewRegister("X" + name, i64);
    }

    private static BigInteger parseImmediate(TerminalNode immediate) {
        final String text = immediate.getText();
        final boolean hex = text.startsWith("#0x");
        return new BigInteger(text.substring(hex ? 3 : 1), hex ? 16 : 10);
    }
}