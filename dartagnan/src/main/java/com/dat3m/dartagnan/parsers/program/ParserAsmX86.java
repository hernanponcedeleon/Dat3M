package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.exception.UnrecognizedTokenListener;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.integers.IntBinaryOp;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.parsers.AsmX86Parser;
import com.dat3m.dartagnan.parsers.AsmX86BaseVisitor;
import com.dat3m.dartagnan.parsers.AsmX86Lexer;
import com.dat3m.dartagnan.parsers.AsmX86Parser.*;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.X86.*;

public class ParserAsmX86 extends ParserAsm {

    private final boolean mode32;
    private final boolean intelSyntax;
    private DirectiveContext instruction;
    private IntegerType type;
    private RegisterInfo registerInfo;

    public ParserAsmX86(Function llvmFunction, boolean mode32, boolean intelSyntax) {
        super(llvmFunction);
        this.mode32 = mode32;
        this.intelSyntax = intelSyntax;
    }

    @Override
    public Register formatLlvmRegister(int index, char constraintCode) {
        return function.getOrNewRegister("R" + index + "X", i64);
    }

    @Override
    public String formatArgument(int index, char constraintCode, String modifier) {
        //TODO modifiers
        return "R" + index + "X";
    }

    @Override
    public List<Event> parse(CharStream charStream) throws ParsingException, UnsupportedOperationException{
        final var lexer = new AsmX86Lexer(charStream);
        lexer.removeErrorListeners(); // Remove default listeners
        lexer.addErrorListener(new UnrecognizedTokenListener());
        final var tokenStream = new CommonTokenStream(lexer);

        final var parser = new AsmX86Parser(tokenStream);
        parser.removeErrorListeners(); // Remove default listeners
        parser.addErrorListener(new UnrecognizedTokenListener());
        visitLines(parser.lines());
        return events;
    }

    private void visitLines(LinesContext lines) {
        for (LineContext line : lines.line()) {
            appendLabel(line.label());
            visitDirective(line.directive());
            assignFullRegister();
        }
    }

    private void appendLabel(LabelContext label) {
        if (label != null) {
            appendLabel(label.getText());
        }
    }

    private void visitDirective(DirectiveContext directive) {
        if (directive == null) {
            return;
        }
        instruction = directive;
        final String mnemonic = directive.mnemnonic.getText().toLowerCase();
        if (intelSyntax) {
            type = scanIntelType();
        } else {
            type = switch (mnemonic.charAt(mnemonic.length() - 1)) {
                case 'b' -> i8;
                case 's' -> i16;
                case 'w' -> i32;
                case 'q' -> i64;
                default -> null;
            };
            if (type != null && matchMnemonic(mnemonic.substring(0, mnemonic.length() - 1))) {
                return;
            }
            type = scanAttType();
        }
        check(matchMnemonic(mnemonic), "Unsupported directive '%s'", mnemonic);
    }

    private void assignFullRegister() {
        if (registerInfo != null && registerInfo.type != (mode32 ? RegisterType.I32 : RegisterType.I64)) {
            final Expression operand = function.getRegister(registerInfo.part);
            final Expression extended = expressions.makeIntegerCast(operand, mode32 ? i32 : i64, false);
            final Expression adjusted = registerInfo.type != RegisterType.I8H ? extended
                    : expressions.makeIntBinary(extended, IntBinaryOp.LSHIFT, expressions.makeValue(8, mode32 ? i32 : i64));
            events.add(newLocal(registerInfo.full, adjusted));
        }
    }

    private IntegerType scanIntelType() {
        for (OperandContext operand : instruction.operand()) {
            if (operand instanceof AddressIntelContext address && address.Type() != null) {
                final String type = address.Type().getText();
                return switch (type) {
                    case "byte ptr" -> i8;
                    case "word ptr" -> i16;
                    case "dword ptr" -> i32;
                    case "qword ptr" -> i64;
                    default -> parsingException("Unknown type '%s'", type);
                };
            }
        }
        if (instruction.operand().isEmpty() || !(instruction.operand(0) instanceof OperandRegisterContext reg)) {
            return mode32 ? i32 : i64;
        }
        return type(parseRegisterInfo(reg.register().Register()).type);
    }

    private IntegerType scanAttType() {
        final List<OperandContext> operand = instruction.operand();
        if (operand.isEmpty() || !(operand.get(operand.size() - 1) instanceof OperandRegisterContext reg)) {
            return mode32 ? i32 : i64;
        }
        return type(parseRegisterInfo(reg.register().Register()).type);
    }

