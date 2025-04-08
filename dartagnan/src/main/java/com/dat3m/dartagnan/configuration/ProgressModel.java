package com.dat3m.dartagnan.configuration;

import com.google.common.base.Preconditions;
import com.google.common.base.Splitter;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;
import com.google.common.reflect.TypeToken;
import org.checkerframework.checker.nullness.qual.Nullable;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.converters.TypeConverter;
import org.sosy_lab.common.log.LogManager;

import java.lang.annotation.Annotation;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Map;

public enum ProgressModel {
    FAIR,       // All threads are fairly scheduled.
    HSA,        // Lowest id thread gets fairly scheduled.
    OBE,        // Threads that made at least one step get fairly scheduled.
    UNFAIR;     // No fair scheduling.

    public static ProgressModel getDefault() {
        return FAIR;
    }

    // Used to decide the order shown by the selector in the UI
    public static ProgressModel[] orderedValues() {
        ProgressModel[] order = { FAIR, HSA, OBE, UNFAIR };
        // Be sure no element is missing
        assert (Arrays.asList(order).containsAll(Arrays.asList(values())));
        return order;
    }


    // ================================================================================================================
    // Progress model hierarchies

    public static Hierarchy defaultHierarchy() {
        return uniform(getDefault());
    }

    public static Hierarchy uniform(ProgressModel model) {
        return new Hierarchy(model, ImmutableMap.of());
    }

    public static Hierarchy scoped(ProgressModel defaultProgress, Map<String, ProgressModel> scope2Progress) {
        return new Hierarchy(defaultProgress, scope2Progress);
    }

    public static class Hierarchy {
        private final ProgressModel defaultProgress;
        private final Map<String, ProgressModel> scope2Progress;

        private Hierarchy(ProgressModel defaultProgress, Map<String, ProgressModel> scope2Progress) {
            this.defaultProgress = defaultProgress;
            this.scope2Progress = ImmutableMap.copyOf(Maps.filterValues(scope2Progress, v -> v != defaultProgress));
        }

        public ProgressModel getProgressAtScope(String scope) {
            return scope2Progress.getOrDefault(scope, defaultProgress);
        }

        public boolean isUniform() {
            return scope2Progress.isEmpty();
        }

        public boolean isFair() {
            return isUniform() && defaultProgress == FAIR;
        }

        public ProgressModel getDefaultProgress() {
            return defaultProgress;
        }

        @Override
        public String toString() {
            if (scope2Progress.isEmpty()) {
                return defaultProgress.toString();
            } else {
                return scope2Progress + " with default=" + defaultProgress;
            }
        }
    }

    // ================================================================================================================
    // Type converter for parsing Hierarchy in user input
    /*
        Allows for following inputs:
            (1) optName=<progModel>                 // Uses <progModel> as default value for all scope levels
            (2) optName=[<scope>=<progModel>,...]   // Uses <progModel> on specified scope levels
                                                    // Defaults to FAIR unless the special key "default=<progModel>" is set.

     */

    public static final TypeConverter HIERARCHY_CONVERTER = new TypeConverter() {
        @Override
        public @Nullable Hierarchy convert(String optName, String value, TypeToken<?> type, @Nullable Annotation annotation, @Nullable Path path, LogManager logManager) throws InvalidConfigurationException {
            Preconditions.checkArgument(type.isSubtypeOf(Hierarchy.class));

            // Dictionary-style specification
            if (value.startsWith("[")) {
                if (!value.endsWith("]")) {
                    final String message = String.format("Invalid value '%s' for option '%s': missing closing bracket ']'.", value, optName);
                    throw new InvalidConfigurationException(message);
                }

                value = value.substring(1, value.length() - 1);
                try {
                    final Map<String, String> split = Splitter.on(",")
                            .trimResults()
                            .withKeyValueSeparator("=")
                            .split(value);
                    final Map<String, ProgressModel> parsed = Maps.transformValues(split, ProgressModel::valueOf);
                    final ProgressModel defaultProg = parsed.getOrDefault("default", ProgressModel.getDefault());
                    final Map<String, ProgressModel> result = ImmutableMap.copyOf(Maps.filterKeys(parsed, k -> !k.equals("default")));
                    return scoped(defaultProg, result);
                } catch (Exception ex) {
                    throw new InvalidConfigurationException(ex.getMessage());
                }
            }

            // Direct style
            try {
                return uniform(ProgressModel.valueOf(value));
            } catch (Exception ex) {
                throw new InvalidConfigurationException(ex.getMessage());
            }
        }

        @Override
        @SuppressWarnings("unchecked")
        public <T> @Nullable T convertDefaultValue(String optionName, @Nullable T value, TypeToken<T> type, @Nullable Annotation secondaryOption) throws InvalidConfigurationException {
            if (type.isSubtypeOf(Hierarchy.class)) {
                return (T) defaultHierarchy();
            }
            return value;
        }
    };
}
