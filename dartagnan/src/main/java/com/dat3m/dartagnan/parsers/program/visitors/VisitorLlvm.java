package com.dat3m.dartagnan.parsers.program.visitors;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.IConst;
import com.dat3m.dartagnan.expression.INonDet;
import com.dat3m.dartagnan.expression.op.IOpBin;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.Type;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.expression.type.VoidType;
import com.dat3m.dartagnan.parsers.LLVMIRBaseVisitor;
import com.dat3m.dartagnan.parsers.LLVMIRParser.*;
import com.dat3m.dartagnan.parsers.program.utils.ProgramBuilder;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Tag;
import com.dat3m.dartagnan.program.event.core.*;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import com.dat3m.dartagnan.program.processing.GEPToAddition;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.*;

import static com.dat3m.dartagnan.program.event.EventFactory.*;
import static com.dat3m.dartagnan.program.event.EventFactory.Llvm.newCompareExchange;
import static com.google.common.base.Preconditions.checkState;
import static com.google.common.base.Verify.verify;

public class VisitorLlvm extends LLVMIRBaseVisitor<Expression> {

    // Global context
    private final Program program = new Program(new Memory(), Program.SourceLanguage.LLVM);
    private final TypeFactory types = TypeFactory.getInstance();
    private final ExpressionFactory expressions = ExpressionFactory.getInstance();
    private final Type pointerType = GlobalSettings.getArchPrecision() == -1 ?
            // Intentionally ignore the given precision for pointers
            types.getIntegerType() : types.getIntegerType(64);
    private final IntegerType integerType = types.getArchType();
    private final Map<String, Expression> constantMap = new HashMap<>();
    private final Map<String, Type> typeMap = new HashMap<>();
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

