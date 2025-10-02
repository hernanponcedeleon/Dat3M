package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.exception.MalformedMemoryModelException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatLexer;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.parsers.CatParser.*;
import com.dat3m.dartagnan.wmm.Definition;
import com.dat3m.dartagnan.wmm.Relation;
import com.dat3m.dartagnan.wmm.RelationNameRepository;
import com.dat3m.dartagnan.wmm.Wmm;
import com.dat3m.dartagnan.wmm.axiom.Axiom;
import com.dat3m.dartagnan.wmm.definition.*;
import com.google.common.collect.ImmutableMap;
import org.antlr.v4.runtime.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

import static com.dat3m.dartagnan.program.event.Tag.VISIBLE;
import static com.dat3m.dartagnan.wmm.RelationNameRepository.ID;

class VisitorCat extends CatBaseVisitor<Object> {

    private static final Logger logger = LogManager.getLogger(VisitorCat.class);

    // The directory path used to resolve include statements.
    private final Path includePath;

    private final Wmm wmm;
    // Maps names used on the lhs of definitions ("let name = relexpr" or "let name(params) = relexpr") to the
    // predicate (either a Relation or a Filter) or the function (FuncDefinition) they identify
    private Map<String, Object> namespace = new HashMap<>();
    // Counts the number of occurrences of a name on the lhs of a definition
    // This is used to give proper names to re-definitions
    private final Map<String, Integer> nameOccurrenceCounter = new HashMap<>();
    // Used to handle recursive definitions properly
    private Relation relationToBeDefined;

    private record FuncDefinition(String name, List<String> params, String expression,
                                  Map<String, Object> capturedNamespace) {
        @Override
        public String toString() {
            return String.format("%s%s := %s",
                    name,
                    params.stream().collect(Collectors.joining(", ", "(", ")")),
                    expression
            );
        }
    }

    VisitorCat(Path includePath) {
        this.includePath = includePath;
        this.wmm = new Wmm();
        includeStdlib();
    }

    private void includeStdlib() {
        try {
            // The standard library is a cat file stdlib.cat which all models include by default
            final CatParser parser = getParser(CharStreams.fromPath(Path.of(GlobalSettings.getCatDirectory() + "/stdlib.cat")));
            parser.mcm().accept(this);
        } catch (IOException e) {
            throw new ParsingException(e, "Error parsing stdlib.cat file");
        }
    }

    @Override
    public Object visitMcm(McmContext ctx) {
        super.visitMcm(ctx);
        return wmm;
    }

    @Override
    public Object visitLetFuncDefinition(LetFuncDefinitionContext ctx) {
        final String fname = ctx.fname.getText();
        final List<String> params = ctx.params.NAME().stream().map(Object::toString).toList();
        final String expression = ctx.expression().getText();
        final Map<String, Object> capturedNamespace = ImmutableMap.copyOf(namespace);

        final FuncDefinition definition = new FuncDefinition(fname, params, expression, capturedNamespace);
        namespace.put(fname, definition);
        return null;
    }

    @Override
    public Object visitInclude(IncludeContext ctx) {
        final String fileName = ctx.path.getText().substring(1, ctx.path.getText().length() - 1);
        final Path filePath = includePath.resolve(Path.of(fileName));
        if (!Files.exists(filePath)) {
            logger.warn("Included file '{}' not found. Skipped inclusion.", filePath);
            return null;
        }

        try {
            final CatParser parser = getParser(CharStreams.fromPath(filePath));
            return parser.mcm().accept(this);
        } catch (IOException e) {
            throw new ParsingException(e, String.format("Error parsing file '%s'", filePath));
        }
    }

    @Override
    public Void visitAxiomDefinition(AxiomDefinitionContext ctx) {
        try {
            Relation r = parseAsRelation(ctx.e);
            Constructor<?> constructor = ctx.cls.getConstructor(Relation.class, boolean.class, boolean.class);
            boolean negate = ctx.negate != null ^ ctx.undef != null;
            boolean flag = ctx.flag != null || ctx.undef != null;
            Axiom axiom = (Axiom) constructor.newInstance(r, negate, flag);
            String name = ctx.NAME() != null ? ctx.NAME().toString() : "";
            name += ctx.undef != null ? " (*undef*)" : "";
            if (!name.isEmpty()) {
                axiom.setName(name);
            }
            wmm.addConstraint(axiom);
        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException |
                 InvocationTargetException e) {
            throw new ParsingException(ctx.getText());
        }
        return null;
    }