    private boolean matchMnemonic(String mnemonic) {
        boolean match = true;
        switch (mnemonic) {
            case "mov" -> visitMov();
            case "xchg" -> visitXchg();
            case "lfence", "mfence", "sfence" -> visitFence(mnemonic);
            default -> { match = false;}
        }
        return match;
    }

    private void visitMov() {
        checkOperands(2, 2);
        if (isAddressOperand(intelSyntax ? 0 : 1)) {
            events.add(newStore(parseAddress(intelSyntax ? 0 : 1), parseExpression(intelSyntax ? 1 : 0)));
            return;
        }
        final Register destination = parseRegister(intelSyntax ? 0 : 1);
        if (isAddressOperand(intelSyntax ? 1 : 0)) {
            events.add(newLoad(destination, parseAddress(intelSyntax ? 1 : 0)));
        } else {
            events.add(newLocal(destination, parseExpression(intelSyntax ? 1 : 0)));
        }
    }

    private void visitXchg() {
        checkOperands(2, 2);
        final boolean register0 = instruction.operand(0) instanceof OperandRegisterContext;
        final boolean register1 = instruction.operand(1) instanceof OperandRegisterContext;
        check(register0 || register1, "Undefined instruction: exchange memory with memory.");
        if (register0 && register1) {
            throw new UnsupportedOperationException("Exchange register with register");
        } else {
            events.add(newExchange(parseAddress(register0 ? 1 : 0), parseRegister(register0 ? 0 : 1)));
        }
    }

    private void visitFence(String type) {
        checkOperands(0, 0);
        events.add(newMemoryFence(type));
    }

    private void checkOperands(int minCount, int maxCount) {
        final int actualCount = instruction.operand().size();
        check(minCount <= actualCount, "missing operands");
        check(actualCount <= maxCount, "extra operands");
    }

    private boolean isAddressOperand(int index) {
        final OperandContext operand = instruction.operand(index);
        return operand instanceof AddressAttContext || operand instanceof AddressIntelContext;
    }

    private Expression parseExpression(int index) {
        final Expression expression = instruction.operand(index).accept(new ExpressionVisitor());
        check(expression != null, "Unsupported expression operand");
        return expression;
    }

    private Register parseRegister(int index) {
        final var register = (OperandRegisterContext) instruction.operand(index);
        registerInfo = parseRegisterInfo(register.register().Register());
        return function.getOrNewRegister(registerInfo.part, type(registerInfo.type));
    }

    private Expression parseAddress(int index) {
        final OperandContext operand = instruction.operand(index);
        final var addressAtt = operand instanceof AddressAttContext c ? c : null;
        final var addressIntel = operand instanceof AddressIntelContext c ? c : null;
        check(intelSyntax ? addressIntel != null : addressAtt != null, "Unexpected address");
        final IntBinaryOp opDisplacement = parseOp(addressAtt != null ? null : addressIntel.opDisplacement);
        final IntBinaryOp opIndex = parseOp(addressAtt != null ? null : addressIntel.opIndex);
        final DisplacementContext dis = addressAtt != null ? addressAtt.displacement() : addressIntel.displacement();
        final IndexContext ind = addressAtt != null ? addressAtt.index() : addressIntel.index();
        final AlignContext ali = addressAtt != null ? addressAtt.align() : addressIntel.align();
        final Expression base = parseBase(addressAtt != null ? addressAtt.base() : addressIntel.base());
        final Expression displaced = parseDisplacement(base, opDisplacement, dis);
        return parseIndex(displaced, opIndex, ind, ali);
    }

    private Expression parseBase(BaseContext base) {
        if (base == null) {
            return null;
        } else if (base.register() != null) {
            return parseRegisterExpression(base.register(), i64);
        } else {
            return parseObject(base.label().getText());
        }
    }

    private Expression parseDisplacement(Expression base, IntBinaryOp op, DisplacementContext displacement) {
        if (displacement == null) {
            return base;
        }
        final Expression object = displacement.Name() == null ? null : parseObject(displacement.Name().getText());
        check(base != null || op == IntBinaryOp.ADD, "Invalid address expression");
        final Expression address = base == null ? object : expressions.makeIntBinary(object, op, base);
        if (displacement.number() == null) {
            return address;
        }
        final BigInteger offsetInteger = parseNumber(displacement.number());
        final Expression offset = expressions.makeValue(offsetInteger, i64);
        return expressions.makeIntBinary(address, parseOp(displacement.op()), offset);
    }

