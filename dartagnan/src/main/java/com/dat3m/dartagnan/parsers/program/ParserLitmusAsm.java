package com.dat3m.dartagnan.parsers.program;

import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.type.FunctionType;
import com.dat3m.dartagnan.expression.type.IntegerType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.parsers.LitmusAsm;
import com.dat3m.dartagnan.parsers.LitmusAsm.*;
import com.dat3m.dartagnan.parsers.LitmusAsmBaseVisitor;
import com.dat3m.dartagnan.parsers.LitmusAsmLexer;
import com.dat3m.dartagnan.program.Entrypoint;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.Thread;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.memory.FinalMemoryValue;
import com.dat3m.dartagnan.program.memory.Memory;
import com.dat3m.dartagnan.program.memory.MemoryObject;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.DiagnosticErrorListener;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.math.BigInteger;
import java.util.List;

import static com.dat3m.dartagnan.program.Program.SpecificationType.*;

class ParserLitmusAsm implements ParserInterface {

    private static final TypeFactory types = TypeFactory.getInstance();
    private static final ExpressionFactory expressions = ExpressionFactory.getInstance();

    private final ParserAsmSupplier asmParser;
    private final IntegerType pointerType;

    ParserLitmusAsm(ParserAsmSupplier asmParser, boolean mode32) {
        this.asmParser = asmParser;
        this.pointerType = types.getIntegerType(mode32 ? 32 : 64);
    }

    interface ParserAsmSupplier {
        ParserAsm create(Function function);
    }

    @Override
    public Program parse(CharStream charStream) {
        final var lexer = new LitmusAsmLexer(charStream);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        final var parser = new LitmusAsm(new CommonTokenStream(lexer));
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        final var program = new Program(new Memory(), Program.SourceLanguage.LITMUS);//TODO name
        final MainContext main = parser.main();
        final var visitor = new VisitorLitmusAsm(program, pointerType);
        parseThreads(program, main.threads());
        main.declarators().accept(visitor);
        parseInstructions(program, main.instructions(), asmParser);
        parseFilter(program, main.filter());
        parseAssertion(program, main.assertion());
        //TODO final List<String> zeroRegs = Arrays.asList("XZR", "WZR");
        //TODO markLoadsIntoZeroRegisters(prog, zeroRegs);
        //TODO replaceZeroRegisters(prog, zeroRegs);
        program.setEntrypoint(new Entrypoint.Resolved());
        program.getMemory().getObjects().forEach(object -> {
            if (object.getInitializedFields().isEmpty()) {
                object.setInitialValue(0, expressions.makeZero(types.getIntegerType(8 * object.getKnownSize())));
            }
        });
        return program;
    }

    private static final class VisitorLitmusAsm extends LitmusAsmBaseVisitor<Void> {

        private final Program program;
        private final IntegerType pointerType;

        private VisitorLitmusAsm(Program p, IntegerType t) { program = p; pointerType = t; }

        @Override
        public Void visitDeclaratorArray(DeclaratorArrayContext ctx) {
            final int typeBytes = typeBytes(ctx.type.getText());
            final int arraySize = Integer.parseInt(ctx.size.getText());
            //TODO check for redefinition
            final MemoryObject array = program.getMemory().allocate(arraySize * typeBytes);
            array.setName(ctx.object().getText());
            return null;
        }

        @Override
        public Void visitDeclaratorObject(DeclaratorObjectContext ctx) {
            final IntegerType type = type(ctx.type);
            final Expression value = constant(ctx.constant(), type);
            //TODO check for redefinition
            final MemoryObject location = program.getMemory().allocate(types.getMemorySizeInBytes(type));
            location.setName(ctx.object().getText());
            location.setInitialValue(0, value);
            return null;
        }

        @Override
        public Void visitDeclaratorRegister(DeclaratorRegisterContext ctx) {
            final IntegerType type = type(ctx.type);
            final Expression value = constant(ctx.constant(), type);
            final Thread thread = parseThreadFromRegister(ctx.register(), program);
            final Register register = thread.getOrNewRegister(ctx.register().name.getText(), type);
            thread.append(EventFactory.newLocal(register, value));
            return null;
        }

        private Expression constant(ConstantContext ctx, IntegerType type) {
            if (ctx == null) {
                return expressions.makeZero(type);
            }
            if (ctx.location() != null) {
                final String name = ctx.location().getText();
                final MemoryObject foundObject =
                        program.getMemory().getObjects().stream().filter(o -> name.equals(o.getName())).findAny()
                                .orElse(null);
                if (foundObject != null) {
                    return foundObject;
                }
                final MemoryObject newObject = program.getMemory().allocate(types.getMemorySizeInBytes(pointerType));
                newObject.setName(name);
                newObject.setInitialValue(0, expressions.makeZero(pointerType));
                return newObject;
            }
            return parseLiteral(ctx.literal(), type);
        }

        private IntegerType type(Token ignore) {
            return pointerType;
        }
    }

