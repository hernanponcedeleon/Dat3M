package com.dat3m.dartagnan.witness.svcomp;

import java.util.List;
import java.util.Optional;

import static java.util.Arrays.stream;

/**
 * Properties for which version 2.2 of the SV witness format defines violation witnesses.
 * Correctness witnesses are only supported for some of them.
 */
public enum SvcompProperty {
    UNREACH_CALL("unreach-call", "CHECK( init(main()), LTL(G ! call(reach_error())) )", true),
    NO_OVERFLOW("no-overflow", "CHECK( init(main()), LTL(G ! overflow) )", true),
    VALID_DEREF("valid-deref", "CHECK( init(main()), LTL(G valid-deref) )", false),
    VALID_FREE("valid-free", "CHECK( init(main()), LTL(G valid-free) )", false),
    DATA_RACE("no-data-race", "CHECK( init(main()), LTL(G ! data-race) )", false);

    /** Name of the relation in {@code cat/svcomp.cat} that orders the events of an SV-COMP execution. */
    public static final String HB_RELATION = "hb-consistency";
    /** Name of the flagged axiom in {@code cat/svcomp.cat} that reports data races. */
    public static final String DATA_RACE_AXIOM = "data-race";

    private final String propertyName;
    private final String specification;
    private final boolean supportsCorrectnessWitness;

    SvcompProperty(String propertyName, String specification, boolean supportsCorrectnessWitness) {
        this.propertyName = propertyName;
        this.specification = specification;
        this.supportsCorrectnessWitness = supportsCorrectnessWitness;
    }

    String propertyName() {
        return propertyName;
    }

    String specification() {
        return specification;
    }

    public static Optional<SvcompProperty> fromPropertyName(String name) {
        return stream(values()).filter(property -> property.propertyName.equals(name)).findFirst();
    }

    boolean supportsCorrectnessWitness() {
        return supportsCorrectnessWitness;
    }

    public static List<String> supportedViolationProperties() {
        return stream(values()).map(SvcompProperty::propertyName).toList();
    }

    public static List<String> supportedCorrectnessProperties() {
        return stream(values()).filter(SvcompProperty::supportsCorrectnessWitness)
                .map(SvcompProperty::propertyName).toList();
    }

    static SvcompProperty fromAssertionError(String errorMessage) {
        return switch (errorMessage) {
            case "integer overflow" -> NO_OVERFLOW;
            case "invalid dereference" -> VALID_DEREF;
            case "invalid free" -> VALID_FREE;
            default -> UNREACH_CALL;
        };
    }
}