    private String createUniqueName(String name) {
        if (wmm.containsRelation(name)) {
            // If we have already seen the name, but not counted it yet, we do so now.
            nameOccurrenceCounter.putIfAbsent(name, 1);
        }

        final int occurrenceNumber =  nameOccurrenceCounter.compute(name, (k, v) -> v == null ? 1 : v + 1);
        // If it is the first time we encounter this name, we return it as is.
        return occurrenceNumber == 1 ? name : name + "#" + occurrenceNumber;
    }

    @Override
    public Void visitLetDefinition(LetDefinitionContext ctx) {
        final String name = ctx.n.getText();
        final Relation definedPredicate = (Relation) ctx.e.accept(this);
        final String alias = createUniqueName(name);
        wmm.addAlias(alias, definedPredicate);
        namespace.put(name, definedPredicate);
        return null;
    }

    @Override
    public Void visitLetRecDefinition(LetRecDefinitionContext ctx) {
        final int recSize = ctx.letRecAndDefinition().size() + 1;
        final Relation[] recursiveGroup = new Relation[recSize];
        final String[] lhsNames = new String[recSize];
        final ExpressionContext[] rhsContexts = new ExpressionContext[recSize];
        // Recompose the syntax.
        for (int i = 0; i < recSize; i++) {
            // First relation needs special treatment due to syntactic difference
            final String relName = i == 0 ? ctx.n.getText() : ctx.letRecAndDefinition(i - 1).n.getText();
            if (Arrays.asList(lhsNames).contains(relName)) {
                final String errorMsg = String.format("Recursive definition defines '%s' multiple times", relName);
                throw new MalformedMemoryModelException(errorMsg);
            }
            lhsNames[i] = relName;
            rhsContexts[i] = i == 0 ? ctx.e : ctx.letRecAndDefinition(i - 1).e;
        }
        // Create the recursive relations.
        for (int i = 0; i < recSize; i++) {
            final Relation.Arity probedArity = rhsContexts[i].accept(new ArityInspector());
            final Relation.Arity arity = probedArity != null ? probedArity : Relation.Arity.BINARY;
            recursiveGroup[i] = wmm.newRelation(createUniqueName(lhsNames[i]), arity);
            recursiveGroup[i].setRecursive();
            namespace.put(lhsNames[i], recursiveGroup[i]);
        }
        // Parse recursive definitions.
        for (int i = 0; i < recSize; i++) {
            final ExpressionContext rhs = rhsContexts[i];
            final Relation lhs = recursiveGroup[i];
            setRelationToBeDefined(lhs);
            final Relation parsedRhs = parseAsRelation(rhs);
            if (parsedRhs.getDefinition() instanceof Definition.Undefined) {
                // This should correspond to the degenerate case: "let rec r = r" which we could technically also
                // simplify to "let r = 0", but we throw an exception for now.
                final String errorMsg = String.format("Ill-defined definition in recursion: '%s = %s'",
                        lhsNames[i], rhs.getText());
                throw new MalformedMemoryModelException(errorMsg);
            }
            if (lhs.getDefinition() != parsedRhs.getDefinition()) {
                // We have an odd case where a relation defined in the recursion is identical to some
                // already defined relation, i.e., it is just an alias.
                namespace.put(lhsNames[i], parsedRhs);
                wmm.deleteRelation(lhs);
                wmm.addAlias(lhs.getName().get(), parsedRhs);
            }
        }
        setRelationToBeDefined(null);
        return null;
    }

    @Override
    public Object visitExpr(ExprContext ctx) {
        return ctx.e.accept(this);
    }

    @Override
    public Object visitExprNewSet(ExprNewSetContext ctx) {
        return addDefinition(new Free(wmm.newRelation(Relation.Arity.UNARY)));
    }

    @Override
    public Object visitExprNewRelation(ExprNewRelationContext ctx) {
        return addDefinition(new Free(wmm.newRelation(Relation.Arity.BINARY)));
    }

