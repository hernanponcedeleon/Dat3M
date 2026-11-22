package com.dat3m.dartagnan.program.processing.compilation;

import com.dat3m.dartagnan.expression.Expression;
import com.dat3m.dartagnan.expression.ExpressionFactory;
import com.dat3m.dartagnan.expression.Type;
import com.dat3m.dartagnan.expression.type.AggregateType;
import com.dat3m.dartagnan.expression.type.TypeFactory;
import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.program.Function;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.program.event.EventFactory;
import com.dat3m.dartagnan.program.event.EventVisitor;
import com.dat3m.dartagnan.program.event.arch.StoreExclusive;
import com.dat3m.dartagnan.program.event.arch.tso.TSOXchg;
import com.dat3m.dartagnan.program.event.lang.linux.*;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmCmpXchg;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmLoad;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmRMWNoReturn;
import com.dat3m.dartagnan.program.event.lang.llvm.LlvmStore;

import com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme;
import com.google.common.base.Preconditions;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.util.Collections;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

import static com.dat3m.dartagnan.configuration.OptionNames.*;
import static com.dat3m.dartagnan.program.processing.compilation.VisitorPower.PowerScheme.LEADING_SYNC;
import static com.google.common.base.Verify.verify;

/*
    Compiles single events of a source language to a target architecture.
    The compilation schemes are implemented by subclasses of the nested Visitor class.
 */
@Options
public final class Compiler {

    // =========================== Configurables ===========================

    @Option(name = TARGET,
            description = "The target architecture to which the program shall be compiled to.",
            secure = true,
            toUppercase = true)
    private Arch target = Arch.C11;

    @Option(name = USE_RC11_TO_ARCH_SCHEME,
            description = "Use the RC11 to Arch (Power/ARMv8) compilation scheme to forbid out-of-thin-air behaviours.",
            secure = true,
            toUppercase = true)
    private boolean useRC11Scheme = false;

    @Option(name = C_TO_POWER_SCHEME,
            description = "Use the leading/trailing-sync compilation scheme from C to Power.",
            secure = true,
            toUppercase = true)
    private PowerScheme cToPowerScheme = LEADING_SYNC;

    // =====================================================================

    // The compilation scheme depends on the source language, which is known only once we see the program.
    private final Map<Program.SourceLanguage, Visitor> visitors = new EnumMap<>(Program.SourceLanguage.class);

    private Compiler() { }

    private Compiler(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        Preconditions.checkNotNull(target);
    }

    public static Compiler fromConfig(Configuration config) throws InvalidConfigurationException {
        return new Compiler(config);
    }

    // Compiles to the default target with the default schemes.
    public static Compiler newInstance() {
        return new Compiler();
    }

    public Arch getTarget() {
        return target;
    }

    /*
        Returns the target-level events the given event compiles to.
        Helper registers are allocated in the given context function, which the result is meant to be placed in.
        The following holds:
        (1) The original event is not affected. The result may be a singleton that contains exactly the original event.
        (2) The resultant events do not inherit any metadata, nor are they inserted anywhere.
        (3) CARE: The resultant events may reference events that the original referenced, i.e., they may be EventUsers.
            This means their existence can affect other events even if not inserted anywhere: the events have to get
            deleted properly!
     */
    public List<Event> compile(Event event, Function context) {
        final Visitor visitor = visitors.computeIfAbsent(context.getProgram().getFormat(), this::newVisitor);
        visitor.funcToBeCompiled = context;
        return event.accept(visitor);
    }

