package com.dat3m.dartagnan.witness.svcomp;

import com.dat3m.dartagnan.model.execution.Execution;
import com.dat3m.dartagnan.task.verification.VerificationResult;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.sosy_lab.common.configuration.Configuration;
import org.sosy_lab.common.configuration.InvalidConfigurationException;
import org.sosy_lab.common.configuration.Option;
import org.sosy_lab.common.configuration.Options;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Optional;

import static com.dat3m.dartagnan.configuration.OptionNames.WITNESS_PROPERTY;
import static com.dat3m.dartagnan.task.verification.VerificationStatus.PASS;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.supportedCorrectnessProperties;
import static com.dat3m.dartagnan.witness.svcomp.SvcompProperty.supportedViolationProperties;

/** Generates SV-COMP witnesses for verification results. */
@Options
public final class SvcompOutputGenerator {

    private static final Logger logger = LoggerFactory.getLogger(SvcompOutputGenerator.class);

    @Option(name=WITNESS_PROPERTY,
            description="SV-COMP property the task is checked against.",
            secure=true)
    private String propertyName = "";

    private final Optional<SvcompProperty> property;

    public SvcompOutputGenerator(Configuration config) throws InvalidConfigurationException {
        config.inject(this);
        property = SvcompProperty.fromPropertyName(propertyName);
        if (property.isEmpty() && !propertyName.isBlank()) {
            throw new InvalidConfigurationException("Unknown SV-COMP property " + propertyName);
        }
    }

    /** Writes the witness for {@code result} to {@code file}. Returns {@code null} if no witness was generated. */
    public Path generate(VerificationResult result, Path file) throws IOException {
        final Optional<? extends SvcompWitness> witness = result.getStatus() == PASS
                ? correctnessWitness(result)
                : violationWitness(result);
        if (witness.isEmpty()) {
            return null;
        }
        SvcompWitnessYamlWriter.write(witness.get(), file);
        return file;
    }

    private Optional<SvcompCorrectnessWitness> correctnessWitness(VerificationResult result) throws IOException {
        if (property.isEmpty()) {
            logger.warn("SV-COMP correctness witnesses require option {}.", WITNESS_PROPERTY);
            return Optional.empty();
        }
        final Optional<SvcompCorrectnessWitness> witness =
                SvcompWitnessExtractor.forCorrectness(result.getTask().getProgram(), property.get());
        if (witness.isEmpty()) {
            logger.warn("SV-COMP correctness witnesses are supported only for the following properties: {}.",
                    String.join(", ", supportedCorrectnessProperties()));
        }
        return witness;
    }

    private Optional<SvcompViolationWitness> violationWitness(VerificationResult result) throws IOException {
        if (!result.hasModel()) {
            return Optional.empty();
        }
        final Optional<SvcompViolationWitness> witness = SvcompWitnessExtractor.forViolation(
                Execution.fromModel(result.getModel()), result.getTask().getProperties());
        if (witness.isEmpty()) {
            logger.warn("SV-COMP violation witnesses are supported only for the following properties: {}.",
                    String.join(", ", supportedViolationProperties()));
        }
        return witness;
    }
}
