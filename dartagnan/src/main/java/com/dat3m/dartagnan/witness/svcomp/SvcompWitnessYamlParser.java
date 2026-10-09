package com.dat3m.dartagnan.witness.svcomp;

import org.yaml.snakeyaml.Yaml;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Instant;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.dat3m.dartagnan.witness.svcomp.SvcompWitness.*;

public final class SvcompWitnessYamlParser {

    private SvcompWitnessYamlParser() { }

    public static SvcompWitness parse(Path path) throws IOException {
        try (InputStream input = Files.newInputStream(path)) {
            final Object yaml = new Yaml().load(input);
            final List<?> entries = asList(yaml, "witness entries");
            final Map<?, ?> entry = entries.stream()
                    .map(value -> asMapping(value, "witness entry"))
                    .filter(value -> "violation_sequence".equals(value.get("entry_type")))
                    .findFirst()
                    .orElseThrow(() -> new IOException("Witness contains no violation sequence"));
            return parseEntry(entry);
        } catch (IllegalArgumentException | DateTimeParseException exception) {
            throw new IOException("Malformed witness: " + exception.getMessage(), exception);
        }
    }

    private static SvcompWitness parseEntry(Map<?, ?> entry) throws IOException {
        final Map<?, ?> metadata = getMapping(entry, "metadata");
        final Map<?, ?> producer = getMapping(metadata, "producer");
        final Map<?, ?> task = getMapping(metadata, "task");
        final List<?> inputFiles = getList(task, "input_files");
        if (inputFiles.size() != 1) {
            throw new IOException("Witness must specify exactly one input file");
        }
        final String inputFile = asString(inputFiles.get(0), "input file");
        final String hash = resolveInputFileHash(getMapping(task, "input_file_hashes"), inputFile);

        final Metadata parsedMetadata = new Metadata(
                getString(metadata, "format_version"),
                getString(metadata, "uuid"),
                Instant.parse(getString(metadata, "creation_time")),
                new Producer(getString(producer, "name", "producer name"),
                        getString(producer, "version", "producer version")),
                new Task(Path.of(inputFile), hash, getString(task, "specification"),
                        getString(task, "data_model"), getString(task, "language")));

        final List<Segment> segments = new ArrayList<>();
        for (Object contentItem : getList(entry, "content")) {
            final List<Waypoint> waypoints = new ArrayList<>();
            final Map<?, ?> segment = asMapping(contentItem, "content item");
            for (Object waypointItem : getList(segment, "segment")) {
                final Map<?, ?> waypoint = asMapping(waypointItem, "waypoint");
                final Map<?, ?> body = getMapping(waypoint, "waypoint");
                final String type = getString(body, "type", "waypoint type");
                if ("branching".equals(type)) {
                    // Branching waypoints are deliberately ignored because source-level
                    // branches may not have a corresponding LLVM-level branch after compilation.
                    continue;
                }
                final String action = getString(body, "action", "waypoint action");
                if (!"follow".equals(action)) {
                    throw new IOException("Unsupported waypoint action '%s' for type '%s'"
                            .formatted(action, type));
                }
                final int threadId = body.containsKey("thread_id") ? getInteger(body, "thread_id") : 0;
                final Map<?, ?> location = getMapping(body, "location");
                final Location parsedLocation = new Location(
                        Path.of(getString(location, "file_name")),
                        getInteger(location, "line"));
                switch (type) {
                    case "function_enter" -> waypoints.add(new FunctionEnter(threadId, parsedLocation));
                    case "assumption" -> {
                        final Map<?, ?> constraint = getMapping(body, "constraint");
                        final String format = getString(constraint, "format", "constraint format");
                        if (!"c_expression".equals(format)) {
                            throw new IOException("Unsupported witness constraint format '" + format + "'");
                        }
                        waypoints.add(new Assumption(threadId, AssumptionParser.parse(
                                getString(constraint, "value", "constraint value")), parsedLocation));
                    }
                    case "target" -> waypoints.add(new Target(threadId, parsedLocation));
                    default -> throw new IOException("Unsupported waypoint type '%s'".formatted(type));
                }
            }
            if (!waypoints.isEmpty()) {
                segments.add(new Segment(waypoints));
            }
        }
        return new SvcompWitness(parsedMetadata, segments);
    }