    @Override
    public Expression visitCompilationUnit(CompilationUnitContext ctx) {
        // Create the metadata mapping beforehand, so that instructions can get all attachments
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.metadataDef() != null) {
                entity.accept(this);
            }
        }
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.globalDecl() != null || entity.globalDef() != null || entity.typeDef() != null) {
                entity.accept(this);
            }
            if (entity.funcDecl() != null) {
                visitFuncHeader(entity.funcDecl().funcHeader());
            }
            if (entity.funcDef() != null) {
                visitFuncHeader(entity.funcDef().funcHeader());
            }
        }
        for (final TopLevelEntityContext entity : ctx.topLevelEntity()) {
            if (entity.metadataDef() == null &&
                    entity.globalDecl() == null &&
                    entity.globalDef() == null &&
                    entity.typeDef() == null &&
                    entity.funcDecl() == null) {
                entity.accept(this);
            }
        }
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Top Level Entities

    @Override
    public Expression visitTypeDef(TypeDefContext ctx) {
        final String name = localIdent(ctx.LocalIdent());
        final Type type = parseType(ctx.type());
        final Type oldType = typeMap.putIfAbsent(name, type);
        check(oldType == null, "Type redefinition in %s.", ctx);
        return null;
    }

    @Override
    public Expression visitFuncHeader(FuncHeaderContext ctx) {
        final String name = globalIdent(ctx.GlobalIdent());
        final Type returnType = parseType(ctx.type());
        final List<Type> parameterTypes = new ArrayList<>();
        final List<String> parameterNames = new ArrayList<>();
        int unnamedParameters = 0;
        for (ParamContext parameter : ctx.params().param()) {
            if (parameter.type().getText().equals("metadata")) {
                //TODO also declare this.
                return null;
            }
            parameterTypes.add(parseType(parameter.type()));
            final String parameterName = parameter.LocalIdent() != null ?
                    localIdent(parameter.LocalIdent()) :
                    "dummy_" + (unnamedParameters++);
            parameterNames.add(adjustRegisterName(parameterName));
        }
        final FunctionType functionType = types.getFunctionType(returnType, parameterTypes);
        //TODO there are more attributes in ctx
        final var declaredFunction = new Function(name, functionType, parameterNames, functionCounter++, null);
        program.addFunction(declaredFunction);
        constantMap.put(name, declaredFunction);
        return null;
    }

    @Override
    public Expression visitFuncDecl(FuncDeclContext ctx) {
        // Do nothing, already declared from visitFuncHeader
        return null;
    }

    @Override
    public Expression visitFuncDef(FuncDefContext ctx) {
        // Assert the function was already declared from visitFuncHeader
        final String name = globalIdent(ctx.funcHeader().GlobalIdent());
        function = program.getFunctions().stream()
                .filter(f -> f.getName().equals(name))
                .findAny().orElseThrow();
        // The grammar requires at least one block, thus an entry and an exit.
        for (final BasicBlockContext basicBlockContext : ctx.funcBody().basicBlock()) {
            block = getBlock(basicBlockContext.LabelIdent());
            for (final InstructionContext instructionContext : basicBlockContext.instruction()) {
                instructionContext.accept(this);
            }
            basicBlockContext.terminator().accept(this);
            block = null;
        }
        //TODO validate: all basic blocks have a terminator, there is one entry, at least one exit, etc.
        for (final BasicBlockContext basicBlockContext : ctx.funcBody().basicBlock()) {
            final Block block = getBlock(basicBlockContext.LabelIdent());
            function.appendParsed(block.label);
            for (final Event event : block.events) {
                function.appendParsed(event);
            }
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
        basicBlocks.clear();
        phiNodes.clear();
        return null;
    }

    private Block getBlock(TerminalNode node) {
        final String ident = node == null ? null : node.getText();
        assert ident == null || ident.endsWith(":");
        // In serialized form, only the entry block should be able to omit its label.
        // The label is named using a counter for temporaries, which resets for each function.
        // see https://llvm.org/docs/LangRef.html#functions
        // This code assumes that all function parameters are also using this counter.
        final String labelName = ident == null ?
                String.valueOf(function.getParameterRegisters().size()) :
                //FIXME this replacing avoids conflicts with LoopAnalysis
                ident.substring(0, ident.length() - 1).replace(".loop", ".\\loop");
        return getBlock(labelName);
    }

    @Override
    public Expression visitGlobalDecl(GlobalDeclContext ctx) {
        final String name = globalIdent(ctx.GlobalIdent());
        check(constantMap.containsKey(name), "Redefined constant in %s.", ctx);
        final Type type = parseType(ctx.type());
        final Expression expression;
        if (ctx.immutable().getText().equals("global")) {
            final int size = GEPToAddition.getMemorySize(type);
            expression = program.getMemory().allocate(size, true);
            //TODO non-det initializer
        } else {
            assert ctx.immutable().getText().equals("constant");
            checkSupport(type instanceof IntegerType, "Non-integer in %s.", ctx);
            final var constant = new INonDet(program.getConstants().size(), (IntegerType) type, false);
            program.addConstant(constant);
            expression = constant;
        }
        constantMap.put(name, expression);
        return null;
    }

    @Override
    public Expression visitGlobalDef(GlobalDefContext ctx) {
        final String name = globalIdent(ctx.GlobalIdent());
        check(!constantMap.containsKey(name), "Redefined constant in %s.", ctx);
        final Type type = parseType(ctx.type());
        final Expression value = checkExpression(type, ctx.constant());
        final Expression expression;
        if (ctx.immutable().getText().equals("global")) {
            final int size = GEPToAddition.getMemorySize(type);
            expression = program.getMemory().allocate(size, true);
            ((MemoryObject) expression).setCVar(name);
            // In case of zero-initializer, there is no particular value
            if (value != null) {
                checkSupport(value instanceof IConst, "Non-constant in %s.", ctx);
                ((MemoryObject) expression).setInitialValue(0, (IConst) value);
            }
        } else {
            assert ctx.immutable().getText().equals("constant");
            expression = value;
        }
        constantMap.put(name, expression);
        return null;
    }

    private Block getBlock(String label) {
        return basicBlocks.computeIfAbsent(label,
                k -> {
                    final Label l = newLabel("l" + k);
                    l.setFunction(function);
                    return new Block(l);
                });
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Terminators

    @Override
    public Expression visitBrTerm(BrTermContext ctx) {
        block.events.add(newGoto(getJumpLabel(ctx.label())));
        return null;
    }

    @Override
    public Expression visitCondBrTerm(CondBrTermContext ctx) {
        final Type type = parseIntType(ctx.IntType());
        final Expression guard = checkExpression(type, ctx.value());
        final Expression cast = expressions.makeBooleanCast(guard);
        block.events.add(newJump(cast, getJumpLabel(ctx.label(0))));
        block.events.add(newGoto(getJumpLabel(ctx.label(1))));
        return null;
    }

    @Override
    public Expression visitCallInst(CallInstContext ctx) {
        final Type returnType = parseType(ctx.type());
        final Expression callTarget = checkPointerExpression(ctx.value());
        if (callTarget == null) {
            //FIXME ignores metadata functions, but also undeclared functions
            return null;
        }
        checkSupport(callTarget instanceof Function, "Indirect call in %s.", ctx);
        final var target = (Function) callTarget;
        final var arguments = new ArrayList<Expression>();
        for (final ArgContext argument : ctx.args().arg()) {
            if (argument.value() == null) {
                //TODO metadata calls are ignored
                return null;
            }
            assert argument.concreteType() != null;
            final Type argumentType = parseType(argument.concreteType());
            arguments.add(checkExpression(argumentType, argument.value()));
        }
        final Register resultRegister = currentRegisterName == null ? null :
                getOrNewRegister(currentRegisterName, returnType);
        final Event call = currentRegisterName == null ?
                newVoidFunctionCall(target, arguments) :
                newValueFunctionCall(resultRegister, target, arguments);
        block.events.add(call);
        return resultRegister;
    }

    @Override
    public Expression visitRetTerm(RetTermContext ctx) {
        final Expression value;
        if (ctx.concreteType() != null) {
            final Type type = parseType(ctx.concreteType());
            value = type instanceof VoidType ? null : checkExpression(type, ctx.value());
        } else {
            value = null;
        }
        block.events.add(newFunctionReturn(value));
        return null;
    }

    private Label getJumpLabel(LabelContext context) {
        final Block target = getBlock(localIdent(context.LocalIdent()));
        final Event label = getPhiNode(block, target).get(0);
        verify(label instanceof Label);
        return (Label) label;
    }

    private List<Event> getPhiNode(Block from, Block to) {
        final BlockPair pair = new BlockPair(from, to);
        final List<Event> find = phiNodes.get(pair);
        if (find != null) {
            return find;
        }
        final var newNode = new ArrayList<Event>();
        newNode.add(newLabel(from.label.getName() + "." + to.label.getName()));
        phiNodes.put(pair, newNode);
        return newNode;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instructions

    @Override
    public Expression visitLocalDefInst(LocalDefInstContext ctx) {
        // each visitor may treat the register differently
        // i.e. a loadInst generates a load event
        currentRegisterName = localIdent(ctx.LocalIdent());
        final Expression expression = ctx.valueInstruction().accept(this);
        currentRegisterName = null;

        if (!(expression instanceof Register)) {
            throw new UnsupportedOperationException(String.format("Parsing of instruction %s.", ctx.getText()));
        }
        return null;
    }

    private Register getOrNewCurrentRegister(Type type) {
        return getOrNewRegister(currentRegisterName, type);
    }

    private Register assignToRegister(Expression expression) {
        Register register = getOrNewCurrentRegister(expression.getType());
        block.events.add(newLocal(register, expression));
        return register;
    }

    @Override
    public Expression visitStoreInst(StoreInstContext ctx) {
        final var atomic = ctx.atomic != null;
        final Expression value = visitTypeValue(ctx.typeValue(0));
        final Expression address = visitTypeValue(ctx.typeValue(1));
        check(address.getType().equals(pointerType), "Non-pointer type in %s.", ctx);
        final String mo = atomic ? parseMemoryOrder(ctx.atomicOrdering()) : "";
        final Event store = atomic ? Llvm.newStore(address, value, mo) : newStore(address, value);
        block.events.add(store);
        return null;
    }

    @Override
    public Expression visitFenceInst(FenceInstContext ctx) {
        final String mo = parseMemoryOrder(ctx.atomicOrdering());
        block.events.add(Llvm.newFence(mo));
        return null;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Instructions producing a value

    @Override
    public Expression visitAllocaInst(AllocaInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#alloca-instruction
        final Register register = getOrNewCurrentRegister(pointerType);
        //final var inalloca = ctx.inAllocaTok != null;
        //final var swifterror = ctx.swiftError != null;
        final Type elementType = parseType(ctx.type());
        final int elementSize = GEPToAddition.getMemorySize(elementType);
        final Expression sizeExpression;
        if (ctx.typeValue() == null) {
            sizeExpression = expressions.makeOne(integerType);
        } else {
            final Type sizeType = parseType(ctx.typeValue().firstClassType());
            sizeExpression = checkExpression(sizeType, ctx.typeValue().value());
        }
        final IntegerType offsetType = (IntegerType) sizeExpression.getType();
        final Expression factor = expressions.makeValue(BigInteger.valueOf(elementSize), offsetType);
        final Expression scaledSizeExpression = expressions.makeMUL(factor, sizeExpression);
        //final int alignment = parseAlignment(ctx.align());
        //final int addressSpace = parseAddressSpace(ctx.addrSpace());
        block.events.add(Std.newMalloc(register, scaledSizeExpression));
        return register;
    }

    @Override
    public Expression visitLoadInst(LoadInstContext ctx) {
        final var atomic = ctx.atomic != null;
        final Register register = getOrNewCurrentRegister(parseType(ctx.type()));
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
        final Register register = getOrNewCurrentRegister(type);
        for (final IncContext inc : ctx.inc()) {
            final Block target = getBlock(localIdent(inc.LocalIdent()));
            final Expression expression = checkExpression(type, inc.value());
            getPhiNode(target, block).add(newLocal(register, expression));
        }
        return register;
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Calculations

    @Override
    public Expression visitICmpInst(ICmpInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        final String operator = ctx.iPred().getText();
        final Expression compared = switch (operator) {
            case "eq" -> expressions.makeEQ(left, right);
            case "ne" -> expressions.makeNEQ(left, right);
            case "slt", "ult" -> expressions.makeLT(left, right, operator.startsWith("s"));
            case "sle", "ule" -> expressions.makeLTE(left, right, operator.startsWith("s"));
            case "sgt", "ugt" -> expressions.makeGT(left, right, operator.startsWith("s"));
            case "sge", "uge" -> expressions.makeGTE(left, right, operator.startsWith("s"));
            default -> throw new ParsingException(String.format("Unknown predicate in %s.", ctx.getText()));
        };
        // LLVM does not support a distinct boolean type.
        return assignToRegister(expressions.makeIntegerCast(compared, getIntegerType(1), false));
    }

    @Override
    public Expression visitAddInst(AddInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeADD(left, right));
    }

    @Override
    public Expression visitSubInst(SubInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeSUB(left, right));
    }

    @Override
    public Expression visitMulInst(MulInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeMUL(left, right));
    }

    @Override
    public Expression visitShlInst(ShlInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeLSH(left, right));
    }

    @Override
    public Expression visitLShrInst(LShrInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeRSH(left, right, false));
    }

    @Override
    public Expression visitAShrInst(AShrInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeRSH(left, right, true));
    }

    @Override
    public Expression visitAndInst(AndInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeAND(left, right));
    }

    @Override
    public Expression visitOrInst(OrInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeOR(left, right));
    }

    @Override
    public Expression visitXorInst(XorInstContext ctx) {
        final Expression left = visitTypeValue(ctx.typeValue());
        final Expression right = checkExpression(left.getType(), ctx.value());
        return assignToRegister(expressions.makeXOR(left, right));
    }

    // Aggregate instructions

    @Override
    public Expression visitExtractValueInst(ExtractValueInstContext ctx) {
        final Type type = parseType(ctx.typeValue().firstClassType());
        check(type instanceof AggregateType, "Non-aggregate type in %s.", ctx);
        Expression expression = checkExpression(type, ctx.typeValue().value());
        for (final TerminalNode literalNode : ctx.IntLit()) {
            final int index = Integer.parseInt(literalNode.getText());
            expression = expressions.makeExtract(index, expression);
        }
        return assignToRegister(expression);
    }

    @Override
    public Expression visitGetElementPtrInst(GetElementPtrInstContext ctx) {
        final Type type = parseType(ctx.type());
        final var operands = new ArrayList<Expression>();
        for (final TypeValueContext typeValue : ctx.typeValue()) {
            operands.add(visitTypeValue(typeValue));
        }
        assert !operands.isEmpty();
        return assignToRegister(
                expressions.makeGetElementPointer(type, operands.get(0), operands.subList(1, operands.size())));
    }

    @Override
    public Expression visitSelectInst(SelectInstContext ctx) {
        assert ctx.typeValue().size() == 3;
        final Expression guard = visitTypeValue(ctx.typeValue(0));
        final Expression trueValue = visitTypeValue(ctx.typeValue(1));
        final Expression falseValue = visitTypeValue(ctx.typeValue(2));
        final Expression cast = expressions.makeBooleanCast(guard);
        return assignToRegister(expressions.makeConditional(cast, trueValue, falseValue));
    }

    @Override
    public Expression visitCmpXchgInst(CmpXchgInstContext ctx) {
        // see https://llvm.org/docs/LangRef.html#cmpxchg-instruction
        // TODO LLVM has no distinguished boolean type.
        final Expression address = visitTypeValue(ctx.typeValue(0));
        final Expression comparator = visitTypeValue(ctx.typeValue(1));
        final Expression substitute = visitTypeValue(ctx.typeValue(2));
        check(comparator.getType().equals(substitute.getType()), "Type mismatch for comparator and new in %s.", ctx);
        final Register value = function.newRegister(comparator.getType());
        final Register asExpected = function.newRegister(types.getBooleanType());
        final boolean weak = ctx.weak != null;
        final String mo = parseMemoryOrder(ctx.atomicOrdering(0));
        block.events.add(newCompareExchange(value, asExpected, address, comparator, substitute, mo, weak));
        final Register register = currentRegisterName == null ? null :
                getOrNewCurrentRegister(types.getAggregateType(List.of(comparator.getType(), getIntegerType(1))));
        if (register != null) {
            final Expression cast = expressions.makeIntegerCast(asExpected, getIntegerType(1), false);
            final Expression result = expressions.makeConstruct(List.of(value, cast));
            block.events.add(newLocal(register, result));
        }
        return register;
    }

    @Override
    public Expression visitAtomicRMWInst(AtomicRMWInstContext ctx) {
        final Expression address = visitTypeValue(ctx.typeValue(0));
        final Expression operand = visitTypeValue(ctx.typeValue(1));
        final Type valueType = operand.getType();
        final Register register = getOrNewCurrentRegister(valueType);
        final String operator = ctx.atomicOp().getText();
        final String mo = parseMemoryOrder(ctx.atomicOrdering());
        final Event event;
        if (operator.equals("xchg")) {
            event = Llvm.newExchange(register, address, operand, mo);
        } else {
            final IOpBin op = switch (operator) {
                case "add" -> IOpBin.PLUS;
                case "sub" -> IOpBin.MINUS;
                case "and" -> IOpBin.AND;
                case "or" -> IOpBin.OR;
                case "xor" -> IOpBin.XOR;
                //TODO nand, min, umin, max, umax, uinc_wrap, udec_wrap, fadd, fsub, fmax, fmin
                default -> throw new UnsupportedOperationException(String.format("Unknown atomic operand %s.", ctx.getText()));
            };
            event = Llvm.newRMW(register, address, operand, op, mo);
        }
        block.events.add(event);
        return register;
    }

    // Conversions

    @Override
    public Expression visitTruncInst(TruncInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), false);
    }

    @Override
    public Expression visitZExtInst(ZExtInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), false);
    }

    @Override
    public Expression visitSExtInst(SExtInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitPtrToIntInst(PtrToIntInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitIntToPtrInst(IntToPtrInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitBitCastInst(BitCastInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    @Override
    public Expression visitAddrSpaceCastInst(AddrSpaceCastInstContext ctx) {
        return conversionInstruction(ctx.typeValue(), ctx.type(), true);
    }

    private Register conversionInstruction(TypeValueContext operand, TypeContext target, boolean signed) {
        final Expression operandExpression = visitTypeValue(operand);
        final Type targetType = parseType(target);
        checkSupport(targetType instanceof IntegerType, "Non-integer in %s.", target);
        final Expression result = expressions.makeIntegerCast(operandExpression, (IntegerType) targetType, signed);
        return assignToRegister(result);
    }

    // =================================================================================================================
    // Expressions

    @Override
    public Expression visitConstant(ConstantContext ctx) {
        if (ctx.GlobalIdent() == null) {
            return super.visitConstant(ctx);
        }
        final String name = globalIdent(ctx.GlobalIdent());
        //TODO check for null.  Currently, this ignores metadata functions.
        return constantMap.get(name);
    }

    @Override
    public Expression visitNullConst(NullConstContext ctx) {
        return expressions.makeZero((IntegerType) pointerType);
    }

    @Override
    public Expression visitIntConst(IntConstContext ctx) {
        final BigInteger value = parseBigInteger(ctx.IntLit());
        checkState(expectedType instanceof IntegerType, "Expected non-integer type.");
        return expressions.makeValue(value, (IntegerType) expectedType);
    }

    @Override
    public Expression visitValue(ValueContext ctx) {
        if (ctx.constant() != null) {
            return visitConstant(ctx.constant());
        }
        checkSupport(ctx.inlineAsm() == null, "Assembly values in %s.", ctx);
        assert expectedType != null : "No expected type.";
        final String id = localIdent(ctx.LocalIdent());
        return getOrNewRegister(id, expectedType);
    }

    @Override
    public Expression visitTypeValue(TypeValueContext ctx) {
        final Type type = parseType(ctx.firstClassType());
        return checkExpression(type, ctx.value());
    }

    @Override
    public Expression visitArrayConst(ArrayConstContext ctx) {
        //TODO this is read-only memory
        if (ctx.StringLit() != null) {
            //TODO handle strings
            return program.getMemory().allocate(1, true);
        }
        final MemoryObject array = program.getMemory().allocate(ctx.typeConst().size(), true);
        for (int i = 0; i < ctx.typeConst().size(); i++) {
            final Expression element = visitTypeConst(ctx.typeConst(i));
            checkSupport(element instanceof IConst, "Non-constant in %s.", ctx);
            array.setInitialValue(i, (IConst) element);
        }
        return array;
    }

    // Operations

    @Override
    public Expression visitTypeConst(TypeConstContext ctx) {
        final Type type = parseType(ctx.firstClassType());
        return checkExpression(type, ctx.constant());
    }

    @Override
    public Expression visitAddExpr(AddExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeADD(left, right);
    }

    @Override
    public Expression visitSubExpr(SubExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeSUB(left, right);
    }

    @Override
    public Expression visitMulExpr(MulExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeMUL(left, right);
    }

    @Override
    public Expression visitShlExpr(ShlExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeLSH(left, right);
    }

    @Override
    public Expression visitLShrExpr(LShrExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeRSH(left, right, false);
    }

    @Override
    public Expression visitAShrExpr(AShrExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeRSH(left, right, true);
    }

    @Override
    public Expression visitAndExpr(AndExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeAND(left, right);
    }

    @Override
    public Expression visitOrExpr(OrExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeOR(left, right);
    }

    @Override
    public Expression visitXorExpr(XorExprContext ctx) {
        assert ctx.typeConst().size() == 2;
        final Expression left = visitTypeConst(ctx.typeConst(0));
        final Expression right = visitTypeConst(ctx.typeConst(1));
        return expressions.makeXOR(left, right);
    }

    // Conversions

    @Override
    public Expression visitTruncExpr(TruncExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), false);
    }

    @Override
    public Expression visitZExtExpr(ZExtExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), false);
    }

    @Override
    public Expression visitSExtExpr(SExtExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitPtrToIntExpr(PtrToIntExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitIntToPtrExpr(IntToPtrExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitBitCastExpr(BitCastExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitAddrSpaceCastExpr(AddrSpaceCastExprContext ctx) {
        return castExpression(ctx.typeConst(), ctx.type(), true);
    }

    @Override
    public Expression visitGetElementPtrExpr(GetElementPtrExprContext ctx) {
        final Type indexingType = parseType(ctx.type());
        final Expression base = visitTypeConst(ctx.typeConst());
        final var offsets = new ArrayList<Expression>();
        for (final GepIndexContext index : ctx.gepIndex()) {
            offsets.add(visitTypeConst(index.typeConst()));
        }
        return expressions.makeGetElementPointer(indexingType, base, offsets);
    }

    @Override
    public Expression visitSelectExpr(SelectExprContext ctx) {
        assert ctx.typeConst().size() == 3;
        final Expression guard = visitTypeConst(ctx.typeConst(0));
        final Expression trueValue = visitTypeConst(ctx.typeConst(1));
        final Expression falseValue = visitTypeConst(ctx.typeConst(2));
        final Expression cast = expressions.makeBooleanCast(guard);
        return expressions.makeConditional(cast, trueValue, falseValue);
    }

    private Expression checkPointerExpression(ParserRuleContext context) {
        return checkExpression(pointerType, context);
    }

    private Expression checkExpression(Type type, ParserRuleContext context) {
        expectedType = type;
        Expression o = context.accept(this);
        expectedType = null;
        return o;
    }

    private Expression castExpression(TypeConstContext operand, TypeContext target, boolean signed) {
        final Expression operandExpression = visitTypeConst(operand);
        final Type targetType = parseType(target);
        checkSupport(targetType instanceof IntegerType, "Non-integer type %s.", target);
        return expressions.makeIntegerCast(operandExpression, (IntegerType) targetType, signed);
    }

    // ----------------------------------------------------------------------------------------------------------------
    // Types

    @Override
    public Expression visitIntType(IntTypeContext ctx) {
        parsedType = parseIntType(ctx.IntType());
        return null;
    }

    @Override
    public Expression visitPointerType(PointerTypeContext ctx) {
        parsedType = pointerType;
        return null;
    }

    @Override
    public Expression visitStructType(StructTypeContext ctx) {
        final var fields = new ArrayList<Type>();
        for (final TypeContext typeContext : ctx.type()) {
            fields.add(parseType(typeContext));
        }
        parsedType = types.getAggregateType(fields);
        return null;
    }

    @Override
    public Expression visitArrayType(ArrayTypeContext ctx) {
        final Type elementType = parseType(ctx.type());
        if (ctx.IntLit() == null) {
            parsedType = types.getArrayType(elementType);
        } else {
            final int size = Integer.parseUnsignedInt(ctx.IntLit().getText());
            parsedType = types.getArrayType(elementType, size);
        }
        return null;
    }

    @Override
    public Expression visitType(TypeContext ctx) {
        // translate opaque pointer types
        if (ctx.type() != null && ctx.params() == null || ctx.opaquePointerType() != null) {
            parsedType = pointerType;
            return null;
        }
        return super.visitType(ctx);
    }

    @Override
    public Expression visitNamedType(NamedTypeContext ctx) {
        final String name = localIdent(ctx.LocalIdent());
        parsedType = typeMap.get(name);
        check(parsedType != null, "Undefined named type %s.", ctx);
        return null;
    }

    private Type parseIntType(TerminalNode t) {
        assert t.getText().startsWith("i");
        return getIntegerType(Integer.parseUnsignedInt(t.getText().substring(1)));
    }

    private Type parseType(ParserRuleContext context) {
        Expression o = context.accept(this);
        assert o == null : "Unexpected return value, expected type.";
        checkSupport(parsedType != null || context.getText().equals("void"),
                "Unsupported type in %s.", context);
        Type type = parsedType != null ? parsedType : types.getVoidType();
        parsedType = null;
        return type;
    }

    private IntegerType getIntegerType(int precision) {
        return GlobalSettings.isMixedType() ? types.getIntegerType(precision) : types.getArchType();
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
            throw new UnsupportedOperationException(String.format(message, context.getText()));
        }
    }

    private Type checkPointerType(TypeValueContext context) {
        final ConcreteTypeContext concreteTypeContext = context.firstClassType().concreteType();
        // NOTE this also accepts the legacy pointer types, but discards their element type information.
        if (concreteTypeContext == null || concreteTypeContext.pointerType() == null) {
            throw new ParsingException(
                    String.format("Expected pointer type, instead of %s.", context.firstClassType().getText()));
        }
        return pointerType;
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

    private static String globalIdent(TerminalNode node) {
        final String ident = node.getText();
        assert ident.startsWith("@");
        return ident.substring(1).replace(".loop", ".\\loop");
    }

    private static String localIdent(TerminalNode node) {
        final String ident = node.getText();
        assert ident.startsWith("%");
        return ident.substring(1).replace(".loop", ".\\loop");
    }

    private Register getOrNewRegister(String name, Type type) {
        return function.getOrNewRegister(adjustRegisterName(name), type);
    }

    private static String adjustRegisterName(String original) {
        return "r" + original;
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