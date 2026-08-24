package com.dat3m.dartagnan.parsers.program;

import java.math.BigInteger;
import java.util.List;

import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.integers.IntLiteral;
import com.dat3m.dartagnan.parsers.AsmPPCParser.*;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.core.Label;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.parsers.AsmPPCLexer;
import com.dat3m.dartagnan.parsers.AsmPPCParser;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

import static com.dat3m.dartagnan.program.event.EventFactory.*;

public class ParserAsmPPC extends ParserAsm {

    private volatile DirectiveContext instruction;

    public ParserAsmPPC(Function function) {
        super(function);
    }

    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException, UnsupportedOperationException{
        final var lexer = new AsmPPCLexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        final var tokenStream = new CommonTokenStream(lexer);
        final var parser = new AsmPPCParser(tokenStream);
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

    private void parseLines(LinesContext lines) {
        for (LineContext line : lines.line()) {
            appendLabel(line.label());
            handleInstruction(line.directive());
        }
    }

    private void appendLabel(LabelContext ctx) {
        if (ctx == null) {
            return;
        }
        final String text = ctx.getText();
        appendLabel(text.substring(0, text.length() - 1));
    }

    private void handleInstruction(DirectiveContext ctx) {
        if (ctx == null) {
            return;
        }
        instruction = ctx;
        final String mnemonic = ctx.mnemnonic.getText().toLowerCase();
        switch (mnemonic) {
            case "li" -> visitLi();
            case "mr" -> visitMr();
            case "lwz", "ld" -> visitLwz();
            case "lwarx", "ldarx" -> visitLwarx();
            case "std", "stw" -> visitStw();
            case "stwcx.", "stdcx." -> visitStwcx();
            case "cmpw", "cmpd" -> visitCmpw();
            case "beq" -> visitBranchEqual(false);
            case "bne" -> visitBranchEqual(true);
            case "or" -> visitBinary(IntBinaryOp.OR);
            case "add" -> visitBinary(IntBinaryOp.ADD);
            case "subf" -> visitBinary(IntBinaryOp.SUB);
            case "xor" -> visitBinary(IntBinaryOp.XOR);
            case "addi" -> visitAddi();
            case "addic" -> visitAddic();
            case "sync", "lwsync", "isync" -> visitBarrier(mnemonic);
            default -> throw new UnsupportedOperationException("Mnemonic %s".formatted(mnemonic));
        }
        instruction = null;
    }

    private void visitLi() {
        checkOperands(2);
        append(newLocal(parseRegister(0), parseImmediate(1)));
    }

    private void visitMr() {
        checkOperands(2);
        append(EventFactory.newLocal(parseRegister(0), parseRegister(1)));
    }

    private void visitLwz() {
        checkOperands(2);
        append(Power.newLoad(parseRegister(0), parseAddress(1)));
    }

    private void visitLwarx() {
        checkOperands(3);
        append(Power.newLoadReserve(parseRegister(0), expressions.makeAdd(parseRegister(1), parseRegister(2))));
    }

    private void visitStw() {
        checkOperands(2);
        append(EventFactory.Power.newStore(parseAddress(1), parseRegister(0)));
    }

    private void visitStwcx() {
        checkOperands(3);
        // Sets CR0 to {EQ} if the store is successful, or {} otherwise.
        //TODO Update other flags in CR0.
        final Expression address = expressions.makeAdd(parseRegister(1), parseRegister(2));
        append(EventFactory.Power.newStoreConditional(cr0eq(), address, parseRegister(0)));
    }

    private void visitBinary(IntBinaryOp op) {
        checkOperands(3);
        append(newLocal(parseRegister(0), expressions.makeIntBinary(parseRegister(1), op, parseRegister(2))));
    }

    private void visitAddi() {
        checkOperands(3);
        append(newLocal(parseRegister(0), expressions.makeAdd(parseRegister(1), parseImmediate(2))));
    }

    private void visitCmpw() {
        checkOperands(2);
        //TODO Update other flags in CR0.
        append(newLocal(cr0eq(), expressions.makeEQ(parseRegister(0), parseRegister(1))));
    }

    private void visitBranchEqual(boolean invert) {
        checkOperands(1);
        append(EventFactory.newJump(invert ? expressions.makeNot(cr0eq()) : cr0eq(), parseLabel(0)));
    }

    private void visitAddic() {
        checkOperands(3);
        // TODO Update the CA bit in the XER register.
        // https://www.ibm.com/docs/sv/aix/7.2?topic=set-addic-ai-add-immediate-carrying-instruction
        append(newLocal(parseRegister(0), expressions.makeAdd(parseRegister(1), parseImmediate(2))));
    }

    private void visitBarrier(String type) {
        checkOperands(0);
        append(Power.newBarrier(type));
    }

    private Expression parseAddress(int index) {
        final var operand = instruction.operand(index) instanceof OperandAddressContext c ? c : null;
        check(operand != null, "Non-address operand");
        final IntLiteral offset = parseConstant(operand.Immediate().getText());
        final Register base = function.getOrNewRegister(operand.Register().getText(), i64);
        return expressions.makeAdd(base, offset);
    }

    private Register parseRegister(int index) {
        final OperandContext operand = instruction.operand(index);
        check(operand instanceof OperandRegisterContext, "Non-register operand");
        return function.getOrNewRegister(operand.getText(), i64);
    }

    private IntLiteral parseImmediate(int index) {
        final OperandContext operand = instruction.operand(index);
        check(operand instanceof OperandImmediateContext, "Non-immediate operand");
        return parseConstant(operand.getText());
    }

    private Label parseLabel(int index) {
        final OperandContext operand = instruction.operand(index);
        check(operand instanceof OperandLabelContext, "Non-label operand");
        return declareLabel(operand.getText());
    }

    private IntLiteral parseConstant(String text) {
        return expressions.makeValue(new BigInteger(text), i64);
    }

    private Register cr0eq() {
        return function.getOrNewRegister("cr0eq", types.getBooleanType());
    }

    private void append(Event event) {
        events.add(event);
    }

    private void checkOperands(int expectedCount) {
        check(expectedCount == instruction.operand().size(), "Invalid number of arguments.");
    }
}