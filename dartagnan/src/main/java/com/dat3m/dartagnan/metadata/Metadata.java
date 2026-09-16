package com.dat3m.dartagnan.metadata;

/*
    ================== Guidelines on metadata usage ==================

    (1) Metadata classes should be immutable and consist of simple types (int, string, bool, etc.)
        but not complex IR types (event, thread, program, register etc.).
        The Expression type can be used in Metadata as long as the expression consists of constants, i.e.,
        it does not refer to other IR types.

    (2) Metadata should not be used to define the semantics of annotated objects.

    (3) Metadata is allowed to affect the precision of the tool which in turn may, e.g., allow the verdict
        to change from UNKNOWN to PASS.
        An example is metadata about C-level types attached to load/store events which can be used
        to do type-based alias analysis (TBAA).

    (4) Metadata should be optional, i.e., dropping metadata should not cause Dartagnan to break.

    (5) Metadata classes should be inner classes of the class they intend to annotate.
        If a Metadata class applies to multiple related classes, it can be placed in a related class.
        If a Metadata class applies to unrelated classes, it should be placed in the metadata package.

    (EXCEPTIONS)
    For metadata that Dartagnan can guarantee to generate internally, e.g. as part of its processing pipeline,
    the rules can be relaxed:
    - Rule (4) does not strictly apply: we can have mandatory metadata, but optional metadata is still preferred.

 */
public interface Metadata {
}
