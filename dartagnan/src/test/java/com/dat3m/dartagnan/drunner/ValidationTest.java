package com.dat3m.dartagnan.drunner;

import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.program.event.Event;
import com.dat3m.dartagnan.utils.printer.Printer;
import com.dat3m.dartagnan.verification.VerificationTask;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static com.dat3m.dartagnan.configuration.Property.PROGRAM_SPEC;
import static com.dat3m.dartagnan.program.event.Tag.NOOPT;
import static com.dat3m.dartagnan.utils.ResourceHelper.getRootPath;
import static com.dat3m.dartagnan.utils.ResourceHelper.getTestResourcePath;
import static com.dat3m.dartagnan.verification.solving.ModelChecker.preprocessProgram;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

@RunWith(Parameterized.class)
public class ValidationTest extends AbstractTest {

    private final String modelPath = getRootPath("cat/spirv.cat");
    private static final boolean PRINT_EVENTS = false;

    private final String dir1;
    private final String dir2;
    private final Map<Integer, Integer> map;
    private final Set<String> skipList;
    private final boolean skipErrors;

    public ValidationTest(String dir1, String dir2, Map<Integer, Integer> map, List<String> files, boolean skipErrors) throws IOException {
        this.dir1 = dir1;
        this.dir2 = dir2;
        this.map = map;
        this.skipList = loadSkipList(files);
        this.skipErrors = skipErrors;
    }