    private static void parseThreads(Program program, ThreadsContext ctx) {
        final List<TerminalNode> declarators = ctx.Thread();
        final FunctionType threadType = types.getFunctionType(types.getVoidType(), List.of());
        for (int i = 0; i < declarators.size(); i++) {
            final String name = declarators.get(i).getText();
            final Thread thread = new Thread(name, threadType, List.of(), i, EventFactory.newThreadStart(null));
            program.addThread(thread);
        }
    }

    private static void parseInstructions(Program program, InstructionsContext ctx, ParserAsmSupplier assembler) {
        final var threads = new StringBuilder[program.getThreads().size()];
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new StringBuilder();
        }
        for (InstructionRowContext row : ctx.instructionRow()) {
            final List<InstructionContext> cells = row.instruction();
            for (int i = 0; i < threads.length; i++) {
                final String text = cells.get(i).getText();
                threads[i].append(text).append('\n');
            }
        }
        for (int i = 0; i < threads.length; i++) {
            final Thread thread = program.getThreads().get(i);
            final ParserAsm parser = assembler.create(thread);
            final List<Event> events = parser.parse(CharStreams.fromString(threads[i].toString()));
            thread.append(events);
        }
    }

    private static void parseFilter(Program program, FilterContext filter) {
        if (filter != null) {
            program.setFilterSpecification(filter.condition().accept(new ConditionVisitor(program)));
        }
    }

    private static void parseAssertion(Program program, AssertionContext ctx) {
        if (ctx != null) {
            final boolean exists = ctx.Exists() != null || ctx.Final() != null;
            final boolean notExists = ctx.Notexists() != null;
            final boolean forall = ctx.Forall() != null;
            if (!exists && !notExists && !forall) {
                throw new ParsingException("Unrecognised assertion type");
            }
            final Program.SpecificationType type = exists ? EXISTS : notExists ? NOT_EXISTS : FORALL;
            program.setSpecification(type, ctx.condition().accept(new ConditionVisitor(program)));
        }
    }

    private static final class ConditionVisitor extends LitmusAsmBaseVisitor<Expression> {

        private final Program program;

        private ConditionVisitor(Program p) { program = p; }

        @Override
        public Expression visitConditionPar(ConditionParContext ctx) {
            return ctx.condition().accept(this);
        }

        @Override
        public Expression visitConditionNot(ConditionNotContext ctx) {
            return expressions.makeNot(ctx.condition().accept(this));
        }

        @Override
        public Expression visitConditionAnd(ConditionAndContext ctx) {
            return expressions.makeAnd(ctx.condition(0).accept(this), ctx.condition(1).accept(this));
        }

        @Override
        public Expression visitConditionOr(ConditionOrContext ctx) {
            return expressions.makeOr(ctx.condition(0).accept(this), ctx.condition(1).accept(this));
        }

        @Override
        public Expression visitConditionEq(ConditionEqContext ctx) {
            final Expression lhs = parseValue(ctx.lvalue(), false);
            return expressions.makeEQ(lhs, parseValue(ctx.rvalue(), lhs));
        }

        private Expression parseValue(LvalueContext ctx, boolean right) {
            final RegisterContext register = ctx.register();
            if (register != null) {
                return parseThreadFromRegister(register, program).getRegister(register.name.getText());
            }
            final String name = ctx.object().name.getText();
            final MemoryObject base = program.getMemory().getObjects().stream()
                    .filter(o -> o.hasName() && o.getName().equals(name))
                    .findAny().orElse(null);
            if (right) {
                assert base != null;
                return base;
            }
            final int offset = ctx.Digits() == null ? 0 : Integer.parseInt(ctx.Digits().getText());
            final IntegerType type = types.getIntegerType(Math.min(64, 8 * base.getKnownSize()));
            return new FinalMemoryValue(name, type, base, offset);
        }

        private Expression parseValue(RvalueContext ctx, Expression lhs) {
            final var type = lhs.getType() instanceof IntegerType t ? t : null;
            return ctx.lvalue() != null ? parseValue(ctx.lvalue(), true) : parseLiteral(ctx.literal(), type);
        }
    }

    private static Expression parseLiteral(LiteralContext ctx, IntegerType type) {
        final String text = ctx.getText();
        if (ctx.Hexdigits() != null) {
            return expressions.makeValue(new BigInteger(text.substring(2), 16), type);
        }
        return expressions.makeValue(new BigInteger(text), type);
    }

    private static Thread parseThreadFromRegister(RegisterContext register, Program program) {
        if (register.threadId != null) {
            return program.getThreads().get(Integer.parseInt(register.threadId.getText()));
        }
        final String name = register.threadName.getText();
        return program.getThreads().stream()
                .filter(t -> name.equals(t.getName()))
                .findAny().orElseThrow();
    }

    private static int typeBytes(String ignore) {
        return 8; // Defaults to 64 bits.
    }
}