    private Visitor newVisitor(Program.SourceLanguage source) {
        if (source == Program.SourceLanguage.SPV) {
            return switch (target) {
                case VULKAN -> new VisitorSpirvVulkan();
                case OPENCL -> new VisitorSpirvOpenCL();
                default -> throw new UnsupportedOperationException("SPIR-V can only be compiled to Vulkan or OpenCL");
            };
        }
        return switch (target) {
            case C11, OPENCL -> new VisitorC11();
            case LKMM -> new VisitorLKMM();
            case TSO -> new VisitorTso();
            case POWER -> new VisitorPower(useRC11Scheme, cToPowerScheme);
            case ARM7 -> new VisitorArm7();
            case ARM8 -> new VisitorArm8(useRC11Scheme);
            case IMM -> new VisitorIMM();
            case RISCV -> new VisitorRISCV(useRC11Scheme);
            case PTX -> new VisitorPTX();
            case VULKAN -> new VisitorVulkan();
        };
    }

    // =============================================================================================
    // Base class of the compilation schemes. By default, events are kept as they are.

    abstract static class Visitor implements EventVisitor<List<Event>> {

        protected final TypeFactory types = TypeFactory.getInstance();
        protected final ExpressionFactory expressions = ExpressionFactory.getInstance();

        protected Function funcToBeCompiled;

        protected Visitor() { }

        @Override
        public List<Event> visitEvent(Event e) {
            return Collections.singletonList(e);
        }

        @Override
        public List<Event> visitStoreExclusive(StoreExclusive e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMAddUnless(LKMMAddUnless e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMCmpXchg(LKMMCmpXchg e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMFetchOp(LKMMFetchOp e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMOpNoReturn(LKMMOpNoReturn e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMOpAndTest(LKMMOpAndTest e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMOpReturn(LKMMOpReturn e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLKMMXchg(LKMMXchg e) {
            throw error(e);
        }

        @Override
        public List<Event> visitTSOXchg(TSOXchg e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLlvmLoad(LlvmLoad e) {
            throw error(e);
        }

        @Override
        public List<Event> visitLlvmStore(LlvmStore e) {
            throw error(e);
        }

        // No-return RMWs are only supported by targets with a known compilation scheme (C11 and ARMv8).
        // We do not fall back to a returning RMW: its read would add ordering a real compiler might not have,
        // which can yield wrong verdicts.
        @Override
        public List<Event> visitLlvmRMWNoReturn(LlvmRMWNoReturn e) {
            throw error(e);
        }

        @Override
        public final List<Event> visitLlvmCmpXchg(LlvmCmpXchg e) {
            final Type resultType = e.getResultRegister().getType();
            verify(resultType instanceof AggregateType t && t.getFields().size() == 2, "Invalid result type of '%s'", e);
            final AggregateType type = (AggregateType) resultType;
            final Register oldValue = funcToBeCompiled.newUniqueRegister("LlvmCmpXchg.oldValue", e.getExpectedValue().getType());
            final Register success = funcToBeCompiled.newUniqueRegister("LlvmCmpXchg.success", types.getBooleanType());
            final Expression r0 = expressions.makeCast(oldValue, type.getFields().get(0).type());
            final Expression r1 = expressions.makeCast(success, type.getFields().get(1).type());
            final Expression expected = e.getExpectedValue();
            final Expression newValue = e.getStoreValue();
            return EventFactory.eventSequence(
                    newLlvmCmpXchg(e, oldValue, success, e.getAddress(), expected, newValue, e.getMo(), e.isStrong()),
                    EventFactory.newLocal(e.getResultRegister(), expressions.makeConstruct(type, List.of(r0, r1)))
            );
        }

        // Compiles a compare-exchange whose result is split into the old value and a success flag.
        // The original event is passed for tags that the compiled events should inherit.
        protected List<Event> newLlvmCmpXchg(Event original, Register oldValue, Register success, Expression address,
                Expression expected, Expression newValue, String mo, boolean strong) {
            throw new UnsupportedOperationException("Compilation of LlvmCmpXchg by %s.".formatted(getClass()));
        }

        private IllegalArgumentException error(Event e) {
            return new IllegalArgumentException("Compilation for " + e.getClass().getSimpleName() +
                    " is not supported by " + getClass().getSimpleName());
        }
    }
}
