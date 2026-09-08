package com.dat3m.dartagnan.witness.svcomp;

/** Properties for which version 2.2 of the SV witness format defines a violation sequence. */
enum SvcompProperty {
    UNREACH_CALL("unreach-call", "CHECK( init(main()), LTL(G ! call(reach_error())) )"),
    NO_OVERFLOW("no-overflow", "CHECK( init(main()), LTL(G ! overflow) )"),
    VALID_DEREF("valid-deref", "CHECK( init(main()), LTL(G valid-deref) )"),
    VALID_FREE("valid-free", "CHECK( init(main()), LTL(G valid-free) )"),
    DATA_RACE("no-data-race", "CHECK( init(main()), LTL(G ! data-race) )");

    private final String propertyName;
    private final String specification;

    SvcompProperty(String propertyName, String specification) {
        this.propertyName = propertyName;
        this.specification = specification;
    }

    String propertyName() {
        return propertyName;
    }

    String specification() {
        return specification;
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