    private Expression parseIndex(Expression address, IntBinaryOp op, IndexContext index, AlignContext align) {
        if (index == null) {
            return address;
        }
        final Expression index_ = parseRegisterExpression(index.register(), i64);
        final Expression aligned = align == null ? index_ : expressions.makeMul(index_, expressions.makeValue(
                parseNumber(align.Number().getText()), i64));
        return expressions.makeIntBinary(address, op, aligned);
    }

    private IntBinaryOp parseOp(OpContext op) {
        return op == null ? IntBinaryOp.ADD : switch (op.getText()) {
            case "+" -> IntBinaryOp.ADD;
            case "-" -> IntBinaryOp.SUB;
            default -> parsingException("Invalid operator");
        };
    }

    private final class ExpressionVisitor extends AsmX86BaseVisitor<Expression> {

        @Override
        public Expression visitOperandImmediate(OperandImmediateContext immediate) {
            return expressions.makeValue(parseNumber(immediate.Immediate().getText().substring(1)), type);
        }

        @Override
        public Expression visitOperandNumber(OperandNumberContext number) {
            return expressions.makeValue(parseNumber(number.number()), type);
        }

        @Override
        public Expression visitOperandRegister(OperandRegisterContext register) {
            return parseRegisterExpression(register.register(), type);
        }

        @Override
        public Expression visitOperandLabel(OperandLabelContext label) {
            return parseLabelExpression(label.label());
        }
    }

    private Expression parseLabelExpression(LabelContext label) {
        return parseObject(label.getText());
    }

    private Expression parseObject(String name) {
        final MemoryObject foundObject = function.getProgram().getMemory().getObjects().stream()
                .filter(o -> o.hasName() && name.equals(o.getName()))
                .findAny().orElse(null);
        if (foundObject != null) {
            return foundObject;
        }
        // `name` denotes an object that is defined later.
        //TODO delay the decision on the object's size.
        // Litmus tests automatically define all remaining objects to fit a target-defined integer type.
        final MemoryObject futureObject = function.getProgram().getMemory().allocate(mode32 ? 4 : 8);
        futureObject.setName(name);
        return futureObject;
    }

    private BigInteger parseNumber(NumberContext number) {
        return parseNumber(number.getText());
    }

    private BigInteger parseNumber(String text) {
        final boolean hex = text.startsWith("0X") || text.startsWith("0x");
        return new BigInteger(hex ? text.substring(2) : text, hex ? 16 : 10);
    }

    private Expression parseRegisterExpression(RegisterContext register, IntegerType targetType) {
        final RegisterInfo info = parseRegisterInfo(register.Register());
        final Expression truncated = switch (info.type) {
            case I64 -> info.full;
            case I32 -> expressions.makeIntegerCast(info.full, i32, false);
            case I16 -> expressions.makeIntegerCast(info.full, i16, false);
            case I8L -> expressions.makeIntegerCast(info.full, i8, false);
            case I8H -> expressions.makeIntExtract(info.full, 8, 15);
        };
        return expressions.makeIntegerCast(truncated, targetType, false);
    }

    private RegisterInfo parseRegisterInfo(TerminalNode node) {
        final String text = node.getText().toUpperCase();
        final String name;
        final RegisterType type;
        if (text.charAt(0) == 'R') {
            check(mode32 == (text.charAt(text.length() - 1) != 'D'), "Not supported in 32-bit mode");
            name = mode32 ? text.substring(0, text.length() - 1) : text;
            type = RegisterType.I64;
        } else if (text.charAt(0) == 'E') {
            name = mode32 ? text : "R" + text.substring(1);
            type = RegisterType.I32;
        } else if (text.charAt(text.length() - 1) == 'H' || text.charAt(text.length() - 1) == 'L') {
            name = (mode32 ? "E" : "R") + text.substring(0, text.length() - 1) + "X";
            type = text.charAt(text.length() - 1) == 'H' ? RegisterType.I8H : RegisterType.I8L;
        } else {
            name = (mode32 ? "E" : "R") + text;
            type = RegisterType.I16;
        }
        return new RegisterInfo(function.getOrNewRegister(name, mode32 ? i32 : i64), text, type);
    }

    private IntegerType type(RegisterType type) {
        return switch (type) {
            case I64 -> i64;
            case I32 -> i32;
            case I16 -> i16;
            case I8H, I8L -> i8;
        };
    }

    private record RegisterInfo(Register full, String part, RegisterType type) {}

    private enum RegisterType { I64, I32, I16, I8L, I8H }
}