    @Override
    public Object visitExprBasic(ExprBasicContext ctx) {
        final String name = ctx.n.getText();
        final Object localObject = namespace.get(name);
        final Object boundObject = localObject != null ? localObject : wmm.getRelation(name);
        if (boundObject != null) {
            return boundObject;
        }
        final boolean predefinedName = RelationNameRepository.contains(name);
        final Relation predefined = predefinedName ? wmm.getOrCreatePredefinedRelation(name) : null;
        return predefinedName ? predefined : addDefinition(new TagSet(wmm.newSet(name), name));
    }

    @Override
    public Object visitExprCall(ExprCallContext ctx) {
        final String calledFunc = ctx.call.getText();
        if (!(namespace.get(calledFunc) instanceof FuncDefinition funcDef)) {
            final String error = String.format("Invalid call %s: %s is undefined or no function.", ctx.getText(), calledFunc);
            throw new ParsingException(error);
        }

        final List<CatParser.ExpressionContext> args = ctx.args.expression();
        if (args.size() != funcDef.params().size()) {
            final String error = String.format("Invalid call %s to function %s: wrong number of arguments.",
                    ctx.getText(), funcDef);
            throw new ParsingException(error);
        }
        final List<Object> arguments = ctx.args.expression().stream().map(e -> e.accept(this)).toList();
        final Map<String, Object> functionNamespace = new HashMap<>(funcDef.capturedNamespace());
        for (int i = 0; i < arguments.size(); i++) {
            functionNamespace.put(funcDef.params.get(i), arguments.get(i));
        }

        final Map<String, Object> curNamespace = namespace;
        namespace = functionNamespace;
        final CatParser parser = getParser(CharStreams.fromString(funcDef.expression));
        Object result =  parser.expression().accept(this);
        namespace = curNamespace;
        return result;
    }

    @Override
    public Object visitExprIntersection(ExprIntersectionContext c) {
        final Optional<Relation> defRel = getAndResetRelationToBeDefined();
        final Relation r1 = parseAsRelation(c.e1);
        final Relation r2 = parseAsRelation(c.e2);
        final Relation r0 = defRel.orElseGet(() -> wmm.newRelation(r1.getArity()));
        return addDefinition(new Intersection(r0, r1, r2));
    }

    @Override
    public Object visitExprMinus(ExprMinusContext c) {
        checkNoRecursion(c);
        final Relation r1 = parseAsRelation(c.e1);
        final Relation r2 = parseAsRelation(c.e2);
        final Relation r0 = wmm.newRelation(r1.getArity());
        return addDefinition(new Difference(r0, r1, r2));
    }

    @Override
    public Object visitExprUnion(ExprUnionContext c) {
        final Optional<Relation> defRel = getAndResetRelationToBeDefined();
        final Relation r1 = parseAsRelation(c.e1);
        final Relation r2 = parseAsRelation(c.e2);
        final Relation r0 = defRel.orElseGet(() -> wmm.newRelation(r1.getArity()));
        return addDefinition(new Union(r0, r1, r2));
    }

    @Override
    public Object visitExprComplement(ExprComplementContext c) {
        checkNoRecursion(c);
        final Relation r1 = parseAsRelation(c.e);
        final Relation visible = wmm.newSet();
        wmm.addDefinition(new TagSet(visible, VISIBLE));
        final Relation r0 = wmm.newRelation(r1.getArity());
        final Relation all = r1.isSet() ? visible : wmm.newRelation();
        if (!r1.isSet()) {
            wmm.addDefinition(new CartesianProduct(all, visible, visible));
        }
        return addDefinition(new Difference(r0, all, r1));
    }