    @Parameterized.Parameters(name = "{index}: {0}, {1}, {2}")
    public static Iterable<Object[]> data() throws IOException {
        return Arrays.asList(new Object[][]{
                {"litmus-vulkan/atomic/lb", "spirv-verification/atomic/lb", Map.of(2, 11, 3, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/atomic/mp", "spirv-verification/atomic/mp", Map.of(1, 12, 2, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/atomic/sb", "spirv-verification/atomic/sb", Map.of(2, 11, 3, 12, 7, 5, 8, 6),  List.of(), false},
                {"litmus-vulkan/mixed/mp", "spirv-verification/mixed/mp", Map.of(1, 12, 2, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/plain/lb", "spirv-verification/plain/lb", Map.of(2, 11, 3, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/plain/mp", "spirv-verification/plain/mp", Map.of(1, 12, 2, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/plain/sb", "spirv-verification/plain/sb", Map.of(2, 11, 3, 12, 7, 5, 8, 6),  List.of(), false},
                {"litmus-vulkan/sanity/storage-class", "spirv-verification/sanity/storage-class", Map.of(1, 10, 5, 5),  List.of(), false},
                {"litmus-vulkan/sanity/storage-class", "spirv-empirical/sanity/storage-class", Map.of(1, 113, 5, 106),  List.of(), false},

                {"litmus-vulkan/sanity/operands/load", "spirv-verification/sanity/operands/load", Map.of(2, 1),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"litmus-vulkan/sanity/operands/store", "spirv-verification/sanity/operands/store", Map.of(1, 1),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"spirv-verification/sanity/operands/load", "spirv-empirical/sanity/operands/load", Map.of(1, 105),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"spirv-verification/sanity/operands/store", "spirv-empirical/sanity/operands/store", Map.of(1, 105),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"litmus-vulkan/sanity/semantics/legal", "spirv-verification/sanity/semantics/legal", Map.of(2, 1),  List.of("litmus-vulkan-sanity-semantics.txt", "spirv-verification-sanity-semantics.txt"), false},
                {"spirv-verification/sanity/semantics/legal", "spirv-empirical/sanity/semantics/legal", Map.of(1, 105, 2, 106),  List.of("spirv-empirical-sanity-semantics.txt", "spirv-verification-sanity-semantics.txt"), false},

                // TODO: Instead of skipping assert that throws exception
                {"litmus-vulkan/sanity/semantics/illegal", "spirv-verification/sanity/semantics/illegal", Map.of(2, 1),  List.of(), true},
                {"spirv-verification/sanity/semantics/illegal", "spirv-empirical/sanity/semantics/illegal", Map.of(1, 105, 2, 106),  null, true},

                {"litmus-vulkan/atomic/lb", "spirv-verification-new/atomic/lb", Map.of(2, 11, 3, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/atomic/mp", "spirv-verification-new/atomic/mp", Map.of(1, 12, 2, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/atomic/sb", "spirv-verification-new/atomic/sb", Map.of(2, 11, 3, 12, 7, 5, 8, 6),  List.of(), false},
                {"litmus-vulkan/mixed/mp/mo", "spirv-verification-new/mixed/mp/mo", Map.of(1, 12, 2, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/plain/lb", "spirv-verification-new/plain/lb", Map.of(2, 11, 3, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/plain/mp", "spirv-verification-new/plain/mp", Map.of(1, 12, 2, 13, 7, 5, 8, 7),  List.of(), false},
                {"litmus-vulkan/plain/sb", "spirv-verification-new/plain/sb", Map.of(2, 11, 3, 12, 7, 5, 8, 6),  List.of(), false},
                {"litmus-vulkan/sanity/storage-class", "spirv-verification-new/sanity/storage-class", Map.of(1, 10, 5, 5),  List.of(), false},

                {"litmus-vulkan/sanity/operands/load", "spirv-verification-new/sanity/operands/load", Map.of(2, 1),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"litmus-vulkan/sanity/operands/store", "spirv-verification-new/sanity/operands/store", Map.of(1, 1),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"litmus-vulkan/sanity/semantics/legal", "spirv-verification-new/sanity/semantics/legal", Map.of(2, 1),  List.of("litmus-vulkan-sanity-semantics.txt", "spirv-verification-sanity-semantics.txt"), false},

                {"spirv-verification-new/sanity/semantics/illegal", "spirv-empirical-new/sanity/semantics/illegal", Map.of(0, 0),  null, true},
                {"spirv-empirical-new/sanity/semantics/illegal", "spirv-verification-new/sanity/semantics/illegal", Map.of(0, 0),  null, true},

                {"litmus-vulkan/atomic/lb", "spirv-empirical-new/atomic/lb", Map.of(2, 49, 3, 51, 7, 41, 8, 43),  List.of(), false},
                {"litmus-vulkan/atomic/mp", "spirv-empirical-new/atomic/mp", Map.of(1, 50, 2, 51, 7, 41, 8, 43),  List.of(), false},
                {"litmus-vulkan/atomic/sb", "spirv-empirical-new/atomic/sb", Map.of(2, 49, 3, 50, 7, 41, 8, 42),  List.of(), false},
                {"litmus-vulkan/mixed/mp/mo", "spirv-empirical-new/mixed/mp/mo", Map.of(1, 50, 2, 51, 7, 41, 8, 43),  List.of(), false},
                {"litmus-vulkan/plain/lb", "spirv-empirical-new/plain/lb", Map.of(2, 49, 3, 51, 7, 41, 8, 43),  List.of(), false},
                {"litmus-vulkan/plain/mp", "spirv-empirical-new/plain/mp", Map.of(1, 50, 2, 51, 7, 41, 8, 43),  List.of(), false},
                {"litmus-vulkan/plain/sb", "spirv-empirical-new/plain/sb", Map.of(2, 49, 3, 50, 7, 41, 8, 42),  List.of(), false},
                {"litmus-vulkan/sanity/storage-class", "spirv-empirical-new/sanity/storage-class", Map.of(1, 59, 5, 52),  List.of(), false},

                {"litmus-vulkan/sanity/operands/load", "spirv-empirical-new/sanity/operands/load", Map.of(2, 49),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"litmus-vulkan/sanity/operands/store", "spirv-empirical-new/sanity/operands/store", Map.of(1, 49),  List.of("spirv-sanity-operands-avvis-illegal.txt"), false},
                {"litmus-vulkan/sanity/semantics/legal", "spirv-empirical-new/sanity/semantics/legal", Map.of(2, 49),  List.of("litmus-vulkan-sanity-semantics.txt", "spirv-empirical-sanity-semantics.txt"), false},

        });
    }

    @Test
    public void compare() throws Exception {
        Path path1 = Path.of(basePath, dir1);
        List<String> fileList1 = listFiles(path1).stream().filter(f -> noSkip(skipList, f)).toList();
        String ext1 = getExtension(fileList1);

        Path path2 = Path.of(basePath, dir2);
        List<String> fileList2 = listFiles(path2).stream().filter(f -> noSkip(skipList, f)).toList();
        String ext2 = getExtension(fileList2);

        assertEquals(fileList1.size(), fileList2.size());

        for (String file1 : fileList1) {
            String base = file1.replace(path1.toString(), "").replace(ext1, "");
            String file2 = Path.of(basePath, dir2, base + ext2).toString();
            System.out.println(file2);
            assertTrue(fileList2.contains(file2));
            compareLitmusTests(file1, file2);
        }
    }

    private static Set<String> loadSkipList(Collection<String> files) throws IOException {
        Set<String> data = new HashSet<>();
        if (files != null) {
            for (String file : files) {
                String path = getTestResourcePath(Path.of("drunner", file).toString());
                try (Stream<String> lines = Files.lines(Paths.get(path))) {
                    data.addAll(lines.collect(Collectors.toSet()));
                }
            }
        }
        return data;
    }

    private static boolean noSkip(Set<String> list, String file) {
        Path base = Path.of(basePath);
        Path filePath = Path.of(file);
        String id = filePath.subpath(base.getNameCount(), filePath.getNameCount())
                .toString()
                .replace("\\", "/");
        return !list.contains(id);
    }

    private String getExtension(List<String> fileList) {
        if (!fileList.isEmpty()) {
            String file = fileList.get(0);
            if (file.endsWith(".litmus")) {
                return verifyExtension(fileList, ".litmus");
            }
            if (file.endsWith(".spv.dis")) {
                return verifyExtension(fileList, ".spv.dis");
            }
            throw new RuntimeException("Unknown file type " + file);
        }
        throw new RuntimeException("Directory is empty");
    }

    private String verifyExtension(List<String> fileList, String extension) {
        Optional<String> mismatch = fileList.stream().filter(f -> !f.endsWith(extension)).findAny();
        if (mismatch.isPresent()) {
            throw new RuntimeException("Mismatching file type " + mismatch.get());
        }
        return extension;
    }

    private void compareLitmusTests(String file1, String file2) throws Exception {
        try {
            VerificationTask task1 = mkTask(modelPath, file1, PROGRAM_SPEC);
            preprocessProgram(task1, task1.getConfig());
            Map<Integer, Set<String>> tagSet1 = mkEventTagMap(task1.getProgram());
            printProgramEvents(file1, task1.getProgram());

            VerificationTask task2 = mkTask(modelPath, file2, PROGRAM_SPEC);
            preprocessProgram(task2, task2.getConfig());
            Map<Integer, Set<String>> tagSet2 = mkEventTagMap(task2.getProgram());
            printProgramEvents(file2, task2.getProgram());

            map.forEach((key, value) -> assertEquals(tagSet1.get(key), tagSet2.get(value)));
        } catch (Exception e) {
            if (!skipErrors) {
                throw e;
            }
            //System.out.println(file1 + " " + e.getMessage());
        }
    }

    private Map<Integer, Set<String>> mkEventTagMap(Program program) {
        return program.getThreadEvents().stream()
                .collect(Collectors.toMap(Event::getGlobalId, e -> {
                    Set<String> data = new HashSet<>(e.getTags());
                    data.remove(NOOPT);
                    return data;
                }));
    }

    private void printProgramEvents(String path, Program program) {
        if (PRINT_EVENTS) {
            System.out.println(path);
            System.out.println(new Printer().setShowInitThreads(true).setMode(Printer.Mode.THREADS).print(program));
            program.getThreads().stream()
                    .flatMap(t -> t.getEvents().stream())
                    .map(e -> e.getGlobalId() + " " + e.getTags())
                    .forEach(System.out::println);
        }
    }
}