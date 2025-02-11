package com.dat3m.dartagnan.drunner;

import com.dat3m.dartagnan.configuration.Arch;
import com.dat3m.dartagnan.configuration.Property;
import com.dat3m.dartagnan.parsers.cat.ParserCat;
import com.dat3m.dartagnan.parsers.program.ProgramParser;
import com.dat3m.dartagnan.program.Program;
import com.dat3m.dartagnan.verification.VerificationTask;
import com.dat3m.dartagnan.wmm.Wmm;
import org.sosy_lab.common.configuration.Configuration;

import java.io.File;
import java.io.IOException;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.EnumSet;
import java.util.LinkedList;
import java.util.List;

import static com.dat3m.dartagnan.configuration.OptionNames.IGNORE_FILTER_SPECIFICATION;

public abstract class AbstractTest {

    //protected final String basePath = Path.of(getTestResourcePath("generated/generation")).toAbsolutePath().toString();
    protected static final String basePath = "C:\\Users\\n00857603\\Desktop\\code\\temp\\pylitmus\\generated\\generation";

    protected List<String> listFiles(Path path) throws IOException {
        List<String> result = new LinkedList<>();
        try (DirectoryStream<Path> files = Files.newDirectoryStream(path)) {
            for (Path file : files) {
                if (Files.isDirectory(file)) {
                    result.addAll(listFiles(file.toAbsolutePath()));
                } else {
                    result.add(file.toAbsolutePath().toString());
                }
            }
        }
        return result;
    }

    protected VerificationTask mkTask(String modelPath, String path, Property property, boolean filter) throws Exception {
        VerificationTask.VerificationTaskBuilder builder = VerificationTask.builder()
                .withConfig(Configuration.builder().setOption(IGNORE_FILTER_SPECIFICATION, Boolean.toString(!filter)).build())
                .withTarget(Arch.VULKAN);
        Program program = new ProgramParser().parse(new File(path));
        Wmm mcm = new ParserCat().parse(new File(modelPath));
        return builder.build(program, mcm, EnumSet.of(property));
    }
}