    private static String resolveInputFileHash(Map<?, ?> hashes, String inputFile) {
        if (hashes.containsKey(inputFile)) {
            return getString(hashes, inputFile);
        }
        final Path fileName = Path.of(inputFile).getFileName();
        final var matches = hashes.entrySet().stream()
                .filter(entry -> fileName.equals(Path.of(asString(entry.getKey(), "input file hash key")).getFileName()))
                .toList();
        if (matches.isEmpty()) {
            throw new IllegalArgumentException("No input file hash matches '" + inputFile + "'");
        }
        if (matches.size() > 1) {
            throw new IllegalArgumentException("Multiple input file hashes match '" + inputFile + "'");
        }
        return asString(matches.get(0).getValue(), "input file hash");
    }

    /** Parses the supported Boolean constants, integer equalities, and conjunctions. */
    private static final class AssumptionParser {

        private static final Pattern IDENTIFIER = Pattern.compile("[A-Za-z_][A-Za-z0-9_$]*");
        private static final Pattern INTEGER = Pattern.compile("-?[0-9]+");

        private final String source;
        private int position;

        private AssumptionParser(String source) {
            this.source = source;
        }

        private static AssumptionExpression parse(String source) {
            final var parser = new AssumptionParser(source);
            final AssumptionExpression result = parser.parseConjunction();
            parser.skipWhitespace();
            if (parser.position != source.length()) {
                throw parser.unsupportedAssumption();
            }
            return result;
        }

        private AssumptionExpression parseConjunction() {
            AssumptionExpression result = parseOperand();
            while (consume("&&")) {
                result = new Conjunction(result, parseOperand());
            }
            return result;
        }

        private AssumptionExpression parseOperand() {
            if (consume("(")) {
                final AssumptionExpression result = parseConjunction();
                if (!consume(")")) {
                    throw unsupportedAssumption();
                }
                return result;
            }
            skipWhitespace();
            final Matcher identifier = IDENTIFIER.matcher(source).region(position, source.length());
            if (identifier.lookingAt()) {
                final String name = identifier.group();
                position = identifier.end();
                if (consume("==")) {
                    return new VariableEquality(name, new BigInteger(readInteger()));
                }
                if ("true".equalsIgnoreCase(name) || "false".equalsIgnoreCase(name)) {
                    return new BooleanConstant("true".equalsIgnoreCase(name));
                }
                throw unsupportedAssumption();
            }
            final String integer = readInteger();
            if (!"0".equals(integer) && !"1".equals(integer)) {
                throw unsupportedAssumption();
            }
            return new BooleanConstant("1".equals(integer));
        }

        private String readInteger() {
            skipWhitespace();
            final Matcher integer = INTEGER.matcher(source).region(position, source.length());
            if (!integer.lookingAt()) {
                throw unsupportedAssumption();
            }
            position = integer.end();
            return integer.group();
        }

        private boolean consume(String token) {
            skipWhitespace();
            if (!source.startsWith(token, position)) {
                return false;
            }
            position += token.length();
            return true;
        }

        private void skipWhitespace() {
            while (position < source.length() && Character.isWhitespace(source.charAt(position))) {
                position++;
            }
        }

        private IllegalArgumentException unsupportedAssumption() {
            return new IllegalArgumentException("Unsupported witness assumption '" + source + "'");
        }
    }

    private static Map<?, ?> getMapping(Map<?, ?> parent, String key) {
        return asMapping(parent.get(key), key);
    }

    private static Map<?, ?> asMapping(Object value, String name) {
        if (!(value instanceof Map<?, ?> result)) {
            throw new IllegalArgumentException("Expected %s to be a mapping".formatted(name));
        }
        return result;
    }

    private static List<?> getList(Map<?, ?> parent, String key) {
        return asList(parent.get(key), key);
    }

    private static List<?> asList(Object value, String name) {
        if (!(value instanceof List<?> result)) {
            throw new IllegalArgumentException("Expected %s to be a list".formatted(name));
        }
        return result;
    }

    private static String getString(Map<?, ?> parent, String key) {
        return getString(parent, key, key);
    }

    private static String getString(Map<?, ?> parent, String key, String name) {
        return asString(parent.get(key), name);
    }

    private static String asString(Object value, String name) {
        if (value == null) {
            throw new IllegalArgumentException("Missing %s".formatted(name));
        }
        return value.toString();
    }

    private static int getInteger(Map<?, ?> parent, String key) {
        return asInteger(parent.get(key), key);
    }

    private static int asInteger(Object value, String name) {
        if (value instanceof Number number) {
            return number.intValue();
        }
        try {
            return Integer.parseInt(asString(value, name));
        } catch (NumberFormatException exception) {
            throw new IllegalArgumentException("Expected %s to be an integer".formatted(name), exception);
        }
    }
}
