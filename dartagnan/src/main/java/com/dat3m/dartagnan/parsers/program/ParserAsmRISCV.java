package com.dat3m.dartagnan.parsers.program;

import java.math.BigInteger;
import java.util.List;
import java.util.stream.Collectors;

import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntCmpOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.AsmRISCVParser.*;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.AsmRISCVLexer;
import com.dat3m.dartagnan.parsers.AsmRISCVParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import org.antlr.v4.runtime.RuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import static com.dat3m.dartagnan.program.event.EventFactory.RISCV.MemoryOrder.*;
import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class ParserAsmRISCV extends ParserAsm {

    private volatile DirectiveContext directive;

    public ParserAsmRISCV(Function function) {
        super(function);
    }

    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException, UnsupportedOperationException {
        final var lexer = new AsmRISCVLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        final var tokenStream = new CommonTokenStream(lexer);
        final var parser = new AsmRISCVParser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        parseLines(parser.lines());
        validate();
        return events;
    }

    @Override
    public Register formatLlvmRegister(int index, char constraintCode) {
        return function.getOrNewRegister("r%d".formatted(index), i64);
    }

    @Override
    public String formatArgument(int index, char constraintCode, String specifier) {
        return "r%d".formatted(index);
    }

    private void parseLines(LinesContext ctx) {
        for (LineContext line : ctx.line()) {
            visitLabel(line.label());
            visitDirective(line.directive());
        }
    }

    private void visitLabel(LabelContext label) {
        if (label == null) {
            return;
        }
        final String name = label.getText();
        appendLabel(name.substring(0, name.length() - 1));
    }

    private void visitDirective(DirectiveContext ctx) {
        if (ctx == null) {
            return;
        }
        directive = ctx;
        final String mnemonic = ctx.mnemonic.getText();
        int stemEnd = mnemonic.length() - 3;
        boolean release = false;
        boolean acquire = false;
        for (; stemEnd > 0; stemEnd -= 3) {
            if (mnemonic.startsWith(".aq", stemEnd)) {
                acquire = true;
            } else if (mnemonic.startsWith(".rl", stemEnd)) {
                release = true;
            } else {
                break;
            }
        }
        final RISCV.MemoryOrder mo = acquire ? release ? ACQ_REL : ACQUIRE : release ? RELEASE : PLAIN;
        final String stem = mnemonic.substring(0, stemEnd + 3);
        switch (stem) {
            case "li" -> visitMv(true);
            case "mv" -> visitMv(false);
            case "neg" -> visitNeg();
            case "add" -> visitBinary(IntBinaryOp.ADD, false);
            case "addi" -> visitBinary(IntBinaryOp.ADD, true);
            case "and" -> visitBinary(IntBinaryOp.AND, false);
            case "andi" -> visitBinary(IntBinaryOp.AND, true);
            case "or" -> visitBinary(IntBinaryOp.OR, false);
            case "ori" -> visitBinary(IntBinaryOp.OR, true);
            case "sub" -> visitBinary(IntBinaryOp.SUB, false);
            case "xor" -> visitBinary(IntBinaryOp.XOR, false);
            case "xori" -> visitBinary(IntBinaryOp.XOR, true);
            case "beq" -> visitBranch(IntCmpOp.EQ, false);
            case "bge" -> visitBranch(IntCmpOp.GTE, false);
            case "bgt" -> visitBranch(IntCmpOp.GT, false);
            case "ble" -> visitBranch(IntCmpOp.LTE, false);
            case "blt" -> visitBranch(IntCmpOp.LT, false);
            case "bne" -> visitBranch(IntCmpOp.NEQ, false);
            case "bnez" -> visitBranch(IntCmpOp.NEQ, true);
            case "ld" -> visitLoad(i64, mo, false);
            case "lw", "lwu" -> visitLoad(i32, mo, false);
            case "lr.d" -> visitLoad(i64, mo, true);
            case "lr.w" -> visitLoad(i32, mo, true);
            case "sd" -> visitStore(i64, mo, false);
            case "sw" -> visitStore(i32, mo, false);
            case "sc.d" -> visitStore(i64, mo, true);
            case "sc.w" -> visitStore(i32, mo, true);
            case "amoadd.d" -> visitAmo(IntBinaryOp.ADD, i64, mo);
            case "amoadd.w" -> visitAmo(IntBinaryOp.ADD, i32, mo);
            case "amoor.d" -> visitAmo(IntBinaryOp.OR, i64, mo);
            case "amoor.w" -> visitAmo(IntBinaryOp.OR, i32, mo);
            case "amoswap.d" -> visitAmo(null, i64, mo);
            case "amoswap.w" -> visitAmo(null, i32, mo);
            case "fence" -> visitFence(null);
            default -> {
                if (stem.startsWith("fence.")) {
                    visitFence(stem.substring(6));
                } else {
                    throw new UnsupportedOperationException("Unknown directive");
                }
            }
        }
        directive = null;
    }

    private void visitMv(boolean immediate) {
        checkOperands(2, 2);
        append(newLocal(parseRegister(0), immediate ? parseImmediate(1) : parseExpression(1)));
    }

    private void visitNeg() {
        checkOperands(2, 2);
        append(newLocal(parseRegister(0), expressions.makeNeg(parseExpression(1))));
    }

    private void visitBinary(IntBinaryOp op, boolean immediate) {
        checkOperands(3, 3);
        final Expression left = parseExpression(1);
        final Expression right = immediate ? parseImmediate(2) : parseExpression(2);
        append(newLocal(parseRegister(0), expressions.makeIntBinary(left, op, right)));
    }

    private void visitBranch(IntCmpOp op, boolean zero) {
        checkOperands(zero ? 2 : 3, zero ? 2 : 3);
        final Expression right = zero ? expressions.makeZero(i64) : parseExpression(1);
        append(newJump(expressions.makeIntCmp(parseRegister(0), op, right), parseLabel(zero ? 1 : 2)));
    }

    private void visitLoad(IntegerType accessType, RISCV.MemoryOrder mo, boolean reserve) {
        checkOperands(2, 2);
        final Register value = parseRegister(0);
        final Expression address = parseAddress(1);
        append(reserve ? RISCV.newLoadReserve(value, address, mo) : RISCV.newLoad(value, address, mo));
    }

    private void visitStore(IntegerType accessType, RISCV.MemoryOrder mo, boolean conditional) {
        checkOperands(conditional ? 3 : 2, conditional ? 3 : 2);
        final Register status = conditional ? parseRegister(0) : null;
        final Expression value = parseExpression(conditional ? 1 : 0);
        final Expression address = parseAddress(conditional ? 2 : 1);
        append(conditional ? RISCV.newStoreConditional(status, address, value, mo) : RISCV.newStore(address, value, mo));
    }

    private void visitAmo(IntBinaryOp op, IntegerType accessType, RISCV.MemoryOrder mo) {
        checkOperands(3, 3);
        final Register result = parseRegister(0);
        final Expression value = parseExpression(1);
        final Expression address = parseAddress(2);
        append(op == null ? RISCV.newAmoSwap(result, address, value, mo) : RISCV.newAmo(result, address, op, value, mo));
    }

    private void visitFence(String mode) {
        checkOperands(mode == null ? 1 : 0, mode == null ? 2 : 0);
        mode = mode != null ? mode : directive.operand().stream().map(RuleContext::getText).collect(Collectors.joining("."));
        append(RISCV.newFence(mode));
    }

    private Label parseLabel(int index) {
        final var operand = directive.operand(index) instanceof OperandLabelContext c ? c : null;
        check(operand != null, "Non-label operand");
        return declareLabel(operand.getText());
    }

    private Register parseRegister(int index) {
        final OperandContext operand = directive.operand(index);
        check(operand instanceof RegisterContext, "Non-register operand");
        return function.getOrNewRegister(operand.getText(), i64);
    }

    private Expression parseExpression(int index) {
        final OperandContext operand = directive.operand(index);
        check(operand instanceof RegisterContext, "Non-register operand");
        return parseRegister(operand.getText());
    }

    private Expression parseAddress(int index) {
        final OperandContext operand = directive.operand(index);
        final var address = operand instanceof AddressContext c ? c : null;
        check(address != null, "Non-address operand");
        final Expression offset = address.Constant() == null ? null : parseConstant(address.Constant());
        final Expression base = parseRegister(address.Register().getText());
        return offset == null ? base : expressions.makeAdd(base, offset);
    }

    private IntLiteral parseImmediate(int index) {
        final var operand = directive.operand(index) instanceof ConstantContext c ? c : null;
        check(operand != null, "Non-immediate operand");
        return parseConstant(operand.Constant());
    }

    private Expression parseRegister(String name) {
        return name.equals("x0") ? expressions.makeZero(i64) : function.getOrNewRegister(name, i64);
    }

    private IntLiteral parseConstant(TerminalNode constant) {
        return expressions.makeValue(new BigInteger(constant.getText()), i64);
    }

    private void append(Event event) {
        events.add(event);
    }

    private void checkOperands(int minCount, int maxCount) {
        final int actualCount = directive.operand().size();
        check(minCount <= actualCount, "Unexpected operand count %d.", actualCount);
        check(actualCount <= maxCount, "Unexpected operand count %d.", actualCount);
    }
}