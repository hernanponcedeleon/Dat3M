package porthosc.app.modules.dartagnan;

import com.beust.jcommander.Parameter;
import com.beust.jcommander.converters.FileConverter;
import porthosc.app.options.AppOptions;
import porthosc.app.options.converters.MemoryModelNameConverter;
import porthosc.app.options.validators.FileValidator;
import porthosc.app.options.validators.InputProgramExtensionValidator;
import porthosc.app.options.validators.MemoryModelNameValidator;
import porthosc.memorymodels.wmm.MemoryModel;

import java.io.File;


public class DartagnanOptions extends AppOptions {

    @Parameter(names = {"-i", "--input"},
            required = true,
            arity = 1,
            description = "Input source-code file path",
            converter = FileConverter.class,
            validateValueWith = {FileValidator.class, InputProgramExtensionValidator.class})
    public File inputProgramFile;

    @Parameter(names = {"-t", "--target-model"},
            required = true,
            arity = 1,
            description = "Target weak memory model name",
            // uncomment when we'll be parsing .cat-files
            //converter = FileConverter.class,
            //validateValueWith = {FileValidator.class, InputProgramExtensionValidator.class})
            converter = MemoryModelNameConverter.class,
            validateValueWith = MemoryModelNameValidator.class)
    public MemoryModel.Kind sourceModel;
}
