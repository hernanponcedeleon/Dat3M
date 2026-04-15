package com.dat3m.dartagnan.configuration;

import com.dat3m.dartagnan.Dartagnan;
import com.dat3m.dartagnan.encoding.*;
import com.dat3m.dartagnan.program.analysis.ReachingDefinitionsAnalysis;
import com.dat3m.dartagnan.program.analysis.alias.AliasAnalysis;
import com.dat3m.dartagnan.program.processing.*;
import com.dat3m.dartagnan.program.processing.compilation.Compilation;
import com.dat3m.dartagnan.solver.caat4wmm.coreReasoning.CoreReasoner;
import com.dat3m.dartagnan.utils.options.BaseOptions;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.verification.TaskSolver;
import com.dat3m.dartagnan.verification.solving.ModelChecker;
import com.dat3m.dartagnan.verification.solving.RefinementSolver;
import com.dat3m.dartagnan.witness.graphviz.ExecutionGraphVisualizer;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.analysis.RelationAnalysis;
import com.dat3m.dartagnan.wmm.analysis.WmmAnalysis;
import com.dat3m.dartagnan.wmm.axiom.Acyclicity;
import com.dat3m.dartagnan.wmm.axiom.Emptiness;
import com.dat3m.dartagnan.wmm.axiom.Irreflexivity;
import com.dat3m.dartagnan.wmm.processing.WmmProcessingManager;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.lang.reflect.*;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.google.common.base.Verify.verify;

public final class OptionInfo implements Comparable<OptionInfo> {

    public static Stream<OptionInfo> stream() {
        return classes().flatMap(OptionInfo::collectOptions);
    }

    private static Stream<Class<?>> classes() {
        return Stream.of(
                TaskSolver.class,
                RelationNameRepository.class,
                OptionNames.class,
                Acyclicity.class,
                Emptiness.class,
                Irreflexivity.class,
                Dartagnan.class,
                ActiveSetAnalysis.class,
                EncodingContext.class,
                ProgramEncoder.class,
                SymmetryEncoder.class,
                WmmEncoder.class,
                ReachingDefinitionsAnalysis.Config.class,
                AliasAnalysis.Config.class,
                BranchReordering.class,
                Inlining.class,
                Intrinsics.class,
                LoopUnrolling.class,
                MemoryAllocation.class,
                NonterminationDetection.class,
                ProcessingManager.class,
                SparseConditionalConstantPropagation.class,
                ThreadCreation.class,
                Compilation.class,
                CoreReasoner.class,
                BaseOptions.class,
                Printer.class,
                ModelChecker.SMTConfig.class,
                RefinementSolver.class,
                RelationAnalysis.Config.class,
                WmmAnalysis.class,
                WmmProcessingManager.class,
                ExecutionGraphVisualizer.class
        );
    }

    private static Stream<OptionInfo> collectOptions(Class<?> c) {

        Options o = c.getAnnotation(Options.class);
        if (o == null) {
            return Stream.empty();
        }

        ClassInfo p = new ClassInfo(o);
        return Stream.concat(
                Stream.of(c.getDeclaredFields()).flatMap(p::of),
                Stream.of(c.getDeclaredMethods()).flatMap(p::of));
    }

    private static class ClassInfo {

        final String prefix;

        ClassInfo(Options o) {
            prefix = o.prefix().isEmpty() ? "" : o.prefix() + ".";
        }

        Stream<OptionInfo> of(Field f) {
            Option o = f.getAnnotation(Option.class);
            if (o == null) {
                return Stream.empty();
            }
            return Stream.of(new OptionInfo(this, o, f, f.getGenericType()));
        }

        Stream<OptionInfo> of(Method m) {
            Option o = m.getAnnotation(Option.class);
            if (o == null) {
                return Stream.empty();
            }
            return Stream.of(new OptionInfo(this, o, m, m.getGenericParameterTypes()[0]));
        }
    }

    private final ClassInfo parent;
    private final Option option;
    private final Member member;
    private final Type type;
    private final Class<?> domain;

    private OptionInfo(ClassInfo i, Option o, Member m, Type t) {
        parent = i;
        option = o;
        member = m;
        type = t;
        Type raw = t instanceof ParameterizedType ? ((ParameterizedType) t).getRawType() : t;
        verify(raw instanceof Class);
        domain = (Class<?>) raw;
    }

    public String getName() {
        return option.name();
    }

    public String getDescription() {
        return option.description();
    }

    public Class<?> getDomain() {
        return domain;
    }

    @Override
    public String toString() {
        return String.format("\n[-] %s%s : %s\n\t%s\n",
                parent.prefix,
                option.name().isEmpty() ? member.getName() : option.name(),
                domain.isEnum() ?
                        "[" + Arrays.stream(domain.getEnumConstants())
                                .map(o -> o instanceof OptionInterface ?
                                        ((OptionInterface) o).asStringOption() :
                                        o.toString().toLowerCase())
                                .collect(Collectors.joining(", ")) +
                                "]" :
                        domain.getSimpleName(),
                option.description());
    }

    @Override
    public int compareTo(OptionInfo o) {
        return toString().compareTo(o.toString());
    }
}