    @Override
    public Relation visitExprComposition(ExprCompositionContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e1);
        Relation r2 = parseAsRelation(c.e2);
        return addDefinition(new Composition(r0, r1, r2));
    }

    @Override
    public Relation visitExprInverse(ExprInverseContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new Inverse(r0, r1));
    }

    @Override
    public Relation visitExprTransitive(ExprTransitiveContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new TransitiveClosure(r0, r1));
    }

    @Override
    public Relation visitExprTransRef(ExprTransRefContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e);
        Relation transClosure = addDefinition(new TransitiveClosure(wmm.newRelation(), r1));
        return addDefinition(new Union(r0, transClosure, wmm.getOrCreatePredefinedRelation(ID)));
    }

    @Override
    public Relation visitExprDomain(ExprDomainContext c) {
        Relation r0 = wmm.newSet();
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new Domain(r0, r1));
    }

    @Override
    public Relation visitExprRange(ExprRangeContext c) {
        Relation r0 = wmm.newSet();
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new Range(r0, r1));
    }

    @Override
    public Relation visitExprOptional(ExprOptionalContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new Union(r0, r1, wmm.getOrCreatePredefinedRelation(ID)));
    }

    @Override
    public Relation visitExprIdentity(ExprIdentityContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        final Relation r1 = parseAsRelation(c.e);
        return addDefinition(new SetIdentity(r0, r1));
    }

    @Override
    public Relation visitExprCartesian(ExprCartesianContext c) {
        checkNoRecursion(c);
        Relation r0 = wmm.newRelation();
        Relation r1 = parseAsRelation(c.e1);
        Relation r2 = parseAsRelation(c.e2);
        return addDefinition(new CartesianProduct(r0, r1, r2));
    }

    // ============================ Utility ============================

    private Relation addDefinition(Definition definition) {
        return wmm.addDefinition(definition);
    }

    private void checkNoRecursion(ExpressionContext c) {
        if(relationToBeDefined != null) {
            throw new ParsingException("Unexpected recursive context at expression: " + c.getText());
        }
    }

    private void setRelationToBeDefined(Relation rel) {
        relationToBeDefined = rel;
    }

    private Optional<Relation> getAndResetRelationToBeDefined() {
        Relation r = relationToBeDefined;
        relationToBeDefined = null;
        return Optional.ofNullable(r);
    }

    private Relation parseAsRelation(ExpressionContext t) {
        return parseAsRelation(t.accept(this), t);
    }

    private Relation parseAsRelation(Object o, ExpressionContext t) {
        if (o instanceof Relation relation) {
            return relation;
        }
        throw new ParsingException("Expected relation, got " + o.getClass().getSimpleName() + " " + o + " from expression " + t.getText());
    }

    private static CatParser getParser(CharStream input) {
        final Lexer lexer = new CatLexer(input);
        lexer.addErrorListener(new AbortErrorListener());
        lexer.addErrorListener(new DiagnosticErrorListener(true));
        final CommonTokenStream tokenStream = new CommonTokenStream(lexer);

        final CatParser parser = new CatParser(tokenStream);
        parser.addErrorListener(new AbortErrorListener());
        parser.addErrorListener(new DiagnosticErrorListener(true));
        return parser;
    }

    private final class ArityInspector extends CatBaseVisitor<Relation.Arity> {

        private ArityInspector() {}

        @Override
        public Relation.Arity visitExpr(ExprContext c) {
            return c.e.accept(this);
        }

        @Override
        public Relation.Arity visitExprBasic(ExprBasicContext c) {
            final Object object = namespace.get(c.n.getText());
            return object instanceof Relation r ? r.getArity() : null;
        }

        @Override
        public Relation.Arity visitExprDomain(ExprDomainContext c) {
            return Relation.Arity.UNARY;
        }

        @Override
        public Relation.Arity visitExprRange(ExprRangeContext c) {
            return Relation.Arity.UNARY;
        }

        @Override
        public Relation.Arity visitExprCartesian(ExprCartesianContext c) {
            return Relation.Arity.BINARY;
        }

        @Override
        public Relation.Arity visitExprComposition(ExprCompositionContext c) {
            return Relation.Arity.BINARY;
        }

        @Override
        public Relation.Arity visitExprIdentity(ExprIdentityContext c) {
            return Relation.Arity.BINARY;
        }

        @Override
        public Relation.Arity visitExprUnion(ExprUnionContext c) {
            return join(c.e1, c.e2);
        }

        @Override
        public Relation.Arity visitExprIntersection(ExprIntersectionContext c) {
            return join(c.e1, c.e2);
        }

        @Override
        public Relation.Arity visitExprMinus(ExprMinusContext c) {
            return join(c.e1, c.e2);
        }

        private Relation.Arity join(ExpressionContext e1, ExpressionContext e2) {
            final Relation.Arity k1 = e1.accept(this);
            final Relation.Arity k2 = e2.accept(this);
            checkCompatible(k1, k2);
            return k1 == null ? k2 : k1;
        }

        private static void checkCompatible(Relation.Arity k1, Relation.Arity k2) {
            if (k1 != null && k2 != null && !k1.equals(k2)) {
                throw new ParsingException("Incompatible kinds %s and %s".formatted(k1, k2));
            }
        }
    }
}

