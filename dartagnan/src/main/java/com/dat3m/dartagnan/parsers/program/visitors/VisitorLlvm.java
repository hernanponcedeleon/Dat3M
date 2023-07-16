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
    private final Type pointerType = types.getArchType();
    private final IntegerType integerType = types.getArchType();
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
        final Type returnType = parseType(ctx.funcHeader().type());
        final List<Type> parameterTypes = new ArrayList<>();
        final List<String> parameterNames = new ArrayList<>();
        for (ParamContext parameter : ctx.funcHeader().params().param()) {
            parameterTypes.add(parseType(parameter.type()));
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
        for (final BasicBlockContext basicBlockContext : ctx.funcBody().basicBlock()) {
            final Block block = getBlock(basicBlockContext.LabelIdent().getText());
            function.appendParsed(block.label);
            for (final Event event : block.events) {
                function.appendParsed(event);
            }
            //TODO function.appendParsed(block.terminator);
            for (final Map.Entry<BlockPair, List<Event>> phiNode : phiNodes.entrySet()) {
                if (phiNode.getKey().from == block) {
                    for (Event event : phiNode.getValue()) {
                        function.appendParsed(event);
                    }
                    function.appendParsed(newGoto(phiNode.getKey().to.label));
                }
            }
        }
        function.validate();
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
        // each visitor may treat the register differently
        // i.e. a loadInst generates a load event
        currentRegisterName = ctx.LocalIdent().getText();
        final Expression expression = ctx.valueInstruction().accept(this);
        currentRegisterName = null;

        if (!(expression instanceof Register)) {
            throw new UnsupportedOperationException(String.format("Parsing of instruction %s.", ctx.getText()));
        }
        return null;
    }

    private Register newRegister(Type type) {
        return function.newRegister(currentRegisterName, type);
    }

    @Override
    public Expression visitStoreInst(StoreInstContext ctx) {
        final var atomic = ctx.atomic != null;
        final TypeValueContext addressContext = ctx.typeValue(0);
        final TypeValueContext valueContext = ctx.typeValue(1);
        checkPointerType(addressContext);
        final Expression address = checkPointerExpression(addressContext.value());
        final Type type = parseType(valueContext.firstClassType());
        final Expression value = checkExpression(type, valueContext.value());
        final String mo = atomic ? parseMemoryOrder(ctx.atomicOrdering()) : "";
        final Event store = atomic ? Llvm.newStore(address, value, mo) : newStore(address, value);
        block.events.add(store);
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instructions producing a value

    @Override
    public Expression visitAllocaInst(AllocaInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#alloca-instruction
        final Register register = newRegister(pointerType);
        //final var inalloca = ctx.inAllocaTok != null;
        //final var swifterror = ctx.swiftError != null;
        //final Type elementType = parseType(ctx.type());
        final Expression sizeExpression;
        if (ctx.typeValue() == null) {
            sizeExpression = expressions.makeOne(integerType);
        } else {
            final Type sizeType = parseType(ctx.typeValue().firstClassType());
            sizeExpression = checkExpression(sizeType, ctx.typeValue().value());
        }
        //final int alignment = parseAlignment(ctx.align());
        //final int addressSpace = parseAddressSpace(ctx.addrSpace());
        block.events.add(Std.newMalloc(register, sizeExpression));
        return register;
    }

    @Override
    public Expression visitLoadInst(LoadInstContext ctx) {
        final var atomic = ctx.atomic != null;
        final Register register = newRegister(parseType(ctx.type()));
        //final var isVolatile = ctx.llvmvolatile != null;
        //final SyncScopeContext syncScope = ctx.syncScope(); // == null || atomic
        //final AlignContext align = ctx.align(); // nullable
        final String mo = atomic ? parseMemoryOrder(ctx.atomicOrdering()) : "";
        checkPointerType(ctx.typeValue());
        final Expression address = checkPointerExpression(ctx.typeValue().value());
        final Event load = atomic ? Llvm.newLoad(register, address, mo) : newLoad(register, address);
        block.events.add(load);
        return register;
    }

    @Override
    public Expression visitPhiInst(PhiInstContext ctx) {
        final Type type = parseType(ctx.type());
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
        checkSupport(ctx.inlineAsm() == null, "Assembly values.", ctx);
        assert expectedType != null : "No expected type.";
        final String id = ctx.LocalIdent().getText();
        return function.getOrNewRegister(id, expectedType);
    }

    @Override
    public Expression visitAddInst(AddInstContext ctx) {
        final Type type = parseType(ctx.typeValue().firstClassType());
        final Expression left = checkExpression(type, ctx.typeValue().value());
        final Expression right = checkExpression(type, ctx.value());
        return expressions.makeADD(left, right);
    }

    @Override
    public Expression visitGetElementPtrInst(GetElementPtrInstContext ctx) {
        final Type type = parseType(ctx.type());
        final var operands = new ArrayList<Expression>();
        for (final TypeValueContext typeValue : ctx.typeValue()) {
            final Type operandType = parseType(typeValue.firstClassType());
            operands.add(checkExpression(operandType, typeValue.value()));
        }
        assert !operands.isEmpty();
        return expressions.makeGetElementPointer(type, operands.get(0), operands.subList(1, operands.size()));
    }

    @Override
    public Expression visitCmpXchgInst(CmpXchgInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#cmpxchg-instruction
        final Type addressType = checkPointerType(ctx.typeValue(0));
        final Type comparatorType = parseType(ctx.typeValue(1).firstClassType());
        final Type substituteType = parseType(ctx.typeValue(2).firstClassType());
        check(comparatorType.equals(substituteType), "Type mismatch for comparator and new in %s.", ctx);
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

    private Expression checkPointerExpression(ParserRuleContext context) {
        return checkExpression(types.getArchType(), context);
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

    @Override
    public Expression visitOpaquePointerType(OpaquePointerTypeContext ctx) {
        parsedType = types.getArchType();
        return null;
    }

    private Type parseIntType(TerminalNode t) {
        assert t.getText().startsWith("i");
        return types.getIntegerType(Integer.parseUnsignedInt(t.getText().substring(1)));
    }

    private Type parseType(ParserRuleContext context) {
        Expression o = context.accept(this);
        assert o == null : "Unexpected return value, expected type.";
        checkSupport(parsedType != null, "Unsupported type.", context);
        Type type = parsedType;
        parsedType = null;
        return type;
    }

    private void checkLabelType(FirstClassTypeContext context) {
        if (context.concreteType() == null || context.concreteType().labelType() == null) {
            throw new ParsingException(String.format("Expected label type, got %s.", context.getText()));
        }
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Helpers

    private void check(boolean condition, String message, ParserRuleContext context) {
        if (!condition) {
            throw new ParsingException(String.format(message, context.getText()));
        }
    }

    private void checkSupport(boolean condition, String message, ParserRuleContext context) {
        if (!condition) {
            throw new ParsingException(String.format("Unsupported: " + message, context.getText()));
        }
    }

    private Type checkPointerType(TypeValueContext context) {
        final ConcreteTypeContext concreteTypeContext = context.firstClassType().concreteType();
        // NOTE this also accepts the legacy pointer types, but discards their element type information.
        if (concreteTypeContext == null || concreteTypeContext.pointerType() == null) {
            throw new ParsingException(
                    String.format("Expected pointer type, instead of %s.", context.firstClassType().getText()));
        }
        return types.getArchType();
    }

    private boolean parseBoolean(TerminalNode node) {
        return Boolean.parseBoolean(node.getText());
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