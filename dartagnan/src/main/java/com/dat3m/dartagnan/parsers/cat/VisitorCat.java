package com.dat3m.dartagnan.parsers.cat;

import com.dat3m.dartagnan.GlobalSettings;
import com.dat3m.dartagnan.exception.AbortErrorListener;
import com.dat3m.dartagnan.exception.MalformedMemoryModelException;
import com.dat3m.dartagnan.exception.ParsingException;
import com.dat3m.dartagnan.parsers.CatBaseVisitor;
import com.dat3m.dartagnan.parsers.CatLexer;
import com.dat3m.dartagnan.parsers.CatParser;
import com.dat3m.dartagnan.parsers.CatParser.*;
import com.dat3m.dartagnan.program.filter.Filter;
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
            Axiom axiom = (Axiom) constructor.newInstance(r, ctx.negate != null, ctx.flag != null);
            if (ctx.NAME() != null) {
                axiom.setName(ctx.NAME().toString());
            }
            wmm.addConstraint(axiom);
        } catch (NoSuchMethodException | InstantiationException | IllegalAccessException |
                 InvocationTargetException e) {
            throw new ParsingException(ctx.getText());
        }
        return null;
    }

    private String createUniqueName(String name) {
        if (namespace.containsKey(name) && !nameOccurrenceCounter.containsKey(name)) {
            // If we have already seen the name, but not counted it yet, we do so now.
            nameOccurrenceCounter.put(name, 1);
        }

        final int occurrenceNumber =  nameOccurrenceCounter.compute(name, (k, v) -> v == null ? 1 : v + 1);
        // If it is the first time we encounter this name, we return it as is.
        return occurrenceNumber == 1 ? name : name + "#" + occurrenceNumber;
    }

    @Override
    public Void visitLetDefinition(LetDefinitionContext ctx) {
        String name = ctx.n.getText();
        Object definedPredicate = ctx.e.accept(this);
        if (definedPredicate instanceof Relation rel) {
            String alias = createUniqueName(name);
            wmm.addAlias(alias, rel);
        } else if (definedPredicate instanceof Filter filter) {
            String alias = createUniqueName(name);
            // NOTE: The support for re-defined filters is limited:
            // The Wmm will recognize all aliases, but the filter itself has a single name,
            // which we set to the most recent alias we used.
            filter.setName(alias);
            wmm.addFilter(filter);
        }
        namespace.put(name, definedPredicate);
        return null;
    }

    @Override
    public Void visitLetRecDefinition(LetRecDefinitionContext ctx) {
        final int recSize = ctx.letRecAndDefinition().size() + 1;
        final Relation[] recursiveGroup = new Relation[recSize];
        final String[] lhsNames = new String[recSize];

        // Create the recursive relations
        for (int i = 0; i < recSize; i++) {
            // First relation needs special treatment due to syntactic difference
            final String relName = i == 0 ? ctx.n.getText() : ctx.letRecAndDefinition(i - 1).n.getText();
            if (Arrays.asList(lhsNames).contains(relName)) {
                final String errorMsg = String.format("Recursive definition defines '%s' multiple times", relName);
                throw new MalformedMemoryModelException(errorMsg);
            }
            lhsNames[i] = relName;
            recursiveGroup[i] = wmm.newRelation(createUniqueName(relName));
            recursiveGroup[i].setRecursive();
            namespace.put(relName, recursiveGroup[i]);
        }

        // Parse recursive definitions
        for (int i = 0; i < recSize; i++) {
            final ExpressionContext rhs = i == 0 ? ctx.e : ctx.letRecAndDefinition(i - 1).e;
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
    public Object visitExprNew(ExprNewContext ctx) {
        return addDefinition(new Free(wmm.newRelation()));
    }

    @Override
    public Object visitExprBasic(ExprBasicContext ctx) {
        String name = ctx.n.getText();
        Object predicate = namespace.computeIfAbsent(name,
                k -> RelationNameRepository.contains(name) ? wmm.getOrCreatePredefinedRelation(k) : Filter.byTag(k));
        return predicate;
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
        Optional<Relation> defRel = getAndResetRelationToBeDefined();
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            Relation r0 = defRel.orElseGet(wmm::newRelation);
            return addDefinition(new Intersection(r0, (Relation) o1, parseAsRelation(o2, c)));
        }
        return Filter.intersection(parseAsFilter(o1, c), parseAsFilter(o2, c));
    }

    @Override
    public Object visitExprMinus(ExprMinusContext c) {
        checkNoRecursion(c);
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            Relation r0 = wmm.newRelation();
            return addDefinition(new Difference(r0, (Relation) o1, parseAsRelation(o2, c)));
        }
        return Filter.difference(parseAsFilter(o1, c), parseAsFilter(o2, c));
    }

    @Override
    public Object visitExprUnion(ExprUnionContext c) {
        Optional<Relation> defRel = getAndResetRelationToBeDefined();
        Object o1 = c.e1.accept(this);
        Object o2 = c.e2.accept(this);
        if (o1 instanceof Relation) {
            Relation r0 = defRel.orElseGet(wmm::newRelation);
            return addDefinition(new Union(r0, (Relation) o1, parseAsRelation(o2, c)));
        }
        return Filter.union(parseAsFilter(o1, c), parseAsFilter(o2, c));
    }

    @Override
    public Object visitExprComplement(ExprComplementContext c) {
        checkNoRecursion(c);
        Object o1 = c.e.accept(this);
        Filter visible = Filter.byTag(VISIBLE);
        if (o1 instanceof Relation) {
            Relation r0 = wmm.newRelation();
            Relation all = wmm.newRelation();
            Relation r1 = wmm.addDefinition(new CartesianProduct(all, visible, visible));
            return addDefinition(new Difference(r0, r1, (Relation) o1));
        }
        return Filter.difference(visible, parseAsFilter(o1, c));
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
    public Relation visitExprDomainIdentity(ExprDomainIdentityContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new DomainIdentity(r0, r1));
    }

    @Override
    public Relation visitExprRangeIdentity(ExprRangeIdentityContext c) {
        Relation r0 = getAndResetRelationToBeDefined().orElseGet(wmm::newRelation);
        Relation r1 = parseAsRelation(c.e);
        return addDefinition(new RangeIdentity(r0, r1));
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
        Filter s1 = parseAsFilter(c.e);
        return addDefinition(new SetIdentity(r0, s1));
    }

    @Override
    public Relation visitExprCartesian(ExprCartesianContext c) {
        checkNoRecursion(c);
        Relation r0 = wmm.newRelation();
        Filter s1 = parseAsFilter(c.e1);
        Filter s2 = parseAsFilter(c.e2);
        return addDefinition(new CartesianProduct(r0, s1, s2));
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

    private Filter parseAsFilter(ExpressionContext t) {
        return parseAsFilter(t.accept(this), t);
    }

    private static Filter parseAsFilter(Object o, ExpressionContext t) {
        if (o instanceof Filter filter) {
            return filter;
        }
        throw new ParsingException("Expected set, got " + o.getClass().getSimpleName() + " " + o + " from expression " + t.getText());
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
}

