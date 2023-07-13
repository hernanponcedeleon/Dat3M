package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LLVMIRBaseVisitor;
import com.dat3m.dartagnan.parsers.LLVMIRParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.Memory;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.Llvm.newCompareExchange;
import static com.google.common.base.Preconditions.checkState;

public class VisitorLlvm extends LLVMIRBaseVisitor<Expression> {

    // Global context
    private final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private int functionCounter;
    // Nonnull, if the visitor is inside a function body.
    private Function function;
    private final Map<String, Block> basicBlocks = new HashMap<>();
    private final Map<BlockPair, List<Event>> phiNodes = new HashMap<>();
    // Nonnull, if the visitor is inside a basic block.
    private Block block;
    // Nonnull, if the visitor is inside a value instruction.  Resolve overloading, like in literals.
    private Type expectedType;
    // Nonnull, if the visitor is inside a named instruction.
    private String currentRegisterName;
    // Nonnull, if a type has been parsed.
    private Type parsedType;

    public VisitorLlvm() {}

    public Program buildProgram() {
        ProgramBuilder.processAfterParsing(program);
        return program;
    }

    public Function getMainFunction() {
        return program.getFunctions().stream().filter(f -> f.getName().equals("@main")).findAny().orElseThrow();
    }

    @Override
    public Expression visitCompilationUnit(CompilationUnitContext ctx) {
        // Create the metadata mapping beforehand, so that instructions can get all attachments
        for (TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.metadataDef() != null) {
                entity.accept(this);
            }
        }
        for (TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.metadataDef() == null) {
                entity.accept(this);
            }
        }
        //TODO insert globals and functions
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Top Level Entities

    @Override
    public Expression visitFuncDef(FuncDefContext ctx) {
        final String name = ctx.funcHeader().GlobalIdent().getText();
        final Type returnType = checkType(ctx.funcHeader().type());
        final List<Type> parameterTypes = new ArrayList<>();
        final List<String> parameterNames = new ArrayList<>();
        for (ParamContext parameter : ctx.funcHeader().params().param()) {
            parameterTypes.add(checkType(parameter.type()));
            parameterNames.add(parameter.LocalIdent().getText());
        }
        final FunctionType functionType = types.getFunctionType(returnType, parameterTypes);
        //TODO there are more attributes in ctx
        function = new Function(name, functionType, parameterNames, functionCounter++, null);
        program.addFunction(function);
        // The grammar requires at least one block, thus an entry and an exit.
        for (final BasicBlockContext basicBlockContext : ctx.funcBody().basicBlock()) {
            block = getBlock(basicBlockContext.LabelIdent().getText());
            for (final InstructionContext instructionContext : basicBlockContext.instruction()) {
                instructionContext.accept(this);
            }
            basicBlockContext.terminator().accept(this);
            block = null;
        }
        //TODO validate: all basic blocks have a terminator, there is one entry, at least one exit, etc.
        function = null;
        return null;
    }

    private Block getBlock(String label) {
        return basicBlocks.computeIfAbsent(label, k -> new Block(newLabel(k)));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Terminators

    // ----------------------------------------------------------------------------------------------------------------
    // Instructions

    @Override
    public Expression visitLocalDefInst(LocalDefInstContext ctx) {
        final Expression expression = ctx.valueInstruction().accept(this);
        final Register register = function.newRegister(ctx.LocalIdent().getText(), expression.getType());
        final Local local = newLocal(register, expression);
        block.events.add(local);
        return null;
    }

    @Override
    public Expression visitPhiInst(PhiInstContext ctx) {
        final Type type = checkType(ctx.type());
        final Register register = function.newRegister(currentRegisterName, type);
        for (final IncContext inc : ctx.inc()) {
            final Block target = getBlock(inc.LocalIdent().getText());
            final Expression expression = checkExpression(type, inc.value());
            phiNodes.computeIfAbsent(new BlockPair(block, target), k -> new ArrayList<>())
                    .add(newLocal(register, expression));
        }
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Expressions

    @Override
    public Expression visitIntConst(IntConstContext ctx) {
        final BigInteger value = parseBigInteger(ctx.IntLit());
        checkState(expectedType instanceof IntegerType, "Expected non-integer type.");
        return expressions.makeValue(value, (IntegerType) expectedType);
    }

    @Override
    public Expression visitValue(ValueContext ctx) {
        if (ctx.constant() != null) {
            return ctx.constant().accept(this);
        }
        checkSupport(ctx.inlineAsm() == null, "Assembly values.");
        assert expectedType != null : "No expected type.";
        final String id = ctx.LocalIdent().getText();
        return function.getOrNewRegister(id, expectedType);
    }

    @Override
    public Expression visitAddInst(AddInstContext ctx) {
        final Type type = checkType(ctx.typeValue().firstClassType());
        final Expression left = checkExpression(type, ctx.typeValue().value());
        final Expression right = checkExpression(type, ctx.value());
        return expressions.makeADD(left, right);
    }

    @Override
    public Expression visitGetElementPtrInst(GetElementPtrInstContext ctx) {
        final Type type = checkType(ctx.type());
        final var operands = new ArrayList<Expression>();
        for (final TypeValueContext typeValue : ctx.typeValue()) {
            final Type operandType = checkType(typeValue.firstClassType());
            operands.add(checkExpression(operandType, typeValue.value()));
        }
        assert !operands.isEmpty();
        return expressions.makeGetElementPointer(type, operands.get(0), operands.subList(1, operands.size()));
    }

    @Override
    public Expression visitCmpXchgInst(CmpXchgInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#cmpxchg-instruction
        final Type addressType = checkType(ctx.typeValue(0).firstClassType());
        check(addressType.equals(types.getArchType()), "Instruction 'cmpxchg' on non-pointer type.");
        final Type comparatorType = checkType(ctx.typeValue(1).firstClassType());
        final Type substituteType = checkType(ctx.typeValue(2).firstClassType());
        check(comparatorType.equals(substituteType), "Type mismatch for comparator and new");
        final Expression address = checkExpression(addressType, ctx.typeValue(0).value());
        final Expression comparator = checkExpression(comparatorType, ctx.typeValue(1).value());
        final Expression substitute = checkExpression(substituteType, ctx.typeValue(2).value());
        // TODO if referred to currentRegisterName, instead refer to a struct of the following
        // Do not rely on this naming scheme
        final Register oldValueRegister = function.getOrNewRegister(currentRegisterName + ".0", comparatorType);
        final Register cmpRegister = function.getOrNewRegister(currentRegisterName + ".1", types.getIntegerType(1));
        final boolean weak = ctx.weak != null;
        final String mo = parseMemoryOrder(ctx.atomicOrdering(0));
        block.events.add(newCompareExchange(oldValueRegister, cmpRegister, address, comparator, substitute, mo, weak));
        return null;
    }

    private Type checkType(ParserRuleContext context) {
        Object o = context.accept(this);
        assert o instanceof Type : "Unexpected return value, expected type.";
        return (Type) o;
    }

    private Expression checkExpression(Type type, ParserRuleContext context) {
        expectedType = type;
        Expression o = context.accept(this);
        expectedType = null;
        return o;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Types

    @Override
    public Expression visitIntType(IntTypeContext ctx) {
        parsedType = parseIntType(ctx.IntType());
        return null;
    }

    private Type parseIntType(TerminalNode t) {
        assert t.getText().startsWith("i");
        return types.getIntegerType(Integer.parseUnsignedInt(t.getText().substring(1)));
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Helpers

    private void check(boolean condition, String message) {
        if (!condition) {
            throw new ParsingException(message);
        }
    }

    private void checkSupport(boolean condition, String message) {
        if (!condition) {
            throw new ParsingException("Unsupported: " + message);
        }
    }

    private BigInteger parseBigInteger(TerminalNode node) {
        return new BigInteger(node.getText());
    }

    private static String parseMemoryOrder(AtomicOrderingContext ctx) {
        return switch (ctx.getText()) {
            case "unordered" -> Tag.C11.NONATOMIC;
            case "monotonic" -> Tag.C11.MO_RELAXED;
            case "acquire" -> Tag.C11.MO_ACQUIRE;
            case "release" -> Tag.C11.MO_RELEASE;
            case "acq_rel" -> Tag.C11.MO_ACQUIRE_RELEASE;
            case "seq_cst" -> Tag.C11.MO_SC;
            default -> throw new ParsingException(String.format("Unknown ordering '%s'", ctx.getText()));
        };
    }

    private record BlockPair(Block from, Block to) {}

    private static final class Block {
        private final Label label;
        private final List<Event> events = new ArrayList<>();
        private Block(Label l) {
            label = l;
        }
    }
}